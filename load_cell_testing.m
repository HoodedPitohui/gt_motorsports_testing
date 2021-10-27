%% Load the data
clc
clear all
close all
inputTable = readtable('aero_test.xlsx', 'Range', 'A7:D131540');
inputTable.Properties.VariableNames = {'time', 'fr_loadcell', 'rr_loadcell', 'speed_kmh'};

%% Conversions:
inputTable.speed_mph = inputTable.speed_kmh * 0.621371;

%% Graph the data

plotFRLoadCellData(inputTable.time, inputTable.fr_loadcell, 1, ...
    length(inputTable.fr_loadcell), inputTable.speed_mph, 1, 1);

plotRRLoadCellData(inputTable.time, inputTable.fr_loadcell, 1, ...
    length(inputTable.fr_loadcell), inputTable.speed_mph, 1, 1);


%% Find and filter for speed values of 0

inputTableA = table2array(inputTable); %convert to array for conversion ease
inputTableA(:, 4) = inputTableA(:, 4) .* 0.621371;
zeroValues = find(inputTableA(:, 4) == 0); %find when the speed = 0
diffsZV = diff(zeroValues); %find the differences
diffsZVA = find(diffsZV > 1); %get indexes
%3500 to 3501, 9350 to 9351, 9358 to 9360

range1 = [zeroValues(1), zeroValues(diffsZVA(1))];
range2 = [zeroValues(diffsZVA(1) + 1), zeroValues(diffsZVA(2))];
range3 = [zeroValues(diffsZVA(2) + 1), zeroValues(diffsZVA(3))];

figure;
subplot(3, 2, 1);
plot(inputTableA(1: range1(1), 1), inputTableA(1: range1(1), 2));
xlabel('time (s)');
ylabel('load (lbs)');
title(strcat('Load (lbs) on FR Load Cell vs. Time (s) from t = ', num2str(inputTableA(1)), ' to ', num2str(inputTableA(range1(1)))));

subplot(3, 2, 2);
plot(inputTableA(1: range1(1), 1), inputTableA(1: range1(1), 4));
xlabel('time (s)');
ylabel('speed (mph)');
title(strcat('Speed (mph) vs. Time (s) from t = ', num2str(inputTableA(range1(2))), ' to ', num2str(inputTableA(range2(1)))));

subplot(3, 2, 3);
plot(inputTableA(range1(2): range2(1), 1), inputTableA(range1(2): range2(1), 2));
xlabel('time (s)');
ylabel('load (lbs)');
title(strcat('Load (lbs) on FR Load Cell vs. Time (s) from t = ', num2str(inputTableA(range1(2))), ' to ', num2str(inputTableA(range2(1)))));


subplot(3, 2, 4);
plot(inputTableA(range1(2): range2(1), 1), inputTableA(range1(2): range2(1), 4));
xlabel('time (s)');
ylabel('speed (mph)');
title(strcat('Speed (mph) vs. Time (s) from t = ', num2str(inputTableA(range1(2))), ' to ', num2str(inputTableA(range2(1)))));

subplot(3, 2, 5);
plot(inputTableA(range2(2): range3(1), 1), inputTableA(range2(2): range3(1), 2));
xlabel('time (s)');
ylabel('load (lbs)');
title(strcat('Load (lbs) on FR Load Cell vs. Time (s) from t = ', num2str(inputTableA(range2(2))), ' to ', num2str(inputTableA(range3(1)))));

subplot(3, 2, 6);
plot(inputTableA(range2(2): range3(1), 1), inputTableA(range2(2): range3(1), 4));
xlabel('time (s)');
ylabel('speed (mph)');
title(strcat('Speed (mph) vs. Time (s) from t = ', num2str(inputTableA(range2(2))), ' to ', num2str(inputTableA(range3(1)))));



figure;
subplot(3, 2, 1);
plot(inputTableA(1: range1(1), 1), inputTableA(1: range1(1), 3));
xlabel('time (s)');
ylabel('load (lbs)');
title(strcat('Load (lbs) on RR Load Cell vs. Time (s) from t = ', num2str(inputTableA(1)), ' to ', num2str(inputTableA(range1(1)))));


subplot(3, 2, 2);
plot(inputTableA(1: range1(1), 1), inputTableA(1: range1(1), 4));
xlabel('time (s)');
ylabel('speed (mph)');
title(strcat('Speed (mph) vs. Time (s) from t = ', num2str(inputTableA(range1(2))), ' to ', num2str(inputTableA(range2(1)))));


subplot(3, 2, 3);
plot(inputTableA(range1(2): range2(1), 1), inputTableA(range1(2): range2(1), 3));
xlabel('time (s)');
ylabel('load (lbs)');
title(strcat('Load (lbs) on RR Load Cell vs. Time (s) from t = ', num2str(inputTableA(range1(2))), ' to ', num2str(inputTableA(range2(1)))));


subplot(3, 2, 4);
plot(inputTableA(range1(2): range2(1), 1), inputTableA(range1(2): range2(1), 4));
xlabel('time (s)');
ylabel('speed (mph)');
title(strcat('Speed (mph) vs. Time (s) from t = ', num2str(inputTableA(range1(2))), ' to ', num2str(inputTableA(range2(1)))));

subplot(3, 2, 5);
plot(inputTableA(range2(2): range3(1), 1), inputTableA(range2(2): range3(1), 3));
xlabel('time (s)');
ylabel('load (lbs)');
title(strcat('Load (lbs) on RR Load Cell vs. Time (s) from t = ', num2str(inputTableA(range2(1))), ' to ', num2str(inputTableA(range3(1)))));

subplot(3, 2, 6);
plot(inputTableA(range2(2): range3(1), 1), inputTableA(range2(2): range3(1), 4));
xlabel('time (s)');
ylabel('speed (mph)');
title(strcat('Speed (mph) vs. Time (s) from t = ', num2str(inputTableA(range2(2))), ' to ', num2str(inputTableA(range3(1)))));

inputTableA(zeroValues(diffsZVA(1) + 1), 1);
inputTableA(zeroValues(3502), 1);

%% Basic Derivative Testing
mean(inputTableA(1: range1(1), 4))


