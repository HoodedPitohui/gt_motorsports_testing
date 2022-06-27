clc;
clear all;
close all;

im = imread('testMap.jpg');
imshow(im)
redPoints = im(:,:,1)>=130 & im(:,:,2)<=60 & im(:,:,3)<=100;
redCoords = find(redPoints == 1)
redRows = floor(redCoords / size(redPoints, 1))
redCols = rem(redCoords, size(redPoints, 2))

% [centers, radii, metric] = imfindcircles(im,[5 14]);
% centersStrong5 = centers(1:10,:); 
% radiiStrong5 = radii(1:10);
% metricStrong5 = metric(1:10);
% viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');
