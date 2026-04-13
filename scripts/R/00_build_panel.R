# ============================================================
# 00_build_panel.R
# Thesis: Impacto del Gasto en Limpieza Pública sobre
#         Gestión de Residuos Sólidos Municipales, Perú 2015-2019
# Author: Dante Barreto Gamarra (UNAS)
# Purpose: Harmonize RENAMU 2015-2019 using OFFICIAL dictionary
#          (validated 2026-04-13 by Dante Barreto Gamarra)
# Inputs:  data/raw/RENAMU_20{15..19}.xlsx
# Outputs: data/processed/panel_enriched.rds / .csv
#          data/processed/codebook.md
# ============================================================

# 0. Setup ----
library(here)
library(readxl)
library(dplyr)
library(stringr)

set.seed(20240101)

dir.create(here("data", "processed"),  recursive = TRUE, showWarnings = FALSE)
dir.create(here("scripts", "R", "output"), recursive = TRUE, showWarnings = FALSE)

# ============================================================
# MAPA DE VARIABLES — Diccionario RENAMU oficial
# ============================================================
#
# TRATAMIENTO (Gasto devengado, SIAF Fun.008):
#   Gasto_Total : C42_P50_T | P48_T | P46_T | P45_T
#   Gasto_Recojo: C42_P50_1 | P48_1 | P46_1 | P45_1
#   Gasto_Barrid: C42_P50_2 | P48_2 | P46_2 | P45_2
#   Gasto_Otros : C42_P50_3 | P48_3 | P46_3 | P45_3
#
# D1 — Eficiencia en Recolección:
#   FR   (1-5)  : C37_P45_1 | P43_1 | P41_1 | P40_1
#   QPRS (kg/día): C38_P46_1 | P44_1 | P42_1 | P41_1
#     *** QPRS = kilogramos diarios recolectados, NO es población ***
#   CSRS (1-4)  : C39_P47_1 | P45_1 | P43_1 | P42_1
#
# D2 — Planeamiento (todos BINARIOS: presencia del instrumento > 0 → 1):
#   PIGARS : C40_P48_1 | P46_1 | P44_1 | P43_1
#   PMRS   : C40_P48_2 | P46_2 | P44_2 | P43_2
#   SRRS   : C40_P48_3 | P46_3 | P44_3 | P43_3
#   PTRS   : C40_P48_4 | P46_4 | P44_4 | P43_4
#   PSFRSRS: C40_P48_5 | P46_5 | P44_5 | P43_5
#
# D3 — Disposición Final (binario: 1=Sí, 2=No → recodif. 0/1;
#                          proporción: 0-100 → dividir /100):
#   RS / PRS        : C41_P49_1_1/C41_P49_1 | P47_2_2/P47_2 | P45_1/P45_1_1 | P44_1/P44_1_1
#   Botadero/PBot   : C41_P49_2_2/C41_P49_2 | P47_1_1/P47_1 | P45_2/P45_2_1 | P44_2/P44_2_1
#   Reciclados/PRec : C41_P49_3_3/C41_P49_3 | P47_3_3/P47_3 | P45_3/P45_3_1 | P44_3/P44_3_1
#   Quemados/PQuem  : C41_P49_4_4/C41_P49_4 | P47_4_4/P47_4 | P45_4/P45_4_1 | P44_4/P44_4_1
#   RSRO/PRSRO      : C41_P49_5_5/C41_P49_5 | P47_5_5/P47_5 | P45_5/P45_5_1 | P44_5/P44_5_1
# ============================================================

# Helpers ----
recode_bin <- function(x) {
  # RENAMU binary: 1=Sí, 2=No, 0 or NA = sin dato → recode to 0/1
  x <- suppressWarnings(as.numeric(x))
  dplyr::case_when(x == 1 ~ 1L, x == 2 ~ 0L, TRUE ~ NA_integer_)
}

