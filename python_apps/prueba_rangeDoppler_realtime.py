#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
import socket as s

#Definicion de parametros
    #Cantidad de muestras de cada porcion de Tx
        #Debe estar en concordancia con el 'file source' de GNU Radio (generado con un script)
nSamp_per_symbol = 10
nSamp_ipp = 1300
nSamp_off = nSamp_ipp - 13*nSamp_per_symbol
nSamp_on = 13*nSamp_per_symbol

    #Parametros genericos (samp_rate se define en GNU Radio, debe concordar con lo soportado por la Red Pitaya)
samp_rate = 1.25E6 #500E3 #1.25E6
ts = 1.0/samp_rate
c = 3E8

    #Tamano (en numero de muestras) de la correlacion obtenida con el Tx_on y Rx (modo 'full')
corr_size = nSamp_on + nSamp_ipp - 1
#corr_size = nSamp_ipp

    #Frecuencia de la RF, ajustado en GNU Radio (como freq central de la Red Pitaya)
freq_rf = 50E6 #600E3

    #Numero de ipps a acumular por dibujo (numero de puntos de la fft)
nIpps_per_plot = 100

    #Sirve para plotear graficas continuamente
plt.ion()

    #Eje de los rangos
#heights_m = np.linspace(0, c*corr_size*ts/2, corr_size)
heights_m = np.linspace(0, c*nSamp_ipp*ts/2, nSamp_ipp)
#heights_m = np.linspace(nSamp_on*c*ts/2, c*corr_size*ts/2 + nSamp_on*c*ts/2, corr_size)

    #Eje de las velocidades
freqs = np.fft.fftfreq(nIpps_per_plot, d=ts)
        #Pasamos el cero al centro
freqs = np.fft.fftshift(freqs)
veloc = freqs*c/(-2*freq_rf)

    #Maximos de velocidad
veloc_max = np.amax(veloc)
veloc_min = np.amin(veloc)

#Lectura del archivo de Tx
f = open("/home/harris/Documents/GNU RADIO - PC/archivos_bin/tx/complex/f50M_s1.25M/out_tx.bin", "rb")
data_tx = np.fromfile(f, dtype=np.complex64)
#Secuencia de samples de Tx (solo la parte 'on')
bark13_seq = data_tx[:nSamp_on]


#Conexion TCP/IP con GNU Radio como 'client', y la aplicacion Python como 'server'
st = s.socket(s.AF_INET, s.SOCK_STREAM)
st.bind(('127.0.0.1', 9000))
st.listen(1)

conn, addr = st.accept()

#Deficion del arreglo bidimensional en el cual se van acumular los ipps (es la transpuesta de lo que se requiere)
samp_per_height_rot = np.empty((0, nSamp_ipp), np.float32) #corr_size

#Deficion del arreglo en el que se van a acumular todas las muestras (unidimensional)
samples_rx = np.array([], dtype=np.complex64)

#Contador de ipps
cont_ipps = 0

#Calibracion inicial(por delay aleatorio)
    #Cantidad de muestras tomadas para calibrar (debe ser menor a 1 Ipp)
#nSamp_calib = nSamp_ipp
#while True:
    #Recepcion de 1 muestra (compleja, 8 bytes)
#    data = conn.recv(8)
#    dt = np.dtype(np.complex64)
#    data = np.frombuffer(data, dtype=dt)

    #Acumulacion de las muestras
#    samples_rx = np.append(samples_rx, data)

    #Cuando lleguen nSamp_calib muestras
#    if samples_rx.size == nSamp_calib:
        #Correlacion de las muestras recibidas con la porcion 'on' de Tx
#        corr = np.correlate(samples_rx, bark13_seq, mode='full')

        #Indice en donde se ubica el pico maximo
#        index_max = np.argmax(abs(corr))

        #Porcion valida de las muestras
#        samples_valid = samples_rx[(index_max - nSamp_on + 1):]

        #Vaciamos el arreglo de acumulacion de muestras
