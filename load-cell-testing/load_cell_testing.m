%% Load the data
clc
clear all
close all
inputTable = readtable('aero_test.xlsx', 'Range', 'A7:D131540');
inputTable.Properties.VariableNames = {'time', 'fr_loadcell', 'rr_loadcell', 'speed_kmh'};

%% Conversions:
inputTable.speed_mph = inputTable.speed_kmh * 0.621371;

%% Graph the data

fig1 = figure('WindowState', 'Maximized');
plotFRLoadCellData(inputTable.time, inputTable.fr_loadcell, 1, ...
    length(inputTable.fr_loadcell), inputTable.speed_mph, 2, 1, 1);

fig2 = figure('WindowState', 'Maximized');
plotRRLoadCellData(inputTable.time, inputTable.fr_loadcell, 1, ...
    length(inputTable.fr_loadcell), inputTable.speed_mph, 2, 1, 1);


%% Find and filter for the time that the vehicle is actually running

nonZeroValues = find(inputTable.speed_mph >= 5); %Gets an index
diffIntervals = diff(nonZeroValues);

% ranges = [];
init = 1;
p1 = find(diffIntervals > 1);
ranges = [nonZeroValues(p1), nonZeroValues(p1 + 1)];
fRange = [];
for i = 1: length(ranges)
    fRange(i, :) = [init, ranges(i, 1)];
    init = ranges(i , 2);
end
fRange(length(ranges) + 1, :) = [init, length(inputTable.time)];

%% Plot the FR Subsets

fig3 = figure('WindowState', 'Maximized');
for i = 1: length(fRange)
    initPos = 1 + 2 * (i - 1);
    plotFRLoadCellData(inputTable.time, inputTable.fr_loadcell, fRange(i, 1),...
        fRange(i, 2), inputTable.speed_mph, length(fRange), 2, initPos);
end

%% Plot the RR Subsets

fig4 = figure('WindowState', 'Maximized');
for i = 1: length(fRange)
    initPos = 1 + 2 * (i - 1);
    plotRRLoadCellData(inputTable.time, inputTable.rr_loadcell, fRange(i, 1),...
        fRange(i, 2), inputTable.speed_mph, length(fRange), 2, initPos);
end


%% Early fourier transform

fig5 = figure('WindowState', 'Maximized');
Fs = 100; %sampling frequency
Ys = inputTable.rr_loadcell(2: length(inputTable.time)); %sampling data
lenRR = length(Ys); %find length
duration = 1 / Fs * lenRR; %duration in time(s)
step = 0.01;

%Amplitude vs. Time plot
HzRR = [0 + step: step:duration];
subplot(3, 1, 1);
plot(HzRR, Ys);
title('Frequency Vs. Time');
xlabel('Time (s)');
ylabel('Amplitude');

%FFT calcs
XRR = abs(fft(Ys)) / (2 * lenRR);

%Frequency calcs
tRR = (0: lenRR - 1) / (lenRR / Fs);

%plot of amplitude vs. frequency
subplot(3, 1, 2);
plot(tRR, abs(XRR));
title('Amplitude vs. Frequency (Hz)');
xlabel('Amplitude');
ylabel('Frequency (Hz)');

%% Attempt 2: fft with average line calculations
fig6 = figure('WindowState', 'Maximized');
subplot(4, 1, 1);
baseLineSet1 = mean(inputTable.rr_loadcell(2: ranges(1, 1)));
newSet1 = inputTable.rr_loadcell(2: ranges(1, 1)) - baseLineSet1;
plot(inputTable.time(2: ranges(1, 1)), newSet1);

subplot(4, 1, 2);
Fs = 100; %sampling frequency
Ys = newSet1;
lenRR = length(Ys); %find length
duration = 1 / Fs * lenRR; %duration in time(s)
step = 0.01;

%Amplitude vs. Time plot
HzRR = [0 + step: step:duration];
plot(HzRR, Ys);
title('Frequency Vs. Time');
xlabel('Time (s)');
ylabel('Amplitude');

%FFT calcs
XRR = abs(fft(Ys)) / (2 * lenRR);

%Frequency calcs
tRR = (0: lenRR - 1) / (lenRR / Fs);

%plot of amplitude vs. frequency
subplot(4, 1, 3);
plot(tRR, abs(XRR));
title('Amplitude vs. Frequency (Hz)');
xlabel('Amplitude');
ylabel('Frequency (Hz)');
