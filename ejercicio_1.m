% Definir señal x[n]
nx = -5:5;
x = double(nx >= -2 & nx <= 2);

% ¿Qué es un vector? Es una lista de números.
%En este caso:
% nx=[-5,-4,-3,-2,-1,0,1,2,3,4,5]
% double: Convierte los resultados en números de tipo decimal (numéricos).
%comprobar qué números del vector nx son mayores o iguales a -2.o menores o iguales a 2


% Definir señal h[n]
nh = 0:5;
h = nh;
%Esta línea significa que queremos que la señal h tenga exactamente los mismos valores que el vector nh.

% Calcular convolución
y = conv(x,h);

% Vector de tiempo de la convolución
ny = (nx(1)+nh(1)):(nx(end)+nh(end));

% Limites de tiempo comunes
nmin = min([nx nh ny]);
nmax = max([nx nh ny]);

% Graficar las tres señales
figure;

subplot(3,1,1);
stem(nx,x);
title('Señal x[n]');
xlabel('n');
ylabel('x[n]');
xlim([nmin nmax]);

subplot(3,1,2);
stem(nh,h);
title('Respuesta al impulso h[n]');
xlabel('n');
ylabel('h[n]');
xlim([nmin nmax]);

subplot(3,1,3);
stem(ny,y);
title('Salida y[n] = x[n] * h[n]');
xlabel('n');
ylabel('y[n]');
xlim([nmin nmax]);