#        samples_rx = np.array([], dtype=np.complex64)

        #Agregamos la porcion valida al arreglo de acumulacion de muestras
#        samples_rx = np.append(samples_rx, samples_valid)

        #Salimos del bucle de calibracion
#        break
        #Por tanto, del primer ipp, ya se tendria una porcion de muestras (faltaria completarlo)

#Recepcion de datos y ploteo
while True:
    #Recepcion de 1 muestra (compleja, 8 bytes)
    data = conn.recv(8)
    dt = np.dtype(np.complex64)
    data = np.frombuffer(data, dtype=dt)

    #Acumulacion de las muestras
    samples_rx = np.append(samples_rx, data)

    #Cuando llegue 1 ipp
    if samples_rx.size == nSamp_ipp:
        #samp_off = samp_ipp[nSamp_on-1:nSamp_on + nSamp_off-1]
        #Correlacion de las muestras recibidas (de 1 ipp) con la porcion 'on' de Tx
        corr = np.correlate(samples_rx, bark13_seq, mode='full')

        #Cogemos desde el indice que equivale a distancia cero
        corr = corr[nSamp_on-1:]

        #Correccion de las muestras de la correlacion por delay aleatorio (de comunicacion en software)
        index_max = np.argmax(abs(corr))
        #corr[:index_max] = 0
        corr = np.roll(corr, -1*index_max) #(index_max - nSamp_on)

        #Agregamos una fila al arreglo bidimensional (rotado) -> [[h1,h2,h3,...], [h1,h2,h3,...], ...]
        samp_per_height_rot = np.append(samp_per_height_rot, [abs(corr)], 0)

        #Incremento del contador de ipps
        cont_ipps+=1

        #Vaciamos el arreglo de muestras
        samples_rx = np.array([], dtype=np.complex64)

    #Cuando llegue el numero de ipps esperado
    if cont_ipps == nIpps_per_plot:
        #Hallamos la transpuesta del arreglo rotado, se tendria -> [[h1,h1,h1,...], [h2,h2,h2,...], ...]
        samp_per_height = samp_per_height_rot.transpose()

        #Inicializamos el arreglo bidimensional de fft's
        samp_per_height_fft = np.empty((0, nIpps_per_plot), np.float32)

        #Sacamos la fft a cada fila de 'samp_per_height' y lo agregamos a 'samp_per_height_fft'
        for i in xrange(0, nSamp_ipp): #corr_size
            #Le hacemos una fft, lo pasamos al centro (shift), sacamos magnitud y lo pasamos a decibelios
            fft_row = (abs(np.fft.fftshift(np.fft.fft(samp_per_height[i])))) #10*np.log10

            #Agregamos una fila al arreglo bidimensional de fft's
            samp_per_height_fft = np.append(samp_per_height_fft, [fft_row], 0)

        #Reiniciamos el contador de ipps
        cont_ipps = 0

        #Vaciamos el arreglo bidimensional
        samp_per_height_rot = np.empty((0, nSamp_ipp), np.float32) #corr_size

        #Ploteamos la grafica
        plt.pcolormesh(veloc, heights_m, samp_per_height_fft, edgecolors = 'None', vmin=0, vmax=32000) #vmin=-50, vmax=50 #vmin=0, vmax=32000

            #Escala de colores
        plt.colorbar()

            #Seteamos los limites
        plt.gca().set_xlim((veloc_min,veloc_max))
        plt.gca().set_ylim((0,c*nSamp_ipp*ts/2)) #corr_size

            #Etiqueta de los ejes de la grafica
        plt.xlabel('Velocity (m/s)')
        plt.ylabel('Range (m)')

            #Sostenemos la grafica por un determinado tiempo
        plt.pause(0.5) #0.05	    

            #Sirve reajustar el 'colorbar'
        plt.clf()

#Sirve para plotear graficas continuamente
while True:
    plt.pause(0.5) #0.05

#Cerramos la conexion TCP/IP
conn.close()
