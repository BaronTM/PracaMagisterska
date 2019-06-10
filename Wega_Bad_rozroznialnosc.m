clc
close all
clear all

%============================================================
legenda = 0;                % legenda: 0 - wy³, 1 - w³

fo = 3.135 * 10^6;          % Czêstotliwoœæ poœrednia [Hz]
B = 150 * 10^3 ;            % Pasmo sygna³u
Bd = -100 * 10^3;
Bg = 50 * 10^3;

N = 1024 * 8;                   % D³ugoœæ wektora obserwacji
fs = 400*10^3;              % Czêstotliwoœæ próbkowania - podpróbkowanie

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
set(fig_1, 'color', 'white','WindowState','maximized');
%-------------------

% -------------------
% Skalowanie osi X
m = ceil(fo/fs);
f_val = [];
f_lab = [];
if (mod(m,2) == 1)
    f_lab = {'-100 kHz' '-75 kHz' '-50 kHz' '-25 kHz' '0 kHz' '+25 kHz' '+50 kHz'};
    f_wid_min = fs * (m - 1);
    f_wid_max = fs * (m - 1) + (fs/2);
    f_val(1) = (fo - f_wid_min + Bd) / fs;
    f_val(2) = (fo - f_wid_min + Bd + 25000) / fs;
    f_val(3) = (fo - f_wid_min + Bd + 50000) / fs;
    f_val(4) = (fo - f_wid_min + Bd + 75000) / fs;
    f_val(5) = (fo - f_wid_min) / fs;
    f_val(6) = (fo - f_wid_min + Bg - 25000) / fs;
    f_val(7) = (fo - f_wid_min + Bg) / fs;
else 
    f_lab = {'+50 kHz' '+25 kHz' '0 kHz' '-25 kHz' '-50 kHz' '-75 kHz' '-100 kHz'};
    f_wid_max = fs * (m);
    f_wid_min = fs * (m - 1) + (fs/2);
    f_val(1) = (f_wid_max - fo - Bg) / fs;
    f_val(2) = (f_wid_max - fo - Bg + 25000) / fs;
    f_val(3) = (f_wid_max - fo) / fs;
    f_val(4) = (f_wid_max - fo - Bd - 75000) / fs;
    f_val(5) = (f_wid_max - fo - Bd - 50000) / fs;
    f_val(6) = (f_wid_max - fo - Bd - 25000) / fs;
    f_val(7) = (f_wid_max - fo - Bd) / fs;
end

if (f_val(4) > 0.5)
    f_val_temp = f_val;
    f_lab_temp = f_lab;
    for i = 1 : 1 : 7
        f_val(i) = 1 - f_val_temp(8 - i);
        f_lab(i) = f_lab_temp(8 - i);
    end
end

% Skalowanie osi X ZOOM
f_val_zoom = [];
f_lab_zoom = [];
if (mod(m,2) == 1)
    f_lab_zoom = {'-65 kHz' '-64 kHz' '-63 kHz' '-62 kHz' '-61 kHz' '-60 kHz' '-59 kHz' '-58 kHz' '-57 kHz' '-56 kHz' '-55 kHz'};
    f_wid_min = fs * (m - 1);
    f_wid_max = fs * (m - 1) + (fs/2);
    f_val_zoom(1) = (fo - f_wid_min + Bd + 35000) / fs;
    f_val_zoom(2) = (fo - f_wid_min + Bd + 36000) / fs;
    f_val_zoom(3) = (fo - f_wid_min + Bd + 37000) / fs;
    f_val_zoom(4) = (fo - f_wid_min + Bd + 38000) / fs;
    f_val_zoom(5) = (fo - f_wid_min + Bd + 39000) / fs;
    f_val_zoom(6) = (fo - f_wid_min + Bd + 40000) / fs;
    f_val_zoom(7) = (fo - f_wid_min + Bd + 41000) / fs;
    f_val_zoom(8) = (fo - f_wid_min + Bd + 42000) / fs;
    f_val_zoom(9) = (fo - f_wid_min + Bd + 43000) / fs;
    f_val_zoom(10) = (fo - f_wid_min + Bd + 44000) / fs;
    f_val_zoom(11) = (fo - f_wid_min + Bd + 450000) / fs; 
    
