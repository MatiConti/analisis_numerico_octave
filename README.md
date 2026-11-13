# ¿Qué pasa si cambio las variables? — Resumen en simple

Este resumen explica qué cambia en los gráficos de cada ejercicio al modificar los parámetros.

Primero, la idea que sirve para todo el TP:

> **El filtro elige por FRECUENCIA, no por amplitud.**
> Las frecuencias menores a **Fc** pasan **iguales**. Las mayores **desaparecen**. Las que están **cerca de Fc** (en la "zona de transición") pasan **a medias**.

---

## Ejercicio 1 — Pulso ∗ rampa (`conv` básica)

| Si cambio… | Qué pasa |
|---|---|
| **Corro el pulso** (por ejemplo, de −2..2 a 3..7) | La salida se corre **lo mismo**. Siempre empieza en *(inicio de x) + (inicio de h)*. |
| **Hago el pulso más ancho** | La salida es **más larga** (largo = Lx + Lh − 1). Si el pulso tiene 6 o más muestras (el largo de la rampa), aparece una **meseta plana** en 15, que es la suma de h. |
| **Hago el pulso más angosto** | La salida es **más corta y más baja**. Con un pulso de 1 sola muestra, la salida es **la rampa misma**, desplazada. |
| **Hago la rampa más larga** (`nh = 0:10`) | La salida sube más alto y dura más. |

**Para recordar:** la convolución "desliza" una señal sobre la otra y suma. El inicio, el fin y el largo de la salida se calculan sumando los de x y h.

---

## Ejercicio 2 — Filtro sinc con `conv` (en n)

### Cambiar Δt (es lo que pide la guía: 0.0001 → 0.0005 → 0.001)

Cambiar Δt es cambiar la **frecuencia de muestreo**: Fm = 1/Δt. La frecuencia más alta que se puede representar es **Fm/2** (Nyquist).

| Δt | Fm | Máx. frecuencia (Fm/2) | Qué se ve |
|---|---|---|---|
| 0.0001 | 10.000 Hz | 5000 Hz | Todo bien: las dos senoidales están bien representadas y el filtro saca los 1000 Hz. |
| 0.0005 | 2000 Hz | 1000 Hz | Los 1000 Hz quedan **justo en el límite**. Como es un **seno**, todas sus muestras caen en **cero** y **desaparece de la entrada antes de filtrar**: x[n] ya es solo el coseno de 150 Hz. Además, la señal dura más (401 × 0,0005 = 0,2 s) y se ven más ciclos. |
| 0.001 | 1000 Hz | 500 Hz | Los 1000 Hz están **por encima del límite**: se produce **aliasing** (se "disfrazan" de otra frecuencia; acá caen en 0 Hz y, por ser seno, otra vez dan cero). El coseno de 150 Hz se ve "escalonado" porque tiene solo ≈ 7 muestras por ciclo. Fc = 400 queda muy cerca del límite de 500 Hz. |

**Conclusión:** si Δt es grande (pocas muestras por segundo), se **pierde información** de las frecuencias altas o se **confunden** con otras. Para que una frecuencia f se represente bien, hace falta **Fm > 2·f**.

En h[n] también se nota: el término `2*Fc*dt` pasa de 0,08 a 0,4 y a 0,8. La sinc se vuelve más "angosta" en n y su pico es más alto.

> Caso límite: si Fc ≥ Fm/2, h[n] se vuelve un **impulso** (un único 1 en n = 0) y el filtro **deja pasar todo**.

### Cambiar Nh (largo del filtro)

| Nh | Qué pasa |
|---|---|
| **Más grande** (201, 301…) | El corte es **más brusco**, más parecido al ideal. Pero los **transitorios en los bordes** de y[n] duran más (±(Nh−1)/2 muestras). |
| **Más chico** (21, 31…) | El corte es **más suave**: las frecuencias cercanas a Fc no se eliminan bien. Los transitorios son más cortos. |

Sin ventana (Ejercicios 2 y 3), el **sobrepico de Gibbs (~10 %) no desaparece** aunque Nh crezca: solo se vuelve más angosto. Eso es lo que corrige Hamming en el Ejercicio 4.

---

## Ejercicio 3 — Lo mismo pero por FFT

| Si cambio… | Qué pasa |
|---|---|
| **N más chico que Nx + Nh − 1** | La FFT hace una convolución **circular**: la cola de la salida **se dobla y se suma al principio**. La salida queda **mal** y el error deja de ser ≈ 0. (El `assert` está para frenar esto.) |
| **N más grande** (2048, 4096) | El espectro tiene **más puntos** y la curva se ve más suave. Pero **no** se separan mejor las frecuencias: eso depende de Nx, no de N. La salida es la misma. |
| **N que no sea potencia de 2** (por ejemplo 600) | Funciona igual (si N ≥ Ny), solo que la FFT es algo más lenta. |

Para ubicar las frecuencias en el eje k: **f = k · Fm / N**. Si cambia N, el mismo pico de 150 Hz aparece en otro k (con N = 2048 queda en k ≈ 31 en vez de 15).

---

## Ejercicio 4 — Filtro con Hamming (en segundos y Hz)

### Con o sin ventana de Hamming

