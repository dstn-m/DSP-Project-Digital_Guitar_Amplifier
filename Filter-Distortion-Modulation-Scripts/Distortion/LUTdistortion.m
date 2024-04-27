%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%
% This file has two purposes. The first is to validate that our distortion
% algorithm will in fact scale the input values seen on the zoom board, with its
% range of roughly +/-32767, as desired using the lookup table method.
%
% The second section of this file reads in a wav file recording and processes it
% in the same manner before renormalizing the levels back to that of the input for
% playback.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = linspace(0, 4*pi, 1024);

% luts are the positive half of trig functions
atanLut = atan(x);
tanhLut = tanh(x);

% generate input sequence at max range of zoom board
inSeq = linspace(-32768, 32768, (32768*2)+1);
len = length(inSeq);

outSeq1 = zeros(1, len);

% test the lut - use the input divided by 32 (for a max of 1024) to
% select the index of the lut. Scale this value by some desired max amplitude
for i = 1 : len
  if(inSeq(i) < 0)
    s = -1;
  else
    s = 1;
  endif
  if((inSeq(i) == 0) || (floor(abs(inSeq(i))/32) == 0))
    outSeq(i) = 0;
  elseif(inSeq(i) < 0)
    outSeq1(i) = s*8192*atanLut(floor(abs(inSeq(i))/32)); %(inSeq(i)/12)
  else
    outSeq1(i) = s*8192*tanhLut(floor(abs(inSeq(i))/32)); %(inSeq(i)/12)
  endif

endfor

figure(1)
plot(inSeq, outSeq1, "linewidth", 3, 'r');
grid on;
set(gca, "linewidth", 3, "fontsize", 30);
title('Asymmetrical Distortion Curve', "fontsize", 30);
ylabel('Output Value',  "fontsize", 30);
xlabel('Input Value',  "fontsize", 30);


%%%%%%%%%%%%%%%%%%%%%%%
% use LUT to test distorting the guitar signal
fs = 44100;
in = audioread('guitar.wav');
% convert to mono
in = in(:, 1);

% play the unprocessed signal
sound(in, fs);

% normalize input to 32768
scale = 32768;
inn = scale * (in / max(abs(in)));

len = length(in);
out = zeros( 1, len);

% apply pre-amp gain - this increases distortion
gain = 10;
inn = gain * inn;

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

% show the input vs output signal
figure(2)
subplot(2,1,1)
plot(in);
subplot(2,1,2)
plot(out);

% play the processed signal
sound(out, fs);
