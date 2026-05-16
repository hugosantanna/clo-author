# Pseudo-código R — Estrategia de Identificación
## Gasto en Limpieza Pública y Gestión de RS en Perú (2015–2019)
**Versión:** Round 3 — fixes integrados (CRE+CF Wooldridge 2015, Conley UCI, Compliers, Bonferroni-Holm)
**Fecha:** 2026-04-12

---

## 0. Setup y carga de datos

```r
# ── Paquetes ──────────────────────────────────────────────────────────────
library(here)
library(dplyr)
library(fixest)      # feols para TWFE y 2SLS lineal
library(MASS)        # polr para Ordered Probit
library(sandwich)    # vcovCL para clustering manual
library(marginaleffects) # avg_slopes para AME
set.seed(20240101)

# ── Rutas (relativas a raíz del proyecto) ─────────────────────────────────
path_data    <- here("data", "cleaned", "panel_municipios_2015_2019.rds")
path_out_tab <- here("paper", "tables")
path_out_fig <- here("paper", "figures")

# ── Carga ─────────────────────────────────────────────────────────────────
panel <- readRDS(path_data)
# Variables clave:
#   ubigeo          — código distrital 6 dígitos (clave RENAMU y SIAF)
#   province_code   — código provincial (nivel de clustering)
#   year            — 2015, 2016, 2017, 2018, 2019
#   G_pc            — ln(gasto devengado limpieza per cápita) [SIAF fun.008]
#   Z_foncomun      — transferencia FONCOMUN per cápita predicha por fórmula
#   ln_QPRS         — ln(kg/día recolectados) [RENAMU]
#   FR_f            — frecuencia recojo, factor ordenado 1-5 [RENAMU]
#   CSRS_f          — cobertura, factor ordenado 1-4 [RENAMU]
#   PI              — índice planeamiento 0-5 (suma 5 binarias) [RENAMU]
#   PRS             — proporción residuos a relleno sanitario [RENAMU]
#   RS              — dummy relleno sanitario [RENAMU]
#   log_pop, urban_rate, poverty_rate, log_own_rev, provincial_dummy

# ── Merge RENAMU–SIAF: diagnóstico ────────────────────────────────────────
# Verificar tasa de match antes de cualquier análisis
n_renamu <- nrow(distinct(panel, ubigeo, year))
cat("Obs RENAMU–SIAF mergeadas:", n_renamu, "\n")
cat("Municipios únicos:", n_distinct(panel$ubigeo), "\n")
cat("Años disponibles:", sort(unique(panel$year)), "\n")
# Registrar municipios no mergeados y caracterizarlos (urbano/rural, tamaño)
```

---

## 1. Construcción de Mundlak means (CRÍTICO — usadas en TODOS los modelos CRE)

```r
# Las medias temporales de municipio (bar_X_i) deben calcularse UNA VEZ
# y usarse de forma IDÉNTICA en Stage 1 y Stage 2 de cada modelo CRE+CF.
# Esto es el requisito de coherencia de Wooldridge (2015, JHR Section 4).

panel <- panel |>
  group_by(ubigeo) |>
  mutate(
    mean_G_pc       = mean(G_pc,         na.rm = TRUE),
    mean_log_pop    = mean(log_pop,       na.rm = TRUE),
    mean_poverty    = mean(poverty_rate,  na.rm = TRUE),
    mean_urban      = mean(urban_rate,    na.rm = TRUE),
    mean_log_own    = mean(log_own_rev,   na.rm = TRUE)
  ) |>
  ungroup()

# También el FONCOMUN rezagado (para DL(1))
panel <- panel |>
  arrange(ubigeo, year) |>
  group_by(ubigeo) |>
  mutate(
    G_pc_lag1       = dplyr::lag(G_pc, 1),
    Z_foncomun_lag1 = dplyr::lag(Z_foncomun, 1)
  ) |>
  ungroup()

# Factor de año (para year dummies en modelos CRE pooled OLS)
panel$year_f <- factor(panel$year)

# FDR: ratio de dependencia FONCOMUN (para caracterización de compliers)
panel <- panel |>
  mutate(FDR = Z_foncomun / (log_own_rev + Z_foncomun),  # proxy
         high_FDR = as.integer(FDR > 0.70))
```

