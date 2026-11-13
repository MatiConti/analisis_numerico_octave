# EJ 4

clear; clc; close all;

% 1. Frecuencia de muestreo
Fm = 10000;
Nx = 401;
nx = 0:Nx-1;
tx = nx/Fm;

% 2. Señal de entrada
x = 10*cos(2*pi*150*tx) + 5*sin(2*pi*1000*tx);

% 3. Filtro pasabajos
Fc = 400;
Nh = 400;
nh = -(Nh-1)/2:(Nh-1)/2;
th = nh/Fm;

% Respuesta ideal
h_ideal = (2*Fc/Fm)*sinc(2*Fc*nh/Fm);

% Ventana de Hamming
ventana = hamming(Nh).';
h = h_ideal .* ventana;

% Normalizar
h = h/sum(h);

% 4. Convolución directa
y_directa = conv(x,h);
Ny = Nx + Nh - 1;
ny = (nx(1)+nh(1)):(nx(end)+nh(end));
ty = ny/Fm;


% 5. Convolución mediante FFT
N = 1024;
assert(N >= Ny);

x_pad = [x, zeros(1,N-Nx)];
h_pad = [h, zeros(1,N-Nh)];

X = fft(x_pad);
H = fft(h_pad);
Y = X .* H;
Yd = fft(y_directa,N);

y_fft = real(ifft(Y));
y_fft = y_fft(1:Ny);

% Comparar
error_max = max(abs(y_directa-y_fft));
fprintf('Error maximo: %.3e\n', error_max);

% 6. Eje de frecuencias en Hz
f = (0:N/2)*Fm/N;
indices_f = 1:N/2+1;
lim_t = [ty(1),ty(end)];
lim_f = [0,Fm/2];

% 7. Ocho gráficos
figure(1);

subplot(4,2,1);
plot(tx,x); grid on; xlim(lim_t);
title('Entrada x(t)');
xlabel('Tiempo (s)');

subplot(4,2,2);
plot(f,abs(X(indices_f))); grid on; xlim(lim_f);
title('|X(f)|');
xlabel('Frecuencia (Hz)');

subplot(4,2,3);
plot(th,h); grid on; xlim(lim_t);
title('Filtro h(t) con Hamming');
xlabel('Tiempo (s)');

subplot(4,2,4);
plot(f,abs(H(indices_f))); grid on; xlim(lim_f);
title('|H(f)|');
xlabel('Frecuencia (Hz)');

subplot(4,2,5);
plot(ty,y_directa); grid on; xlim(lim_t);
title('Salida por conv');
xlabel('Tiempo (s)');

subplot(4,2,6);
plot(f,abs(Yd(indices_f))); grid on; xlim(lim_f);
title('|Y(f)| por conv');
xlabel('Frecuencia (Hz)');

subplot(4,2,7);
plot(ty,y_fft); grid on; xlim(lim_t);
title('Salida por FFT');
xlabel('Tiempo (s)');

subplot(4,2,8);
plot(f,abs(Y(indices_f))); grid on; xlim(lim_f);
title('|Y(f)| por FFT');
xlabel('Frecuencia (Hz)');