|  | Sin ventana (Ejs. 2-3) | Con Hamming (Ej. 4) |
|---|---|---|
| Sobrepico en \|H\| | ~10-15 % (Gibbs) | Prácticamente 0 % |
| Rebotes después del corte | Sí | No |
| Ancho de la caída | Más angosto | **Más ancho** (es el precio que se paga) |

### Cambiar Nh (el "núcleo" del filtro): la zona de transición

Valores calculados para Fm = 10 kHz y Fc = 400 Hz, con Hamming:

| Nh | \|H\| empieza a caer (≈ 0,9) | \|H\| ya casi es 0 (≈ 0,1) | ¿Pasa algo de los 1000 Hz? |
|---|---|---|---|
| 21 | ≈ 210 Hz | ≈ 910 Hz | Sí, **≈ 6 %** se filtra (queda una pequeña ondulación) |
| 51 | ≈ 215 Hz | ≈ 580 Hz | No |
| 101 | ≈ 310 Hz | ≈ 490 Hz | No |
| 201 | ≈ 355 Hz | ≈ 445 Hz | No |

**Conclusión:** a **más Nh**, la caída es **más vertical**, más cerca del filtro ideal. A cambio, el filtro es más largo, hace más cuentas y tiene transitorios más largos. Si se agranda mucho Nh, hay que subir N (por ejemplo a 2048) para que siga cumpliendo **N ≥ Nx + Nh − 1**.

### Cambiar Nx (el largo de la señal que se toma: el "enventanado")

Una senoidal **infinita** tendría un espectro con **picos perfectamente finos** (una raya por frecuencia). Como se toma solo un pedazo, los picos se **ensanchan** y aparecen "faldas" a los costados (fuga espectral).

| Nx | Qué pasa en \|X(f)\| |
|---|---|
| **Más grande** (801, 1601…) | Los picos son **más finos y más altos** (altura ≈ A·Nx/2), más parecidos a la señal infinita. |
| **Más chico** (101, 51…) | Los picos son **más anchos y más bajos**. Si las dos frecuencias estuvieran cerca, **se mezclarían** en un solo pico. |

Ancho aproximado de cada pico: **Fm / Nx** (con 401 muestras, ≈ 25 Hz).

### Cambiar Fm (frecuencia de muestreo)

| Fm | En el tiempo | En frecuencia |
|---|---|---|
| **Más alta** (20.000 Hz) | Curvas **más suaves**, con más puntos por ciclo. | El eje llega más lejos (Fm/2). Pero con el mismo Nx la señal dura menos, así que los picos se ensanchan, y con el mismo Nh la transición del filtro también es más ancha. |
| **Más baja, pero > 2000 Hz** (por ejemplo 3000) | Curvas más "escalonadas". | Todo sigue funcionando. |
| **Menor que 2000 Hz** (por ejemplo 1500 o 1200) | La onda de 1000 Hz se ve como otra más lenta. | **Aliasing**: los 1000 Hz aparecen en una frecuencia falsa, \|1000 − Fm\|. Con Fm = 1500 aparece en **500 Hz**, y el filtro la elimina igual. Con Fm = 1200 aparece en **200 Hz**: **pasa el filtro** y "ensucia" la salida aunque Fc = 400. |

**Regla de oro:** Fm tiene que ser mayor que el doble de la frecuencia más alta de la señal (**Fm > 2 × 1000 = 2000 Hz**), y también mayor que 2·Fc.

---

## ¿Y si cambio las frecuencias de la señal o Fc?

Con Fc = 400 Hz:

| Cambio | Resultado en la salida |
|---|---|
| 150 Hz → **50 Hz** | Pasa igual: un coseno más lento, de amplitud 10. |
| 150 Hz → **600 Hz** | Ahora también se elimina: la salida queda **≈ 0** (solo transitorios). |
| 1000 Hz → **300 Hz** | **Pasa** el filtro: la salida tiene las dos ondas mezcladas. |
| Una frecuencia **cerca de Fc** (380 o 450 Hz) | Cae en la **zona de transición**: sale **atenuada a medias**. |
| **Fc = 100 Hz** | Elimina las dos: salida ≈ 0. |
| **Fc = 1500 Hz** | Deja pasar las dos: la salida ≈ la entrada. |
| **Fc entre 150 y 1000** (200, 600, 800) | Funciona igual que con 400, aunque el corte queda más cerca de una u otra. |
| **Cambio las amplitudes** (10 → 50, 5 → 2) | **No cambia qué pasa y qué no.** Lo que pasa sale con su amplitud original y lo que se elimina se elimina, sea grande o chico. |

---

## Resumen en una tabla

| Variable | Si la **aumento** | Si la **disminuyo** |
|---|---|---|
| **Fm** (o 1/Δt) | Más detalle en el tiempo, eje de frecuencias más largo | Riesgo de **aliasing** si Fm < 2·f máx. |
| **Nx** | Picos del espectro más **finos** y altos | Picos más **anchos**, se pueden mezclar |
| **Nh** | Corte del filtro más **brusco**, transitorios más largos | Corte más **suave**, puede dejar pasar frecuencias que no debería |
| **N** (FFT) | Espectro con más puntos, más suave | Si N < Nx + Nh − 1, **salida errónea** (circular) |
| **Fc** | Deja pasar más frecuencias | Deja pasar menos frecuencias |
| **Ventana Hamming** | (vs. sin ventana) Sin Gibbs, transición más ancha | — |
