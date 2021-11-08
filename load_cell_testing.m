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

%Spitting out magnitudes in the value of 10^3
tv = inputTable.time;
LC = inputTable.fr_loadcell;

subplot(3, 1, 1);
plot(tv, LC);
grid;

Ts = mean(diff(tv));
Fs = 1 / Ts;
Fn = Fs / 2;
L = size(tv, 1);

FTLC = fft(LC) / L;
z = fix(L / 2);
Fv = linspace(0, 1, fix(L / 2) + 1) .* Fn;
Iv = 1:length(Fv);

subplot(3, 1, 2)
plot(Fv, abs(FTLC(Iv)));
grid

axis([0  500    ylim]);

% fourier_loadcell= fft(inputTable.fr_loadcell(11100:11200));
% a = max(inputTable.fr_loadcell);
% a2 = min(inputTable.fr_loadcell);
% plot(inputTable.time(11100:11200), fourier_loadcell)

% Note there are some extreme signal noises after the fft is done
plot(inputTable.time(10000:20000), x);
plotFRLoadCellData(inputTable.time, inputTable.fr1_loadcell, 10000, ...
    20000, inputTable.speed_mph, 2, 1, 1);

