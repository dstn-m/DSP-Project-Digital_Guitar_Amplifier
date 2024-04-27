fs = 96000/6;
scale = 1;
freq = 5;
timestep = 1/fs;
t = 0:timestep:(1/freq)-timestep;

steps = fs/freq;
y = (scale*sin(freq*2*pi*t));

plot(t, y);
ylim([-scale*1.1 scale*1.1]);
title("Scaled Sine");
ylabel("Magnitude");
xlabel("Time(s)");

output = y(1:steps);
%writematrix(output',output.h);

outfile = 'sinLUT.txt';
d = fopen(outfile, 'wb'); %opens the output file

for i = 1:steps
    fprintf(d,'%d,',output(i));
    fprintf(d,'\n');
end

fclose(d);
