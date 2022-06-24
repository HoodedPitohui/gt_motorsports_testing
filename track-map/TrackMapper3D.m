%Plot points on a map and then retrieve latitude and longitude coordinates
%Mapping Toolbox Needed
clc;
clear all;
close all;

%Pick two reference points

%Building 1 to the left, Building 2 to the right
Building1.lat = [33.77716 33.77758];
Building1.lon = [-84.40050 -84.39889];
Building1.label = "MRDC Building (GT)";
Building2.lat = 30;
Building2.lon = 40;
Building2.label = "Howey Physics Building (GT)";
Limits.lat = [33.777167 33.778189]; %6
Limits.lon = [Building1.lon Building2.lon];

%Plot the original two base points
MapPlot = uifigure;
plotOrigPoints(Building1, Building2, Limits, MapPlot);
coneLatCoords = [];
coneLonCoords = [];
pointCounter = 0;

%wait for user button press, store character
w = waitforbuttonpress;
value = char(get(gcf, 'CurrentCharacter'));

%check if initial value is c, b, or d
if (value ~= 'c' | value ~= 'b' | value ~= 'd')  
    pointCounter = pointCounter + 1;
    [coneLatCoords, coneLonCoords, plots{pointCounter}] = plotUserPoint(pointCounter, coneLatCoords, coneLonCoords);
    
    w = waitforbuttonpress;
    value = char(get(gcf, 'CurrentCharacter'));
    
    while (value ~= 'd') %d aborts
        if (value == 'r') %remove point
            %have user pick a point on graph to remove and find cone closest
            [lat, lon] = ginput(1);
            d = distance(coneLatCoords, coneLonCoords, lat, lon);
            k = find(d == min(d(:)), 1);
            
            %remove datapoints associated with the removed point
            delete(plots{k});
            plots(k) = [];
            coneLatCoords(k) = [];
            coneLonCoords(k) = [];
            pointCounter = pointCounter - 1;
        else
            pointCounter = pointCounter + 1;
            [coneLatCoords, coneLonCoords, plots{pointCounter}] = plotUserPoint(pointCounter, coneLatCoords, coneLonCoords);
        end
        w = waitforbuttonpress;
        value = char(get(gcf, 'CurrentCharacter'));
    end
else
    disp("Please type in c to continue, b to remove the previous point, and d to be done");
end

%Graph to excel
filename = 'sample.xlsx';

header = ["latitude", "longitude"];
writematrix(header, filename, 'Sheet', 1, 'Range', 'A1');
writematrix(coneLatCoords', filename, 'Sheet', 1, 'Range', 'A2');
writematrix(coneLonCoords', filename, 'Sheet', 1, 'Range', 'B2');

%Plot user inputted points
function [coneLatCoords, coneLonCoords, outPlot] = plotUserPoint(pointCounter, coneLatCoords, coneLonCoords)
    [lat, lon] = ginput(1);
    outPlot = geoplot3(lat, lon, "om", MarkerFaceColor = "m", MarkerSize = 2);
    coneLatCoords(pointCounter) = lat;
    coneLonCoords(pointCounter) = lon;
end

%Plot base points
function plotOrigPoints(Building1, Building2, Limits, uif)  
    g = geoglobe(uif);
    hTerrain = [10 0];
    geoplot3(g, Building1.lat, Building1.lon, hTerrain,'y','HeightReference','terrain', ...
    'LineWidth',3);
    
%     geoplot3(g, Building2.lat, Building2.lon, 100, 'co');
    [Limits.lat, Limits.lon] = geolimits(g, Limits.lat,Limits.lon)
    geobasemap satellite
    text(Building1.lat, Building1.lon, Building1.label);
    text(Building2.lat, Building2.lon, Building2.label);
end

function [dist] = distance(latCoordList, lonCoordList, givenLatCoord, givenLonCoord)
    dist = [sqrt((latCoordList - givenLatCoord).^2 + (lonCoordList - givenLonCoord).^2)];
end

%Club: Georgia Tech Motorsports (GTMS)
%Creator: Karthik Shaji
%Year Created: 2022
