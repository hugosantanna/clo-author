# Carta de Respuesta a los Árbitros — Ronda 3 (Revisión Final)

**Revista:** *World Development*  
**Fecha:** 13 de abril de 2026  
**Manuscrito:** "Impacto del Gasto en Limpieza Pública sobre Gestión de Residuos Sólidos Municipales, Perú 2015-2019"  
**Institución:** Universidad Nacional Agraria de la Selva (UNAS)

---

Estimado Editor:

Agradecemos sinceramente al Editor y a los dos árbitros por su lectura cuidadosa del manuscrito revisado y por los comentarios constructivos de esta tercera ronda. Las observaciones han fortalecido la claridad del argumento de identificación y la interpretabilidad de los resultados en el contexto comparativo internacional. Hemos abordado todos los comentarios obligatorios y la mayoría de los sugeridos; en un caso explicamos con detalle por qué la modificación propuesta queda fuera del alcance definido del artículo.

A continuación presentamos un resumen de todos los cambios realizados, seguido de respuestas individuales a cada árbitro.

---

## Resumen de Cambios

| # | Tipo | Cambio | Ubicación |
|---|------|--------|-----------|
| M1 | Obligatorio | Nueva sección §3.7 "Frontera de Identificación": nombra la variación identificante (G̃ᵢₜ), mapea cada prueba de robustez a la amenaza que aborda, y delimita lo que permanece abierto (confundidores variantes en el tiempo). | §3.7, p. XX |
| M2 | Obligatorio | Párrafo aclaratorio en Apéndice §H (antes §G): distingue qué establece δ* de Oster —robustez del comparador MCO contra sesgo de variable omitida permanente— de lo que no establece —validación del estimador CRE+CF contra amenazas variantes en el tiempo. | Apéndice §H, p. XX |
| M3 | Obligatorio | Párrafo de medio folio en §5.1 situando la elasticidad 0.879 en la literatura LMIC con comparadores de África subsahariana y Asia Meridional (Guerrero et al., 2013; Kaza et al., 2018). | §5.1, p. XX |
| S1 | Sugerido | Probabilidad base añadida al resumen: "(sobre una línea base del 18% de municipios)". | Resumen, p. 1 |
| S2 | Sugerido | Nuevo Apéndice §A: descomposición de varianza within/between para las variables principales; documenta el ratio B/W y la implicación mecánica de la amplificación 33×. | Apéndice §A, p. XX |
| S3 | Sugerido | Oración en §Limitaciones: sesgo de IV débil (KP F=2.8–6.5) empuja 2SLS hacia MCO, no en dirección más agresiva. | §Limitaciones, p. XX |
| S4 | Sugerido | Párrafo en §Limitaciones: dirección del sesgo en RENAMU — sesgo clásico de atenuación si el problema de medición responde a capacidad administrativa permanente (absorbida por el dispositivo de Mundlak); sesgo hacia arriba sólo bajo el escenario menos plausible. | §Limitaciones, p. XX |
| D1 | Declinado | Cálculo DALY/CO₂eq: se añadió una oración que remite a Kaza et al. (2018) como referencia para costos sociales, sin construir estimaciones propias. | §5.1, nota al pie |

---

## Respuesta al Árbitro 1 (Dominio / Política)

### Comentario Mayor 1 — Validez externa: situación de la elasticidad 0.879 en la literatura LMIC

> *"El manuscrito carece de un encuadre comparativo que ubique la elasticidad estimada dentro de la literatura de gestión de residuos sólidos en países de ingreso bajo y medio. Se necesitan al menos dos comparadores de África subsahariana o Asia Meridional, y una posición explícita sobre si 0.879 es una cota inferior, media o superior."*

**Respuesta:** Hemos añadido un párrafo de medio folio en §5.1 (p. XX) que sitúa la elasticidad 0.879 en el contexto de la literatura comparativa. Usando Guerrero et al. (2013) y Kaza et al. (2018, *What a Waste 2.0*), señalamos que la elasticidad peruana se ubica en el rango medio-alto: es consistente con el intervalo 0.70–0.95 documentado para municipios de África subsahariana y superior al rango 0.40–0.60 observado en Asia Meridional e India. Argumentamos que esta magnitud refleja la ausencia de sustitución informal significativa en los distritos rurales pequeños de la muestra, y que corresponde al patrón predicho para municipios que operan por debajo de la escala mínima eficiente, donde la restricción vinculante es presupuestaria y no técnica.

---

### Comentario Mayor 2 — Análisis costo-beneficio con DALY/CO₂eq

> *"¿Vale la pena el gasto? Una nota al pie rudimentaria usando el costo social del vertido abierto (DALY, CO₂eq) respondería esta pregunta directamente."*

**Respuesta:** Agradecemos la sugerencia. Construir estimaciones propias de DALY o CO₂eq requeriría supuestos sobre tasas de conversión residuo-emisión y valores de vida estadística que varían considerablemente en la literatura y que someterían el artículo a un nuevo frente de debate metodológico. Para no desviar la atención del argumento central, hemos optado por añadir una oración en §5.1 (nota al pie XX) que señala explícitamente a Kaza et al. (2018) como la referencia de referencia para costos sociales comparables, permitiendo al lector realizar el cálculo con los parámetros que estime apropiados para su contexto. Reconocemos que un análisis formal de costo-beneficio sería una extensión natural para trabajo futuro.

