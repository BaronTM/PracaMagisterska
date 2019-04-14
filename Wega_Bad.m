clc
close all
clear all

%============================================================
kraniec = 0;                % 0 - sygna� jest przemiatany od jednego kra�ca
                            %   do drugiego
                            % 1 - przedstawia szeroko�c pasma przemiatania
                            % 2 - pokazuje pr��ki na obu kra�cach
legenda = 1;                % legenda: 0 - wy�, 1 - w�

fo = 3.135 * 10^6;          % Cz�stotliwo�� po�rednia [Hz]
B = 200 * 10^3 ;            % Pasmo sygna�u
Bd = -100 * 10^3;
Bg = 50 * 10^3;

N = 4096;                   % D�ugo�� wektora obserwacji
fs = 336*10^3;              % Cz�stotliwo�� pr�bkowania - podpr�bkowanie

Ts = 1/fs;
T = Ts * N;                 % Czas obserwacji sygna�u
df = fs/N;                  % Rozdzielczo�� widmowa

% Obliczenia
n = 0 : 1 : N-1;
t = n .* Ts;                % Wektor czasu pr�bkowania

t_ms = t .* 10^(3);         % Podstawa czasu [ms]
t_us = t .* 10^(6);         % Podstawa czasu [us]

% Normowanie
s = zeros(1, N);
norm = ones(1, N);
norm = norm./N;

% Cz�stotliwo�� unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_n = f_un .* fs;
% -------------------
% Parametry wykres�w
w_t = 50 * Ts;        % Szeroko�� okna rysowania wykresu sygna�u s[n]
w_t_ms = w_t * 10^3;
w_t_us = w_t * 10^6;

% -------------------
% Skalowanie osi X
m = ceil(fo/fs);
f_wid_min = fs * (m - 1);
f_wid_max = fs * (m - 1) + (fs/2);
f_wid_m100 = (fo - f_wid_min + Bd) / fs;
f_wid_m80 = (fo - f_wid_min + Bd + 20000) / fs;
f_wid_m60 = (fo - f_wid_min + Bd + 40000) / fs;
f_wid_m40 = (fo - f_wid_min + Bd + 60000) / fs;
f_wid_m20 = (fo - f_wid_min + Bd + 80000) / fs;
f_wid_0 = (fo - f_wid_min) / fs;
f_wid_p20 = (fo - f_wid_min + Bg - 30000) / fs;
f_wid_p40 = (fo - f_wid_min + Bg - 10000) / fs;
f_wid_p50 = (fo - f_wid_min + Bg) / fs;

fig_1 = figure;
set(fig_1, 'color', 'white');
%-------------------
if kraniec == 0
    for fd = Bd : 100 : Bg
        % GENERACJA SZUMU
        sigma = 0;                                            % Standardowe odchylenie szumu
        noise = sigma * randn(1,N); 
        
        % GENERACJA Sygna�u
        f_sygnal = fo + fd;
        s = sin(2 * pi * f_sygnal * n / fs) + noise;         % Pr�bki sygna�u - podpr�bkowanie
        sx = s .* norm;                                      % Normowanie sygna�u                   
        S = abs(fft(sx, N));                                 % Modu� widma sygna�u 

        hold off
        subplot(2,1,1);
        stem(t_us, s, 'Linewidth',2);
        hold on
        plot(t_us, s, 'r', 'Linewidth',2);
        hold off
        xlim([0 w_t_us])
        grid on;
        title(['Sygna� po�redniej pr�bkowanej z cz�stotliwo�ci� :  ', num2str(fs/1000), '  kHz']);
        xlabel('Czas [us]');
        ylabel('Amplituda');

        subplot(2,1,2);
        bar(f_un, S, 'Linewidth',2);
        xlim([0 0.5])
        ylim([0 0.55])
        xticks([f_wid_m100 f_wid_m80 f_wid_m60 f_wid_m40 f_wid_m20 f_wid_0 f_wid_p20 f_wid_p40 f_wid_p50])
        xticklabels({'-100 kHz','-80 kHz','-60 kHz','-40 kHz','-20 kHz','0 kHz','+20 kHz','+40 kHz','+50 kHz'})
        grid on;
        title('Widmo Amplitudowe');
        xlabel('Cz�stotliwo�� dopplerowska');
        ylabel('Warto�� pr�bki');
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
    
    % GENERACJA Sygna�u
    suma = 0;
    for fd = Bd : 100 : Bg
        f_sygnal = fo + fd;
        s = sin(2 * pi * f_sygnal * n / fs) + noise;         % Pr�bki sygna�u - podpr�bkowanie
        sx = s .* norm;                                      % Normowanie sygna�u                   
        S = abs(fft(sx, N));                                 % Modu� widma sygna�u 
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
    title(['Sygna� po�redniej pr�bkowanej z cz�stotliwo�ci� :  ', num2str(fs/1000), '  kHz']);
    xlabel('Czas [us]');
    ylabel('Amplituda');

    subplot(2,1,2);
    bar(f_un, suma, 'Linewidth',2);
    xlim([0 0.5])
    ylim([0 0.8])
    xticks([f_wid_m100 f_wid_m80 f_wid_m60 f_wid_m40 f_wid_m20 f_wid_0 f_wid_p20 f_wid_p40 f_wid_p50])
    xticklabels({'-100 kHz','-80 kHz','-60 kHz','-40 kHz','-20 kHz','0 kHz','+20 kHz','+40 kHz','+50 kHz'})
    grid on;
    title('Widmo Amplitudowe');
    xlabel('Cz�stotliwo�� dopplerowska');
    ylabel('Warto�� pr�bki');
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
    %GENERACJA Sygna�u
    s = sin(2 * pi * (fo + Bd) * n / fs) + sin(2 * pi * (fo + Bg) * n / fs) + noise;         %Pr�bki sygna�u - podpr�bkowanie
    sx = s .* norm;                                      % Normowanie sygna�u                   
    S = abs(fft(sx, N));                                     % Modu� widma sygna�u 

    hold off
    subplot(2,1,1);
    stem(t_us, s, 'Linewidth',2);
    hold on
    plot(t_us, s, 'r', 'Linewidth',2);
    hold off
    xlim([0 w_t_us])
    grid on;
    title(['Sygna� po�redniej pr�bkowanej z cz�stotliwo�ci� :  ', num2str(fs/1000), '  kHz']);
    xlabel('Czas [us]');
    ylabel('Amplituda');

    subplot(2,2,3);
    bar(f_un, S, 'Linewidth',2);
    xlim([0 0.5])
    ylim([0 0.55])
    xticks([f_wid_m100 f_wid_m80 f_wid_m60 f_wid_m40 f_wid_m20 f_wid_0 f_wid_p20 f_wid_p40 f_wid_p50])
    xticklabels({'-100 kHz','-80 kHz','-60 kHz','-40 kHz','-20 kHz','0 kHz','+20 kHz','+40 kHz','+50 kHz'})
    grid on;
    title('Widmo Amplitudowe');
    xlabel('Cz�stotliwo�� dopplerowska');
    ylabel('Warto�� pr�bki')
    if legenda == 1
        legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
             'df = ', num2str(df), ' [Hz],  ' ...
             'N = ', num2str(N), ' [Sa],  ' ...
             'T = ', num2str(T * 10^3), ' [ms]']);
    end
    pause(0.001);
    set(gcf, 'Position', get(0, 'Screensize'));
end




