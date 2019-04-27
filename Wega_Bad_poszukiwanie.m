clc
close all
clear all

%============================================================
kraniec = 1;                % 0 - sygna³ jest przemiatany od jednego krañca
                            %   do drugiego
                            % 1 - przedstawia szerokoœc pasma przemiatania
                            % 2 - pokazuje pr¹¿ki na obu krañcach
legenda = 1;                % legenda: 0 - wy³, 1 - w³

fig_1 = figure;
set(fig_1, 'color', 'white');

for delta = 0 : 1000 : 100000
fo = 3.135 * 10^6;          % Czêstotliwoœæ poœrednia [Hz]
B = 150 * 10^3 ;            % Pasmo sygna³u
Bd = -100 * 10^3;
Bg = 50 * 10^3;

N = 2048;                   % D³ugoœæ wektora obserwacji
fs = 300*10^3 + delta;              % Czêstotliwoœæ próbkowania - podpróbkowanie

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

%-------------------
if kraniec == 0
    for fd = Bd : 100 : Bg
        % GENERACJA SZUMU
        sigma = 0;                                            % Standardowe odchylenie szumu
        noise = sigma * randn(1,N); 
        
        % GENERACJA Sygna³u
        f_sygnal = fo + fd;
        s = sin(2 * pi * f_sygnal * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
        sx = s .* norm;                                      % Normowanie sygna³u                   
        S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 

        hold off
        subplot(2,1,1);
        stem(t_us, s, 'Linewidth',2);
        hold on
        plot(t_us, s, 'r', 'Linewidth',2);
        hold off
        xlim([0 w_t_us])
        grid on;
        title(['Sygna? po?redniej próbkowanej z cz?stotliwo?ci? :  ', num2str(fs/1000), '  kHz']);
        xlabel('Czas [us]');
        ylabel('Amplituda');

        subplot(2,1,2);
        bar(f_un, S, 'Linewidth',2);
        xlim([0 0.5])
        ylim([0 0.8])
        xticks([f_val(1) f_val(2) f_val(3) f_val(4) f_val(5) f_val(6) f_val(7)])
        xticklabels(f_lab)
        grid on;
        title('Widmo Amplitudowe');
        xlabel('Cz?stotliwo?? dopplerowska');
        ylabel('Warto?? próbki');
        if legenda == 1
            legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
                 'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
                 'df = ', num2str(df), ' [Hz],  ' ...
                 'N = ', num2str(N), ' [Sa],  ' ...
                 'T = ', num2str(T * 10^3), ' [ms]']);
        end
        pause(0.001);
        set(gcf, 'Position', get(0, 'Screensize'));
    end
elseif kraniec == 1
    % GENERACJA SZUMU
    sigma = 0;                                            % Standardowe odchylenie szumu
    noise = sigma * randn(1,N); 
    
    % GENERACJA Sygna³u
    suma = 0;
    for fd = Bd : 100 : Bg
        f_sygnal = fo + fd;
        s = sin(2 * pi * f_sygnal * n / fs) + noise;         % Próbki sygna³u - podpróbkowanie
        sx = s .* norm;                                      % Normowanie sygna³u                   
        S = abs(fft(sx, N));                                 % Modu³ widma sygna³u 
        suma = suma + S;
    end
    suma = suma .* 0.3;
    
    hold off
    subplot(2,1,1);
    stem(t_us, s, 'Linewidth',2);
    hold on
    plot(t_us, s, 'r', 'Linewidth',2);
    hold off
    xlim([0 w_t_us])
    grid on;
    title(['Sygna? po?redniej próbkowanej z cz?stotliwo?ci? :  ', num2str(fs/1000), '  kHz']);
    xlabel('Czas [us]');
    ylabel('Amplituda');

    subplot(2,1,2);
    bar(f_un, suma, 'Linewidth',2);
    xlim([0 0.5])
    ylim([0 0.8])
    xticks([f_val(1) f_val(2) f_val(3) f_val(4) f_val(5) f_val(6) f_val(7)])
    xticklabels(f_lab)
    grid on;
    title('Widmo Amplitudowe');
    xlabel('Cz?stotliwo?? dopplerowska');
    ylabel('Warto?? próbki');
    if legenda == 1
        legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
             'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
             'df = ', num2str(df), ' [Hz],  ' ...
             'N = ', num2str(N), ' [Sa],  ' ...
             'T = ', num2str(T * 10^3), ' [ms]']);
    end
    pause(0.001);
    set(gcf, 'Position', get(0, 'Screensize'));
elseif kraniec == 2
    %GENERACJA SZUMU
    sigma = 0;                                            %Standardowe odchylenie szumu
    noise = sigma * randn(1,N); 
    %GENERACJA Sygna³u
    s = sin(2 * pi * (fo + Bd) * n / fs) + sin(2 * pi * (fo + Bg) * n / fs) + noise;         %Próbki sygna³u - podpróbkowanie
    sx = s .* norm;                                      % Normowanie sygna³u                   
    S = abs(fft(sx, N));                                     % Modu³ widma sygna³u 

    hold off
    subplot(2,1,1);
    stem(t_us, s, 'Linewidth',2);
    hold on
    plot(t_us, s, 'r', 'Linewidth',2);
    hold off
    xlim([0 w_t_us])
    grid on;
    title(['Sygna? po?redniej próbkowanej z cz?stotliwo?ci? :  ', num2str(fs/1000), '  kHz']);
    xlabel('Czas [us]');
    ylabel('Amplituda');

    subplot(2,2,3);
    bar(f_un, S, 'Linewidth',2);
    xlim([0 0.5])
    ylim([0 0.8])
    xticks([f_val(1) f_val(2) f_val(3) f_val(4) f_val(5) f_val(6) f_val(7)])
    xticklabels(f_lab)
    grid on;
    title('Widmo Amplitudowe');
    xlabel('Cz?stotliwo?? dopplerowska');
    ylabel('Warto?? próbki');
    if legenda == 1
        legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
             'df = ', num2str(df), ' [Hz],  ' ...
             'N = ', num2str(N), ' [Sa],  ' ...
             'T = ', num2str(T * 10^3), ' [ms]']);
    end
    pause(0.001);
    set(gcf, 'Position', get(0, 'Screensize'));
end
pause(1);
end


