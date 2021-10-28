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


%% Find and filter for speed values of 0

zeroValues = find(inputTable.speed_mph == 0); %find when the speed = 0
diffsZV = diff(zeroValues); %find the differences
diffsZVA = find(diffsZV > 1); %get indexes
%3500 to 3501, 9350 to 9351, 9358 to 9360

range1 = [zeroValues(1), zeroValues(diffsZVA(1))];
range2 = [zeroValues(diffsZVA(1) + 1), zeroValues(diffsZVA(2))];
range3 = [zeroValues(diffsZVA(2) + 1), zeroValues(diffsZVA(3))];

%% Plot the FR Subsets

fig3 = figure('WindowState', 'Maximized');
plotFRLoadCellData(inputTable.time, inputTable.fr_loadcell, 1, ...
    range1(1), inputTable.speed_mph, 3, 2, 1);

plotFRLoadCellData(inputTable.time, inputTable.fr_loadcell, range1(2), ...
    range2(1), inputTable.speed_mph, 3, 2, 3);

plotFRLoadCellData(inputTable.time, inputTable.fr_loadcell, range2(2), ...
    range3(1), inputTable.speed_mph, 3, 2, 5);

%% Plot the RR Subsets

fig4 = figure('WindowState', 'Maximized');
plotRRLoadCellData(inputTable.time, inputTable.rr_loadcell, 1, ...
    range1(1), inputTable.speed_mph, 3, 2, 1);

plotRRLoadCellData(inputTable.time, inputTable.rr_loadcell, range1(2), ...
    range2(1), inputTable.speed_mph, 3, 2, 3);

plotRRLoadCellData(inputTable.time, inputTable.rr_loadcell, range2(2), ...
    range3(1), inputTable.speed_mph, 3, 2, 5);


%% Basic Derivative Testing


