%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%
% This file is to generate a header file with atan and tanh value lookup tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate 1024 datapoints
x = linspace(0, 4*pi, 1024);

% LUTS are the positive half of trig functions
atanLut = atan(x);
tanhLut = tanh(x);

figure(1)
hold on;

s1 = subplot(2, 1, 1);

plot(x, atanLut, "linewidth", 3);
set(s1, 'title', 'ATAN Curve',"fontsize", 30);
set(gca, "linewidth", 2, "fontsize", 30);
ylabel('Output',  "fontsize", 30);
xlabel('Input',  "fontsize", 30);

ylim([0 1.75]);
xlim([0 4*pi]);
set(gca, "linewidth", 2, "fontsize", 30);

s2 = subplot(2, 1, 2);

plot(x, tanhLut, "linewidth", 3, 'r');
set(s2, 'title', 'TANH Curve', "fontsize", 30);
ylabel('Output',  "fontsize", 30);
xlabel('Input',  "fontsize", 30);
ylim([0 1.5]);
xlim([0 4*pi]);
set(gca, "linewidth", 2, "fontsize", 30);
S = axes( 'visible', 'off', 'title', 'Nonlinear Functions to Simulate Amplifier Distortion Curves ', "linewidth", 2,  "fontsize", 30);


figure(2)
xn = linspace(-4*pi, 0, 512);
dn = atan(xn);
xp = linspace(4*pi/512, 2*pi, 512);
dp = tanh(xp);
dist = ([dn(1:512) dp(1:512)]);
xg = linspace(-4*pi, 4*pi, 1024);

plot(xg, dist, "linewidth", 2, 'r');
grid on;
set(gca, "linewidth", 2, "fontsize", 30);
title('Asymmetrical Distortion Curve', "fontsize", 30);
ylabel('Output',  "fontsize", 30);
xlabel('Input',  "fontsize", 30);

figure(3)

xg = linspace(-4*pi, 4*pi, 1024);
dist2 = atan(xg);

plot(xg, dist2, "linewidth", 6, 'r');
grid on;
set(gca, "linewidth", 2, "fontsize", 16);
title('Symmetrical Distortion Curve', "fontsize", 16);
ylabel('Output',  "fontsize", 16);
xlabel('Input',  "fontsize", 16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE THE LUT FILE
% ---------------------
LUTSIZE = 1024;

generate = 0;
if(generate)

filename = "distortionLUT";

j = fopen([filename '.h'],'w');
  fprintf(j, '/* %-35s */\n\n', [filename '.h']);
  fprintf(j, '/* Distortion LUTS=s\n');
  fprintf(j, ' *------------------------\n\n');
  fprintf(j, ' * LUTs are 1024 datapoints of atan(x) and tanh(x)\n');
  fprintf(j, ' */ \n\n');


  fprintf(j, '#ifndef DISTORTIONLUT_H_\n');
  fprintf(j, '#define DISTORTIONLUT_H_\n\n');
  fprintf(j, '#include "distortionModule.h"\n\n');

  fprintf(j, '#define DISTLUTSIZE 1024\n\n');

  % use PRAGMA to store the LUT values

  % ATAN LUT
  fprintf(j, '#pragma DATA_SECTION (ATAN, "CE0");\n\n');
  fprintf(j, 'float ATAN[DISTLUTSIZE] = {\n');

  for i = 1 : 1024
    fprintf(j, '\t\t%g,\n', atanLut(i));
  endfor

  fprintf(j, ' };\n\n');   % no comma

    % TANH LUT
  fprintf(j, '#pragma DATA_SECTION (TANH, "CE0");\n\n');
  fprintf(j, 'float TANH[DISTLUTSIZE] = {\n');

  for i = 1 : 1024
    fprintf(j, '\t\t%.5f,\n', tanhLut(i));
  endfor

  fprintf(j, ' };\n\n');   % no comma


  % EOF
  fprintf(j, '#endif /* DISTORTIONLUT_H_ */\n');

  fclose(j);

endif
