# Strategy Memo — Gasto en Limpieza Pública y Gestión de Residuos Sólidos Municipales en Perú
**Agent:** Strategist
**Date:** 2026-04-12
**Período oficial:** 2015–2019 (Resolución N° 056/2026-D-FCEA, UNAS — 10 feb 2026)
**Status:** CONDITIONAL APPROVE (strategist-critic score: 61/100 — ver review)
**Blocking issues:** 5 críticos/mayores — ver sección de revisión

---

## Pre-Strategy Report

**Research spec:** No encontrado como archivo independiente — inferido del documento de proyecto proporcionado por el usuario.
**Literature review:** No encontrado — no existe output del librarian en `quality_reports/`.
**Data assessment:** No encontrado — no existe output del explorer en `quality_reports/`.
**Domain profile:** Cargado desde `.claude/references/domain-profile.md`.

> ✅ **RESUELTO — Resolución N° 056/2026-D-FCEA (10 feb 2026):** El período oficial del estudio es **2015–2019**. El proyecto de tesis (versión anterior 2015–2019) fue modificado mediante resolución del Decano de la Facultad de Ciencias Económicas y Administrativas de la UNAS. El CLAUDE.md ya reflejaba el período correcto.

**Research question:** ¿El gasto público ejecutado en limpieza pública tiene un impacto causal sobre los indicadores de gestión de residuos sólidos municipales (eficiencia en recolección, planeamiento y disposición final) en los municipios peruanos entre **2015 y 2019**?

**Key findings from literature:**
- Ferreira & Barros (2021): existe correlación entre ingresos/gastos municipales y manejo de RS; diferencias por grupos de población.
- Vilca Mamani et al. (2021): ineficiencia en gasto municipal en Puno; mayor gasto no necesariamente mejora gestión.
- Molinos-Senante et al. (2022): eficiencia técnica en RS en Chile; municipios más eficientes que otros.
- Zhou et al. (2022): evaluación DEA de eficiencia en RS en China; mayor financiamiento para protección ambiental correlaciona con mejor gestión.
- **Gap:** Ningún trabajo identifica causalmente el efecto del gasto mediante variación exógena para Perú.

**Available data:**
- RENAMU (INEI) 2015–2019 — ~1,800 municipios/año — variables de gestión de RS, planeamiento, equipamiento
- SIAF/MEF — gasto devengado por función/sub-función — función 008 saneamiento/limpieza pública
- FONCOMUN (MEF) — transferencias intergubernamentales por fórmula — fuente de variación exógena
- CPV 2017 (INEI) — controles demográficos (interpolados entre 2007 y 2017)
- ENAHO/INEI — pobreza provincial (interpolada)

**Candidate designs:** OLS-TWFE, IV-2SLS (fórmula FONCOMUN), CRE Probit/Ordered Probit (dispositivo Mundlak), Fractional Logit (Papke-Wooldridge), LPM-TWFE.

---

## Paper Type

**Primario: Reduced-form causal inference.** El paper estima el efecto causal de un tratamiento continuo (gasto per cápita ejecutado en limpieza) sobre múltiples outcomes usando un panel municipal observacional. El diseño ideal asignaría gasto aleatoriamente; este diseño lo aproxima con TWFE + IV (fórmula FONCOMUN).

---

## Identification Strategy

### El experimento ideal y la distancia desde él

El experimento ideal asignaría aleatoriamente presupuestos de limpieza entre municipios. Los datos observacionales se alejan de esto de tres formas:
1. **Selección en niveles:** municipios más ricos y urbanizados gastan más y tienen mejores outcomes.
2. **Causalidad inversa:** municipios con peores outcomes pueden recibir más recursos (sesgo hacia abajo en OLS ingenuo).
3. **Confusores variables en el tiempo:** nuevas gestiones municipales pueden simultáneamente aumentar gasto y adoptar planes de gestión.

### Fuente de variación exógena: Fórmula FONCOMUN

La fórmula FONCOMUN distribuye la principal transferencia intergubernamental del Perú usando pesos fijados centralmente por el MEF basados en población, índices de pobreza, ruralidad y altitud. La variación año a año en transferencias predichas por la fórmula refleja cambios en el pool nacional y coeficientes de fórmula — no decisiones específicas del municipio. Dado que los municipios distritales pequeños y pobres dependen de FONCOMUN para el 80–95% de sus ingresos, la variación en transferencias predichas por la fórmula se traduce directamente en variación en el gasto total y por función.

