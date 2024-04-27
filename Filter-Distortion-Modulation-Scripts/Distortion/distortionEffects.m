%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%
% This file is to generate plots showing our waveshaping distortion method against
% a simple sinusoidal input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = linspace(0, 4*pi, 1024);

% luts are the positive half of trig functions
atanLut = atan(x);
tanhLut = tanh(x);

% generate input sequence at max range of zoom board
f = 1.2e3;
t = linspace(0, 2/f, 1024);
input = 16384*sin(2*pi*f*t);
out = zeros(1, 1024);
out2 = zeros(1, 1024);

% test the lut - use the input divided by 32 (for a max of 1024) to
% select the index of the lut. Scale this value by some desired max amplitude
for i = 1 : 1024
  if(input(i) < 0)
    s = -1;
  else
    s = 1;
  endif
  if(input(i) == 0 )
    out(i) = 0;
  elseif(input(i) < 0 )
    out(i) = s*8192*atanLut(abs(floor(input(i) / 16)));
  else
    out(i) = s*8192*tanhLut(abs(floor(input(i) / 16)));
  endif

endfor

figure(1)

plot(t, input, "linewidth",3);
hold on;
plot(t, out, "linewidth",3);
grid on;
hold off;
set(gca, "linewidth", 2, "fontsize", 30);
legend('Input', 'Output', "fontsize", 30);
title('Sinusoid Through Distortion Stage',"fontsize", 30);
ylabel('Output',  "fontsize", 30);
xlabel('Input',  "fontsize", 30);
xlim([0 2/f]);


figure(2)
for i = 1 : 1024
  if(out(i) < 0)
    s = -1;
  else
    s = 1;
  endif
  if(out(i) == 0 )
    out2(i) = 0;
  elseif(out(i) < 0 )
    out2(i) = s*8192*atanLut(abs(floor(out(i) / 16)));
  else
    out2(i) = s*8192*tanhLut(abs(floor(out(i) / 16)));
  endif

endfor

plot(t, out, "linewidth",3);
hold on;
plot(t, out2, "linewidth",3);
grid on;
hold off;
set(gca, "linewidth", 2, "fontsize", 30);
legend('Input', 'Output', "fontsize", 30);
title('Sinusoid Through Distortion Stage',"fontsize", 30);
ylabel('Output',  "fontsize", 30);
xlabel('Input to Second Stage',  "fontsize", 30);
xlim([0 2/f]);


%%%%%%%%%%%%%%%%%%%%%%%
% use LUT to distort the guitar signal

in = audioread('guitar.wav');
% convert to mono
in = in(:, 1);

% normalize input to 32768
scale = 32768;
inn = scale * (in / max(abs(in)));

len = length(in);
out = zeros( 1, len);

% apply pre-amp gain - this increases distortion
gain = 10;
inn = gain * inn;
if(0)
for i = 1 : len

  lutindx = floor(abs(inn(i))/32);
  if( lutindx > 1024 )
    lutindx = 1024;
  endif

  if(inn(i) < 0)
    s = -1;
  else
    s = 1;
  endif

  if((inn(i) == 0) || (lutindx == 0))
    out(i) = 0;
  elseif(inn(i) < 0)
    out(i) = s*10000*tanhLut(lutindx); %(inSeq(i)/12)
  else
    out(i) = s*10000*atanLut(lutindx);
  endif
endfor

% renormalize to input level
out = max(in) * (out/max(out));


figure(3)
subplot(2,1,1)
plot(in);
subplot(2,1,2)
plot(out);

endif
%fs = 44100;
%sound(out, fs);
