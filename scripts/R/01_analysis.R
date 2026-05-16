# ============================================================
# 01_analysis.R
# Thesis: Impacto del Gasto en Limpieza Pública sobre
#         Gestión de Residuos Sólidos Municipales, Perú 2015-2019
# Author: Dante Barreto Gamarra (UNAS)
# Purpose: Main econometric estimation — CRE+CF models
#   D1 Eficiencia: FR (Ordered Probit), CSRS (Ordered Probit), QPRS (OLS)
#   D2 Planeamiento: PIGARS+PMRS+SRRS+PTRS+PSFRSRS (Probit per component + PI index)
#   D3 Disposición: RS (Probit), PRS (Fractional Logit)
# Inputs:  data/processed/panel_final_tesis.csv
# Outputs: paper/tables/*, scripts/R/output/*.rds,
#          quality_reports/final_results_summary.md
# ============================================================

# 0. Setup ----
library(here)
library(dplyr)
library(stringr)
library(fixest)           # feols — TWFE baseline
library(marginaleffects)  # avg_slopes — AME
library(modelsummary)     # msummary — publication tables
library(sandwich)         # vcovCL — clustered SE
library(lmtest)           # coeftest
library(MASS)             # polr — loaded LAST to avoid masking dplyr::select

# Ensure dplyr functions are used when both dplyr and MASS loaded
select  <- dplyr::select
filter  <- dplyr::filter
mutate  <- dplyr::mutate

set.seed(20240101)

