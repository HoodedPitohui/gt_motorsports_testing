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

comp_tube_nb.summary_stats = renamevars(comp_tube_nb.summary_stats, ...
    ["x1NB"], ["Var1"]);
comp_tube_wb.summary_stats = renamevars(comp_tube_wb.summary_stats, ...
    ["x1WB"], ["Var1"]);


 %% Calculate Data Values

comp_tube_2.property_table = find_material_props(comp_tube_2, file_names(1));
comp_tube_3.property_table = find_material_props(comp_tube_3, file_names(2));
comp_tube_4.property_table = find_material_props(comp_tube_4, file_names(3));
comp_tube_5.property_table = find_material_props(comp_tube_5, file_names(4));
comp_tube_6.property_table = find_material_props(comp_tube_6, file_names(5));
comp_tube_7.property_table = find_material_props(comp_tube_7, file_names(6));
comp_tube_8.property_table = find_material_props(comp_tube_8, file_names(7));
comp_tube_nb.property_table = find_material_props(comp_tube_nb, file_names(8));
comp_tube_wb.property_table = find_material_props(comp_tube_wb, file_names(9));

test = 0;


%% Functions
function [property_table] = find_material_props(tube_struct, tube_name)
    %Data Value: MID: 
    MID = tube_name;

    %Data Value: E1 = longitudinal modulus of elasticity
    %Status: Given in excel input
    E1 = tube_struct.summary_stats.Var1("Modulus (Automatic Young's)");

    %Data Value: E2 = lateral modulus of elasticity
    E2 = E1;

    %Data Value: NU12 = Poisson's ratio
    NU12 = 1;
    
    %Data Value: G12 = Inplane Shear Modulus
    G12 = 0;
    
    %Data Value: G1Z = Transverse Shear Modulus for Shear in 1-Z Plane
    G1Z = 0;
    
    %Data Value: G2Z = Transverse Shear Modulus for Shear in 2-Z Plane
    G2Z = 0;
    
    %Data Value: RHO = Mass Density
    RHO = 0;
    
    %Data Value: A1 = Thermal expansion coefficient in 1-direction
    A1 = "[Leave Blank]";
    
    %Data Value: A2 = Thermal expansion coefficient in 2-direction
    A2 = "[Leave Blank]";
    
    %Data Value: TREF = Reference temperature for the calculation of
    %thermal loads
    TREF = "[Leave Blank]";
    
    %Data Value: Xt, Xc, Yt, Yc: Allowable stresses or strains in the
    %longitudinal and lateral directions
    XtXcYtYc = [0, 0, 0, 0];
    
    %Data Value: S = Allowable for in-plane shear stresses or strains for
    %composite ply failure calculations
    S = 0;
    
    %Data Value: GE = Structural Element Damping Coefficient
    GE = "[Leave Blank]";
    
    %Data Value: F12 = Tsai-Wu interaction term for composite failure
    F12 = 0.0;
    
    %Data Value: indicates whether Xt, Xc, Yt, Yc, and S are stress or
    %strain allowables
    STRN = "[Leave Blank]"; %we're using stress allowables
    property_table = table(MID, E1, E2, NU12, G12, G1Z, G2Z, RHO, A1, A2,...
        TREF, XtXcYtYc, S, GE, F12, STRN);
    
    
end

function [summary_stats, part_descript, raw_data] = read_data(file_path, file_name)
    file_path_total = strcat(file_path, file_name);
    summary_stats = readtable(cell2mat(file_path_total), 'Range', 'A1:B9', ...
        'ReadRowNames', true);
    part_descript = readtable(cell2mat(file_path_total), 'Range', 'A11:B17', ...
        'ReadRowNames', true);
    raw_data = readtable(cell2mat(file_path_total), 'Range', 'A19:F5000');
end
