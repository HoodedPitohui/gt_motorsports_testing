clc
close all
clear all
baseData = readtable('brake_testing.xlsx', 'Range', 'A7:B6851');
baseMatrix = str2double(table2array(baseData));
hold on;
subplot(2, 1, 1);
scatter(baseMatrix(:, 1), baseMatrix(:, 2));
subplot(2, 1, 2);
plot(baseMatrix(:, 1), gradient(baseMatrix(:, 2) ./ baseMatrix(:, 1)));
% lsline
figure;