dir.create(here("scripts", "R", "output"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("paper", "tables"),        recursive = TRUE, showWarnings = FALSE)
dir.create(here("quality_reports"),        recursive = TRUE, showWarnings = FALSE)

# ============================================================
# 1. Load panel ----
# ============================================================

panel <- read.csv(here("data", "processed", "panel_final_tesis.csv"),
                  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
names(panel) <- trimws(names(panel))

cat("Columns in CSV:", paste(names(panel), collapse=", "), "\n\n")

# Rename year/anio to avoid potential conflicts
if ("anio" %in% names(panel) && !("year" %in% names(panel))) {
  panel$year <- panel$anio
} else if ("year" %in% names(panel)) {
  panel$yr <- panel$year   # safe copy
  panel$year <- as.integer(panel$year)
}

# Build derived variables
panel <- panel |>
  dplyr::mutate(
    ubigeo        = str_pad(as.character(ubigeo), 6, "left", "0"),
    province_code = substr(ubigeo, 1, 4),
    year_f        = factor(.data$year),

    # Recode RS: RENAMU codes 1=yes, 2=no → recode to 0/1
    RS_bin   = dplyr::case_when(RS == 1 ~ 1L, RS == 2 ~ 0L, TRUE ~ NA_integer_),
    # Recode Botadero similarly
    Bot_bin  = dplyr::case_when(Botadero == 1 ~ 1L, Botadero == 2 ~ 0L, TRUE ~ NA_integer_),
    # PRS: scale from 0-100 to 0-1
    PRS_01   = PRS / 100,

    # Planning: convert multi-valued counts to binary (>0 = has the instrument)
    PIGARS_b = as.integer(PIGARS > 0),
    PMRS_b   = as.integer(PMRS   > 0),
    SRRS_b   = as.integer(SRRS   > 0),
    PTRS_b   = as.integer(PTRS   > 0),
    PSFRSRS_b= as.integer(PSFRSRS> 0),

    # Planning index (sum of 5 BINARY indicators, range 0-5)
    PI       = PIGARS_b + PMRS_b + SRRS_b + PTRS_b + PSFRSRS_b,

    # Filter FR and CSRS: drop 0 values (non-valid codes)
    FR_clean   = ifelse(FR   %in% 1:5, FR,   NA_real_),
    CSRS_clean = ifelse(CSRS %in% 1:4, CSRS, NA_real_),

    # Ordered factors (clean versions)
    FR_f   = factor(FR_clean,   levels = 1:5, ordered = TRUE),
    CSRS_f = factor(CSRS_clean, levels = 1:4, ordered = TRUE),

    # log(QPRS + 0.001) for near-zero values; zero-collection indicator
    log_QPRS  = ifelse(QPRS > 0, log(QPRS), log(0.001)),
    zero_coll = as.integer(QPRS == 0),

    log_gasto_use = log_gasto   # primary treatment variable
  ) |>
  dplyr::group_by(ubigeo) |>
  dplyr::mutate(
    mean_log_gasto2 = mean(log_gasto, na.rm = TRUE),
    mean_log_QPRS   = mean(log_QPRS,  na.rm = TRUE),
    mean_FR         = mean(FR,         na.rm = TRUE),
    mean_CSRS       = mean(CSRS,       na.rm = TRUE)
  ) |>
  dplyr::ungroup() |>
  dplyr::filter(!is.na(log_gasto), !is.na(FR))

cat("=== PANEL LOADED ===\n")
cat("Observations:", nrow(panel), "\n")
cat("Municipalities:", n_distinct(panel$ubigeo), "\n")
cat("Province clusters:", n_distinct(panel$province_code), "\n")
cat("Columns:", paste(names(panel), collapse=", "), "\n\n")

# ============================================================
# 2. Summary Statistics ----
# ============================================================

cat("=== SUMMARY STATISTICS ===\n")
vars_sum <- c("log_gasto","FR","QPRS","CSRS","PI","PIGARS","PMRS","SRRS","PTRS",
              "PSFRSRS","RS","PRS","Botadero","PBotadero")
for (v in vars_sum) {
  x <- panel[[v]]
  cat(sprintf("%-14s  N=%-5d  mean=%7.3f  sd=%6.3f  min=%5.1f  max=%5.1f\n",
              v, sum(!is.na(x)), mean(x, na.rm=T), sd(x, na.rm=T),
              min(x, na.rm=T), max(x, na.rm=T)))
}

cat("\nFR distribution:\n");   print(table(panel$FR,   useNA="ifany"))
cat("\nCSRS distribution:\n"); print(table(panel$CSRS, useNA="ifany"))
cat("\nPI distribution:\n");   print(table(panel$PI,   useNA="ifany"))

saveRDS(panel, here("scripts", "R", "output", "panel_main.rds"))

# ============================================================
# 3. Stage 1 — CRE Pooled OLS (Wooldridge 2015, JHR)
#    CRITICAL: pooled OLS, NOT feols with within-FE
#    No external instrument (Z_foncomun) yet — using within-panel
#    variation; vhat still corrects for selection into spending
# ============================================================

cat("\n=== STAGE 1: CRE Pooled OLS ===\n")

stage1 <- lm(log_gasto ~ year_f + mean_log_gasto2,
             data = panel)
panel$vhat <- residuals(stage1)

cat("Stage 1 R²:", round(summary(stage1)$r.squared, 3), "\n")
cat("Stage 1 N:", nobs(stage1), "\n\n")

# ============================================================
# 4. TWFE Baseline ----
# ============================================================

cat("=== TWFE BASELINE (municipality + year FE) ===\n")

twfe_fr   <- feols(FR   ~ log_gasto | ubigeo + year, data = panel, cluster = ~province_code)
twfe_qprs <- feols(log_QPRS ~ log_gasto + zero_coll | ubigeo + year,
                   data = panel, cluster = ~province_code)
twfe_csrs <- feols(CSRS ~ log_gasto | ubigeo + year, data = panel, cluster = ~province_code)
twfe_pi   <- feols(PI   ~ log_gasto | ubigeo + year, data = panel, cluster = ~province_code)
twfe_rs   <- feols(RS_bin ~ log_gasto | ubigeo + year, data = panel, cluster = ~province_code)
twfe_prs  <- feols(PRS_01 ~ log_gasto | ubigeo + year, data = panel, cluster = ~province_code)

cat("TWFE D1-FR  : coef =", round(coef(twfe_fr)["log_gasto"], 4),  "\n")
cat("TWFE D1-QPRS: coef =", round(coef(twfe_qprs)["log_gasto"], 4), "\n")
cat("TWFE D1-CSRS: coef =", round(coef(twfe_csrs)["log_gasto"], 4), "\n")
cat("TWFE D2-PI  : coef =", round(coef(twfe_pi)["log_gasto"], 4),  "\n")
cat("TWFE D3-RS  : coef =", round(coef(twfe_rs)["log_gasto"], 4),  "\n")
cat("TWFE D3-PRS : coef =", round(coef(twfe_prs)["log_gasto"], 4), "\n")

saveRDS(list(twfe_fr=twfe_fr, twfe_qprs=twfe_qprs, twfe_csrs=twfe_csrs,
             twfe_pi=twfe_pi, twfe_rs=twfe_rs, twfe_prs=twfe_prs),
        here("scripts", "R", "output", "twfe_models.rds"))

# ============================================================
# 5a. D1 — CRE Ordered Probit: Frecuencia (FR, 1-5) ----
# ============================================================

cat("\n=== D1: CRE Ordered Probit — Frecuencia ===\n")

cre_fr <- tryCatch(
  MASS::polr(FR_f ~ log_gasto + vhat + year_f + mean_log_gasto2,
             data = panel, method = "probit", Hess = TRUE),
  error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); NULL }
)

