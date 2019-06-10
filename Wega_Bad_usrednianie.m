clc
close all
clear all
%wvtool(hamming(64), rectwin(64), blackman(64), hanning(64))
%============================================================
legenda = 0;                % legenda: 0 - wy³, 1 - w³

fo = 3.135 * 10^6;          % Czêstotliwoœæ poœrednia [Hz]
B = 150 * 10^3 ;            % Pasmo sygna³u
Bd = -100 * 10^3;
Bg = 50 * 10^3;

N = 1024 * 1;                   % D³ugoœæ wektora obserwacji
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



O_Hamming = zeros(1, N);
O_Hanning = zeros(1, N);
O_Blackman = zeros(1, N);

%GENERACJA OKIEN
for i = 1 : 1 : N
    O_Hamming(i) = 0.42 - 0.5 * cos((2 * pi * (i - 1)) / (N - 1)) + 0.08 * cos((4 * pi * (i - 1)) / (N - 1));
end

for i = 1 : 1 : N
    O_Hanning(i) = 0.5 - 0.5 * cos((2 * pi * (i - 1)) / N);
end

for i = 1 : 1 : N
    O_Blackman(i) = 0.54 - 0.46 * cos((2 * pi * (i - 1)) / (N - 1));
end

O_Hamming = O_Hamming./N;
O_Hanning = O_Hanning./N;
O_Blackman = O_Blackman./N;


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
    f_lab_zoom = {'-65' '-64' '-63' '-62' '-61' '-60' '-59' '-58' '-57' '-56' '-55'};
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
    f_lab_zoom = {'45' '46' '47' '48' '49' '50' '51' '52' '53' '54' '55' '56' '57' '58' '59' '60' '61' '62' '63' '64' '65' '66' '67' '68' '69' '70'};
    f_wid_max = fs * (m);
    f_wid_min = fs * (m - 1) + (fs/2);
    f_val_zoom(1) = (f_wid_max - fo - Bd - 55000) / fs;
    f_val_zoom(2) = (f_wid_max - fo - Bd - 54000) / fs;
    f_val_zoom(3) = (f_wid_max - fo - Bd - 53000) / fs;
    f_val_zoom(4) = (f_wid_max - fo - Bd - 52000) / fs;
    f_val_zoom(5) = (f_wid_max - fo - Bd - 51000) / fs;
    f_val_zoom(6) = (f_wid_max - fo - Bd - 50000) / fs;
    f_val_zoom(7) = (f_wid_max - fo - Bd - 49000) / fs;
    f_val_zoom(8) = (f_wid_max - fo - Bd - 48000) / fs;
    f_val_zoom(9) = (f_wid_max - fo - Bd - 47000) / fs;
    f_val_zoom(10) = (f_wid_max - fo - Bd - 46000) / fs;
    f_val_zoom(11) = (f_wid_max - fo - Bd - 45000) / fs;
    f_val_zoom(12) = (f_wid_max - fo - Bd - 44000) / fs;
    f_val_zoom(13) = (f_wid_max - fo - Bd - 43000) / fs;
    f_val_zoom(14) = (f_wid_max - fo - Bd - 42000) / fs;
    f_val_zoom(15) = (f_wid_max - fo - Bd - 41000) / fs;
    f_val_zoom(16) = (f_wid_max - fo - Bd - 40000) / fs;
    f_val_zoom(17) = (f_wid_max - fo - Bd - 39000) / fs;
    f_val_zoom(18) = (f_wid_max - fo - Bd - 38000) / fs;
    f_val_zoom(19) = (f_wid_max - fo - Bd - 37000) / fs;
    f_val_zoom(20) = (f_wid_max - fo - Bd - 36000) / fs;
    f_val_zoom(21) = (f_wid_max - fo - Bd - 35000) / fs;
    f_val_zoom(22) = (f_wid_max - fo - Bd - 34000) / fs;     
    f_val_zoom(23) = (f_wid_max - fo - Bd - 33000) / fs;     
    f_val_zoom(24) = (f_wid_max - fo - Bd - 32000) / fs;     
    f_val_zoom(25) = (f_wid_max - fo - Bd - 31000) / fs;     
    f_val_zoom(26) = (f_wid_max - fo - Bd - 30000) / fs;          
end

if (f_val(4) > 0.5)
    f_val_temp_zoom = f_val_zoom;
    f_lab_temp_zoom = f_lab_zoom;
    for i = 1 : 1 : 26
        f_val_zoom(i) = 1 - f_val_temp_zoom(27 - i);
        f_lab_zoom(i) = f_lab_temp_zoom(27 - i);
    end
end

% Czeœtotliwoœci sygna³ów
%f_syg_1 = 24000;
df_1 = fs/1024;
df_2 = fs/2048;
df_4 = fs/4096;
df_8 = fs/8192;

f_syg_0 = -60000;
%f_syg_1 = f_syg_0 - 1 * df_1;
f_syg_1 = 0;

