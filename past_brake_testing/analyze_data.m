clc
close all
clear all
baseData = readtable('brake_testing.xlsx', 'Range', 'A7:B6851');
baseMatrix = str2double(table2array(baseData));
scatter(baseMatrix(:, 1), baseMatrix(:, 2));
lsline