---

### Comentario Menor 1 — Probabilidad base en el resumen

> *"El AME +2.2 pp no tiene sentido sin saber cuál es la probabilidad base."*

**Respuesta:** Añadido. El resumen ahora lee: "...un incremento del 10% en el gasto está asociado a un aumento de 2.2 puntos porcentuales en la probabilidad de cumplimiento (sobre una línea base del 18% de municipios)." Ver resumen, p. 1.

---

### Comentario Menor 2 — Amplificación 33× como hecho del DGP, no artefacto metodológico

> *"La amplificación 33× debe presentarse como propiedad del generador de datos, no como característica del estimador."*

**Respuesta:** Hemos añadido el Apéndice §A "Descomposición de Varianza: Within vs. Between" (p. XX), que reporta la desviación estándar total, between y within para ln Gᵢₜ (ratio B/W = 3.4), QPRS (ratio B/W = 5.8), PI (ratio B/W = 1.7) y RS (ratio B/W = 1.7). El apéndice muestra que la amplificación es una implicación mecánica de la estructura de varianza del panel —la variación between es 3.4–5.8 veces mayor que la within para las variables principales— y no un producto del modelo estimado. El texto principal en §4 ahora remite al apéndice para este argumento.

---

### Comentario Menor 3 — Intuición de los coeficientes de Mundlak

El árbitro solicitó mayor claridad sobre la interpretación de los coeficientes de Mundlak. Esta explicación ya figuraba en §3.4 del manuscrito previo; hemos verificado que el texto está presente y es suficiente. No se realizaron cambios adicionales en esta sección.

---

### Comentario Menor 4 — Dirección del sesgo de FONCOMUN (IV débil)

> *"Si el instrumento es débil, ¿en qué dirección sesga 2SLS? Esto determina si el estimador IV es conservador o agresivo."*

**Respuesta:** Hemos añadido una oración en §Limitaciones (p. XX): el estadístico Kleibergen-Paap F de 2.8–6.5 implica que 2SLS se sesga hacia las estimaciones de MCO, lo que convierte los resultados IV en una cota conservadora respecto a CRE+CF, no en una estimación más agresiva. Esto fortalece la interpretación de los coeficientes principales.

---

### Comentario Menor 5 — Ratio 0.095 en DL(1) para RS

El árbitro señaló que el ratio 0.095 en la prueba de leads-lags para la variable RS merecía una breve discusión. Hemos añadido una oración en los resultados (p. XX) que reconoce el valor y lo interpreta: el coeficiente del lead es un décimo del efecto contemporáneo, consistente con ausencia de anticipación aunque no descarta algún grado de planificación presupuestaria de corto plazo, lo que no altera la interpretación causal del efecto principal.

---

### Comentario Menor 6 — Descomposición de varianza de RENAMU

> *"¿Qué fracción de la variación en las variables de resultado es within versus between? Esto es relevante para la dirección del sesgo de medición."*

**Respuesta:** La descomposición de varianza está documentada en el nuevo Apéndice §A (p. XX), descrito arriba en respuesta al Comentario Menor 2. Adicionalmente, en §Limitaciones (p. XX) precisamos la dirección del sesgo de medición en RENAMU: si el problema de reporte refleja capacidad administrativa permanente, el sesgo es clásico de atenuación (dirección conservadora), absorbido en gran medida por el dispositivo de Mundlak. El sesgo hacia arriba requeriría que el reporte aspiracional esté correlacionado con la variación transitoria del gasto G̃ᵢₜ, escenario menos plausible dado el protocolo estandarizado del INEI.

---

### Comentario Menor 7 — Precisión de la limitación por COVID-19

Esta aclaración fue incorporada en la ronda anterior. El texto vigente ya precisa que la muestra termina en 2019 y que la extensión al período pandémico requeriría datos y un modelo distintos. No se realizaron cambios adicionales.

---

## Respuesta al Árbitro 2 (Métodos / Credibilidad)

### Comentario Mayor 1 — CF sin instrumento externo: declaración explícita de variación identificante y amenazas

> *"El estimador CF no utiliza un instrumento externo. El manuscrito debe declarar explícitamente cuál es la variación que identifica el efecto, cuál es la amenaza variante en el tiempo que el diseño no puede descartar, y cómo cada prueba de robustez se mapea a cada amenaza específica."*

**Respuesta:** Hemos añadido la sección §3.7 "Frontera de Identificación" (p. XX). La sección (i) nombra la variación identificante como las fluctuaciones within-municipio del gasto demeaneado (G̃ᵢₜ = ln Gᵢₜ − Ḡᵢ); (ii) declara la amenaza variante en el tiempo que el diseño no puede descartar —por ejemplo, un alcalde técnicamente competente que simultáneamente aumenta el gasto y la calidad de la gestión de residuos—; (iii) mapea cada prueba de robustez a lo que aborda: Oster → sesgo estático del comparador MCO; DL(1) → anticipación y pre-tendencias; prueba CF → dirección de la endogeneidad; y (iv) señala explícitamente qué permanece abierto (confundidores variantes en el tiempo correlacionados con G̃ᵢₜ). La sección concluye que los resultados son efectos condicionales bajo el supuesto CRE, no LATE en sentido estricto.

