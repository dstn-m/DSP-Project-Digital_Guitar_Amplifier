%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%
% This file is to generate plots & tap values for three sets of 
% cascaded low-and-high pass filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pkg load signal;

%%%% NEW TONESTACK :(
%%%%%%%% FILT 1 for low freq band

% generate 2nd order
fs = 96000;
N = 1;
% digital filter ->fs/2
WL = 75/(fs/2);
WH = 150/(fs/2);

[bzH, azH] = butter(N, WL, "high");

figure(1)
wz = 1: 1: fs/2;
HzH1 = freqz(bzH, azH, wz, fs);
semilogx(wz, 20*log10(abs(HzH1)));
hold on;
ylim([-40 10]);


[bzL, azL] = butter(N, WH);
HzL1 = freqz(bzL, azL, wz, fs);
semilogx(wz, 20*log10(abs(HzL1)));
hold off;

figure(2)
Ht1 = HzL1.*HzH1;
semilogx(wz, 20*log10(abs(Ht1)));
ylim([-40 10]);

if(1)
fileID = fopen('lowfreqCascade.txt','w');

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% FILT 2 for mid freq band

% generate 2nd order
fs = 96000;
N = 1;
% digital filter ->fs/2
WL = 350/(fs/2);
WH = 1000/(fs/2);

[bzH, azH] = butter(N, WL, "high");


figure(3)
wz = 1: 1: fs/2;
HzH2 = freqz(bzH, azH, wz, fs);
semilogx(wz, 20*log10(abs(HzH2)));
hold on;
ylim([-40 10]);


[bzL, azL] = butter(N, WH);
HzL2 = freqz(bzL, azL, wz, fs);
semilogx(wz, 20*log10(abs(HzL2)));
hold off;

figure(4)
Ht2 = HzL2.*HzH2;
semilogx(wz, 20*log10(abs(Ht2)));
ylim([-40 10]);

if(1)
fileID = fopen('MIDfreqCascade.txt','w');

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% FILT 3 for hi freq band

% generate 2nd order
fs = 96000;
N = 1;
% digital filter ->fs/2
WL = 2000/(fs/2);
WH = 10000/(fs/2);

[bzH, azH] = butter(N, WL, "high");


figure(5)
wz = 1: 1: fs/2;
HzH3 = freqz(bzH, azH, wz, fs);
semilogx(wz, 20*log10(abs(HzH3)));
hold on;
ylim([-40 10]);


[bzL, azL] = butter(N, WH);
HzL3 = freqz(bzL, azL, wz, fs);
semilogx(wz, 20*log10(abs(HzL3)));
hold off;

figure(6)
Ht3 = HzL3.*HzH3;
semilogx(wz, 20*log10(abs(Ht3)));
ylim([-40 10]);

if(1)
fileID = fopen('TREBfreqCascade.txt','w');

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


figure(7)
hold on;
HtT = .04*Ht1 + 1*Ht2 + Ht3;
s1 = subplot(3, 1, 1);

semilogx(wz, 20*log10(abs(HtT)), "linewidth", 2);
ylim([-40 10]);
set(s1, 'title', 'Bass Min',  "fontsize", 16);
ylabel('dB');
xlabel('Freq (Hz)');
set(gca, "linewidth", 2, "fontsize", 12);

HtT = 1*Ht1 + 0.04*Ht2 + Ht3;
s2 = subplot(3, 1, 2);

semilogx(wz, 20*log10(abs(HtT)), "linewidth", 2);
ylim([-40 10]);
set(s2, 'title', 'Mids Min',  "fontsize", 16);
ylabel('dB');
xlabel('Freq (Hz)');
set(gca, "linewidth", 2, "fontsize", 12);


HtT = 1*Ht1 + Ht2 + 0.04*Ht3;
s3 = subplot(3, 1, 3);

semilogx(wz, 20*log10(abs(HtT)), "linewidth", 2);
ylim([-40 10]);
set(s3, 'title', 'Treb Min',  "fontsize", 16 );
ylabel('dB');
xlabel('Freq (Hz)');
set(gca, "linewidth", 2, "fontsize", 12);

hold off;
S = axes( 'visible', 'off', 'title', 'Tonestack Frequency Response', "linewidth", 2,  "fontsize", 16);
