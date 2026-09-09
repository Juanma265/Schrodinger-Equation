import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# 1. CARGA DE DATOS (Simplificada)
x, pot = np.loadtxt('potencial.txt').T

frames = []
with open('funcion_onda.txt', 'r') as f:
    # Dividimos el archivo entero por la palabra "SIGUIENTE"
    bloques = f.read().split('SIGUIENTE')
    for b in bloques:
        # Extraemos solo la segunda columna (probabilidad) de cada línea
        lineas = b.strip().split('\n')
        if lineas[0]: 
            frames.append([float(l.split()[1]) for l in lineas if len(l.split())==2])


# 3. GRÁFICO Y ANIMACIÓN
fig, ax = plt.subplots()
ax.fill_between(x, 0, pot, color='gray', alpha=0.3, label='Potencial') # El "suelo"
line, = ax.plot(x, np.array(frames[0]), color='red', lw=2, label='Onda')

ax.set_ylim(min(np.min(pot), 0) - 0.1, max(np.max(pot), 0) + np.max(frames) + 0.1)
ax.legend()

def update(i):
    line.set_ydata(np.array(frames[i]))
    return line,

ani = FuncAnimation(fig, update, frames=len(frames), interval=2, blit=True)
plt.show()

    