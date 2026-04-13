# Final Results Summary
**Generado:** 2026-04-13 01:24
**Panel:** 1874 municipios × 5 años = 9322 obs | 196 clusters de provincia

---

## Modelo base: TWFE (Two-Way Fixed Effects)
| Outcome | Coef. log_gasto | SE | N |
|---------|-----------------|-----|---|
| FR (frecuencia) | -0.0809 | cluster-SE | 9322 |
| QPRS log-log | 0.0268 | cluster-SE | 9322 |
| CSRS (cobertura) | 0.1158 | cluster-SE | 9322 |
| PI (planeamiento) | 0.0386 | cluster-SE | 9322 |
| RS (relleno sanitario) | -0.0033 | cluster-SE | 9225 |
| PRS (proporción relleno) | -0.003 | cluster-SE | 9322 |

---

## Modelo CRE+CF (Wooldridge 2015, JHR)
Stage 1: OLS agrupado con Mundlak means — sin IV (Z_foncomun pendiente de merge con SIAF/MEF)

### D1 — Eficiencia en Recolección
- **FR (Ordered Probit)**: coef = -0.5215 | AME dP(FR=1) = n/a
- **QPRS (OLS log-log)**: coef = 0.8793  SE = 0.0212  p = 0
- **CSRS (Ordered Probit)**: coef = 0.254

### D2 — Planeamiento
- **PI (OLS)**: coef = 0.2995  SE = 0.0153  p = 0
- **Componentes binarios (Probit AME)**: PIGARS=0.0550

### D3 — Disposición Final
- **RS (Probit)**: AME = 0.0216
- **PRS (Fractional Logit)**: AME = 0.0261

---

## Prueba de endogeneidad (H0: vhat = 0)
- D1-QPRS: vhat p = 0
- D2-PI:   vhat p = 0

---

## Bonferroni-Holm (3 hipótesis primarias)
- H1 FR:  raw p = 0  ajustado = 0  **SIGNIFICATIVO**
- H2 PI:  raw p = 0  ajustado = 0  **SIGNIFICATIVO**
- H3 PRS: raw p = 0  ajustado = 0  **SIGNIFICATIVO**

---

## Archivos generados
- `scripts/R/output/panel_main.rds` — panel listo para análisis
- `scripts/R/output/twfe_models.rds` — modelos TWFE
- `scripts/R/output/cre_fr.rds` — CRE Ordered Probit FR
- `scripts/R/output/cre_qprs.rds` — CRE OLS QPRS
- `scripts/R/output/cre_csrs.rds` — CRE Ordered Probit CSRS
- `scripts/R/output/cre_pi.rds` — CRE OLS Planning Index
- `scripts/R/output/cre_plan_components.rds` — CRE Probit por componente D2
- `scripts/R/output/cre_rs.rds` — CRE Probit RS
- `scripts/R/output/cre_prs.rds` — CRE Fractional Logit PRS
- `paper/tables/tab_twfe_main.tex` — Tabla principal TWFE

## Limitaciones / Pendiente
- Z_foncomun (instrumento FONCOMUN) no disponible aún — requiere merge con datos MEF/SIAF
- Sin IV, el CF test mide endogeneidad pero no estima LATE
- Variables de control externas (pobreza, urbanización) pendientes (ENAHO/CPV)
