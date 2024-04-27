%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin and Lucas
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%
% This file is used to demonstrate the validity of our 'phaser' effect
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
fs = 44100;
% import guitar clip
src = audioread('guitar.wav');
src = transpose(src(:, 1));
smpls = length(src);
% play unprocessed signal
sound(src, fs);

% change the speed of the phaser with PHASERFREQ
PHASERFREQ = 6;
t = linspace(0, smpls/fs, smpls);
% low frequency oscillation signal
wv = sin(2*pi*PHASERFREQ*t);

out = src;%zeros(1, smpls);

% create circular buffer for delayed signal
cntmax = floor(44.1*125); cntmin = 1;
head = cntmax;
tail = cntmin;
buf = zeros(1,cntmax);

for i = 1:smpls
  buf(head) = out(i)* wv(i);

  out(i) = out(i) + .5*buf(tail);
  if(tail == cntmax)
    tail = cntmin;
  else
    tail++;
  endif
  if(head == cntmax)
    head = cntmin;
  else
    head++;
  endif

endfor

out= out/max(abs(out));

% play processed signal
sound(out, fs);
