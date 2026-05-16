# strategist-critic Review — Strategy Memo: Gasto en Limpieza Pública y Gestión de RS
**Agent:** strategist-critic
**Date:** 2026-04-12
**Target:** `quality_reports/strategy_memo_gasto_residuos_peru.md`
**Phase:** Strategy (severidad: ALTA)

---

## Score: 64/100 *(ajustado — Issue 4.1 resuelto por Resolución N° 056/2026-D-FCEA)*
*(Score original: 61/100)*
**Verdict: CONDITIONAL APPROVE**

---

### Phase 1 — Claim Identification: 17/25

**Issue 1.1: Ambigüedad del estimando — LATE vs. ATT no resuelto**
**Severidad: MAJOR** (–4)

El memo trata el estimado IV y el TWFE como si estimaran lo mismo, pero no es así. TWFE recupera (bajo tendencias paralelas) un ATT ponderado entre municipios y años. El IV FONCOMUN recupera un LATE — el efecto promedio para municipios cuyo gasto en limpieza cambia por variación en la fórmula FONCOMUN. Son estimandos diferentes. El memo debe especificar explícitamente:
- ¿Quiénes son los "compliers"? Municipios más dependientes financieramente de FONCOMUN, con menos ingresos propios, probablemente rurales/pobres.
- ¿Es el LATE relevante para la política? Si el claim de la tesis es "el gasto mejora los outcomes", el LATE aplica solo a municipios FONCOMUN-dependientes.
- TWFE e IV deben presentarse como estimando objetos diferentes, no como el IV "corrigiendo" el TWFE por endogeneidad.

**Issue 1.2: Definición del tratamiento — devengado vs. pagado no resuelto**
**Severidad: MAJOR** (–3)

El memo indica "SIAF/MEF" pero no especifica la etapa del gasto. SIAF rastrea cuatro etapas: certificado, devengado, girado, pagado. Estas divergen, especialmente en municipios con gestión tesorera deficiente. El limpieza pública normalmente se registra en devengado, pero las tasas de ejecución varían. Si se usa pagado, los retrasos municipales crean error de medición sistemáticamente correlacionado con capacidad administrativa — confusor que los controles pueden no absorber. **Especificar: Gasto Ejecutado = devengado.**

**Issue 1.3: AME para outcomes ordinales no especificado**
**Severidad: MINOR** (–1)

Para FR (ordinal 1–5) y CSRS (ordinal 1–4), el memo reporta "AME" sin especificar la categoría. Los AME del Ordered Probit son específicos por categoría: $\partial P(Y=k)/\partial G$ difiere para cada $k$. El memo debe especificar qué categoría reporta como titular (se recomienda P(diaria) para FR y P(>75%) para CSRS).

---

### Phase 2 — Core Design Validity: 16/35

**Issue 2.1: Restricción de exclusión — FONCOMUN es fungible entre líneas presupuestarias**
**Severidad: CRITICAL** (–10)

Este es el principal riesgo de identificación. La restricción de exclusión requiere que las transferencias FONCOMUN afecten los outcomes de RS **solo** a través del gasto en limpieza. Pero FONCOMUN es una transferencia general sin restricción — los municipios pueden asignarlo a vialidad, agua, personal, administración o deuda. Un municipio que recibe un incremento FONCOMUN puede gastarlo en saneamiento (agua/alcantarillado) que afecta directamente los outcomes de disposición final.

El memo menciona límites de Conley pero sin valores específicos de $\gamma$. **Bloqueante:** debe especificarse:
1. El valor de $\gamma$ (efecto directo del instrumento sobre el outcome) que haría insignificante el estimado.
2. Mostrar que el IV retiene poder en el primer estadio condicionando en gasto total per cápita.

**Issue 2.2: Interacción función de control + CRE — especificación incompleta**
**Severidad: CRITICAL** (–8)

El memo combina la corrección CRE (Mundlak) + función de control (IV en modelos no-lineales) sin especificar la interacción. El enfoque de función de control requiere:
1. Primer estadio: $G_{it} = \pi_1 \hat{F}_{it} + \mathbf{X}_{it}'\boldsymbol{\pi}_2 + \alpha_i + \lambda_t + u_{it}$
2. Calcular residuales $\hat{u}_{it}$
3. Incluir $\hat{u}_{it}$ en el segundo estadio no-lineal