---

## 2. Dimensión 1 — Eficiencia en Recolección

### 2a. OLS TWFE — QPRS (outcome continuo, modelo primario D1)

```r
# ── TWFE (estima ATT bajo tendencias paralelas) ───────────────────────────
m_twfe_qprs <- feols(
  ln_QPRS ~ G_pc + log_pop + urban_rate + poverty_rate + log_own_rev +
             provincial_dummy | ubigeo + year,
  data    = panel,
  cluster = ~province_code
)

# ── IV 2SLS TWFE (estima LATE para municipios compliers) ──────────────────
m_iv_qprs <- feols(
  ln_QPRS ~ log_pop + urban_rate + poverty_rate + log_own_rev +
             provincial_dummy | ubigeo + year | G_pc ~ Z_foncomun,
  data    = panel,
  cluster = ~province_code
)

# Primer estadio: F de Montiel Olea-Pflueger
fitstat(m_iv_qprs, "ivf")   # umbral: > 10 convencional, > 23.11 (5% size)

# ── DL(1) para QPRS como robustez ─────────────────────────────────────────
m_dl1_qprs <- feols(
  ln_QPRS ~ G_pc + G_pc_lag1 + log_pop + urban_rate + poverty_rate +
             log_own_rev + provincial_dummy | ubigeo + year,
  data    = panel[!is.na(panel$G_pc_lag1), ],
  cluster = ~province_code
)
# Efecto acumulado θ = β1 + β2
theta_qprs <- sum(coef(m_dl1_qprs)[c("G_pc", "G_pc_lag1")])
```

### 2b. CRE Ordered Probit + CF — FR y CSRS (outcomes ordinales)

```r
# ════════════════════════════════════════════════════════════════════════════
# WOOLDRIDGE (2015) CRE + CF — ESPECIFICACIÓN CORRECTA
# Requisito: Stage 1 usa OLS AGRUPADO con Mundlak terms (NO feols con FE)
#            Stage 2 incluye vhat de Stage 1 como función de control
#            AMBAS etapas usan los MISMOS Mundlak means
# ════════════════════════════════════════════════════════════════════════════

# ── STAGE 1: CRE Linear Reduced Form (OLS agrupado, sin FE-within) ────────
stage1_fr <- lm(
  G_pc ~ Z_foncomun +
         log_pop + urban_rate + poverty_rate + log_own_rev +
         provincial_dummy + year_f +
         mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data = panel
)
panel$vhat_fr <- residuals(stage1_fr)

# Diagnóstico primer estadio (F para Z_foncomun)
s1_summary <- summary(stage1_fr)
cat("F primer estadio (Z_foncomun):", 
    (coef(s1_summary)["Z_foncomun", "t value"])^2, "\n")

# ── STAGE 2: CRE Ordered Probit + CF ──────────────────────────────────────
# vhat_fr = función de control que corrige endogeneidad de G_pc
# rho = coeficiente en vhat; rho ≈ 0 → G_pc exógeno (test de exogeneidad)
stage2_fr <- MASS::polr(
  FR_f ~ G_pc + vhat_fr +
         log_pop + urban_rate + poverty_rate + log_own_rev +
         provincial_dummy + year_f +
         mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data   = panel,
  method = "probit",
  Hess   = TRUE
)

# ── Average Marginal Effects ───────────────────────────────────────────────
# Reportar: AME en P(FR=1) — recolección DIARIA
# Reportar: AME en P(FR≤2) — diaria o interdiaria (umbral de adecuación)
ame_fr <- marginaleffects::avg_slopes(
  stage2_fr,
  variables = "G_pc",
  newdata   = panel
)
# SEs mediante bootstrap (ver Sección 5)

# ── Mismo procedimiento para CSRS ─────────────────────────────────────────
stage1_csrs <- lm(
  G_pc ~ Z_foncomun +
         log_pop + urban_rate + poverty_rate + log_own_rev +
         provincial_dummy + year_f +
         mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data = panel
)
panel$vhat_csrs <- residuals(stage1_csrs)   # idéntico a vhat_fr; se puede reusar

stage2_csrs <- MASS::polr(
  CSRS_f ~ G_pc + vhat_csrs +
           log_pop + urban_rate + poverty_rate + log_own_rev +
           provincial_dummy + year_f +
           mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data   = panel,
  method = "probit",
  Hess   = TRUE
)
# AME en P(CSRS=4) — cobertura >75%
ame_csrs <- marginaleffects::avg_slopes(
  stage2_csrs,
  variables = "G_pc",
  newdata   = panel
)
```

