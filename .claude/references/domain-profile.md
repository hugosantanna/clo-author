# Domain Profile
<!-- Configurado para: Tesis de Maestría UNAS — Gasto público en limpieza pública y gestión de residuos sólidos municipales en Perú (2015–2019) -->
<!-- Paper type: Reduced-form causal inference -->
<!-- Última actualización: 2026-04-12 -->

---

## Field

**Primary:** Economía Pública / Economía Ambiental (Public Finance, Environmental Economics)
**Adjacent subfields:** Economía del Desarrollo, Descentralización Fiscal, Políticas Públicas Locales, Gestión Municipal

---

## Target Journals (ranked by tier)

<!-- El Orchestrator usa esto para selección de revista. El Librarian prioriza estas en búsquedas. -->

| Tier | Journals |
|------|----------|
| Top-5 generales | AER, JPE, QJE, REStud, Econometrica |
| Top field | Journal of Public Economics, Journal of Environmental Economics and Management (JEEM), Journal of Development Economics |
| Strong field | Environment and Development Economics, World Development, Latin American Economic Review (LAER), Economía (LACEA) |
| Specialty / tesis | Revista de Economía y Finanzas (BCRP), Apuntes (CIUP), Economía PUCP, CEPAL Review |

---

## Common Data Sources

<!-- El Explorer prioriza estas. El explorer-critic conoce sus peculiaridades. -->