**El problema:** si el primer estadio usa FE verdaderos (within-demean), los residuales son within-municipality. Si el segundo estadio usa CRE Probit con $\bar{\mathbf{X}}_i$, el demean del primer estadio y la corrección Mundlak del segundo estadio hacen cosas superpuestas pero no idénticas. **Referencia correcta: Wooldridge (2015, JHR).** El primer estadio también debe estimarse como CRE (con $\bar{\mathbf{X}}_i$, no FE-within) para que ambas etapas usen la misma aproximación de $\alpha_i$.

**Issue 2.3: Modelo de rezagos distribuidos — estructura de rezagos sin motivar**
**Severidad: MAJOR** (–5)

El DL(2) no está justificado. Específicamente:
1. Los rellenos sanitarios en Perú (bajo el marco PIGARS) típicamente toman 3–5 años desde planeación hasta operación. Si el rezago verdadero es mayor, DL(2) puede producir estimados atenuados.
2. Con 2 rezagos y datos 2011–2020, la ventana de estimación se reduce a 2013–2020. Si hubo cambios estructurales en 2011–2012 (creación MINAM, cambios regulatorios), la truncación puede introducir sesgo de selección.
3. Si $G_{it-1}$ es endógeno (mismo problema de causalidad inversa), también necesita instrumento. ¿Se usa $\hat{F}_{it-1}$? ¿Está disponible desde 2009–2010?

**Issue 2.4: SUTVA y spillovers espaciales**
**Severidad: MAJOR** (–4)

Con ~1,800 municipios peruanos, muchos son contiguos o comparten sitios de disposición final (botaderos). Los botaderos son frecuentemente compartidos entre municipios — una municipalidad que reduce su contribución afecta los outcomes de municipios vecinos, violando SUTVA. El memo debe especificar si se calculan errores estándar espaciales de Conley y si se examina la estructura espacial de los residuales.

**Issue 2.5: Log-log para QPRS cuando QPRS=0 es plausible**
**Severidad: MINOR** (–2)

Municipios sin recolección reportada (rurales o con datos faltantes RENAMU) son eliminados en la especificación log. Si la eliminación de la muestra log correlaciona con el tratamiento, el sample de estimación está seleccionado en el outcome. Reportar: (a) cuántos municipality-year tienen QPRS=0 o missing, (b) especificación IHS o niveles como robustez.

---

### Phase 3 — Inference Soundness: 14/20

**Issue 3.1: Clustering a provincia — 196 clusters es adecuado pero debe verificarse**
**Severidad: MINOR** (–2)

196 clusters es generalmente suficiente, pero depende del balance en tamaño de cluster. Perú tiene provincias con muy diferente número de municipios (Lima vs. provincias amazónicas pequeñas). Reportar distribución de tamaño de clusters y confirmar si se usa wild cluster bootstrap (Cameron, Gelbach, Miller 2008) como robustez, especialmente para modelos no-lineales.

**Issue 3.2: Corrección de múltiples comparaciones mal aplicada**
**Severidad: MAJOR** (–4)

Problema de lógica: el memo propone (a) testear el Índice de Planeamiento (PI = suma de 5 binarias) como outcome primario, Y (b) testear las 5 binarias individuales con Bonferroni-Holm. Pero el test del índice y los tests de componentes no son independientes — el índice es una función de los componentes. Bonferroni-Holm dentro de los sub-tests no resuelve el problema de testing múltiple; lo duplica.

**Corrección:** Aplicar Bonferroni-Holm a los 3 outcomes primarios (uno por dimensión: PI para planeamiento, QPRS/FR/CSRS para recolección, RS o PRS para disposición). Reportar componentes individuales como exploratoria/descriptivos.

**Issue 3.3: Bootstrap para modelos CRE con función de control — propagación de varianza incompleta**
**Severidad: MAJOR** (–4)

El bootstrap debe: (a) re-muestrear al nivel de provincia (bootstrap clustered), NO al nivel municipio-año; (b) re-estimar la totalidad del procedimiento en dos etapas en cada iteración bootstrap. Un SE bootstrapeado que solo re-estima la segunda etapa es inconsistente.

---

### Phase 4 — Polish and Completeness: 14/20

**Issue 4.1: Discrepancia de período muestral — ✅ RESUELTO (2026-04-12)**
~~**Severidad: MAJOR** (–3)~~ → **+3 puntos recuperados. Score ajustado: 64/100.**