---

## 3. Dimensión 2 — Planeamiento

### 3a. OLS TWFE — Índice PI (outcome primario D2)

```r
# PI = suma de 5 binarias PIGARS + PMRS + SRRS + PTRS + PSFRSRS
m_twfe_pi <- feols(
  PI ~ G_pc + log_pop + urban_rate + poverty_rate + log_own_rev +
       provincial_dummy | ubigeo + year,
  data    = panel,
  cluster = ~province_code
)

m_iv_pi <- feols(
  PI ~ log_pop + urban_rate + poverty_rate + log_own_rev +
       provincial_dummy | ubigeo + year | G_pc ~ Z_foncomun,
  data    = panel,
  cluster = ~province_code
)
```

### 3b. CRE Probit + CF — Componentes binarios (secundarios D2)

```r
# Reutilizar vhat_fr (mismo Stage 1 para todos los modelos binarios/ordinales)
# El Stage 1 es el mismo para todas las dimensiones porque el tratamiento G_pc
# es el mismo. Solo se estima una vez.

run_cre_probit_cf <- function(outcome_var, data) {
  fmla <- as.formula(paste0(
    outcome_var, " ~ G_pc + vhat_fr + log_pop + urban_rate + poverty_rate + ",
    "log_own_rev + provincial_dummy + year_f + ",
    "mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own"
  ))
  glm(fmla, data = data, family = binomial(link = "probit"))
}

binary_planning <- c("PIGARS", "PMRS", "SRRS", "PTRS", "PSFRSRS")
models_planning <- lapply(binary_planning, run_cre_probit_cf, data = panel)
names(models_planning) <- binary_planning
```

### 3c. Anderson (2008) Standardized Planning Index (SPI) como robustez

```r
# Estandarizar con media/sd del cuartil inferior de gasto (control group)
low_spending <- panel |> filter(G_pc <= quantile(G_pc, 0.25, na.rm=TRUE))

spi_components <- binary_planning
spi_stats <- sapply(spi_components, function(v) {
  c(mu = mean(low_spending[[v]], na.rm=TRUE),
    sd = sd(low_spending[[v]],   na.rm=TRUE))
})

panel$SPI <- rowMeans(
  mapply(function(v, mu, sg) (panel[[v]] - mu) / sg,
         spi_components,
         spi_stats["mu",],
         spi_stats["sd", ],
         SIMPLIFY = TRUE),
  na.rm = TRUE
)

m_twfe_spi <- feols(
  SPI ~ G_pc + log_pop + urban_rate + poverty_rate + log_own_rev +
        provincial_dummy | ubigeo + year,
  data = panel, cluster = ~province_code
)
```

---

## 4. Dimensión 3 — Disposición Final

### 4a. DL(1) con CRE Probit + CF — RS binario (primario D3)

```r
# DL(1): G_pc + G_pc_lag1. Estimación en 2016-2019 (4 años).
panel_dl1 <- panel |> filter(!is.na(G_pc_lag1))

# Stage 1 CRE para DL(1) — incluir G_pc_lag1 como regresor en Stage 1
stage1_dl1 <- lm(
  G_pc ~ Z_foncomun + Z_foncomun_lag1 +
         G_pc_lag1 + log_pop + urban_rate + poverty_rate + log_own_rev +
         provincial_dummy + year_f +
         mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data = panel_dl1
)
panel_dl1$vhat_dl1 <- residuals(stage1_dl1)

# Stage 2 CRE Probit + CF para RS
stage2_rs_dl1 <- glm(
  RS ~ G_pc + G_pc_lag1 + vhat_dl1 +
       log_pop + urban_rate + poverty_rate + log_own_rev +
       provincial_dummy + year_f +
       mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data   = panel_dl1,
  family = binomial(link = "probit")
)

# Efecto acumulado: β1 + β2
theta_rs <- sum(coef(stage2_rs_dl1)[c("G_pc", "G_pc_lag1")])

# LPM TWFE como robustez
m_lpm_rs <- feols(
  RS ~ G_pc + G_pc_lag1 + log_pop + urban_rate + poverty_rate +
       log_own_rev + provincial_dummy | ubigeo + year,
  data = panel_dl1, cluster = ~province_code
)
```

