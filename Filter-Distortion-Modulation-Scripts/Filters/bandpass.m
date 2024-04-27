%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pkg load signal;  % required to run filter cmds in Octave
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% INPUT FILTER

% generate 2nd order filters
fs = 96000;
N = 1;
% digital filter ->fs/2
WL = 100/(fs/2);
WH = 8000/(fs/2);

% octave allows a digital filter to be generated directly by
% selecting frequencies < 1
[bzH, azH] = butter(N, WL, "high");

figure(1)
s1 = subplot(3, 1, 1);
wz = 1: 1: fs/2;
HzH2 = freqz(bzH, azH, wz, fs);
semilogx(wz, 20*log10(abs(HzH2)), "linewidth",2);

set(s1, 'title', 'High Pass',"fontsize", 30);
ylabel('dB',  "fontsize", 30);
xlabel('Frequency (Hz)',  "fontsize", 30);
ylim([-40 10]);

s2 = subplot(3, 1, 2);
[bzL, azL] = butter(N, WH);
HzL2 = freqz(bzL, azL, wz, fs);
semilogx(wz, 20*log10(abs(HzL2)), "linewidth",2);

set(s2, 'title', 'Low Pass',"fontsize", 30);
ylabel('dB',  "fontsize", 30);
xlabel('Frequency (Hz)',  "fontsize", 30);
ylim([-40 10]);

s3 = subplot(3, 1, 3);
Ht2 = HzL2.*HzH2;
semilogx(wz, 20*log10(abs(Ht2)), "linewidth",2);

set(s3, 'title', 'Cascaded Response',"fontsize", 30);
ylabel('dB',  "fontsize", 30);
xlabel('Frequency (Hz)',  "fontsize", 30);
ylim([-40 10]);

if(1)
fileID = fopen('bandpass.txt','w');

fprintf(fileID,'b\n');
fprintf(fileID,'%f, ', bzH(1,:));
fprintf(fileID,'%f, ', bzL(1,:));

fprintf(fileID,'\na\n');
fprintf(fileID,'%f, ', azH(1,:));
fprintf(fileID,'%f, ', azL(1,:));
fprintf(fileID,'\n\n');

fprintf(fileID,'\n\n');
fclose(fileID);
endif
