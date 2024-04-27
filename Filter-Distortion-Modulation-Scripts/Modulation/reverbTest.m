%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin and Lucas
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%
% This file is used to demonstrate the validity of our 'reverb' method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
fs = 44100;
% import guitar clip
src = audioread('guitar.wav');
% convert to mono
src = transpose(src(:, 1));
smpls = length(src);

% play unprocessed signal
sound(src, fs);

%
out = src;

% create circular buffer for delayed signal
% length of the reverb can be changed with vLen
vLen = 128;
cntmax = floor(44.1*vLen); cntmin = 1;
head = cntmax;
tail = cntmin;
buf = zeros(1,cntmax);

for i = 1:smpls
  buf(head) = out(i);

  out(i) = out(i) + .75*buf(tail);
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

% renormalize
out= out/max(abs(out));

sound(out, fs);