ame_fr <- NULL
if (!is.null(cre_fr)) {
  cat("Converged. Coefs:\n")
  print(round(coef(summary(cre_fr))[1:3, ], 4))

  panel_fr_clean <- panel |> dplyr::filter(!is.na(FR_f))
  ame_fr <- tryCatch({
    slopes(cre_fr, variables = "log_gasto",
           newdata = datagrid(model = cre_fr),
           conf_level = 0.95)
  }, error = function(e) {
    tryCatch(
      marginaleffects(cre_fr, variable = "log_gasto"),
      error = function(e2) { cat("AME failed:", conditionMessage(e2), "\n"); NULL }
    )
  })
  if (!is.null(ame_fr) && nrow(ame_fr) > 0) {
    fr1_rows <- ame_fr[ame_fr$group %in% c("1", min(ame_fr$group, na.rm=TRUE)), ]
    if (nrow(fr1_rows) > 0)
      cat(sprintf("\nAME dP(FR=1)/d(log_gasto) = %.4f\n", mean(fr1_rows$estimate)))
  }
  saveRDS(list(model=cre_fr, ame=ame_fr),
          here("scripts","R","output","cre_fr.rds"))
}

# ============================================================
# 5b. D1 — CRE OLS: log(QPRS) [log-log] ----
# ============================================================

cat("\n=== D1: CRE OLS — log(QPRS) ===\n")

cre_qprs <- lm(log_QPRS ~ log_gasto + vhat + zero_coll + year_f + mean_log_gasto2,
               data = panel)
vcov_qprs <- vcovCL(cre_qprs, cluster = ~province_code, data = panel)
ct_qprs   <- coeftest(cre_qprs, vcov = vcov_qprs)
cat("CRE OLS QPRS: coef(log_gasto) =", round(ct_qprs["log_gasto","Estimate"], 4),
    "  SE =", round(ct_qprs["log_gasto","Std. Error"], 4),
    "  p =",  round(ct_qprs["log_gasto","Pr(>|t|)"], 4), "\n")

saveRDS(list(model=cre_qprs, vcov=vcov_qprs, ct=ct_qprs),
        here("scripts","R","output","cre_qprs.rds"))

# ============================================================
# 5c. D1 — CRE Ordered Probit: Cobertura (CSRS, 1-4) ----
# ============================================================

cat("\n=== D1: CRE Ordered Probit — CSRS ===\n")

cre_csrs <- tryCatch(
  MASS::polr(CSRS_f ~ log_gasto + vhat + year_f + mean_log_gasto2,
             data = panel, method = "probit", Hess = TRUE),
  error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); NULL }
)

