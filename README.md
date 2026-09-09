# Resolución Numérica de la Ecuación de Schrödinger 1D (Crank-Nicolson)

Simulación computacional de la evolución temporal de un paquete de ondas gaussiano y su interacción con una barrera de potencial unidimensional mediante el método implícito y unitario de **Crank-Nicolson** (algoritmo de Thomas / tridiagonal). El proyecto combina un integrador numérico de alto rendimiento en **Fortran 90** con visualización animada en **Python**.

---

## Fundamento Físico y Numérico

La dinámica cuántica del paquete viene gobernada por la ecuación de Schrödinger dependiente del tiempo:

$$i \hbar \frac{\partial \psi(x,t)}{\partial t} = \left( -\frac{\hbar^2}{2m}\frac{\partial^2}{\partial x^2} + V(x) \right) \psi(x,t)$$

### Discretización (Crank-Nicolson)
Para preservar la **conservación de la norma** (unitaridad del operador de evolución), se emplea el esquema implícito de Crank-Nicolson:

$$(I + i H \Delta t / 2\hbar) \psi^{n+1} = (I - i H \Delta t / 2\hbar) \psi^n$$

Al discretizar espacialmente en una malla de $N$ nodos, se obtiene un sistema tridiagonal acoplado que se resuelve eficientemente con complejidad $\mathcal{O}(N)$ mediante el **algoritmo de Thomas** (relaciones de recurrencia hacia atrás y hacia adelante para $\alpha_j$, $\beta_j$ y $\chi_j$).

### Condiciones y Parámetros
* **Estado inicial:** Paquete de ondas gaussiano modulado con momento medio $k_0$:
  $$\psi(x, 0) \propto e^{i k_0 x} e^{-8 \frac{(4x - N)^2}{N^2}}$$
* **Potencial:** Pozo/barrera rectangular centrado en la región $x \in [0.4N, 0.6N]$ modulado por el parámetro adimensional $\lambda$:
  $$V(x) = \lambda k_0^2$$
* **Conservación de la norma:** El programa monitoriza en cada paso de tiempo que $\int |\psi(x,t)|^2 dx \approx 1$, comprobando la estabilidad del integrador numérico.

---

##  Estructura del Repositorio

* **`schro_eq.f90`**: Código fuente en Fortran 90[cite: 10]. 
  * Genera el retículo espacial y aplica condiciones de contorno tipo Dirichlet en los extremos ($\psi(0) = \psi(L) = 0$)[cite: 10].
  * Resuelve el sistema tridiagonal en cada paso temporal y exporta la densidad de probabilidad $|\psi(x,t)|^2$ y la norma[cite: 10].
* **`Schro_eq.py`**: Script de animación en Python.
  * Carga el perfil del potencial $V(x)$ y los bloques temporales de la función de onda[cite: 11].
  * Renderiza en tiempo real la dispersión cuántica (reflexión, transmisión y efecto túnel) usando `matplotlib.animation.FuncAnimation`[cite: 11].
* **`potencial.txt`**: Perfil espacial del potencial $V(x)$[cite: 8, 10].
* **`norma_schro.txt`**: Registro de la norma de la función de onda en cada iteración[cite: 7, 10].
* **`funcion_onda.txt`**: Volcado de la densidad de probabilidad $|\psi(x)|^2$ a lo largo de las iteraciones (generado tras la ejecución de Fortran)[cite: 10, 11].

---

## Compilación y Ejecución

### 1. Requisitos
* Compilador de Fortran (`gfortran`).
* Python 3 con librerías `numpy` y `matplotlib`.

```bash
pip install numpy matplotlib

