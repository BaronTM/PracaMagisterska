clc;
clear all;


u = udp('0.0.0.0', 5678);
u.OutputBufferSize = 2048;
u.InputBufferSize = 2048;
fopen(u);

for k = 1:1000
   data = fread(u, 2048, 'uchar')
   
end