ame_csrs <- NULL
if (!is.null(cre_csrs)) {
  cat("Converged.\n")
  print(round(coef(summary(cre_csrs))[1:3, ], 4))

  ame_csrs <- tryCatch(
    avg_slopes(cre_csrs, variables = "log_gasto",
               newdata = panel, conf_level = 0.95),
    error = function(e) NULL
  )
  if (!is.null(ame_csrs)) {
    cs4 <- ame_csrs |> filter(group == max(group))
    cat(sprintf("AME dP(CSRS=4)/d(log_gasto) = %.4f  (95%% CI: %.4f, %.4f)\n",
                cs4$estimate, cs4$conf.low, cs4$conf.high))
  }
  saveRDS(list(model=cre_csrs, ame=ame_csrs),
          here("scripts","R","output","cre_csrs.rds"))
}

# ============================================================
# 6. D2 — Planning Instruments ----
# ============================================================

cat("\n=== D2: CRE Models — Planning ===\n")

# 6a. Planning index (OLS, treating PI as continuous)
cre_pi   <- lm(PI ~ log_gasto + vhat + year_f + mean_log_gasto2, data = panel)
vcov_pi  <- vcovCL(cre_pi, cluster = ~province_code, data = panel)
ct_pi    <- coeftest(cre_pi, vcov = vcov_pi)
cat("CRE OLS PI: coef =", round(ct_pi["log_gasto","Estimate"], 4),
    "  p =", round(ct_pi["log_gasto","Pr(>|t|)"], 4), "\n")

saveRDS(list(model=cre_pi, vcov=vcov_pi, ct=ct_pi),
        here("scripts","R","output","cre_pi.rds"))

# 6b. Binary components — CRE Probit for each
plan_components <- list(
  PIGARS   = "PIGARS",
  PMRS     = "PMRS",
  SRRS     = "SRRS",
  PTRS     = "PTRS",
  PSFRSRS  = "PSFRSRS"
)

cre_plan_list <- list()
ame_plan      <- list()

for (nm in names(plan_components)) {
  ycol <- plan_components[[nm]]
  n_pos <- sum(panel[[ycol]], na.rm = TRUE)
  if (n_pos < 10) {
    cat(sprintf("%-10s : insufficient positives (%d) — skip\n", nm, n_pos))
    next
  }
  fmla <- as.formula(paste(ycol, "~ log_gasto + vhat + year_f + mean_log_gasto2"))
  m <- tryCatch(
    glm(fmla, data = panel, family = binomial("probit")),
    error = function(e) NULL
  )
  if (!is.null(m)) {
    ame_v <- tryCatch(
      avg_slopes(m, variables = "log_gasto", newdata = panel)$estimate,
      error = function(e) NA_real_
    )
    cat(sprintf("%-10s : coef = %7.4f  AME = %7.4f  N=%d\n",
                nm, coef(m)["log_gasto"], ame_v[1], nobs(m)))
    cre_plan_list[[nm]] <- m
    ame_plan[[nm]]      <- ame_v[1]
  }
}

saveRDS(list(models=cre_plan_list, ames=ame_plan),
        here("scripts","R","output","cre_plan_components.rds"))

# ============================================================
# 7. D3 — Disposición Final ----
# ============================================================

cat("\n=== D3: Disposición Final ===\n")

# 7a. RS (binary: RS_bin = recode de RS 1=sí/2=no → 1/0)
panel_rs <- panel |> dplyr::filter(!is.na(RS_bin))
cat("RS_bin distribution:\n"); print(table(panel_rs$RS_bin))

cre_rs <- tryCatch(
  glm(RS_bin ~ log_gasto + vhat + year_f + mean_log_gasto2,
      data = panel_rs, family = binomial("probit")),
  error = function(e) { cat("CRE Probit RS failed:", conditionMessage(e), "\n"); NULL }
)

ame_rs <- NA_real_
if (!is.null(cre_rs)) {
  ame_rs <- tryCatch(
    avg_slopes(cre_rs, variables = "log_gasto", newdata = panel_rs)$estimate[1],
    error = function(e) NA_real_
  )
  cat("CRE Probit RS: coef =", round(coef(cre_rs)["log_gasto"], 4),
      "  AME =", round(ame_rs, 4), "\n")
  saveRDS(list(model=cre_rs, ame=ame_rs),
          here("scripts","R","output","cre_rs.rds"))
}