plan_bin <- function(x) {
  # Planning instrument: value = code if present, 0 if absent → binary
  as.integer(suppressWarnings(as.numeric(x)) > 0)
}

n <- function(x) suppressWarnings(as.numeric(x))

# ============================================================
# 1. Year-specific readers ----
# ============================================================

read_year <- function(yr, path) {
  d <- read_excel(path, sheet = 1) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character))
  u <- str_pad(d[["UBIGEO"]], 6, "left", "0")

  if (yr %in% c(2015, 2016)) {
    data.frame(
      ubigeo = u, year = yr,
      # D1
      FR    = n(d[["C37_P45_1"]]),
      QPRS  = n(d[["C38_P46_1"]]),   # kg/día — NO es población
      CSRS  = n(d[["C39_P47_1"]]),
      # Gasto
      Gasto_Total   = n(d[["C42_P50_T"]]),
      Gasto_Recojo  = n(d[["C42_P50_1"]]),
      Gasto_Barrido = n(d[["C42_P50_2"]]),
      Gasto_Otros   = n(d[["C42_P50_3"]]),
      # D2
      PIGARS  = plan_bin(d[["C40_P48_1"]]),
      PMRS    = plan_bin(d[["C40_P48_2"]]),
      SRRS    = plan_bin(d[["C40_P48_3"]]),
      PTRS    = plan_bin(d[["C40_P48_4"]]),
      PSFRSRS = plan_bin(d[["C40_P48_5"]]),
      # D3
      RS          = recode_bin(d[["C41_P49_1_1"]]),
      PRS         = n(d[["C41_P49_1"]]) / 100,
      Botadero    = recode_bin(d[["C41_P49_2_2"]]),
      PBotadero   = n(d[["C41_P49_2"]]) / 100,
      Reciclados  = recode_bin(d[["C41_P49_3_3"]]),
      PReciclados = n(d[["C41_P49_3"]]) / 100,
      Quemados    = recode_bin(d[["C41_P49_4_4"]]),
      PQuemados   = n(d[["C41_P49_4"]]) / 100,
      RSRO        = recode_bin(d[["C41_P49_5_5"]]),
      PRSRO       = n(d[["C41_P49_5"]]) / 100,
      stringsAsFactors = FALSE
    )

  } else if (yr == 2017) {
    data.frame(
      ubigeo = u, year = yr,
      FR    = n(d[["P43_1"]]),
      QPRS  = n(d[["P44_1"]]),
      CSRS  = n(d[["P45_1"]]),
      Gasto_Total   = n(d[["P48_T"]]),
      Gasto_Recojo  = n(d[["P48_1"]]),
      Gasto_Barrido = n(d[["P48_2"]]),
      Gasto_Otros   = n(d[["P48_3"]]),
      PIGARS  = plan_bin(d[["P46_1"]]),
      PMRS    = plan_bin(d[["P46_2"]]),
      SRRS    = plan_bin(d[["P46_3"]]),
      PTRS    = plan_bin(d[["P46_4"]]),
      PSFRSRS = plan_bin(d[["P46_5"]]),
      RS          = recode_bin(d[["P47_2_2"]]),
      PRS         = n(d[["P47_2"]]) / 100,
      Botadero    = recode_bin(d[["P47_1_1"]]),
      PBotadero   = n(d[["P47_1"]]) / 100,
      Reciclados  = recode_bin(d[["P47_3_3"]]),
      PReciclados = n(d[["P47_3"]]) / 100,
      Quemados    = recode_bin(d[["P47_4_4"]]),
      PQuemados   = n(d[["P47_4"]]) / 100,
      RSRO        = recode_bin(d[["P47_5_5"]]),
      PRSRO       = n(d[["P47_5"]]) / 100,
      stringsAsFactors = FALSE
    )

  } else if (yr == 2018) {
    data.frame(
      ubigeo = u, year = yr,
      FR    = n(d[["P41_1"]]),
      QPRS  = n(d[["P42_1"]]),
      CSRS  = n(d[["P43_1"]]),
      Gasto_Total   = n(d[["P46_T"]]),
      Gasto_Recojo  = n(d[["P46_1"]]),
      Gasto_Barrido = n(d[["P46_2"]]),
      Gasto_Otros   = n(d[["P46_3"]]),
      PIGARS  = plan_bin(d[["P44_1"]]),
      PMRS    = plan_bin(d[["P44_2"]]),
      SRRS    = plan_bin(d[["P44_3"]]),
      PTRS    = plan_bin(d[["P44_4"]]),
      PSFRSRS = plan_bin(d[["P44_5"]]),
      RS          = recode_bin(d[["P45_1"]]),
      PRS         = n(d[["P45_1_1"]]) / 100,
      Botadero    = recode_bin(d[["P45_2"]]),
      PBotadero   = n(d[["P45_2_1"]]) / 100,
      Reciclados  = recode_bin(d[["P45_3"]]),
      PReciclados = n(d[["P45_3_1"]]) / 100,
      Quemados    = recode_bin(d[["P45_4"]]),
      PQuemados   = n(d[["P45_4_1"]]) / 100,
      RSRO        = recode_bin(d[["P45_5"]]),
      PRSRO       = n(d[["P45_5_1"]]) / 100,
      stringsAsFactors = FALSE
    )

  } else if (yr == 2019) {
    data.frame(
      ubigeo = u, year = yr,
      FR    = n(d[["P40_1"]]),
      QPRS  = n(d[["P41_1"]]),
      CSRS  = n(d[["P42_1"]]),
      Gasto_Total   = n(d[["P45_T"]]),
      Gasto_Recojo  = n(d[["P45_1"]]),
      Gasto_Barrido = n(d[["P45_2"]]),
      Gasto_Otros   = n(d[["P45_3"]]),
      PIGARS  = plan_bin(d[["P43_1"]]),
      PMRS    = plan_bin(d[["P43_2"]]),
      SRRS    = plan_bin(d[["P43_3"]]),
      PTRS    = plan_bin(d[["P43_4"]]),
      PSFRSRS = plan_bin(d[["P43_5"]]),
      RS          = recode_bin(d[["P44_1"]]),
      PRS         = n(d[["P44_1_1"]]) / 100,
      Botadero    = recode_bin(d[["P44_2"]]),
      PBotadero   = n(d[["P44_2_1"]]) / 100,
      Reciclados  = recode_bin(d[["P44_3"]]),
      PReciclados = n(d[["P44_3_1"]]) / 100,
      Quemados    = recode_bin(d[["P44_4"]]),
      PQuemados   = n(d[["P44_4_1"]]) / 100,
      RSRO        = recode_bin(d[["P44_5"]]),
      PRSRO       = n(d[["P44_5_1"]]) / 100,
      stringsAsFactors = FALSE
    )
  }
}

