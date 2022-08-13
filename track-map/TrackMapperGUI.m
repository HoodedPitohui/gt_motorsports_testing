function [] = TrackMapperGUI()
% Demonstrate how to use a pushbutton to delete bits of string and how to 
% let the user know that their actions are futile.  After the string is 
% deleted completely, the user is informed that there is nothing left to 
% delete if the delete button is pressed again.  A color change accompanies
% this announcement.
%
% Suggested exercise:  Add a counter to S that starts incrementing when the  
% warning is given.  If the user clicks again, close the GUI.
%
%
% Author:  Matt Fig
% Date:  7/15/2009
clc;
clear all;
close all;
screenSize = get(groot, 'ScreenSize');
buttonSize = [260 80];

S.fh = figure('units','pixels',...
              'menubar','none',...
              'name','Track Mapper',...
              'numbertitle','off', 'WindowState', 'maximized');
S.pb = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[screenSize(3) / 2 - buttonSize(1) / 2, 20, 260, 80],...
                 'string','Upload Image');
set(S.pb,'callback',{@pb_call,S})  % Set the callback for pushbutton.
function [] = mapTrack(im)
    
function [] = pb_call(varargin)
    subplot(2, 1, 1);
    [File_Name, Path_Name] = uigetfile('D:\Users\Public\Pictures\Sample Pictures');
    imshow([Path_Name,File_Name]);
    