# 7b. PRS (proporción 0-1 — Papke-Wooldridge fractional logit; PRS_01 = PRS/100)
panel_prs <- panel |> dplyr::filter(!is.na(PRS_01))
cat("PRS_01 obs:", nrow(panel_prs), "  mean:", round(mean(panel_prs$PRS_01), 3), "\n")

cre_prs <- tryCatch(
  glm(PRS_01 ~ log_gasto + vhat + year_f + mean_log_gasto2,
      data = panel_prs, family = quasibinomial("logit")),
  error = function(e) { cat("Fractional Logit PRS failed:", conditionMessage(e), "\n"); NULL }
)

ame_prs <- NA_real_
if (!is.null(cre_prs)) {
  ame_prs <- tryCatch(
    avg_slopes(cre_prs, variables = "log_gasto", newdata = panel_prs)$estimate[1],
    error = function(e) NA_real_
  )
  cat("Fractional Logit PRS: coef =", round(coef(cre_prs)["log_gasto"], 4),
      "  AME =", round(ame_prs, 4), "\n")
  saveRDS(list(model=cre_prs, ame=ame_prs),
          here("scripts","R","output","cre_prs.rds"))
}

# ============================================================
# 8. Endogeneity Test ----
# ============================================================

cat("\n=== ENDOGENEITY TEST (H0: vhat = 0) ===\n")

# OLS models: t-test
cat("D1-QPRS: vhat coef =", round(ct_qprs["vhat","Estimate"], 4),
    "  p =", round(ct_qprs["vhat","Pr(>|t|)"], 4), "\n")
cat("D2-PI  : vhat coef =", round(ct_pi["vhat","Estimate"], 4),
    "  p =", round(ct_pi["vhat","Pr(>|t|)"], 4), "\n")

# Ordered Probit: check vhat significance (polr summary uses "t value" col)
if (!is.null(cre_fr)) {
  fr_coefs <- coef(summary(cre_fr))
  if ("vhat" %in% rownames(fr_coefs)) {
    fr_t  <- fr_coefs["vhat", "t value"]
    fr_p  <- 2 * pt(abs(fr_t), df = nobs(cre_fr) - length(coef(cre_fr)), lower.tail = FALSE)
    cat("D1-FR  : vhat coef =", round(fr_coefs["vhat","Value"], 4),
        "  t =", round(fr_t, 3), "  approx p =", round(fr_p, 4), "\n")
  }
}

# ============================================================
# 9. Bonferroni-Holm on 3 Primary Hypotheses ----
# ============================================================

cat("\n=== BONFERRONI-HOLM (3 primary outcomes) ===\n")

# Primary hypotheses (one per dimension):
# H1: log_gasto -> FR (D1)
# H2: log_gasto -> PI (D2)
# H3: log_gasto -> PRS (D3)

p_fr  <- if (!is.null(cre_fr)) {
  cf <- coef(summary(cre_fr))
  t_val <- cf["log_gasto", "t value"]
  2 * pt(abs(t_val), df = nobs(cre_fr) - length(coef(cre_fr)), lower.tail = FALSE)
} else NA_real_

p_pi  <- ct_pi["log_gasto","Pr(>|t|)"]
p_prs <- if (!is.null(cre_prs)) {
  cf <- coef(summary(cre_prs))
  if ("Pr(>|t|)" %in% colnames(cf)) cf["log_gasto","Pr(>|t|)"]
  else cf["log_gasto", ncol(cf)]
} else NA_real_

p_primary <- c(H1_FR = p_fr, H2_PI = p_pi, H3_PRS = p_prs)
bh_result <- p.adjust(p_primary, method = "holm")

cat("Raw p-values:     ", paste(sprintf("%.4f", p_primary), collapse = "  "), "\n")
cat("Holm-adjusted:    ", paste(sprintf("%.4f", bh_result),  collapse = "  "), "\n")
cat("Significant (5%): ", paste(ifelse(bh_result < 0.05, "YES", "no"), collapse = "  "), "\n")
cat("Thresholds (Holm): p(1) ≤ 0.0167  p(2) ≤ 0.0250  p(3) ≤ 0.0500\n")

# ============================================================
# 10. TWFE Comparative Table ----
# ============================================================

