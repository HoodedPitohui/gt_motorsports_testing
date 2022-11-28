clc;
clear all;
close all;

%% Read in the excel files
file_path = 'composite_tube_tests/';
file_names = {'comp_tube_2'; 'comp_tube_3'; 'comp_tube_4'; 'comp_tube_5'; ...
    'comp_tube_6'; 'comp_tube_7'; 'comp_tube_8'; 'comp_tube_nb'; 'comp_tube_wb'};

[comp_tube_2.summary_stats, comp_tube_2.part_descript, comp_tube_2.raw_data] = ...
    read_data(file_path, file_names(1));
[comp_tube_3.summary_stats, comp_tube_3.part_descript, comp_tube_3.raw_data] = ...
    read_data(file_path, file_names(2));
[comp_tube_4.summary_stats, comp_tube_4.part_descript, comp_tube_4.raw_data] = ...
    read_data(file_path, file_names(3));
[comp_tube_5.summary_stats, comp_tube_5.part_descript, comp_tube_5.raw_data] = ...
    read_data(file_path, file_names(4));
[comp_tube_6.summary_stats, comp_tube_6.part_descript, comp_tube_6.raw_data] = ...
    read_data(file_path, file_names(5));
[comp_tube_7.summary_stats, comp_tube_7.part_descript, comp_tube_7.raw_data] = ...
    read_data(file_path, file_names(6));
[comp_tube_8.summary_stats, comp_tube_8.part_descript, comp_tube_8.raw_data] = ...
    read_data(file_path, file_names(7));
[comp_tube_nb.summary_stats, comp_tube_nb.part_descript, comp_tube_nb.raw_data] = ...
    read_data(file_path, file_names(8));
[comp_tube_wb.summary_stats, comp_tube_wb.part_descript, comp_tube_wb.raw_data] = ...
    read_data(file_path, file_names(9));




%% Calculate Data Values
%Data Value: MID: 
%Status: Arbitrary, given in excel input
MID = "string";

%Data Value: E1 = longitudinal modulus of elasticity
%Status: Given in excel input
long_elastic_mod = 9;

%Data Value: E2 = lateral modulus of elasticity
%Status: Due to Poisson's ratio (shown below), this is the same as
%longitudinal elastic mod.
lat_elastic_mod = long_elastic_mod

%Data Value: NU12 = Poisson's ratio
%Status: Due to a warp-weft ratio of 45-45-90, this is equal to 1
poisson = 1;

%DataValue: G12 = inplane shear modulus

function [summary_stats, part_descript, raw_data] = read_data(file_path, file_name)
    file_path_total = strcat(file_path, file_name);
    summary_stats = readtable(cell2mat(file_path_total), 'Range', 'A1:B9', ...
        'ReadRowNames', true);
    part_descript = readtable(cell2mat(file_path_total), 'Range', 'A11:B17', ...
        'ReadRowNames', true);
    raw_data = readtable(cell2mat(file_path_total), 'Range', 'A19:F5000');
end
