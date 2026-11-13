% Ejercicio 2 - Laboratorio
clear; clc; close all;

% 1. Parametros de muestreo
Nx = 401;
dt = 0.0001;
nx = 0:Nx-1;
t = nx * dt;

% 2. Senal de entrada
x = 10*cos(2*pi*150*t) + 5*sin(2*pi*1000*t);

% 3. Respuesta al impulso del filtro
Fc = 400;
Nh = 101;
nh = -(Nh-1)/2 : (Nh-1)/2;

h = 2*Fc*dt*sinc(2*Fc*dt*nh);

% 4. Convolucion
y = conv(x,h);
ny = (nx(1)+nh(1)) : (nx(end)+nh(end));

% 5. Graficos
figure(1);

subplot(3,1,1);
stem(nx,x);
title('Entrada x[n]');
grid on;
xlim([ny(1),ny(end)]);

subplot(3,1,2);
stem(nh,h);
title('Respuesta h[n]');
grid on;
xlim([ny(1),ny(end)]);

subplot(3,1,3);
stem(ny,y);
title('Salida y[n]');
grid on;
xlim([ny(1),ny(end)]);
