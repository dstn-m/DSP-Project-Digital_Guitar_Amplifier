%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Dustin and Lucas
% Course: EGR 423
% Instructor: Prof. Bruce Dunne
% Date: Apr. 2024
% File written for and run in Octave software
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 44100;
% import guitar clip
%src = audioread('guitar.wav');
%src = transpose(src(:, 1));
f = 1.2e3;
t = linspace(0, 2/f, 32767);
src = 16384*sin(2*pi*f*t);

phase = sin(2*pi*1000*t);
smpls = length(src);

out = src;%zeros(1, smpls);


cntmax = floor(44.1*32); cntmin = 1;
head = cntmax;
tail = cntmin;
buf = zeros(1,cntmax);

for i = 1:smpls
  buf(head) = (out(i)/2);

  out(i) = out(i) + .5*buf(tail)*phase(i);
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

figure(1)
plot(t, src, "linewidth",4);
hold on;
plot(t, out, "linewidth",4);
grid on;
hold off;
set(gca, "linewidth", 2, "fontsize", 32);
title('Phaser',"fontsize", 32);
ylabel('Output',  "fontsize", 32);
xlabel('t (s)',  "fontsize", 32);
set(gca, "linewidth", 2, "fontsize", 32);
legend('input', 'output', "fontsize", 32);

%out= out/max(abs(out));


%sound(out, fs);