**Resolución N° 056/2026-D-FCEA (UNAS, Decano Dr. Antonio Jesús Lazo Calle, 10 feb 2026)** modifica oficialmente el título de la tesis. Período definitivo: **2015–2019**. El módulo de RS de RENAMU tiene cobertura sólida desde 2015 (año de reestructuración del módulo de residuos). El clasificador presupuestario SIAF es homogéneo en todo el período 2015–2019. Además, el panel queda reducido a **5 años × ~1,800 municipios ≈ 9,000 obs**. Nota: con 5 años, el modelo de rezagos distribuidos DL(2) deja solo 3 años de estimación efectiva (2017–2019) — revisar si DL(1) es más apropiado.

**Issue 4.2: Estrategia de merge RENAMU-SIAF no especificada**
**Severidad: MAJOR** (–3)

No se especifica la clave de merge. RENAMU usa UBIGEO (código distrital de 6 dígitos); SIAF usa combinación de código de entidad + UBIGEO. El mapeo no es 1-a-1 para todos los años — municipios pequeños pueden registrarse bajo una entidad SIAF diferente, especialmente si caen bajo una municipalidad provincial. Debe especificarse: (a) clave de merge, (b) tasa de match por año, (c) caracterización de observaciones no mergeadas.

**Issue 4.3: Sin análisis de poder**
**Severidad: MINOR** (–2)

Para una tesis, se espera un cálculo de MDE (Mínimo Efecto Detectable). Con ~196 clusters efectivos (clustering a provincia), el N efectivo es moderado. Para outcomes binarios raros (relleno sanitario ~30%, reciclaje ~10%), la potencia para detectar efectos modestos puede ser baja. Incluir cálculo de MDE para al menos un outcome binario y uno continuo.

**Issue 4.4: Sin jerarquía pre-especificada de hipótesis**
**Severidad: MINOR** (–2)

Con 15+ variables dependientes, el comité de tesis puede percibir selección ex-post de resultados. Una jerarquía declarada ex ante (outcomes primarios vs. secundarios vs. exploratorios) por dimensión protege contra esta percepción.

---

### Summary

**Strengths:**
La estrategia de identificación es sofisticada para una tesis de maestría. El IV FONCOMUN es una fuente creíble de variación plausiblemente exógena en el contexto peruano. El uso del dispositivo CRE para modelos de panel no-lineales refleja cuidado metodológico genuino. La estructura de tres dimensiones con modelos apropiados por tipo de outcome (Fractional Logit para proporciones, Ordered Probit para ordinales, LPM como robustez) está bien razonada y va más allá de lo que la mayoría de las tesis intentan.

**Blocking issues (deben resolverse antes de despachar al Coder):**

1. **[CRÍTICO]** La restricción de exclusión debe argumentarse con más rigor. Los límites de Conley deben especificarse con valores reales de $\gamma$. Mostrar que el IV retiene poder condicionando en gasto total per cápita.
2. **[CRÍTICO]** La interacción función de control + CRE debe especificarse formalmente, siguiendo Wooldridge (2015, JHR). El primer estadio también debe estimarse como CRE, no como FE-within.
3. **[MAYOR]** Distinguir explícitamente ATT (TWFE) vs. LATE (IV). Caracterizar la población complier. Argumentar que el LATE es el estimando de interés para la política.
4. **[MAYOR]** Resolver la discrepancia de período muestral (2011–2020 vs. 2015–2019) y documentar disponibilidad del módulo RENAMU y clasificador SIAF por año.
5. **[MAYOR]** Reestructurar la corrección de testing múltiple: Bonferroni-Holm entre dimensiones (3 outcomes primarios), no dentro de componentes individuales.

**Recommended fixes (ordered by priority):**
1. Wooldridge (2015) CRE + control function: confirmar primer estadio como CRE; documentar construcción de residuales.
2. Límites de Conley con $\gamma$ específicos; test de primer estadio condicionando en gasto total.
3. Interpretar LATE explícitamente; caracterizar compliers con ratio de dependencia FONCOMUN.
4. Resolver timeline de datos: documentar disponibilidad RENAMU por módulo y año; documentar cambios en clasificador SIAF 2014.
5. Especificar clave de merge RENAMU-SIAF y tasa de match esperada.
6. Especificar qué categoría AME se reporta para FR y CSRS en Ordered Probit.
7. Reestructurar Bonferroni-Holm: aplicar entre dimensiones, no dentro de componentes.
8. Justificar DL(2) con tiempos de construcción de rellenos peruanos; confirmar instrumentalización de rezagos.
9. IHS o niveles como robustez para QPRS (zeros en municipios rurales).
10. Bootstrap clustered en ambas etapas de todos los modelos con función de control.
