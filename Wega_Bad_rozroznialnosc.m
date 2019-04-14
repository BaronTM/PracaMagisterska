clc
close all
clear all

%============================================================
legenda = 0;                % legenda: 0 - wy³, 1 - w³

fo = 3.135 * 10^6;          % Czêstotliwoœæ poœrednia [Hz]
B = 200 * 10^3 ;            % Pasmo sygna³u
Bd = -100 * 10^3;
Bg = 100 * 10^3;

N = 4096;                   % D³ugoœæ wektora obserwacji
fs = 432*10^3;              % Czêstotliwoœæ próbkowania - podpróbkowanie

Ts = 1/fs;
T = Ts * N;                 % Czas obserwacji sygna³u
df = fs/N;                  % Rozdzielczoœæ widmowa

% Obliczenia
n = 0 : 1 : N-1;
t = n .* Ts;                % Wektor czasu próbkowania

t_ms = t .* 10^(3);         % Podstawa czasu [ms]
t_us = t .* 10^(6);         % Podstawa czasu [us]

% Normowanie
s = zeros(1, N);
norm = ones(1, N);
norm = norm./N;

% Czêstotliwoœæ unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_n = f_un .* fs;
% -------------------
% Parametry wykresów
w_t = 50 * Ts;        % Szerokoœæ okna rysowania wykresu sygna³u s[n]
w_t_ms = w_t * 10^3;
w_t_us = w_t * 10^6;

fig_1 = figure;
set(fig_1, 'color', 'white');
%-------------------

% Czeœtotliwoœci sygna³ów
%f_syg_1 = 24000;
f_syg_1 = 24000 + 30;
f_syg_2 = 24000 + df + 30;

% GENERACJA SZUMU
sigma = 0;                                            % Standardowe odchylenie szumu
noise = sigma * randn(1,N); 



% GENERACJA Sygna³u
f_sygnal_1 = fo + f_syg_1;
f_sygnal_2 = fo + f_syg_2;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 

subplot(2,2,1);
bar(f_un, S, 'Linewidth',2);
xlim([0.31 0.315])
ylim([0 0.55])
grid on;
title('Widmo Amplitudowe');
xlabel('Czêstotliwoœæ unormowana');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
         'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
         'df = ', num2str(df), ' [Hz],  ' ...
         'N = ', num2str(N), ' [Sa],  ' ...
         'T = ', num2str(T * 10^3), ' [ms]']);
end
pause(0.001);
set(gcf, 'Position', get(0, 'Screensize'));