# ============================================================
# 2. Stack all years ----
# ============================================================

cat("Leyendo archivos RENAMU...\n")
panel <- dplyr::bind_rows(lapply(2015:2019, function(yr) {
  fp <- here("data", "raw", paste0("RENAMU_", yr, ".xlsx"))
  cat(" ", yr, "\n")
  read_year(yr, fp)
}))

cat("\nPanel apilado:", nrow(panel), "obs |",
    n_distinct(panel$ubigeo), "municipios |",
    n_distinct(panel$year), "años\n")

# ============================================================
# 3. Derivar variables ----
# ============================================================

panel <- panel |>
  dplyr::mutate(
    province_code = substr(ubigeo, 1, 4),
    year_f        = factor(year),

    # Tratamiento
    log_gasto    = log(Gasto_Total + 1),

    # D1: log(QPRS) con indicador de cero
    log_QPRS  = dplyr::if_else(QPRS > 0, log(QPRS), log(0.001)),
    zero_QPRS = as.integer(is.na(QPRS) | QPRS == 0),

    # D2: Planning Index (0-5)
    PI = PIGARS + PMRS + SRRS + PTRS + PSFRSRS,

    # D3: proporciones acotadas a [0,1]
    PRS       = pmax(0, pmin(1, dplyr::coalesce(PRS,       0))),
    PBotadero = pmax(0, pmin(1, dplyr::coalesce(PBotadero, 0))),

    # Factores ordenados (excluir código 0 = sin dato)
    FR_f   = factor(dplyr::if_else(FR   %in% 1:5, FR,   NA_real_),
                    levels = 1:5, ordered = TRUE),
    CSRS_f = factor(dplyr::if_else(CSRS %in% 1:4, CSRS, NA_real_),
                    levels = 1:4, ordered = TRUE)
  ) |>
  # Mundlak means — calculadas UNA VEZ, usadas igual en Stage 1 y Stage 2
  dplyr::group_by(ubigeo) |>
  dplyr::mutate(
    mean_log_gasto = mean(log_gasto,  na.rm = TRUE),
    mean_log_QPRS  = mean(log_QPRS,   na.rm = TRUE),
    mean_FR        = mean(FR,          na.rm = TRUE),
    mean_CSRS      = mean(CSRS,        na.rm = TRUE),
    mean_PI        = mean(PI,          na.rm = TRUE)
  ) |>
  dplyr::ungroup() |>
  # DL(1): rezago de gasto
  dplyr::arrange(ubigeo, year) |>
  dplyr::group_by(ubigeo) |>
  dplyr::mutate(log_gasto_lag1 = dplyr::lag(log_gasto, 1)) |>
  dplyr::ungroup()

