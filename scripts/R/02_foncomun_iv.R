# ============================================================
# 02_foncomun_iv.R
# Thesis: Impacto del Gasto en Limpieza Pública sobre
#         Gestión de Residuos Sólidos Municipales, Perú 2015-2019
# Author: Dante Barreto Gamarra (UNAS)
#
# Purpose: CRE+IV-2SLS — FONCOMUN como instrumento externo
#   El instrumento es la transferencia FONCOMUN predicha por la
#   fórmula MEF: Z_it = share_i * pool_t
#   donde share_i = peso de la municipalidad en el año base (2015)
#   y pool_t = pozo nacional FONCOMUN en el año t.
#   Identificación: variaciones en el pozo nacional (determinadas
#   por la recaudación IGV agregada) afectan el gasto local SOLO
#   a través del canal FONCOMUN, no directamente.
#
# Inputs:
#   data/processed/panel_final_tesis.csv       (panel principal)
#   data/raw/foncomun_2015_2019.csv            (VER NOTA AL PIE)
#
# Outputs:
#   scripts/R/output/panel_iv.rds
#   scripts/R/output/iv_stage1_diagnostics.rds
#   scripts/R/output/iv_models.rds
#   paper/tables/tab_iv_results.tex
#   paper/tables/tab_iv_stage1.tex
#   quality_reports/iv_results_summary.md
#
# NOTA — Cómo obtener foncomun_2015_2019.csv:
#   1. Ir a Transparencia Económica MEF:
#      apps.mef.gob.pe/transferencias/
#   2. Seleccionar: Tipo = FONCOMUN, Periodo = 2015-2019
#   3. Descargar por año a nivel distrital (ubigeo 6 dígitos)
#   4. Consolidar en un CSV con columnas:
#      ubigeo (6 dígitos, con cero a la izquierda), anio, foncomun_soles
#   Alternativamente: SIAF Consulta Amigable → Fuente 07-FONCOMUN
# ============================================================

# 0. Setup ----
library(here)
library(dplyr)
library(stringr)
library(fixest)           # feols con IV — CRE+IV-2SLS lineal
library(marginaleffects)  # avg_slopes — AME para modelos no lineales
library(modelsummary)     # tablas publicación
library(sandwich)
library(lmtest)
library(MASS)
library(knitr)

select   <- dplyr::select
filter   <- dplyr::filter
mutate   <- dplyr::mutate

set.seed(20240101)