| Dataset | Tipo | Acceso | Notas clave |
|---------|------|--------|-------------|
| SIAF (MEF) | Admin / panel municipal | Público — [consulta.mef.gob.pe](https://consulta.mef.gob.pe) | Gasto devengado por función, unidad ejecutora y municipio. Función 008 = Saneamiento; sub-categoría limpieza pública. Granularidad anual. |
| SIGERSOL / MINAM | Admin / panel municipal | Público — [sigersol.minam.gob.pe](http://sigersol.minam.gob.pe) | Indicadores de gestión de residuos sólidos por distrito: toneladas recolectadas, cobertura, disposición final, formalización. |
| RENAMU (INEI) | Encuesta municipal | Público — [inei.gob.pe](https://www.inei.gob.pe) | Registro Nacional de Municipalidades. Variables de capacidad institucional, personal, equipamiento y servicios municipales. Anual. |
| CPV 2017 (INEI) | Censo de población y vivienda | Público | Controles demográficos: población, densidad, NBI, acceso a servicios básicos a nivel distrital. |
| MEF — Presupuesto Institucional | Admin | Público | PIM y PIA por municipio. Permite calcular % de ejecución del gasto. |
| INEI — Pobreza distrital | Panel | Público | Tasa de pobreza monetaria a nivel distrital. Importante control socioeconómico. |

---

## Common Identification Strategies

<!-- El Strategist considera estas primero. El strategist-critic conoce las amenazas específicas del campo. -->

| Strategy | Aplicación típica | Supuesto clave a defender |
|----------|------------------|--------------------------|
| OLS múltiple con EF municipio y tiempo | Efecto del gasto ejecutado en limpieza pública sobre indicadores de residuos sólidos | Sin endogeneidad del gasto (o controlar con rezagos y variables instrumentales) |
| Panel con efectos fijos de doble vía (TWFE) | Panel 2015–2019, variación en gasto across municipios y años | Parallel trends; no spillovers entre municipios adyacentes |
| Logit / Probit (marginal effects) | Resultado binario: ¿el municipio tiene disposición final adecuada? ¿formalización del servicio? | Distribución del error correctamente especificada; reportar efectos marginales en media |
| Modelos ordenados (Ordered Logit/Probit) | Resultado ordinal: nivel de gestión de residuos (categorías MINAM) | Proporcionalidad de odds (testar con Brant test); robustez con OLS sobre escala ordinal |
| IV (si endogeneidad es preocupación) | Instrumento: transferencias FONCOMUN rezagadas o fórmula de distribución exógena | Relevancia y exclusión del instrumento; primer estadístico de F > 10 |

---

## Field Conventions

<!-- El Coder y Writer siguen estas. El writer-critic verifica. -->

- **Panel municipal:** Unidad de análisis = distrito-año. Cluster de errores estándar al nivel de provincia (unidad de política).
- **Gasto:** Usar logaritmo del gasto per cápita (o gasto sobre PIM) para reducir asimetría y facilitar interpretación semi-elasticidad.
- **Outcomes binarios:** Reportar LPM (para comparabilidad e interpretación directa) y Logit/Probit con efectos marginales promedio (AME) de forma paralela.
- **Outcomes ordinales:** Ordered Logit como especificación principal; OLS como robustez. Reportar odds ratios Y efectos marginales.
- **Controles mínimos:** Población (log), densidad poblacional, tasa de pobreza, ingreso per cápita, dummy departamento, año.
- **Tablas:** Progresión de controles (sin controles → controles básicos → controles completos + EF).
- **Heterogeneidad:** Analizar por tamaño de municipio (urbano vs rural), sierra/selva/costa, y quintil de capacidad institucional.
- **Causalidad:** Este es un paper de forma reducida — el lenguaje debe ser cuidadoso: "asociación", "efecto condicional" excepto en secciones donde la estrategia de identificación lo justifique.
- **Unidades monetarias:** Soles constantes (deflactar con IPP o deflactor del gasto público del BCRP). Especificar año base.

---

## Notation Conventions

<!-- El Writer y writer-critic imponen estas convenciones. -->

| Símbolo | Significado | Anti-patrón |
|---------|------------|-------------|
| $Y_{it}$ | Indicador de gestión de residuos sólidos para municipio $i$ en año $t$ | No usar $y$ sin subíndices |
| $G_{it}$ | Gasto ejecutado per cápita en limpieza pública (log) | No confundir con presupuesto asignado (PIM) |
| $X_{it}$ | Vector de controles municipales observables | No usar $Z$ para controles (reservar para instrumentos) |
| $\alpha_i$ | Efecto fijo de municipio | No omitir en especificación con panel |
| $\lambda_t$ | Efecto fijo de año | No omitir — captura shocks nacionales (e.g., cambios Ley 27314) |
| $\varepsilon_{it}$ | Error idiosincrático | No usar $u$ si ya se usa para utilidad |
| $\beta_1$ | Coeficiente de interés — elasticidad/semi-elasticidad del gasto | Siempre reportar con SE robustos |

---

## Seminal References

<!-- El Librarian asegura que estos se citen cuando sean relevantes. El strategist-critic conoce sus métodos. -->

| Paper | Por qué importa |
|-------|----------------|
| Besley & Case (1995) | Fundamento teórico de comportamiento de gobiernos locales y gasto público |
| Tiebout (1956) | Competencia entre municipios y provisión eficiente de bienes públicos locales |
| Oates (1972) — *Fiscal Federalism* | Marco canónico de descentralización fiscal — relevante para gobiernos locales peruanos |
| Ley 27314 (Perú, 2000) + DS 014-2017-MINAM | Marco normativo de residuos sólidos en Perú — contexto institucional obligatorio |
| Acuña et al. (2012) — GRADE | Análisis de gestión municipal en Perú — referencia metodológica local |
| Seiglie (2003) | Gasto local en servicios ambientales — marco analítico |
| Faguet (2004) | Descentralización y efectividad del gasto local — caso Bolivia (comparable) |

---

## Field-Specific Referee Concerns

<!-- El domain-referee y methods-referee observan estos puntos. -->

- **"Endogeneidad del gasto"** — El gasto puede ser mayor donde los problemas de residuos ya son peores (causalidad inversa). Debe abordarse: IV, rezagos, o discutir dirección del sesgo.
- **"Selección municipal"** — Los municipios con más capacidad institucional gastan más Y gestionan mejor los residuos. Control: RENAMU institucional, EF municipio.
- **"¿La fuente SIGERSOL tiene reporte selectivo?"** — No todos los municipios reportan. Analizar attrition y reportar si el panel es balanceado.
- **"Unidad de análisis apropiada"** — ¿Distrito o provincia? ¿El gasto de la municipalidad provincial incluye gastos de distritos satélite?
- **"¿Qué es 'gestión adecuada'?"** — El outcome debe estar bien definido y justificado. Usar definición MINAM oficialmente validada.
- **"External validity"** — Resultados para Perú (país con descentralización débil) pueden no generalizarse. Discutir explícitamente.
- **"¿Gasto ejecutado vs devengado vs pagado?"** — Precisar el concepto de gasto del SIAF usado y justificarlo.

---

## Quality Tolerance Thresholds

| Cantidad | Tolerancia | Justificación |
|----------|-----------|---------------|
| Estimaciones puntuales | 1e-6 | Precisión numérica estándar en regresiones OLS |
| Errores estándar clustered | 1e-4 | Variabilidad aceptable con clustering a nivel provincia |
| Efectos marginales (Logit/Probit) | 1e-4 | Variabilidad del método delta |
| Odds ratios | 2 decimales mínimo | Convención del campo |
