# Decision Record — Estrategia de Identificación
**Project:** Impacto del gasto ejecutado en limpieza pública sobre la gestión de RS en Perú (**2015–2019**)
**Agent:** Strategist + strategist-critic
**Date:** 2026-04-12
**Resolución:** N° 056/2026-D-FCEA, UNAS — 10 feb 2026 (modifica período de 2011-2020 a **2015–2019**)
**Status:** CONDITIONAL APPROVE — 4 issues bloqueantes pendientes (Issue 4.1 RESUELTO)

---

## Decision

**Estrategia elegida:** Panel de doble vía (TWFE) con IV basado en la fórmula de distribución del FONCOMUN como especificación de identificación principal.

**Modelos por dimensión:**

| Dimensión | Outcome | Modelo | Justificación |
|-----------|---------|--------|---------------|
| Eficiencia en recolección | FR (ordinal 1–5) | CRE Ordered Probit + AME | Escala ordinal; FE verdaderos inconsistentes en Probit no-lineal |
| Eficiencia en recolección | QPRS (kg/día) | Log-log OLS TWFE | Continua; interpretación directa como semi-elasticidad |
| Eficiencia en recolección | CSRS (cobertura ordinal) | CRE Ordered Probit + AME | Igual que FR |
| Planeamiento | PI (índice count 0–5) | OLS TWFE (primario) | Outcome primario continuo; simple e interpretable |
| Planeamiento | PIGARS, PMRS, SRRS, PTRS, PSFRSRS | CRE Probit + LPM-TWFE | Binarias; LPM como robustez |
| Disposición final | RS, Botadero, Reciclados, Quemados | CRE Probit + LPM-TWFE | Binarias |
| Disposición final | PRS, PBotadero, PReciclados, PRSRO | CRE Fractional Logit | Proporciones [0,1]; OLS inconsistente en los bordes |

---

## Alternatives Considered

| Diseño alternativo | Razón de rechazo |
|-------------------|-----------------|
| OLS cross-seccional puro | No controla heterogeneidad no observada entre municipios; altamente probable sesgo de selección |
| DiD (diferencias en diferencias clásico) | No hay cambio de política discreto y exógeno que defina grupos tratado/control en el período |
| RDD | No existe umbral de elegibilidad claro en el gasto de limpieza pública |
| Synthetic Control | Impracticable con ~1,800 municipios como unidades tratadas |
| Probit/Logit sin CRE | Inconsistente con datos de panel (problema de parámetros incidentales) |

---

## Key Assumptions

1. **Tendencias paralelas (TWFE):** En ausencia de cambios en la fórmula FONCOMUN, los municipios que reciben más y menos gasto habrían seguido tendencias paralelas en los outcomes de RS.
2. **Relevancia del instrumento:** La variación en transferencias FONCOMUN predichas por la fórmula genera variación sustancial en el gasto de limpieza pública. Verificar: F efectivo de Montiel Olea-Pflueger > 10.
3. **Restricción de exclusión:** Las transferencias FONCOMUN afectan los outcomes de RS **solo** a través del gasto en limpieza pública, no directamente ni a través de otras funciones de gasto. **[PENDIENTE DE VALIDACIÓN — ver Issue 2.1 del critic]**
4. **SUTVA:** El gasto en limpieza de un municipio no afecta los outcomes de RS de municipios vecinos. **[AMENAZA: botaderos compartidos entre municipios]**
5. **Mundlak device:** Las medias temporales de los regresores variables en el tiempo aproximan adequadamente los efectos fijos de municipio en los modelos no-lineales.

---

## What Would Invalidate the Strategy

| Hallazgo | Acción requerida |
|----------|-----------------|
| Primer estadio débil (F < 10) | Buscar instrumento alternativo o restringir muestra a municipios FONCOMUN-dependientes |
| Exclusión restriction violada (gasto total per cápita absorbe relevancia del instrumento) | Descartar IV; limitar inferencia causal a TWFE con controles ricos + discutir dirección del sesgo |
| Pre-trends test falla en TWFE | Revisar período muestral; considerar DiD escalonado (Callaway & Sant'Anna 2021) si hay heterogeneidad en timing |
| Fuerte evidencia de spillovers espaciales (errores Conley) | Añadir controles espaciales; redefinir unidad de análisis a mancomunidades |
| Módulo RENAMU no comparable antes de 2015 | Restringir muestra a 2015–2020 (consistente con CLAUDE.md original) |
| Clasificador SIAF incomparable antes de 2014 | Restringir muestra a 2014–2020 o construir serie empalmada con documentación |

---

## Open Questions (Pendientes de Resolución por el Investigador)

1. ✅ ~~**¿Cuál es el período muestral definitivo?**~~ **RESUELTO** — Resolución N° 056/2026-D-FCEA confirma **2015–2019** como el período oficial del estudio.
2. **¿Qué etapa del gasto SIAF se usa?** Confirmar: Gasto Ejecutado = devengado.
3. **¿Está disponible la serie FONCOMUN formula-predicted desde 2011?** Si no, esto limita el período del IV.
4. **¿Cuántos municipios no tienen match entre RENAMU y SIAF?** ¿Son sistemáticamente diferentes (más pequeños, más rurales)?
5. **¿El comité de tesis requiere un pre-analysis plan formal?** Si sí, ejecutar `/strategize pap` antes de proceder al análisis.

---

## Files

| Archivo | Descripción |
|---------|-------------|
| `quality_reports/strategy_memo_gasto_residuos_peru.md` | Memo completo de estrategia (Strategist) |
| `quality_reports/strategy_memo_gasto_residuos_peru_review.md` | Revisión adversarial (strategist-critic, 61/100) |
| `quality_reports/decisions/strategy_gasto_residuos_peru.md` | Este archivo — Decision Record |