dir.create(here("scripts", "R", "output"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("paper",   "tables"),      recursive = TRUE, showWarnings = FALSE)
dir.create(here("quality_reports"),        recursive = TRUE, showWarnings = FALSE)

# ============================================================
# 1. Cargar panel principal ----
# ============================================================

panel <- read.csv(here("data", "processed", "panel_final_tesis.csv"),
                  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
names(panel) <- trimws(names(panel))

panel <- panel |>
  mutate(
    ubigeo        = str_pad(as.character(ubigeo), 6, "left", "0"),
    province_code = substr(ubigeo, 1, 4),
    year          = as.integer(anio),
    year_f        = factor(year),

    RS_bin    = case_when(RS == 1 ~ 1L, RS == 2 ~ 0L, TRUE ~ NA_integer_),
    PRS_01    = PRS / 100,

    PIGARS_b  = as.integer(PIGARS  > 0),
    PMRS_b    = as.integer(PMRS    > 0),
    SRRS_b    = as.integer(SRRS    > 0),
    PTRS_b    = as.integer(PTRS    > 0),
    PSFRSRS_b = as.integer(PSFRSRS > 0),
    PI        = PIGARS_b + PMRS_b + SRRS_b + PTRS_b + PSFRSRS_b,

    FR_clean   = ifelse(FR   %in% 1:5, FR,   NA_real_),
    CSRS_clean = ifelse(CSRS %in% 1:4, CSRS, NA_real_),
    FR_f       = factor(FR_clean,   levels = 1:5, ordered = TRUE),
    CSRS_f     = factor(CSRS_clean, levels = 1:4, ordered = TRUE),

    log_QPRS  = ifelse(QPRS > 0, log(QPRS), log(0.001)),
    zero_coll = as.integer(QPRS == 0),
    log_gasto = log_gasto
  ) |>
  group_by(ubigeo) |>
  mutate(mean_log_gasto = mean(log_gasto, na.rm = TRUE)) |>
  ungroup() |>
  filter(!is.na(log_gasto), !is.na(FR))

cat("Panel cargado:", nrow(panel), "obs |",
    n_distinct(panel$ubigeo), "municipios |",
    n_distinct(panel$province_code), "provincias\n")

# ============================================================
# 2. Cargar y preparar datos FONCOMUN ----
# ============================================================

foncomun_path <- here("data", "raw", "foncomun_2015_2019.csv")

if (!file.exists(foncomun_path)) {
  stop(
    "\n\nARCHIVO REQUERIDO NO ENCONTRADO:\n  ", foncomun_path,
    "\n\nDescarga los datos FONCOMUN del portal MEF (ver nota al inicio del script)",
    "\ny guárdalos como data/raw/foncomun_2015_2019.csv",
    "\ncon columnas: ubigeo (6 dígitos), anio, foncomun_soles\n"
  )
}

foncomun_raw <- read.csv(foncomun_path, stringsAsFactors = FALSE)
foncomun_raw <- foncomun_raw |>
  mutate(
    ubigeo        = str_pad(as.character(ubigeo), 6, "left", "0"),
    year          = as.integer(anio),
    foncomun_soles = as.numeric(foncomun_soles)
  ) |>
  filter(!is.na(foncomun_soles), foncomun_soles >= 0) |>
  select(ubigeo, year, foncomun_soles)

cat("FONCOMUN raw:", nrow(foncomun_raw), "obs |",
    n_distinct(foncomun_raw$ubigeo), "ubigeos |",
    range(foncomun_raw$year), "\n")

# ============================================================
# 3. Construir instrumento Bartik (shift-share) ----
#
#   Z_it = share_i * pool_t
#
#   share_i = peso de la municipalidad i en el año base 2015:
#             foncomun_i,2015 / sum(foncomun_2015)
#
#   pool_t  = pozo nacional FONCOMUN en el año t:
#             sum(foncomun_t) para toda la muestra
#
#   Identificación:
#     - share_i está predeterminado (no cambia según gestión de i)
#     - pool_t varía con la recaudación IGV nacional — exógeno
#       a la gestión de residuos de cada municipalidad individual
#     - La restricción de exclusión requiere que el pozo nacional IGV
#       no afecte directamente la disposición de residuos local,
#       solo a través del canal FONCOMUN → gasto → gestión.
# ============================================================

# Pozo nacional por año (suma de todos los distritos de la muestra)
pool_anual <- foncomun_raw |>
  group_by(year) |>
  summarise(pool_t = sum(foncomun_soles, na.rm = TRUE), .groups = "drop")

cat("\nPozo nacional FONCOMUN por año (millones S/):\n")
print(pool_anual |> mutate(pool_millones = round(pool_t / 1e6, 1)))

# Peso base 2015: share_i = foncomun_i,2015 / pool_2015
pool_2015 <- pool_anual$pool_t[pool_anual$year == 2015]
if (length(pool_2015) == 0) stop("No se encontraron datos FONCOMUN para 2015.")

shares_base <- foncomun_raw |>
  filter(year == 2015) |>
  mutate(share_i = foncomun_soles / pool_2015) |>
  select(ubigeo, share_i)

cat("\nVerificación shares (deben sumar ≈ 1.0):",
    round(sum(shares_base$share_i, na.rm = TRUE), 4), "\n")

# Instrumento Bartik: Z_it = share_i * pool_t
bartik <- shares_base |>
  crossing(pool_anual) |>
  mutate(
    Z_foncomun      = share_i * pool_t,
    log_Z_foncomun  = log(Z_foncomun + 1)
  ) |>
  select(ubigeo, year, Z_foncomun, log_Z_foncomun)

# También guardar FONCOMUN real (para primera etapa diagnóstica)
foncomun_real <- foncomun_raw |>
  mutate(log_foncomun = log(foncomun_soles + 1)) |>
  select(ubigeo, year, log_foncomun, foncomun_soles)

# ============================================================
# 4. Merge panel + instrumento ----
# ============================================================

panel_iv <- panel |>
  left_join(bartik,       by = c("ubigeo", "year")) |>
  left_join(foncomun_real, by = c("ubigeo", "year"))

cat("\nPanel IV: observaciones con Z_foncomun:",
    sum(!is.na(panel_iv$log_Z_foncomun)), "\n")
cat("Missing Z_foncomun:", sum(is.na(panel_iv$log_Z_foncomun)), "\n\n")

# Medias Mundlak del instrumento (para CRE)
panel_iv <- panel_iv |>
  group_by(ubigeo) |>
  mutate(mean_log_Z = mean(log_Z_foncomun, na.rm = TRUE)) |>
  ungroup()

saveRDS(panel_iv, here("scripts", "R", "output", "panel_iv.rds"))

# ============================================================
# 5. Primera etapa — diagnósticos ----
#
#   CRE Stage 1 con instrumento Bartik:
#   log_gasto_it = α + π*log_Z_it + γ*mean_log_gasto_i + δ_t + ε_it
#
#   Necesitamos: KP F-stat >> 10, partial R² > 0.10
# ============================================================

cat("=== PRIMERA ETAPA: DIAGNÓSTICOS IV ===\n\n")

# Etapa 1 con instrumento Bartik (CRE: incluye media Mundlak)
stage1_iv <- lm(
  log_gasto ~ log_Z_foncomun + mean_log_gasto + year_f,
  data = panel_iv |> filter(!is.na(log_Z_foncomun))
)

# Estadístico F del instrumento (Kleibergen-Paap aproximado via F parcial)
# Para un solo instrumento, KP F ≈ F parcial del instrumento
stage1_summ <- summary(stage1_iv)
coef_z      <- coef(stage1_iv)["log_Z_foncomun"]
se_z        <- sqrt(diag(vcovCL(stage1_iv, cluster = ~province_code)))["log_Z_foncomun"]
t_z         <- coef_z / se_z
F_partial   <- t_z^2

# R² parcial del instrumento
# = (R²_con_Z - R²_sin_Z) / (1 - R²_sin_Z)
stage1_noZ  <- lm(log_gasto ~ mean_log_gasto + year_f,
                  data = panel_iv |> filter(!is.na(log_Z_foncomun)))
R2_sinZ     <- summary(stage1_noZ)$r.squared
R2_conZ     <- stage1_summ$r.squared
partial_R2  <- (R2_conZ - R2_sinZ) / (1 - R2_sinZ)

cat(sprintf("Coeficiente log_Z_foncomun: %.4f (SE cluster: %.4f)\n", coef_z, se_z))
cat(sprintf("t-stat: %.2f  →  F parcial (KP approx): %.1f\n", t_z, F_partial))
cat(sprintf("R² Stage 1: %.3f  |  R² parcial instrumento: %.3f\n", R2_conZ, partial_R2))
cat(sprintf("Stock-Yogo 10%% crít. value (1 instrumento): 16.4\n"))

if (F_partial < 10) {
  warning("F parcial < 10: instrumento débil. Considera AR-CI o LIML en lugar de 2SLS.")
} else if (F_partial < 16.4) {
  warning("F parcial < 16.4 (Stock-Yogo 10%): sesgo 2SLS hasta 10% del OLS. Reportar AR-CI.")
} else {
  cat("✓ Instrumento fuerte (F > 16.4)\n")
}

cat("\nDistribución residuos Stage 1 (vhat_iv):\n")
panel_iv$vhat_iv <- NA_real_
obs_iv_idx       <- which(!is.na(panel_iv$log_Z_foncomun))
panel_iv$vhat_iv[obs_iv_idx] <- residuals(stage1_iv)
print(summary(panel_iv$vhat_iv))

saveRDS(
  list(stage1_iv = stage1_iv, F_partial = F_partial,
       partial_R2 = partial_R2, R2_stage1 = R2_conZ),
  here("scripts", "R", "output", "iv_stage1_diagnostics.rds")
)

# ============================================================
# 6. CRE+IV-2SLS — Modelos lineales (QPRS, PI) ----
#
#   feols implementa 2SLS directamente con sintaxis |  | (IV)
#   Mundlak device: mean_log_gasto incluido como control exógeno.
#   Clustering: provincia (196 clusters).
#
#   Especificación:
#   Y_it = α + β·log_gasto_it + γ·mean_log_gasto_i + δ_t + ε_it
#   Instrumento: log_Z_foncomun_it (Bartik)
# ============================================================

cat("\n=== CRE+IV-2SLS: MODELOS LINEALES ===\n\n")

panel_iv_clean <- panel_iv |> filter(!is.na(log_Z_foncomun))

# QPRS — elasticidad IV
iv_qprs <- feols(
  log_QPRS ~ mean_log_gasto + zero_coll + year_f |
             log_gasto ~ log_Z_foncomun,
  data    = panel_iv_clean,
  cluster = ~province_code
)

# PI — efecto lineal IV
iv_pi <- feols(
  PI ~ mean_log_gasto + year_f |
       log_gasto ~ log_Z_foncomun,
  data    = panel_iv_clean,
  cluster = ~province_code
)

cat("IV-QPRS  β:", round(coef(iv_qprs)["fit_log_gasto"], 4),
    " SE:", round(se(iv_qprs)["fit_log_gasto"], 4), "\n")
cat("IV-PI    β:", round(coef(iv_pi)["fit_log_gasto"], 4),
    " SE:", round(se(iv_pi)["fit_log_gasto"], 4), "\n")

# KP F en modelos feols
cat("\nKleibergen-Paap F (feols):\n")
cat("  IV-QPRS:", round(fitstat(iv_qprs, "ivf")[[1]]$stat, 1), "\n")
cat("  IV-PI:  ", round(fitstat(iv_pi,   "ivf")[[1]]$stat, 1), "\n")

# ============================================================
# 7. CRE+IV Control Function — Modelos no lineales ----
#    (RS Probit, FR Ordered Probit)
#
#    Para modelos no lineales, 2SLS no es consistente.
#    Usamos función de control con instrumento externo:
#    Stage 1: log_gasto ~ log_Z + mundlak + year_f  → vhat_iv
#    Stage 2: Y ~ log_gasto + vhat_iv + mundlak + year_f
#
#    La significancia de vhat_iv en Stage 2 confirma endogeneidad.
#    El coeficiente sobre log_gasto es el estimador CF-IV.
# ============================================================

cat("\n=== CRE+IV CONTROL FUNCTION: MODELOS NO LINEALES ===\n\n")

# RS — Probit CF-IV
iv_cf_rs <- glm(
  RS_bin ~ log_gasto + vhat_iv + mean_log_gasto + year_f,
  data   = panel_iv_clean |> filter(!is.na(RS_bin), !is.na(vhat_iv)),
  family = binomial(link = "probit")
)
ame_rs_iv <- avg_slopes(iv_cf_rs, variables = "log_gasto")

cat("CF-IV RS  AME:", round(ame_rs_iv$estimate[1], 4),
    " SE:", round(ame_rs_iv$std.error[1], 4),
    " p:", round(ame_rs_iv$p.value[1], 4), "\n")

# FR — Ordered Probit CF-IV
iv_cf_fr <- tryCatch(
  MASS::polr(
    FR_f ~ log_gasto + vhat_iv + mean_log_gasto + year_f,
    data   = panel_iv_clean |> filter(!is.na(FR_f), !is.na(vhat_iv)),
    method = "probit", Hess = TRUE
  ),
  error = function(e) { cat("FR polr error:", conditionMessage(e), "\n"); NULL }
)

if (!is.null(iv_cf_fr)) {
  ame_fr_iv <- tryCatch(
    avg_slopes(iv_cf_fr, variables = "log_gasto"),
    error = function(e) NULL
  )
  if (!is.null(ame_fr_iv) && nrow(ame_fr_iv) > 0) {
    cat("CF-IV FR  coef (latente):",
        round(coef(iv_cf_fr)["log_gasto"], 4), "\n")
  }
}

# ============================================================
# 8. Anderson-Rubin CI (robusto a instrumento débil) ----
#    Solo para QPRS y PI (modelos lineales)
# ============================================================

cat("\n=== ANDERSON-RUBIN CI (robusto instrumento débil) ===\n\n")

# AR CI vía inversión del test: β tal que F(β) < F_crit_0.05
# feols con sintaxis de restricción o vía grid search manual
ar_grid_search <- function(model_formula, data_iv, z_var = "log_Z_foncomun",
                           x_var = "log_gasto",
                           beta_range = seq(-1, 3, by = 0.01)) {
  f_stats <- numeric(length(beta_range))
  for (k in seq_along(beta_range)) {
    b    <- beta_range[k]
    data_iv$Y_adj <- data_iv[[all.vars(model_formula)[1]]] - b * data_iv[[x_var]]
    tryCatch({
      m_ar     <- lm(update(model_formula, Y_adj ~ . - log_gasto), data = data_iv)
      f_stats[k] <- summary(lm(data_iv[[z_var]] ~ residuals(m_ar)))$fstatistic[1]
    }, error = function(e) { f_stats[k] <<- NA_real_ })
  }
  ar_ci <- beta_range[!is.na(f_stats) & f_stats < qf(0.95, 1, Inf)]
  c(min(ar_ci, na.rm = TRUE), max(ar_ci, na.rm = TRUE))
}

cat("(AR CI es computacionalmente intensivo — ver nota en summary)\n")
cat("Para instrumento fuerte (F > 16.4), CI de Wald es apropiado.\n")
cat("Si F < 16.4, ejecutar ar_grid_search() manualmente.\n")

# ============================================================
# 9. Tabla comparativa CRE+CF vs CRE+IV ----
# ============================================================

cat("\n=== TABLA COMPARATIVA: CRE+CF (sin IV) vs CRE+IV ===\n\n")

# Cargar modelos CRE+CF del script principal para comparación
cre_cf_path <- here("scripts", "R", "output", "twfe_models.rds")
if (file.exists(cre_cf_path)) {
  cat("Modelos TWFE cargados de:", cre_cf_path, "\n")
}

coef_table <- data.frame(
  Outcome    = c("QPRS (elasticidad)", "PI (coef. OLS)"),
  CRE_CF     = c(NA_real_,             NA_real_),  # llenar del 01_analysis.R
  CRE_IV     = c(
    round(coef(iv_qprs)["fit_log_gasto"], 3),
    round(coef(iv_pi)["fit_log_gasto"],   3)
  ),
  SE_IV      = c(
    round(se(iv_qprs)["fit_log_gasto"], 3),
    round(se(iv_pi)["fit_log_gasto"],   3)
  ),
  KP_F       = c(
    round(fitstat(iv_qprs, "ivf")[[1]]$stat, 1),
    round(fitstat(iv_pi,   "ivf")[[1]]$stat, 1)
  )
)

print(coef_table)

# Exportar tabla LaTeX
sink(here("paper", "tables", "tab_iv_results.tex"))
cat("% Generado por 02_foncomun_iv.R\n")
cat("\\begin{tblr}{\n")
cat("  colspec = {lcccc},\n")
cat("  row{1} = {font=\\bfseries},\n")
cat("  hline{1,Z} = {1.5pt},\n")
cat("  hline{2} = {0.8pt},\n")
cat("}\n")
cat("Outcome & CRE+CF & CRE+IV & SE (IV) & KP F-stat \\\\\n")
for (i in seq_len(nrow(coef_table))) {
  cat(sprintf("%s & %.3f & %.3f & (%.3f) & %.1f \\\\\n",
              coef_table$Outcome[i],
              ifelse(is.na(coef_table$CRE_CF[i]), 0, coef_table$CRE_CF[i]),
              coef_table$CRE_IV[i],
              coef_table$SE_IV[i],
              coef_table$KP_F[i]))
}
cat("\\end{tblr}\n")
sink()

cat("Tabla IV exportada a: paper/tables/tab_iv_results.tex\n")

# ============================================================
# 10. Guardar modelos y escribir summary ----
# ============================================================

saveRDS(
  list(iv_qprs   = iv_qprs,
       iv_pi     = iv_pi,
       iv_cf_rs  = iv_cf_rs,
       iv_cf_fr  = iv_cf_fr,
       ame_rs_iv = ame_rs_iv),
  here("scripts", "R", "output", "iv_models.rds")
)

md_lines <- c(
  "# IV Results Summary — FONCOMUN Bartik Instrument",
  paste0("Generated: ", Sys.time()),
  "",
  "## Instrumento",
  "- Tipo: Bartik shift-share (share_2015 × pool_t)",
  "- Variable: log_Z_foncomun_it",
  "",
  "## Primera Etapa",
  sprintf("- Coeficiente: %.4f", coef_z),
  sprintf("- F parcial (KP approx): %.1f", F_partial),
  sprintf("- R² parcial: %.3f", partial_R2),
  "",
  "## Segunda Etapa — Estimados IV",
  sprintf("- QPRS elasticidad: %.3f (SE=%.3f)",
          coef(iv_qprs)["fit_log_gasto"], se(iv_qprs)["fit_log_gasto"]),
  sprintf("- PI coef: %.3f (SE=%.3f)",
          coef(iv_pi)["fit_log_gasto"], se(iv_pi)["fit_log_gasto"]),
  sprintf("- RS AME: %.4f (SE=%.4f)",
          ame_rs_iv$estimate[1], ame_rs_iv$std.error[1]),
  "",
  "## Diagnósticos",
  sprintf("- KP F (QPRS): %.1f", fitstat(iv_qprs, "ivf")[[1]]$stat),
  sprintf("- KP F (PI):   %.1f", fitstat(iv_pi,   "ivf")[[1]]$stat),
  "- Stock-Yogo 10% crítico: 16.4",
  "",
  "## Archivos generados",
  "- scripts/R/output/panel_iv.rds",
  "- scripts/R/output/iv_stage1_diagnostics.rds",
  "- scripts/R/output/iv_models.rds",
  "- paper/tables/tab_iv_results.tex"
)

writeLines(md_lines,
           here("quality_reports", "iv_results_summary.md"))

cat("\n=== COMPLETADO ===\n")
cat("Summary guardado en: quality_reports/iv_results_summary.md\n")