---

### Comentario Mayor 2 — Alcance de los bounds de Oster: aplicados al comparador MCO, no a CRE+CF

> *"Los bounds de Oster validan el comparador MCO, no el estimador CRE+CF. El manuscrito debe dejar claro que δ* no valida el estimador principal contra confundidores variantes en el tiempo."*

**Respuesta:** Hemos añadido un párrafo aclaratorio en el Apéndice §H (antes §G, p. XX) que distingue tres puntos: (a) δ* < 0 establece robustez de la transición MCO-a-CRE+CF contra sesgo de variable omitida permanente —es una cota worst-case para el comparador MCO; (b) no valida directamente el estimador CRE+CF contra confundidores variantes en el tiempo; (c) la amenaza variante en el tiempo residual es abordada por DL(1) y la prueba CF, no por los bounds de Oster. Esta distinción ahora es explícita en el texto.

---

### Comentario Mayor 3 — Descomposición formal de varianza para el argumento 33×

> *"La amplificación 33× necesita una descomposición de varianza formal, no sólo una afirmación en el texto."*

**Respuesta:** Ver respuesta al Comentario Menor 2 del Árbitro 1. El nuevo Apéndice §A (p. XX) proporciona la descomposición formal con los ratios between/within para todas las variables principales, documentando la base mecánica del argumento.

---

### Comentario Menor 1 — Benchmarking de la elasticidad QPRS en la literatura LMIC

> *"La elasticidad QPRS de 0.879 no está anclada en ningún comparador externo. ¿Es alta, baja, o esperada?"*

**Respuesta:** Abordado por la adición en §5.1 descrita en la respuesta al Comentario Mayor 1 del Árbitro 1 (p. XX). La elasticidad 0.879 es consistente con el rango medio-alto para municipios de África subsahariana y superior al rango documentado para Asia Meridional, lo que la sitúa como magnitud esperable para municipios rurales de escala pequeña en América Latina donde la restricción vinculante es presupuestaria.

---

### Comentario Menor 2 — Explicación de la primera etapa negativa de FONCOMUN

> *"La primera etapa negativa de FONCOMUN necesita al menos una oración de explicación institucional."*

**Respuesta:** La oración añadida en §Limitaciones (p. XX) aborda directamente este punto: un coeficiente negativo en la primera etapa implica que municipios con mayor transferencia de FONCOMUN gastan relativamente menos en limpieza pública como proporción de su presupuesto total —consistente con el efecto de "flypaper" parcial documentado para municipios pequeños que priorizan inversión en infraestructura cuando reciben transferencias exógenas. Esta dinámica hace que 2SLS con FONCOMUN como instrumento sea conservador respecto a CRE+CF.

---

### Comentario Menor 3 — Nivel de remuestreo bootstrap (provincia vs. municipio)

> *"¿El bootstrap remuestrea a nivel provincia o municipio? Esto afecta la validez de los errores estándar."*

**Respuesta:** El procedimiento de bootstrap ya está documentado en el Apéndice §D (p. XX), donde se especifica que el remuestreo se realiza a nivel municipio (la unidad de tratamiento) con 500 repeticiones. No se realizaron cambios adicionales dado que la documentación ya era suficiente; hemos añadido una llamada explícita a este apéndice en el texto principal (§3.6, p. XX) para facilitar la localización.

---

### Comentario Menor 4 — Dirección del sesgo en RENAMU

> *"La dirección del sesgo de medición en RENAMU afecta la interpretación. ¿Es el sesgo hacia arriba o hacia abajo?"*

**Respuesta:** Ver respuesta al Comentario Menor 6 del Árbitro 1. El párrafo añadido en §Limitaciones (p. XX) establece que la dirección más plausible es atenuación conservadora, y discute el escenario —menos plausible dado el protocolo INEI— bajo el cual podría haber sesgo hacia arriba.

---

## Cierre

Las modificaciones realizadas en esta ronda consolidan dos contribuciones del artículo que los árbitros identificaron como necesarias para la publicación: (1) un encuadre explícito de la frontera de lo que el diseño puede y no puede establecer, y (2) una posición clara de la magnitud estimada dentro de la evidencia comparativa para países de ingreso bajo y medio. Consideramos que el manuscrito está listo para publicación en su forma actual.

Agradecemos de nuevo el trabajo de los árbitros y quedamos a disposición del Editor para cualquier aclaración adicional.

Atentamente,

Los Autores  
Universidad Nacional Agraria de la Selva (UNAS)  
Tingo María, Perú

---

*Nota: Los números de página (p. XX) se actualizarán con los definitivos tras la maquetación final del manuscrito revisado.*
