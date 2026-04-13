# ============================================================
# 00_build_panel.R
# Thesis: Impacto del Gasto en Limpieza Pública sobre
#         Gestión de Residuos Sólidos Municipales, Perú 2015-2019
# Author: Dante Barreto Gamarra (UNAS)
# Purpose: Harmonize RENAMU 2015-2019 and build enriched panel
# Inputs:  data/raw/RENAMU_20{15..19}.xlsx
#          data/processed/panel_final_tesis.csv
# Outputs: data/processed/panel_enriched.rds
#          data/processed/panel_enriched.csv
#          data/processed/codebook.md
# ============================================================

# 0. Setup ----
library(here)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

set.seed(20240101)

dir.create(here("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("scripts", "R", "output"),  recursive = TRUE, showWarnings = FALSE)
dir.create(here("paper", "tables"),         recursive = TRUE, showWarnings = FALSE)

# ============================================================
# 1. Variable maps by year
# ============================================================
# Confirmed by inspecting first rows (ubigeo 010101 = Chachapoyas):
#
# | Variable       | 2015        | 2016        | 2017   | 2018   | 2019   |
# |----------------|-------------|-------------|--------|--------|--------|
# | frecuencia     | C37_P45_1   | C37_P45_1   | P43_1  | P41_1  | P40_1  |
# | poblacion      | C38_P46_1   | C38_P46_1   | P44_1  | P42_1  | P41_1  |
# | cobertura_cat  | C39_P47_1   | C39_P47_1   | P45_1  | P43_1  | P42_1  |
# | gasto_total    | C42_P50_T   | C42_P50_T   | P48_T  | P46_T  | P45_T  |
# | plan_1..5      | C40_P48_1-5 | C40_P48_1-5 |P46_1-5 |P44_1-5 |P43_1-5 |
# | prs_pct (%)    | C41_P49_2   | C41_P49_2   | P47_2  |P45_2_1 |P44_2_1 |
# | rs_bin (1=yes) | C41_P49_2_2 | C41_P49_2_2 |P47_2_2 | P45_2  | P44_2  |
#   rs_bin coding: 2015/16/17 use 1=yes,2=no -> recode; 2018/19 use 1=yes,2=no

# ============================================================
# 2. Reader functions per year
# ============================================================

read_renamu_year <- function(year, path) {
  df <- read_excel(path, sheet = 1) |>
    mutate(across(everything(), as.character))   # normalize types

  ubigeo_col <- "UBIGEO"

  if (year %in% c(2015, 2016)) {
    df <- df |> transmute(
      ubigeo        = str_pad(.data[[ubigeo_col]], 6, "left", "0"),
      year          = year,
      frecuencia    = as.numeric(C37_P45_1),
      poblacion     = as.numeric(C38_P46_1),
      cobertura_cat = as.numeric(C39_P47_1),
      gasto_total   = as.numeric(C42_P50_T),
      plan_1        = as.integer(as.numeric(C40_P48_1) > 0),
      plan_2        = as.integer(as.numeric(C40_P48_2) > 0),
      plan_3        = as.integer(as.numeric(C40_P48_3) > 0),
      plan_4        = as.integer(as.numeric(C40_P48_4) > 0),
      plan_5        = as.integer(as.numeric(C40_P48_5) > 0),
      prs_pct       = as.numeric(C41_P49_2),            # % to relleno sanitario
      rs_raw        = as.numeric(C41_P49_2_2)           # 1=yes, 2=no
    )
  } else if (year == 2017) {
    df <- df |> transmute(
      ubigeo        = str_pad(.data[[ubigeo_col]], 6, "left", "0"),
      year          = year,
      frecuencia    = as.numeric(P43_1),
      poblacion     = as.numeric(P44_1),
      cobertura_cat = as.numeric(P45_1),
      gasto_total   = as.numeric(P48_T),
      plan_1        = as.integer(as.numeric(P46_1) > 0),
      plan_2        = as.integer(as.numeric(P46_2) > 0),
      plan_3        = as.integer(as.numeric(P46_3) > 0),
      plan_4        = as.integer(as.numeric(P46_4) > 0),
      plan_5        = as.integer(as.numeric(P46_5) > 0),
      prs_pct       = as.numeric(P47_2),
      rs_raw        = as.numeric(P47_2_2)               # 1=yes, 2=no
    )
  } else if (year == 2018) {
    df <- df |> transmute(
      ubigeo        = str_pad(.data[[ubigeo_col]], 6, "left", "0"),
      year          = year,
      frecuencia    = as.numeric(P41_1),
      poblacion     = as.numeric(P42_1),
      cobertura_cat = as.numeric(P43_1),
      gasto_total   = as.numeric(P46_T),
      plan_1        = as.integer(as.numeric(P44_1) > 0),
      plan_2        = as.integer(as.numeric(P44_2) > 0),
      plan_3        = as.integer(as.numeric(P44_3) > 0),
      plan_4        = as.integer(as.numeric(P44_4) > 0),
      plan_5        = as.integer(as.numeric(P44_5) > 0),
      prs_pct       = as.numeric(P45_2_1),              # % to relleno sanitario
      rs_raw        = as.numeric(P45_2)                 # 1=yes, 2=no
    )
  } else if (year == 2019) {
    df <- df |> transmute(
      ubigeo        = str_pad(.data[[ubigeo_col]], 6, "left", "0"),
      year          = year,
      frecuencia    = as.numeric(P40_1),
      poblacion     = as.numeric(P41_1),
      cobertura_cat = as.numeric(P42_1),
      gasto_total   = as.numeric(P45_T),
      plan_1        = as.integer(as.numeric(P43_1) > 0),
      plan_2        = as.integer(as.numeric(P43_2) > 0),
      plan_3        = as.integer(as.numeric(P43_3) > 0),
      plan_4        = as.integer(as.numeric(P43_4) > 0),
      plan_5        = as.integer(as.numeric(P43_5) > 0),
      prs_pct       = as.numeric(P44_2_1),
      rs_raw        = as.numeric(P44_2)                 # 1=yes, 2=no
    )
  }
  return(df)
}

# ============================================================
# 3. Read and stack all years
# ============================================================

years <- 2015:2019
raw_path <- here("data", "raw")

renamu_list <- lapply(years, function(yr) {
  fpath <- file.path(raw_path, paste0("RENAMU_", yr, ".xlsx"))
  cat("Reading", fpath, "\n")
  read_renamu_year(yr, fpath)
})

renamu <- bind_rows(renamu_list)

cat("\n=== RENAMU stacked ===\n")
cat("Rows:", nrow(renamu), "\n")
cat("Municipalities:", n_distinct(renamu$ubigeo), "\n")
cat("Years:", sort(unique(renamu$year)), "\n")
cat("Missing gasto_total:", sum(is.na(renamu$gasto_total)), "\n")
cat("Missing frecuencia:", sum(is.na(renamu$frecuencia)), "\n")

# ============================================================
# 4. Recode and derive variables
# ============================================================

renamu <- renamu |>
  mutate(
    # Province code (first 4 digits of ubigeo)
    province_code = substr(ubigeo, 1, 4),

    # RS binary: 1=yes, 2=no -> recode to 0/1
    # For 2015/16/17: 1=yes, 2=no; for 2018/19: 1=yes, 2=no (same)
    RS = case_when(
      rs_raw == 1 ~ 1L,
      rs_raw == 2 ~ 0L,
      TRUE ~ NA_integer_
    ),

    # PRS: proportion to sanitary landfill (0-1)
    PRS = case_when(
      is.na(prs_pct) & RS == 0 ~ 0,
      !is.na(prs_pct)           ~ prs_pct / 100,
      TRUE ~ NA_real_
    ),
    PRS = pmax(0, pmin(1, PRS)),  # clamp to [0,1]

    # Planning index (0-5)
    PI = rowSums(cbind(plan_1, plan_2, plan_3, plan_4, plan_5), na.rm = FALSE),

    # Gasto per capita
    gasto_pc = case_when(
      poblacion > 0 ~ gasto_total / poblacion,
      TRUE ~ NA_real_
    ),
    log_G_pc = log(gasto_pc + 1),   # log(x+1) to handle zeros

    # Frecuencia as ordered factor (1-5)
    FR_f = factor(frecuencia,
                  levels = 1:5,
                  ordered = TRUE),

    # Coverage as ordered factor (1-4)
    CSRS_f = factor(cobertura_cat,
                    levels = 1:4,
                    ordered = TRUE),

    # Year factor
    year_f = factor(year)
  )

# ============================================================
# 5. Mundlak means (computed on full panel BEFORE analysis)
# ============================================================

renamu <- renamu |>
  group_by(ubigeo) |>
  mutate(
    mean_G_pc    = mean(log_G_pc,     na.rm = TRUE),
    mean_pop     = mean(log(poblacion + 1), na.rm = TRUE),
    mean_PI      = mean(PI,            na.rm = TRUE),
    mean_FR      = mean(frecuencia,    na.rm = TRUE)
  ) |>
  ungroup()

# ============================================================
# 6. Merge diagnostics
# ============================================================

base_panel <- read.csv(here("data", "processed", "panel_final_tesis.csv"),
                       stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM") |>
  mutate(ubigeo = str_pad(as.character(ubigeo), 6, "left", "0"),
         year   = as.integer(anio))

# Normalize column names (handle BOM or encoding issues)
names(base_panel) <- trimws(names(base_panel))

cat("\n=== MERGE DIAGNOSTICS ===\n")
cat("Base panel rows:", nrow(base_panel), "\n")
cat("Base panel columns:", paste(names(base_panel), collapse=", "), "\n")
cat("RENAMU rows:", nrow(renamu), "\n")

# Check match on frecuencia (known-good variable)
if ("frecuencia" %in% names(base_panel)) {
  check <- inner_join(
    base_panel |> select(ubigeo, year, frecuencia_csv = frecuencia),
    renamu     |> select(ubigeo, year, frecuencia_renamu = frecuencia),
    by = c("ubigeo", "year")
  )
  cat("Matched rows (base x RENAMU):", nrow(check), "\n")
  freq_agree <- mean(check$frecuencia_csv == check$frecuencia_renamu, na.rm = TRUE)
  cat("Frecuencia agreement rate:", round(freq_agree * 100, 1), "%\n")
} else {
  cat("NOTE: 'frecuencia' column not found in base panel — skipping match check\n")
  cat("Available columns:", paste(names(base_panel), collapse=", "), "\n")
}

# ============================================================
# 7. Final panel (use RENAMU as primary; add lag for DL(1))
# ============================================================

panel <- renamu |>
  arrange(ubigeo, year) |>
  group_by(ubigeo) |>
  mutate(
    log_G_pc_lag1 = dplyr::lag(log_G_pc, 1)
  ) |>
  ungroup() |>
  filter(!is.na(log_G_pc), !is.na(frecuencia), poblacion > 0)

cat("\n=== FINAL PANEL ===\n")
cat("Observations:", nrow(panel), "\n")
cat("Municipalities:", n_distinct(panel$ubigeo), "\n")
cat("Province clusters:", n_distinct(panel$province_code), "\n")
print(table(panel$year))
cat("\nMissing values by key variable:\n")
key_vars <- c("log_G_pc", "frecuencia", "PI", "PRS", "RS", "cobertura_cat")
for (v in key_vars) {
  cat(sprintf("  %-15s : %d missing (%.1f%%)\n",
              v, sum(is.na(panel[[v]])),
              100 * mean(is.na(panel[[v]]))))
}

# ============================================================
# 8. Save outputs
# ============================================================

saveRDS(panel, here("data", "processed", "panel_enriched.rds"))
write.csv(panel, here("data", "processed", "panel_enriched.csv"),
          row.names = FALSE, fileEncoding = "UTF-8")

cat("\n✓ Saved panel_enriched.rds and panel_enriched.csv\n")

# Quick codebook
codebook <- data.frame(
  variable = c("ubigeo","year","province_code","frecuencia","FR_f","cobertura_cat",
               "CSRS_f","gasto_total","gasto_pc","log_G_pc","log_G_pc_lag1",
               "PI","plan_1","plan_2","plan_3","plan_4","plan_5",
               "PRS","RS","poblacion","mean_G_pc","mean_pop","year_f"),
  label = c(
    "Código distrital 6 dígitos (RENAMU/SIAF key)",
    "Año (2015-2019)",
    "Código provincial 4 dígitos (cluster variable)",
    "Frecuencia de recolección (1=diaria, 5=nunca) [RENAMU C37/P43/P41/P40]",
    "Frecuencia ordenada factor 1-5",
    "Categoría cobertura del servicio 1-4 [RENAMU C39/P45/P43/P42]",
    "Cobertura ordenada factor 1-4",
    "Gasto devengado total limpieza pública S/ [RENAMU C42/P48/P46/P45]",
    "Gasto per capita (gasto_total/poblacion)",
    "log(gasto_pc + 1) — tratamiento principal G_pc",
    "log_G_pc rezagado 1 año (para DL(1))",
    "Índice planeamiento: suma 5 instrumentos binarios [RENAMU C40/P46/P44/P43]",
    "Plan de gestión RS (0/1) [RENAMU instrumento 1]",
    "Registro de generadores (0/1) [RENAMU instrumento 2]",
    "Programa segregación en fuente (0/1) [RENAMU instrumento 3]",
    "Servicio de barrido (0/1) [RENAMU instrumento 4]",
    "Presupuesto asignado RS (0/1) [RENAMU instrumento 5]",
    "Proporción residuos a relleno sanitario [0,1] [RENAMU C41/P47/P45/P44]",
    "Usa relleno sanitario (0/1) [derivado de RS_raw]",
    "Población distrital [RENAMU C38/P44/P42/P41]",
    "Media temporal de log_G_pc (Mundlak device)",
    "Media temporal de log(poblacion) (Mundlak device)",
    "Año como factor (efectos fijos de año)"
  ),
  source = "RENAMU INEI",
  stringsAsFactors = FALSE
)

writeLines(
  c("# Codebook — panel_enriched",
    paste0("**Generado:** ", Sys.time()),
    paste0("**Obs:** ", nrow(panel), " | **Municipios:** ", n_distinct(panel$ubigeo)),
    "",
    paste(c("| Variable | Label | Source |"),
          c("|---------|-------|--------|"),
          apply(codebook, 1, function(r) paste0("| ", r[1], " | ", r[2], " | ", r[3], " |")),
          sep = "\n")
  ),
  here("data", "processed", "codebook.md")
)

cat("✓ Saved codebook.md\n")
cat("\nDone: 00_build_panel.R\n")