# ============================================================
# 4. Diagnósticos ----
# ============================================================

cat("\n=== MISSINGS ===\n")
vars_check <- c("log_gasto","FR","QPRS","CSRS","PI","RS","PRS","Botadero","PBotadero")
for (v in vars_check) {
  nm <- sum(is.na(panel[[v]]))
  cat(sprintf("  %-14s : %5d missing (%5.1f%%)\n", v, nm, 100*nm/nrow(panel)))
}

cat("\nRS (recodif. 0/1):\n"); print(table(panel$RS, useNA = "ifany"))
cat("\nPI (0-5):\n");          print(table(panel$PI, useNA = "ifany"))
cat("\nFR (1-5):\n");          print(table(panel$FR, useNA = "ifany"))

# ============================================================
# 5. Guardar ----
# ============================================================

saveRDS(panel, here("data", "processed", "panel_enriched.rds"))
write.csv(panel, here("data", "processed", "panel_enriched.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")
cat("\n✓ panel_enriched.rds / .csv guardados\n")

writeLines(c(
  "# Codebook — panel_enriched.rds",
  paste0("**Fecha:** ", format(Sys.time(), "%Y-%m-%d")),
  paste0("**Fuente:** RENAMU 2015-2019 (INEI) — mapeado vs. Diccionario oficial"),
  paste0("**Obs:** ", nrow(panel),
         " | **Municipios:** ", n_distinct(panel$ubigeo),
         " | **Provincias (clusters):** ", n_distinct(panel$province_code)),
  "",
  "| Variable | Descripción | Unidad | Código RENAMU (2015-16 / 2017 / 2018 / 2019) |",
  "|----------|-------------|--------|----------------------------------------------|",
  "| ubigeo | Código distrital | 6 dígitos | UBIGEO |",
  "| year | Año encuesta | 2015-2019 | — |",
  "| province_code | Código provincial (cluster) | 4 dígitos | derived |",
  "| **Tratamiento** ||||",
  "| Gasto_Total | Gasto devengado limpieza pública | S/ | C42_P50_T / P48_T / P46_T / P45_T |",
  "| Gasto_Recojo | Gasto recojo y transporte | S/ | C42_P50_1 / P48_1 / P46_1 / P45_1 |",
  "| Gasto_Barrido | Gasto barrido de calles | S/ | C42_P50_2 / P48_2 / P46_2 / P45_2 |",
  "| log_gasto | log(Gasto_Total+1) — tratamiento principal | ln(S/) | derived |",
  "| log_gasto_lag1 | log_gasto rezagado 1 año — DL(1) | ln(S/) | derived |",
  "| **D1 — Eficiencia** ||||",
  "| FR | Frecuencia de recojo (1=diaria … 5=nunca) | 1-5 ordenada | C37_P45_1 / P43_1 / P41_1 / P40_1 |",
  "| QPRS | **Kilogramos diarios** recolectados (NO es población) | kg/día | C38_P46_1 / P44_1 / P42_1 / P41_1 |",
  "| CSRS | Cobertura del servicio (1=<25% … 4=>75%) | 1-4 ordenada | C39_P47_1 / P45_1 / P43_1 / P42_1 |",
  "| **D2 — Planeamiento** ||||",
  "| PIGARS | Plan Integral Gestión Ambiental RS (0/1) | binaria | C40_P48_1 / P46_1 / P44_1 / P43_1 |",
  "| PMRS | Plan de Manejo RS (0/1) | binaria | C40_P48_2 / P46_2 / P44_2 / P43_2 |",
  "| SRRS | Sistema Recolección RS (0/1) | binaria | C40_P48_3 / P46_3 / P44_3 / P43_3 |",
  "| PTRS | Programa Transformación RS (0/1) | binaria | C40_P48_4 / P46_4 / P44_4 / P43_4 |",
  "| PSFRSRS | Programa Segregación en Fuente (0/1) | binaria | C40_P48_5 / P46_5 / P44_5 / P43_5 |",
  "| PI | Índice planeamiento = suma(5 binarias) | 0-5 | derived |",
  "| **D3 — Disposición Final** ||||",
  "| RS | Usa relleno sanitario (0=No, 1=Sí) | binaria | C41_P49_1_1 / P47_2_2 / P45_1 / P44_1 |",
  "| PRS | Proporción a relleno sanitario | [0,1] | C41_P49_1 / P47_2 / P45_1_1 / P44_1_1 |",
  "| Botadero | Usa botadero (0/1) | binaria | C41_P49_2_2 / P47_1_1 / P45_2 / P44_2 |",
  "| PBotadero | Proporción a botadero | [0,1] | C41_P49_2 / P47_1 / P45_2_1 / P44_2_1 |",
  "| Reciclados | Recicla residuos (0/1) | binaria | C41_P49_3_3 / P47_3_3 / P45_3 / P44_3 |",
  "| PReciclados | Proporción reciclada | [0,1] | C41_P49_3 / P47_3 / P45_3_1 / P44_3_1 |",
  "| Quemados | Quema residuos (0/1) | binaria | C41_P49_4_4 / P47_4_4 / P45_4 / P44_4 |",
  "| PQuemados | Proporción quemada | [0,1] | C41_P49_4 / P47_4 / P45_4_1 / P44_4_1 |",
  "| RSRO | Otro destino (0/1) | binaria | C41_P49_5_5 / P47_5_5 / P45_5 / P44_5 |",
  "| PRSRO | Proporción otro destino | [0,1] | C41_P49_5 / P47_5 / P45_5_1 / P44_5_1 |",
  "| **Mundlak means** ||||",
  "| mean_log_gasto | Media temporal log_gasto por municipio | — | derived |",
  "| mean_log_QPRS | Media temporal log(QPRS) | — | derived |",
  "| mean_FR | Media temporal FR | — | derived |",
  "| mean_PI | Media temporal PI | — | derived |"
), here("data", "processed", "codebook.md"))

cat("✓ codebook.md guardado\n")
cat("\nDone: 00_build_panel.R\n")
