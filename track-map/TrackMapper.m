%Plot points on a map and then retrieve latitude and longitude coordinates
clc;
clear all;

%Pick two reference points
Building1.lat = 33.77716;
Building1.lon = -84.40050;
Building1.label = "MRDC Building (GT)";
Building2.lat = 33.77758;
Building2.lon = -84.39889;
Building2.label = "Howey Physics Building (GT)";
Limits.lat = [33.776667 33.777639];
Limits.lon = [-84.400556 -84.398889];

%Plot the original two base points
MapPlot = figure;
plotOrigPoints(Building1, Building2, Limits)
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
            delete(plots{k});
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

filename = 'sample.xlsx';
writematrix(coneLatCoords, filename, 'Sheet', 1, 'Range', 'A1');
writematrix(coneLonCoords, filename, 'Sheet', 1, 'Range', 'A2');

%Plot user inputted points
function [coneLatCoords, coneLonCoords, outPlot] = plotUserPoint(pointCounter, coneLatCoords, coneLonCoords)
    [lat, lon] = ginput(1);
    outPlot = geoplot(lat, lon, "om", MarkerFaceColor = "m", MarkerSize = 2);
    coneLatCoords(pointCounter) = lat;
    coneLonCoords(pointCounter) = lon;
end

%Plot base points
function plotOrigPoints(Building1, Building2, Limits)   
    geoplot(Building1.lat, Building1.lon, '*');
    hold on;
    geoplot(Building1.lat, Building1.lon, "om", MarkerFaceColor = "m", MarkerSize = 2);
    geoplot(Building2.lat, Building2.lon, "om", MarkerFaceColor = "m", MarkerSize = 2);
    geolimits(Limits.lat,Limits.lon)
    geobasemap streets
    text(Building1.lat, Building1.lon, Building1.label);
    text(Building2.lat, Building2.lon, Building2.label);
end

function [dist] = distance(latCoordList, lonCoordList, givenLatCoord, givenLonCoord)
    dist = [sqrt((latCoordList - givenLatCoord).^2 + (lonCoordList - givenLonCoord).^2)];
end
%Club: Georgia Tech Motorsports (GTMS)
%Creator: Karthik Shaji
%Year Created: 2022
