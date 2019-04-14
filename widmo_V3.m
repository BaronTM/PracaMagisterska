%-----------------------
%	Przetwarzanie sygna³u CW - 
%   SG
%-----------------------
clear
close all
%-----------------------
debug = 0; 
font = 14;
%-----------------------
fo = 3.135 * 10^6;          %Czêstotliwoœæ noœna [Hz]
B = 150 * 10^3 ;            %Pasmo sygna³u
Bd = -44 * 10^3;
Bg = 84 * 10^3;
%-----------------------
N = 4096;                   %D³ugoœæ wektora obserwacji
N_o = N * 1;                %D³ugoœæ wektora obserwacji
%fs = 432 *10^3;             %Czêstotliwoœæ próbkowania - podpróbkowanie
fs = 308 *10^3;

fs_o = 10 * fo;             %Czêstotliwoœæ próbkowania - próbkowannie 

Ts = 1/fs;
Ts_o = 1/fs_o;
T = Ts * N;                 %Czas obserwacji sygna³u
df = fs/N;                  %Rozdzielczoœæ widmowa
df_o = fs_o/N_o;            %Rozdzielczoœæ widmowa
%-------------------

%Obliczenia
n = 0 : 1 : N-1;
n_o = 0 : 1 : N_o-1;
t = n .* Ts;                %Wektor czasu próbkowania
t_o = n_o .* Ts_o;

t_ms = t .* 10^(3);         %Podstawa czasu [ms]
t_us = t .* 10^(6);          %Podstawa czasu [us]
to_ms = t_o.* 10^(3);       %Podstawa czasu [ms]
to_us = t_o.* 10^(6);       %Podstawa czasu [us]

s = zeros(1, N);
s_o = zeros(1, N_o);
O_Ham = zeros(1, N);
O_Ham_o = zeros(1, N_o);
%GENERACJA OKNA HAMMINGA
for i = 1 : 1 : N
    O_Ham(i) = (0.54 - 0.46*cos(2*pi*i/N)); 
end
O_Ham = O_Ham./sum(O_Ham);
for i = 1 : 1 : N_o
    O_Ham_o(i) = (0.54 - 0.46*cos(2*pi*i/N_o)); 
end
O_Ham_o = O_Ham_o./sum(O_Ham_o);'df = ', num2str(df), ' [Hz],  ' ...'df = ', num2str(df), ' [Hz],  ' ...

%Czêstotliwoœæ unormowana
f_un = (0 : 1 : N-1)./(N-1);
f_un_o = (0 : 1 : N_o-1)./(N_o-1);
f_n = f_un .* fs;
f_n_o = f_un_o .* fs_o;
f_n_o_MHz = f_n_o ./ 10^6;
%-------------------
%Parametry wykresów
w_t = 50 * Ts;        %Szerokoœæ okna rysowania wykresu sygna³u s[n]
w_t_ms = w_t * 10^3;
w_t_us = w_t * 10^6;
w_t_o = 20 * Ts_o;    %Szerokoœæ okna rysowania wykresu sygna³u s_o[n]
w_t_o_us = w_t_o * 10^6;

fig_1 = figure;


% Tworzenie pliku AVI
writerObj = VideoWriter('przykladowe.avi');
writerObj.FrameRate = 10;
open(writerObj);

%-------------------
for fd = Bd : 100 : Bg
    %GENERACJA SZUMU
    sigma = 0;                                            %Standardowe odchylenie szumu
    noise = sigma * randn(1,N); 
    noise_o = sigma * randn(1,N_o); 
    %GENERACJA Sygna³u
    f_sygnal = fo + fd;
    s_o = sin(2 * pi * f_sygnal * n_o / fs_o);           %Próbki sygna³u - fs = wiêksza od max pasma
    s = sin(2 * pi * f_sygnal * n / fs) + noise;         %Próbki sygna³u - podpróbkowanie
    sx = s .* O_Ham;                                      %Normowanie sygna³u                   
    sx_o = s_o .* O_Ham_o;
    S = abs(fft(sx, N));                                     %Modu³ widma sygna³u 
       
    hold off
    subplot(3,2,1);
    stem(t_us, s, 'Linewidth',2);
    hold on
    plot(t_us, s, 'r', 'Linewidth',2);
    hold off
    xlim([0 w_t_us])
    grid on;
    title(['Sygna³ poœredniej próbkowanej z czêstotliwoœci¹ :  ', num2str(fs/1000), '  kHz']);
    xlabel('Czas [us]');
    ylabel('Amplituda');
   
    subplot(3,2,2);
    bar(to_us, s_o, 'b', 'Linewidth',2);
    hold off
    xlim([0 w_t_o_us])
    grid on;
    title(['Sygna³ poœredniej próbkowanej z czêstotliwoœci¹ :  ', num2str(fs_o/10^6), '  MHz']);
    xlabel('Czas [us]');
    ylabel('Amplituda');
    
    subplot(3,1,2);
    f_skl_max = find(S == max(S));      %Czêstotliwoœæ max skladowej widma
    f_skl_max = f_skl_max(1)/N;
    f_skl_max_hz = f_skl_max * fs; 
    zp_d = f_skl_max - 0.010;
    zp_g = f_skl_max + 0.010;
    zp_d_hz = f_skl_max_hz - 500;
    zp_g_hz = f_skl_max_hz + 300;
    
    bar(f_un, S, 'Linewidth', 1);        
    xlim([zp_d zp_g])
    ylim([0 0.51])
    %legend(['fs = ', num2str(fs/10^3), ' [kHz]'; 'f = ', num2str(fs/10^3), ' [kHz]']);
    legend(['fs = ', num2str(fs/10^3), ' [kHz],  '  ...
         'f = ', num2str(f_sygnal/10^6), ' [MHz],  ' ...
         'df = ', num2str(df), ' [Hz],  ' ...
         'N = ', num2str(N), ' [Sa],  ' ...
         'T = ', num2str(T * 10^3), ' [ms]']);
     
    grid on;
    title('Widmo amplitudowe [ZOOM]');
    xlabel('Czêstotliwoœæ unormowana');
    ylabel('Wartoœæ próbki');
    
    if debug == 1
        S_o = abs(fft(s_o, N_o));  
        subplot(3,2,6);
        bar(f_n_o_MHz, S_o, 'Linewidth',2);
        grid on;
        title('Widmo amplitudowe sygna³u o czêstotliwoœci poœredniej');
        xlabel('Czêstotliwoœæ [MHz]');
        ylabel('Wartoœæ próbki'); 
        xlim([3 3.5])
        
        subplot(3,2,5);
        bar(f_un, S, 'Linewidth',2);
        xlim([0 0.5])
        ylim([0 0.55])
        grid on;
        title(['Widmo amplitudowepróbkowanej z czêstotliwoœci¹ :  ', num2str(fs/1000), '  kHz']);
        xlabel('Czêstotliwoœæ unormowana');
        ylabel('Wartoœæ próbki');  
  
    else
        subplot(3,1,3);
        bar(f_un, S, 'Linewidth',2);
        xlim([0 0.5])
        ylim([0 0.55])
        grid on;
        title('Widmo Amplitudowe');
        xlabel('Czêstotliwoœæ unormowana');
        ylabel('Wartoœæ próbki');
    end
    pause(0.001);
    set(gcf, 'Position', get(0, 'Screensize'));
    
    frame = getframe(fig_1);
    writeVideo(writerObj, frame);
end
close(writerObj);