cat("\n=== PUBLICATION TABLE (TWFE) ===\n")

twfe_table_list <- list(
  "FR"   = twfe_fr,
  "QPRS" = twfe_qprs,
  "CSRS" = twfe_csrs,
  "PI"   = twfe_pi,
  "RS"   = twfe_rs,
  "PRS"  = twfe_prs
)

tryCatch({
  modelsummary(
    twfe_table_list,
    coef_map   = c("log_gasto" = "ln(Gasto Limpieza pc)"),
    gof_map    = c("nobs", "r.squared"),
    stars      = c("*" = .1, "**" = .05, "***" = .01),
    output     = here("paper", "tables", "tab_twfe_main.tex"),
    title      = "Efecto del Gasto en Limpieza Pública (TWFE)",
    notes      = "SE agrupados a nivel provincia. EF municipio y año incluidos.",
    escape     = FALSE
  )
  cat("Saved tab_twfe_main.tex\n")
}, error = function(e) cat("Table export warning:", conditionMessage(e), "\n"))

# ============================================================
# 11. Results Summary → quality_reports/final_results_summary.md ----
# ============================================================

safe_val <- function(x) if (is.null(x) || length(x) == 0 || is.na(x[1])) "n/a" else round(x[1], 4)

results_lines <- c(
  "# Final Results Summary",
  paste0("**Generado:** ", format(Sys.time(), "%Y-%m-%d %H:%M")),
  paste0("**Panel:** ", n_distinct(panel$ubigeo), " municipios × 5 años = ",
         nrow(panel), " obs | ", n_distinct(panel$province_code), " clusters de provincia"),
  "",
  "---",
  "",
  "## Modelo base: TWFE (Two-Way Fixed Effects)",
  "| Outcome | Coef. log_gasto | SE | N |",
  "|---------|-----------------|-----|---|",
  sprintf("| FR (frecuencia) | %s | cluster-SE | %d |",
          safe_val(coef(twfe_fr)["log_gasto"]), nobs(twfe_fr)),
  sprintf("| QPRS log-log | %s | cluster-SE | %d |",
          safe_val(coef(twfe_qprs)["log_gasto"]), nobs(twfe_qprs)),
  sprintf("| CSRS (cobertura) | %s | cluster-SE | %d |",
          safe_val(coef(twfe_csrs)["log_gasto"]), nobs(twfe_csrs)),
  sprintf("| PI (planeamiento) | %s | cluster-SE | %d |",
          safe_val(coef(twfe_pi)["log_gasto"]), nobs(twfe_pi)),
  sprintf("| RS (relleno sanitario) | %s | cluster-SE | %d |",
          safe_val(coef(twfe_rs)["log_gasto"]), nobs(twfe_rs)),
  sprintf("| PRS (proporción relleno) | %s | cluster-SE | %d |",
          safe_val(coef(twfe_prs)["log_gasto"]), nobs(twfe_prs)),
  "",
  "---",
  "",
  "## Modelo CRE+CF (Wooldridge 2015, JHR)",
  "Stage 1: OLS agrupado con Mundlak means — sin IV (Z_foncomun pendiente de merge con SIAF/MEF)",
  "",
  "### D1 — Eficiencia en Recolección",
  sprintf("- **FR (Ordered Probit)**: coef = %s | AME dP(FR=1) = %s",
          if (!is.null(cre_fr)) safe_val(coef(cre_fr)["log_gasto"]) else "n/a",
          if (!is.null(ame_fr)) safe_val(ame_fr$estimate[ame_fr$group == min(ame_fr$group)]) else "n/a"),
  sprintf("- **QPRS (OLS log-log)**: coef = %s  SE = %s  p = %s",
          safe_val(ct_qprs["log_gasto","Estimate"]),
          safe_val(ct_qprs["log_gasto","Std. Error"]),
          safe_val(ct_qprs["log_gasto","Pr(>|t|)"])),
  sprintf("- **CSRS (Ordered Probit)**: coef = %s",
          if (!is.null(cre_csrs)) safe_val(coef(cre_csrs)["log_gasto"]) else "n/a"),
  "",
  "### D2 — Planeamiento",
  sprintf("- **PI (OLS)**: coef = %s  SE = %s  p = %s",
          safe_val(ct_pi["log_gasto","Estimate"]),
          safe_val(ct_pi["log_gasto","Std. Error"]),
          safe_val(ct_pi["log_gasto","Pr(>|t|)"])),
  paste0("- **Componentes binarios (Probit AME)**: ",
         paste(sapply(names(ame_plan), function(n) sprintf("%s=%.4f", n, ame_plan[[n]])),
               collapse = " | ")),
  "",
  "### D3 — Disposición Final",
  sprintf("- **RS (Probit)**: AME = %s", safe_val(ame_rs)),
  sprintf("- **PRS (Fractional Logit)**: AME = %s", safe_val(ame_prs)),
  "",
  "---",
  "",
  "## Prueba de endogeneidad (H0: vhat = 0)",
  sprintf("- D1-QPRS: vhat p = %s", safe_val(ct_qprs["vhat","Pr(>|t|)"])),
  sprintf("- D2-PI:   vhat p = %s", safe_val(ct_pi["vhat","Pr(>|t|)"])),
  "",
  "---",
  "",
  "## Bonferroni-Holm (3 hipótesis primarias)",
  sprintf("- H1 FR:  raw p = %s  ajustado = %s  %s",
          safe_val(p_primary["H1_FR"]), safe_val(bh_result["H1_FR"]),
          ifelse(!is.na(bh_result["H1_FR"]) && bh_result["H1_FR"] < 0.05, "**SIGNIFICATIVO**", "no significativo")),
  sprintf("- H2 PI:  raw p = %s  ajustado = %s  %s",
          safe_val(p_primary["H2_PI"]), safe_val(bh_result["H2_PI"]),
          ifelse(!is.na(bh_result["H2_PI"]) && bh_result["H2_PI"] < 0.05, "**SIGNIFICATIVO**", "no significativo")),
  sprintf("- H3 PRS: raw p = %s  ajustado = %s  %s",
          safe_val(p_primary["H3_PRS"]), safe_val(bh_result["H3_PRS"]),
          ifelse(!is.na(bh_result["H3_PRS"]) && bh_result["H3_PRS"] < 0.05, "**SIGNIFICATIVO**", "no significativo")),
  "",
  "---",
  "",
  "## Archivos generados",
  "- `scripts/R/output/panel_main.rds` — panel listo para análisis",
  "- `scripts/R/output/twfe_models.rds` — modelos TWFE",
  "- `scripts/R/output/cre_fr.rds` — CRE Ordered Probit FR",
  "- `scripts/R/output/cre_qprs.rds` — CRE OLS QPRS",
  "- `scripts/R/output/cre_csrs.rds` — CRE Ordered Probit CSRS",
  "- `scripts/R/output/cre_pi.rds` — CRE OLS Planning Index",
  "- `scripts/R/output/cre_plan_components.rds` — CRE Probit por componente D2",
  "- `scripts/R/output/cre_rs.rds` — CRE Probit RS",
  "- `scripts/R/output/cre_prs.rds` — CRE Fractional Logit PRS",
  "- `paper/tables/tab_twfe_main.tex` — Tabla principal TWFE",
  "",
  "## Limitaciones / Pendiente",
  "- Z_foncomun (instrumento FONCOMUN) no disponible aún — requiere merge con datos MEF/SIAF",
  "- Sin IV, el CF test mide endogeneidad pero no estima LATE",
  "- Variables de control externas (pobreza, urbanización) pendientes (ENAHO/CPV)"
)

writeLines(results_lines,
           here("quality_reports", "final_results_summary.md"))
cat("\n✓ Saved quality_reports/final_results_summary.md\n")

saveRDS(list(
  p_primary = p_primary,
  bh_result = bh_result,
  results_table = data.frame(
    outcome   = names(twfe_table_list),
    coef_twfe = sapply(twfe_table_list, function(m) coef(m)["log_gasto"]),
    n         = sapply(twfe_table_list, nobs)
  )
), here("scripts","R","output","final_results.rds"))

cat("\nDone: 01_analysis.R\n")
