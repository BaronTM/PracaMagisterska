clc
close all
clear all

%============================================================
legenda = 1;                % legenda: 0 - wy³, 1 - w³

fo = 3.135 * 10^6;          % Czêstotliwoœæ poœrednia [Hz]
B = 150 * 10^3 ;            % Pasmo sygna³u
Bd = -100 * 10^3;
Bg = 50 * 10^3;

N_1 = 8 * 1;                   % D³ugoœæ wektora obserwacji
N_2 = 8 * 2;                   % D³ugoœæ wektora obserwacji
N_4 = 8 * 4;                   % D³ugoœæ wektora obserwacji
N_8 = 8 * 8;                   % D³ugoœæ wektora obserwacji

Np = 8 * 1;

fs = 319*10^3;              % Czêstotliwoœæ próbkowania - podpróbkowanie
Nz_1 = N_1 - Np;              % D³ugoœæ wektora zer
Nz_2 = N_2 - Np;              % D³ugoœæ wektora zer
Nz_4 = N_4 - Np;              % D³ugoœæ wektora zer
Nz_8 = N_8 - Np;              % D³ugoœæ wektora zer

fig_1 = figure;
set(fig_1, 'color', 'white','WindowState','maximized');
%-------------------

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

% Szerokosc 1024
N = N_1;
Nz = Nz_1; 
Ts = 1/fs;
T = Ts * N;                 % Czas obserwacji sygna³u
df = fs/N;                  % Rozdzielczoœæ widmowa
ind = 0 : 1 : N - 1;
% Obliczenia
n = 0 : 1 : N-1;
t = n .* Ts;                % Wektor czasu próbkowania

t_ms = t .* 10^(3);         % Podstawa czasu [ms]
t_us = t .* 10^(6);         % Podstawa czasu [us]

% Normowanie
s = ones(1, N);
norm = ones(1, N);
norm = norm./Np;

% Czêstotliwoœæ unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_n = f_un .* fs;
% -------------------

% Próbki sygna³u - podpróbkowanie
for i = (N - Nz + 1) : 1 : N
    s(i) = 0;
end
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                              % Modu³ widma sygna³u 

subplot(2,2,1);
stem(ind, S, 'Linewidth',2);
hold on;

x = linspace(0, N / 2, 1000);
sc = abs(sinc(x));
xn = x;
plot(xn, sc, 'Linewidth',2);

xlim([0.0 (N/2)])
xlab = 0 : N/Np : N;
xticks(xlab)
y_scale8 = max(S) + 0.1;
ylim([0 y_scale8])
grid on;
title('Widmo Amplitudowe');
xlabel('Nr indeksu');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend('FFT','sinc')
end

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

% Szerokosc 2048
N = N_2;
Nz = Nz_2; 
Ts = 1/fs;
T = Ts * N;                 % Czas obserwacji sygna³u
df = fs/N;                  % Rozdzielczoœæ widmowa
ind = 0 : 1 : N - 1;

% Obliczenia
n = 0 : 1 : N-1;
t = n .* Ts;                % Wektor czasu próbkowania

t_ms = t .* 10^(3);         % Podstawa czasu [ms]
t_us = t .* 10^(6);         % Podstawa czasu [us]

% Normowanie
s = ones(1, N);
norm = ones(1, N);
norm = norm./Np;

% Czêstotliwoœæ unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_n = f_un .* fs;
% -------------------

% Próbki sygna³u - podpróbkowanie
for i = (N - Nz + 1) : 1 : N
    s(i) = 0;
end
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                              % Modu³ widma sygna³u 

subplot(2,2,2);
stem(ind, S, 'Linewidth',2);
hold on;

x = linspace(0, N / 2, 1000);
sc = abs(sinc(x));
xn = x .* N/Np;
plot(xn, sc, 'Linewidth',2);

xlim([0.0 (N/2)])
xlab = 0 : N/Np : N;
xticks(xlab)
y_scale8 = max(S) + 0.1;
ylim([0 y_scale8])
grid on;
title('Widmo Amplitudowe');
xlabel('Nr indeksu');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend('FFT','sinc')
end

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

% Szerokosc 4096
N = N_4;
Nz = Nz_4; 
Ts = 1/fs;
T = Ts * N;                 % Czas obserwacji sygna³u
df = fs/N;                  % Rozdzielczoœæ widmowa
ind = 0 : 1 : N - 1;

% Obliczenia
n = 0 : 1 : N-1;
t = n .* Ts;                % Wektor czasu próbkowania

t_ms = t .* 10^(3);         % Podstawa czasu [ms]
t_us = t .* 10^(6);         % Podstawa czasu [us]

% Normowanie
s = ones(1, N);
norm = ones(1, N);
norm = norm./Np;

% Czêstotliwoœæ unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_n = f_un .* fs;
% -------------------

% Próbki sygna³u - podpróbkowanie
for i = (N - Nz + 1) : 1 : N
    s(i) = 0;
end
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                              % Modu³ widma sygna³u 

subplot(2,2,3);
stem(ind, S, 'Linewidth',2);
hold on;

x = linspace(0, N / 2, 1000);
sc = abs(sinc(x));
xn = x .* N/Np;
plot(xn, sc, 'Linewidth',2);

xlim([0.0 (N/2)])
xlab = 0 : N/Np : N;
xticks(xlab)
y_scale8 = max(S) + 0.1;
ylim([0 y_scale8])
grid on;
title('Widmo Amplitudowe');
xlabel('Nr indeksu');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend('FFT','sinc')
end

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

% Szerokosc 8192
N = N_8;
Nz = Nz_8; 
Ts = 1/fs;
T = Ts * N;                 % Czas obserwacji sygna³u
df = fs/Np;                  % Rozdzielczoœæ widmowa
ind = 0 : 1 : N - 1;

% Obliczenia
n = 0 : 1 : N-1;
t = n .* Ts;                % Wektor czasu próbkowania

t_ms = t .* 10^(3);         % Podstawa czasu [ms]
t_us = t .* 10^(6);         % Podstawa czasu [us]

% Normowanie
s = ones(1, N);
norm = ones(1, N);
norm = norm./Np;

% Czêstotliwoœæ unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_n = f_un .* fs;
% -------------------

% Próbki sygna³u - podpróbkowanie
for i = (N - Nz + 1) : 1 : N
    s(i) = 0;
end
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                              % Modu³ widma sygna³u 

subplot(2,2,4);
stem(ind, S, 'Linewidth',2);
hold on;

x = linspace(0, N / 2, 1000);
sc = abs(sinc(x));
xn = x .* N/Np;
plot(xn, sc, 'Linewidth',2);

xlim([0.0 (N/2)])
xlab = 0 : N/Np : N;
xticks(xlab)
y_scale8 = max(S) + 0.1;
ylim([0 y_scale8])
grid on;
title('Widmo Amplitudowe');
xlabel('Nr indeksu');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend('FFT','sinc')
end

%saveas(gcf,'sinc_zero.png')