# EJ 3

clear; clc; close all;

% 1. Señal de entrada
Nx = 401;
dt = 0.0001;
nx = 0:Nx-1;
t = nx * dt;

x = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);

% 2. Respuesta al impulso
Fc = 400;
Nh = 101;
nh = -(Nh-1)/2:(Nh-1)/2;

h = 2*Fc*dt*sinc(2*Fc*dt*nh);

% 3. Convolución directa para comparar
y_directa = conv(x,h);
Ny = Nx + Nh - 1;
ny = (nx(1)+nh(1)):(nx(end)+nh(end));

% 4. Rellenar con ceros hasta N = 1024
N = 1024;
assert(N >= Ny);

x_pad = [x, zeros(1,N-Nx)];
h_pad = [h, zeros(1,N-Nh)];

% 5. Convolución por FFT
X = fft(x_pad);
H = fft(h_pad);
Y = X .* H;

y_fft = real(ifft(Y));
y_fft = y_fft(1:Ny);

% Comparar los resultados
error_max = max(abs(y_directa - y_fft));
fprintf('Error maximo: %.3e\n', error_max);

% 6. Graficar
k = 0:N/2;
limites_n = [ny(1),ny(end)];

figure(1);

subplot(3,2,1);
stem(nx,x); grid on; xlim(limites_n);
title('Entrada x[n]'); xlabel('n');

subplot(3,2,2);
plot(k,abs(X(1:N/2+1))); grid on;
title('|X[k]|'); xlabel('k');

subplot(3,2,3);
stem(nh,h); grid on; xlim(limites_n);
title('Respuesta h[n]'); xlabel('n');

subplot(3,2,4);
plot(k,abs(H(1:N/2+1))); grid on;
title('|H[k]|'); xlabel('k');

subplot(3,2,5);
stem(ny,y_fft); grid on; xlim(limites_n);
title('Salida y[n] por FFT'); xlabel('n');

subplot(3,2,6);
plot(k,abs(Y(1:N/2+1))); grid on;
title('|Y[k]|'); xlabel('k');