else 
    f_lab_zoom = {'55 kHz' '56 kHz' '57 kHz' '58 kHz' '59 kHz' '60 kHz' '61 kHz' '62 kHz' '63 kHz' '64 kHz' '65 kHz'};
    f_wid_max = fs * (m);
    f_wid_min = fs * (m - 1) + (fs/2);
    f_val_zoom(1) = (f_wid_max - fo - Bd - 45000) / fs;
    f_val_zoom(2) = (f_wid_max - fo - Bd - 44000) / fs;
    f_val_zoom(3) = (f_wid_max - fo - Bd - 43000) / fs;
    f_val_zoom(4) = (f_wid_max - fo - Bd - 42000) / fs;
    f_val_zoom(5) = (f_wid_max - fo - Bd - 41000) / fs;
    f_val_zoom(6) = (f_wid_max - fo - Bd - 40000) / fs;
    f_val_zoom(7) = (f_wid_max - fo - Bd - 39000) / fs;
    f_val_zoom(8) = (f_wid_max - fo - Bd - 38000) / fs;
    f_val_zoom(9) = (f_wid_max - fo - Bd - 37000) / fs;
    f_val_zoom(10) = (f_wid_max - fo - Bd - 36000) / fs;
    f_val_zoom(11) = (f_wid_max - fo - Bd - 35000) / fs;     
end

if (f_val(4) > 0.5)
    f_val_temp_zoom = f_val_zoom;
    f_lab_temp_zoom = f_lab_zoom;
    for i = 1 : 1 : 11
        f_val_zoom(i) = 1 - f_val_temp_zoom(12 - i);
        f_lab_zoom(i) = f_lab_temp_zoom(12 - i);
    end
end

% Czeœtotliwoœci sygna³ów
%f_syg_1 = 24000;
df_1 = fs/1024;
df_2 = fs/2048;
df_4 = fs/4096;
df_8 = fs/8192;

f_syg_0 = -60000;
f_syg_1 = f_syg_0 - 1 * df_1;
f_syg_2 = f_syg_0 - 1 * df_2;
f_syg_4 = f_syg_0 - 1 * df_4;
f_syg_8 = f_syg_0 - 1 * df_8;

% GENERACJA SZUMU
sigma = 0;                                            % Standardowe odchylenie szumu
noise = sigma * randn(1,N); 

% GENERACJA Sygna³u
f_sygnal_1 = fo + f_syg_0;
f_sygnal_2 = fo + f_syg_1;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N)); 

bar(f_un, S, 'Linewidth',2);
xlim([0.0 0.5])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val(1) f_val(2) f_val(3) f_val(4) f_val(5) f_val(6) f_val(7)])
xticklabels(f_lab)
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
%pause;
set(gcf, 'Position', get(0, 'Screensize'));


% GENERACJA Sygna³u 1024
f_sygnal_1 = fo + f_syg_0;
f_sygnal_2 = fo + f_syg_1;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 

subplot(2,2,1);
bar(f_un, S, 'Linewidth',2);
xlim([0.308 0.318])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11)])
xticklabels(f_lab_zoom)
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




% GENERACJA Sygna³u 2048
f_sygnal_1 = fo + f_syg_0;
f_sygnal_2 = fo + f_syg_2;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 

subplot(2,2,2);
bar(f_un, S, 'Linewidth',2);
xlim([0.308 0.318])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11)])
xticklabels(f_lab_zoom)
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


% GENERACJA Sygna³u 4096
f_sygnal_1 = fo + f_syg_0;
f_sygnal_2 = fo + f_syg_4;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 

subplot(2,2,3);
bar(f_un, S, 'Linewidth',2);
xlim([0.308 0.318])
y_scale4 = max(S) + 0.1;
ylim([0 y_scale4])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11)])
xticklabels(f_lab_zoom)
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

% GENERACJA Sygna³u 8192
f_sygnal_1 = fo + f_syg_0;
f_sygnal_2 = fo + f_syg_8;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 

subplot(2,2,4);
bar(f_un, S, 'Linewidth',2);
xlim([0.308 0.318])
y_scale8 = max(S) + 0.1;
ylim([0 y_scale8])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11)])
xticklabels(f_lab_zoom)
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

%saveas(gcf,'shoot.png')