### 4b. CRE Fractional Logit + CF — PRS proporción (primario D3)

```r
# Papke-Wooldridge (1996) QMLE — para outcomes en [0,1]
# Con control function de Stage 1 ya estimado
stage2_prs <- glm(
  PRS ~ G_pc + vhat_fr +
        log_pop + urban_rate + poverty_rate + log_own_rev +
        provincial_dummy + year_f +
        mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
  data   = panel,
  family = quasibinomial(link = "logit")
)
# AME via marginaleffects
ame_prs <- marginaleffects::avg_slopes(stage2_prs, variables = "G_pc",
                                        newdata = panel)
```

---

## 5. Bootstrap Province-Level (SEs correctos para modelos CRE+CF)

```r
# ════════════════════════════════════════════════════════════════════════════
# CRÍTICO: resamplear PROVINCIAS completas (no obs individuales)
# En cada iteración re-estimar AMBAS etapas
# ════════════════════════════════════════════════════════════════════════════

B         <- 500
provinces <- unique(panel$province_code)
n_prov    <- length(provinces)

# Pre-alocar matriz (columnas = coeficientes de stage2_fr)
n_coef    <- length(coef(stage2_fr))
boot_coef <- matrix(NA_real_, nrow = B, ncol = n_coef,
                    dimnames = list(NULL, names(coef(stage2_fr))))

for (b in seq_len(B)) {

  # ── 1. Resamplear provincias (con reemplazo) ────────────────────────────
  sampled <- sample(provinces, size = n_prov, replace = TRUE)

  # ── 2. Construir dataset bootstrap (preserva duplicados de provincia) ───
  boot_data <- dplyr::bind_rows(
    lapply(seq_along(sampled), function(k) {
      df <- panel[panel$province_code == sampled[k], ]
      df$.boot_id <- k    # evitar conflicto de ubigeo duplicado
      df
    })
  )

  # ── 3. Re-calcular Mundlak means en el sample bootstrap ─────────────────
  boot_data <- boot_data |>
    group_by(ubigeo, .boot_id) |>
    mutate(
      mean_G_pc    = mean(G_pc,        na.rm = TRUE),
      mean_log_pop = mean(log_pop,     na.rm = TRUE),
      mean_poverty = mean(poverty_rate,na.rm = TRUE),
      mean_urban   = mean(urban_rate,  na.rm = TRUE),
      mean_log_own = mean(log_own_rev, na.rm = TRUE)
    ) |>
    ungroup()

  # ── 4. Re-estimar Stage 1 ────────────────────────────────────────────────
  s1b <- lm(
    G_pc ~ Z_foncomun +
           log_pop + urban_rate + poverty_rate + log_own_rev +
           provincial_dummy + year_f +
           mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
    data = boot_data
  )
  boot_data$vhat_fr <- residuals(s1b)

  # ── 5. Re-estimar Stage 2 ────────────────────────────────────────────────
  s2b <- tryCatch(
    MASS::polr(
      FR_f ~ G_pc + vhat_fr +
             log_pop + urban_rate + poverty_rate + log_own_rev +
             provincial_dummy + year_f +
             mean_G_pc + mean_log_pop + mean_poverty + mean_urban + mean_log_own,
      data = boot_data, method = "probit", Hess = FALSE
    ),
    error = function(e) NULL
  )
  if (!is.null(s2b)) boot_coef[b, ] <- coef(s2b)
}

# ── SEs y CI ────────────────────────────────────────────────────────────────
valid        <- boot_coef[complete.cases(boot_coef), ]
boot_se      <- apply(valid, 2, sd)
boot_ci95    <- apply(valid, 2, quantile, probs = c(0.025, 0.975), na.rm = TRUE)
cat("Bootstrap convergencia:", nrow(valid), "/", B, "\n")
```

---