---

## Outcome-Model Pairings by Dimension

### Dimensión 1 — Eficiencia en la Recolección

| Outcome | Escala | Modelo primario | Estimando |
|---------|--------|----------------|-----------|
| FR (frecuencia de recojo) | Ordinal 1–5 | CRE Ordered Probit, AME | AME en P(diaria) y P(diaria o interdiaria) |
| QPRS (kg/día recolectados) | Continua | Log-log OLS TWFE | Elasticidad del gasto sobre residuos recolectados |
| CSRS (cobertura del servicio) | Ordinal 1–4 | CRE Ordered Probit, AME | AME en P(>75% cobertura) |

**Ecuación estimante — QPRS:**
$$\ln(QPRS_{it}) = \beta_1 G_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \alpha_i + \lambda_t + \varepsilon_{it}$$

**Ecuación estimante — FR (índice latente, Ordered Probit):**
$$FR_{it}^* = \beta_1 G_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\psi} + \lambda_t + \varepsilon_{it}$$
$$FR_{it} = j \iff \kappa_{j-1} < FR_{it}^* \leq \kappa_j$$

> ⚠️ **Nota del critic [Issue 1.3]:** El memo debe especificar qué categoría del AME se reporta como titular. El AME sumado sobre todas las categorías es cero por construcción.

### Dimensión 2 — Planeamiento

**Outcome primario:** Índice de planeamiento $PI_{it} = \sum_{k=1}^{5} Y_{k,it}$ (count 0–5) — OLS TWFE.

**Outcomes secundarios (individuales):**
- PIGARS, PMRS, SRRS, PTRS, PSFRSRS — todos binarios

**Ecuación — CRE Probit (cada binaria):**
$$P(Y_{it} = 1 \mid \cdot) = \Phi\!\left(\beta_1 G_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\psi} + \lambda_t\right)$$

> ⚠️ **Nota del critic [Issue 3.2]:** La corrección Bonferroni-Holm debe aplicarse a los outcomes primarios (uno por dimensión), NO dentro de los componentes individuales que están mecánicamente correlacionados con el índice.

### Dimensión 3 — Disposición Final

**Outcomes binarios** (RS, Botadero, Reciclados, Quemados): CRE Probit + LPM-TWFE.