% GENERACJA SZUMU
sigma = 10;                                            % Standardowe odchylenie szumu
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

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
K = 10;
allFft = zeros(K,1024);
for i = 1 : 1 : K
% GENERACJA SZUMU
sigma = 10;                                            % Standardowe odchylenie szumu
noise = sigma * randn(1,N); 
% GENERACJA Sygna³u 1024
f_sygnal_1 = fo + f_syg_0;
f_sygnal_2 = fo + f_syg_1;
s = sin(2 * pi * f_sygnal_1 * n / fs) + sin(2 * pi * f_sygnal_2 * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie

sx = s .* norm;                                      % Normowanie sygna³u                   
S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 
allFft(i,:) = S;
%S = fft(sx, N);
end
rrr = rms(S(1:512))
mmm = mean(S)
aaa = rms(0.5)
20 * log(rms(0.5) / rrr)

% [maxRect, maxId] = max(S(1:512));
% if ((s(maxId) > s(maxId + 1)) && (s(maxId + 2) > s(maxId + 1)) && (s(maxId) > 0.1) && (s(maxId + 2) > 0.1))
%     pause
% end

S = allFft(1,:);
subplot(2,2,1);
bar(f_un, S, 'Linewidth',2);
xlim([0.29 0.33])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11) f_val_zoom(12) f_val_zoom(13) f_val_zoom(14) f_val_zoom(15) f_val_zoom(16) f_val_zoom(17) f_val_zoom(18) f_val_zoom(19) f_val_zoom(20) f_val_zoom(21) f_val_zoom(22) f_val_zoom(23) f_val_zoom(24) f_val_zoom(25) f_val_zoom(26)])
xticklabels(f_lab_zoom)
grid on;
title('Widmo Amplitudowe bez uœredniania');
xlabel('Czêstotliwoœæ unormowana [kHz]');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
         'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
         'df = ', num2str(df), ' [Hz],  ' ...
         'N = ', num2str(N), ' [Sa],  ' ...
         'T = ', num2str(T * 10^3), ' [ms]']);
end



S = zeros(1, 1024);
for k = 1 : 1 : 2
    S = S +  allFft(k,:);
end
S = S ./ 2;
subplot(2,2,2);
bar(f_un, S, 'Linewidth',2);
xlim([0.29 0.33])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11) f_val_zoom(12) f_val_zoom(13) f_val_zoom(14) f_val_zoom(15) f_val_zoom(16) f_val_zoom(17) f_val_zoom(18) f_val_zoom(19) f_val_zoom(20) f_val_zoom(21) f_val_zoom(22) f_val_zoom(23) f_val_zoom(24) f_val_zoom(25) f_val_zoom(26)])
xticklabels(f_lab_zoom)
grid on;
title('Widmo Amplitudowe z uœrednianiem 2 DFT');
xlabel('Czêstotliwoœæ unormowana [kHz]');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
         'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
         'df = ', num2str(df), ' [Hz],  ' ...
         'N = ', num2str(N), ' [Sa],  ' ...
         'T = ', num2str(T * 10^3), ' [ms]']);
end


S = zeros(1, 1024);
for k = 1 : 1 : 5
    S = S +  allFft(k,:);
end
S = S ./ 5;
subplot(2,2,3);
bar(f_un, S, 'Linewidth',2);
xlim([0.29 0.33])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11) f_val_zoom(12) f_val_zoom(13) f_val_zoom(14) f_val_zoom(15) f_val_zoom(16) f_val_zoom(17) f_val_zoom(18) f_val_zoom(19) f_val_zoom(20) f_val_zoom(21) f_val_zoom(22) f_val_zoom(23) f_val_zoom(24) f_val_zoom(25) f_val_zoom(26)])
xticklabels(f_lab_zoom)
grid on;
title('Widmo Amplitudowe z uœrednianiem 5 DFT');
xlabel('Czêstotliwoœæ unormowana [kHz]');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
         'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
         'df = ', num2str(df), ' [Hz],  ' ...
         'N = ', num2str(N), ' [Sa],  ' ...
         'T = ', num2str(T * 10^3), ' [ms]']);
end


S = zeros(1, 1024);
for k = 1 : 1 : K
    S = S +  allFft(k,:);
end
S = S ./ K;
subplot(2,2,4);
bar(f_un, S, 'Linewidth',2);
xlim([0.29 0.33])
y_scale2 = max(S) + 0.1;
ylim([0 y_scale2])
xticks([f_val_zoom(1) f_val_zoom(2) f_val_zoom(3) f_val_zoom(4) f_val_zoom(5) f_val_zoom(6) f_val_zoom(7) f_val_zoom(8) f_val_zoom(9) f_val_zoom(10) f_val_zoom(11) f_val_zoom(12) f_val_zoom(13) f_val_zoom(14) f_val_zoom(15) f_val_zoom(16) f_val_zoom(17) f_val_zoom(18) f_val_zoom(19) f_val_zoom(20) f_val_zoom(21) f_val_zoom(22) f_val_zoom(23) f_val_zoom(24) f_val_zoom(25) f_val_zoom(26)])
xticklabels(f_lab_zoom)
grid on;
title('Widmo Amplitudowe z uœrednianiem 10 DFT');
xlabel('Czêstotliwoœæ unormowana [kHz]');
ylabel('Wartoœæ próbki');
if legenda == 1
    legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
         'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
         'df = ', num2str(df), ' [Hz],  ' ...
         'N = ', num2str(N), ' [Sa],  ' ...
         'T = ', num2str(T * 10^3), ' [ms]']);
end