## 6. Conley, Hansen & Rossi (2012) — UCI Bounds (Fix Issue 1)

```r
# ════════════════════════════════════════════════════════════════════════════
# Aplicado al outcome primario de cada dimensión:
#   D1: ln_QPRS  |  D2: PI  |  D3: PRS (logit-transformado para OLS)
# ════════════════════════════════════════════════════════════════════════════

# ── Calibración: gamma_bar como fracción del |β_OLS| ─────────────────────
m_ols_qprs <- feols(
  ln_QPRS ~ G_pc + log_pop + urban_rate + poverty_rate + log_own_rev +
             provincial_dummy | ubigeo + year,
  data = panel, cluster = ~province_code
)
beta_ols <- abs(coef(m_ols_qprs)["G_pc"])
gamma_fracs <- c(0.05, 0.10, 0.25, 0.50)

# ── UCI loop ──────────────────────────────────────────────────────────────
uci_results <- lapply(gamma_fracs, function(frac) {
  gbar      <- frac * beta_ols
  gamma_seq <- seq(-gbar, gbar, length.out = 201)

  ci_all <- lapply(gamma_seq, function(g) {
    pd <- dplyr::mutate(panel, Y_adj = ln_QPRS - g * Z_foncomun)
    m  <- feols(
      Y_adj ~ log_pop + urban_rate + poverty_rate + log_own_rev +
               provincial_dummy | ubigeo + year | G_pc ~ Z_foncomun,
      data = pd, cluster = ~province_code
    )
    confint(m, level = 0.95)["fit_G_pc", ]
  })

  ci_mat  <- do.call(rbind, ci_all)
  uci_lo  <- min(ci_mat[, 1])
  uci_hi  <- max(ci_mat[, 2])

  list(gamma_frac   = frac,
       gamma_bar    = gbar,
       uci_lo       = uci_lo,
       uci_hi       = uci_hi,
       excludes_zero = (uci_lo > 0 | uci_hi < 0))
})

uci_table <- dplyr::bind_rows(lapply(uci_results, as.data.frame))
print(uci_table)
# Criterio de robustez: UCI excluye cero con gamma_frac = 0.25
# Exportar: here("paper","tables","tab_conley_uci.tex")

# ── Test de canal de presupuesto total (primer estadio robusto) ────────────
m_fs_total <- feols(
  G_pc ~ Z_foncomun + log(total_budget_pc) + log_pop + urban_rate +
         poverty_rate | ubigeo + year,
  data = panel, cluster = ~province_code
)
# Si Z_foncomun sigue siendo significativo → instrumento predice COMPOSICIÓN,
# no solo nivel total del gasto → restricción de exclusión más creíble

# ── Placebo: gasto en educación como outcome ───────────────────────────────
m_placebo_edu <- feols(
  ln_G_edu ~ Z_foncomun + log(total_budget_pc) + log_pop + urban_rate +
              poverty_rate | ubigeo + year,
  data = panel, cluster = ~province_code
)
# Esperado: coef(Z_foncomun) ≈ 0, p > 0.10
# Significativo = señal de violación de restricción de exclusión
```

---

## 7. Caracterización de Compliers y Heterogeneidad (Fix Issue 3)

```r
# ════════════════════════════════════════════════════════════════════════════
# LATE vs ATT:
#   TWFE = ATT (municipios con variación en gasto, sin importar fuente)
#   IV   = LATE (municipios cuyo gasto responde a variación FONCOMUN)
#
# Compliers ≈ municipios con FDR > 0.70 (alta dependencia FONCOMUN)
# ════════════════════════════════════════════════════════════════════════════

# ── Primer estadio por cuartil de FDR ─────────────────────────────────────
fdr_quartiles <- quantile(panel$FDR, probs = c(0.25, 0.50, 0.75), na.rm=TRUE)

fs_by_fdr <- lapply(1:4, function(q) {
  subset_q <- if (q == 1) {
    panel |> filter(FDR <= fdr_quartiles[1])
  } else if (q == 2) {
    panel |> filter(FDR > fdr_quartiles[1], FDR <= fdr_quartiles[2])
  } else if (q == 3) {
    panel |> filter(FDR > fdr_quartiles[2], FDR <= fdr_quartiles[3])
  } else {
    panel |> filter(FDR > fdr_quartiles[3])
  }
  feols(G_pc ~ Z_foncomun + log_pop + urban_rate + poverty_rate |
          ubigeo + year,
        data = subset_q, cluster = ~province_code)
})
# Predicción: coef(Z_foncomun) grande y significativo en Q4,
#             pequeño e insignificante en Q1

# ── Heterogeneidad en resultados por FDR ──────────────────────────────────
# Interacción G_pc × high_FDR para verificar LATE > ATT en compliers
m_het_qprs <- feols(
  ln_QPRS ~ G_pc * high_FDR + log_pop + urban_rate + poverty_rate +
             log_own_rev | ubigeo + year,
  data = panel, cluster = ~province_code
)
# coef(G_pc:high_FDR) > 0 → efecto mayor en municipios FONCOMUN-dependientes
```