**Outcomes proporcionales** (PRS, PBotadero, PReciclados, PRSRO): **CRE Fractional Logit** (Papke-Wooldridge 1996):
$$E(PRS_{it} \mid \cdot) = \Lambda\!\left(\beta_1 G_{it} + \mathbf{X}_{it}'\boldsymbol{\beta}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\psi} + \lambda_t\right)$$

**Modelo de rezagos distribuidos** (para relleno sanitario y planeamiento) — **DL(1) con T=5 años:**
$$RS_{it} = \beta_1 G_{it} + \beta_2 G_{it-1} + \mathbf{X}_{it}'\boldsymbol{\gamma} + \alpha_i + \lambda_t + \varepsilon_{it}$$

Efecto acumulado: $\theta = \beta_1 + \beta_2$. Test: $H_0: \beta_1 + \beta_2 = 0$. Ver **§ Distributed Lag Adjustment** para justificación completa.

---

## Ecuación del Primer Estadio (IV) — Especificación CRE

$$G_{it} = \pi_0 + \pi_1 \hat{F}_{it} + \mathbf{X}_{it}'\boldsymbol{\pi}_2 + \bar{\mathbf{X}}_i'\boldsymbol{\pi}_3 + \lambda_t + v_{it}$$

donde $\hat{F}_{it}$ = transferencia FONCOMUN per cápita predicha por la fórmula; $\bar{\mathbf{X}}_i$ = medias temporales de municipio (Mundlak). **Estimado por OLS agrupado (no FE-within)** para compatibilidad con el segundo estadio CRE no-lineal. Ver **§ CRE + Control Function** para especificación completa y pseudo-código R.

---

## Vector de Controles

**Mínimo:** ln(población), tasa de urbanización (interpolada CPV 2007/2017), pobreza provincial (interpolada ENAHO), ln(ingresos propios per cápita), dummy capital provincial.

**Extendido:** densidad poblacional, quintiles de altitud × año, proporción sin acceso a saneamiento básico (CPV 2017 interpolado), ln(presupuesto total municipal per cápita).

---

## Estrategia de Clustering

Errores estándar agrupados al nivel de **provincia** (~196 clusters). Para modelos de función de control: bootstrap clustered a nivel de provincia (ambas etapas re-estimadas en cada iteración).

---

## Top 5 Objeciones del Árbitro

1. **"El gasto es endógeno — causalidad inversa."** Defensa: TWFE elimina selección time-invariant; IV FONCOMUN elimina causalidad inversa variable en el tiempo. Límites de Conley (2010) formalizan robustez a violación parcial.

2. **"La restricción de exclusión del FONCOMUN es violada — el FONCOMUN financia múltiples funciones."** Defensa: controlar por gasto total per cápita en el primer estadio; mostrar que el instrumento retiene poder con este control. Especificar $\gamma$ en los límites de Conley.

3. **"El dispositivo Mundlak no sustituye verdaderos efectos fijos en modelos no-lineales."** Defensa: LPM-TWFE reportado para todos los outcomes binarios y ordinales. Concordancia entre LPM y CRE Probit AME mostrada sistemáticamente.

4. **"Los resultados están impulsados por municipios grandes y urbanos."** Defensa: análisis de heterogeneidad por cuartil de población, estatus urbano/rural, quintil de dependencia FONCOMUN.

5. **"Con 15+ outcomes, algún resultado significativo es esperado por azar."** Defensa: tres índices pre-especificados (uno por dimensión) son los outcomes primarios. Bonferroni-Holm aplicado entre dimensiones.

---

## Robustness Plan (pre-especificado)

| Prioridad | Check | Rationale |
|-----------|-------|-----------|
| 1 | IV vs. TWFE: dirección y magnitud del sesgo | Confirmar causalidad inversa como fuente de sesgo |
| 2 | LPM-TWFE vs. CRE Probit AME (concordancia) | Validar supuesto distribucional del Probit |
| 3 | Límites de Conley (2010) para restricción de exclusión | Robustez a violación parcial |
| 4 | Rezago alternativo: G_{it-1} como tratamiento principal | Reducir endogeneidad contemporánea |
| 5 | IHS o niveles para QPRS (vs. log-log) | Abordar selección por zeros en municipios rurales |
| 6 | DL(1) y DL(3) como alternativas al DL(2) | Robustez a la estructura de rezagos |
| 7 | Clustering a departamento vs. provincia | Robustez a nivel de clustering |
| 8 | Wild cluster bootstrap (Cameron et al. 2008) | Verificar validez con distribución asimétrica de clusters |
| 9 | Muestra restringida a municipios FONCOMUN-dependientes | Clarificar LATE en la población complier |
| 10 | Excluir Lima Metropolitana | Robustez a municipios atípicos |
| 11 | Separar 2013–2014 vs. 2015–2020 | Heterogeneidad temporal; cambios en clasificador SIAF |
| 12 | Fractional Logit vs. OLS con transformación logit para proporciones | Robustez funcional para outcomes en [0,1] |
| 13 | Panel balanceado vs. desbalanceado (attrition RENAMU) | Robustez a pérdida selectiva de observaciones |
| 14 | Errores espaciales de Conley | Capturar spillovers entre municipios contiguos |
| 15 | SUR compositional para disposición final | Imponer restricción de suma de proporciones = 1 |

---

## Falsification Tests

| Test | Por qué debería ser null |
|------|------------------------|
| Placebo: gasto en educación sobre outcomes de RS | No hay canal directo de educación a RS en el modelo |
| Pre-trends test (si hay datos previos) | Valida supuesto de tendencias paralelas para TWFE |
| Instrumento en gasto de otras funciones (salud, vialidad) | Verifica que FONCOMUN no opera solo a través de RS |
| Outcome en períodos previos como dependent variable | El gasto futuro no debe predecir outcomes pasados |
| Gasto de municipios no-limítrofes sobre outcomes locales | No debe haber efecto — elimina spillovers globales |
