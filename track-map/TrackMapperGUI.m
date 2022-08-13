function TrackMapperGUI
clc;
clear all;
close all;
screenSize = get(groot, 'ScreenSize');
buttonSize = [260 80];
fillSize = [130 40];
button1Pos = [screenSize(3) / 4 - buttonSize(1) / 4, 20, buttonSize(1), buttonSize(2)];

figInterface = uifigure('WindowState', 'maximized');
figAxes = uiaxes(figInterface);
uplImg = uibutton(figInterface, 'Text', 'Upload Image', 'Position', button1Pos, ...
                   'ButtonPushedFcn', @(btn, event) uplButtonPushed(btn, figAxes));
end

function uplButtonPushed(btn, uiFigAxes)
    [File_Name, Path_Name] = uigetfile('D:\Users\Public\Pictures\Sample Pictures');
    imshow([Path_Name,File_Name], "Parent", uiFigAxes);
end
