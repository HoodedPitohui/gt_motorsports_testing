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
subplot(3, 1, 1)
Fs = 100;
%Spitting out magnitudes in the value of 10^3
L = ranges(1, 1) / 100;
n = 2^nextpow2(L);
dim = 2;
data1 = fft(inputTable.rr_loadcell(5000: ranges(1, 1)), n, dim);
plot(inputTable.time(5000: ranges(1, 1)), data1);
P2 = abs(data1 / L);
P1 = P2(1: n/ 2 + 1);
P1(2: end - 1) = 2 * P1(2: end - 1);

subplot(3, 1, 2)
plot(0:(Fs / n):(Fs / 2 - Fs / n), P1(1: n / 2));
title('frequency domain graph');



%% Testing
fig6 = figure('WindowState', 'Maximized');
%Find Lengths
Lf = length(ranges(1, 1));
%Sample rate
Step1 = 1/100;
%Find duration of recordings
Duration_Flute = Lf / 100;
%X axis for amplitude vs time plots
Hzf = [0+Step1:Step1:Duration_Flute];
%Amplitude vs time plots
subplot(2,1,1)
plot(Hzf,inputTable.rr_loadcell(1: ranges(1, 1)))
xlabel('Time (ms)');
ylabel('Amplitude');
% title('2"')(
% xlabel('Time (ms)')
% ylabel('Amplitude')
% subplot(2,2,2)

%FFT calcs
Xf = abs(fft(inputTable.rr_loadcell(1: ranges(1, 1))))/(2 * Lf);
%Frequency Calculation
tf = (0:Lf-1)/(Lf/100);

figure(2)
%Plot amplitude vs frequency
subplot(2,1,2)
plot(tf,abs(Xf))