---

## 8. Bonferroni-Holm — 3 Hipótesis Primarias (Fix Issue 4)

```r
# ════════════════════════════════════════════════════════════════════════════
# Aplicar B-H ENTRE las 3 hipótesis primarias (una por dimensión)
# NO dentro de los componentes binarios de D2 (están correlacionados con PI)
#
# H1: efecto sobre QPRS (D1 — recolección)
# H2: efecto sobre PI   (D2 — planeamiento)
# H3: efecto sobre PRS  (D3 — disposición final)
# ════════════════════════════════════════════════════════════════════════════

# Extraer p-valores de los modelos IV primarios de cada dimensión
p_H1 <- pvalue(m_iv_qprs)["fit_G_pc"]          # D1: QPRS
p_H2 <- pvalue(m_iv_pi)["fit_G_pc"]             # D2: PI
p_H3 <- as.numeric(summary(ame_prs)$p.value[1]) # D3: PRS (AME)

p_primary <- c(H1_QPRS = p_H1, H2_PI = p_H2, H3_PRS = p_H3)
cat("P-valores primarios:\n"); print(round(p_primary, 4))

# ── Bonferroni-Holm step-down ─────────────────────────────────────────────
bh_result <- p.adjust(p_primary, method = "holm")
cat("\nP-valores ajustados (Bonferroni-Holm):\n"); print(round(bh_result, 4))

# Umbrales secuenciales con m = 3:
#   p_(1) <= 0.05/3 = 0.0167
#   p_(2) <= 0.05/2 = 0.025
#   p_(3) <= 0.05/1 = 0.050

rejection_table <- data.frame(
  hypothesis = names(p_primary),
  p_raw      = round(p_primary, 4),
  p_adjusted = round(bh_result, 4),
  rejected   = bh_result < 0.05
)
print(rejection_table)
# Exportar: here("paper","tables","tab_bonferroni_holm.tex")

# ── Nota: componentes binarios de D2 NO llevan corrección B-H ────────────
# Se reportan con p-valores crudos, etiquetados como "secundarios/exploratorios"
# El SPI de Anderson (2008) es la alternativa robusta para D2 (ver Sección 3c)
```

---

## 9. Diagnósticos finales

```r
# ── Conley spatial SEs (spillovers entre municipios) ─────────────────────
# library(conleySE)   # o implementación manual con distancias lat-lon
# Reportar junto a SEs clustered para verificar consistencia

# ── Wild cluster bootstrap para inferencia robusta ────────────────────────
# library(fwildclusterboot)
# boottest(m_iv_qprs, clustid = "province_code", param = "fit_G_pc", B = 999)

# ── IHS como robustez para QPRS (municipios con cero recolección) ─────────
panel$IHS_QPRS <- log(panel$QPRS + sqrt(panel$QPRS^2 + 1))
m_ihs_qprs <- feols(
  IHS_QPRS ~ log_pop + urban_rate + poverty_rate + log_own_rev +
              provincial_dummy | ubigeo + year | G_pc ~ Z_foncomun,
  data = panel, cluster = ~province_code
)

# ── Exportar tabla principal ───────────────────────────────────────────────
# etable(m_twfe_qprs, m_iv_qprs, m_twfe_pi, m_iv_pi,
#        file = here("paper","tables","tab_main_results.tex"),
#        tex = TRUE)
```
