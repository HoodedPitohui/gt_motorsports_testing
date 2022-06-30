clc;
clear all;
close all;

%load the image and find its red point indices
im = imread('testMap.jpg');
imshow(im)
redPoints = im(:,:,1)>=130 & im(:,:,2)<=60 & im(:,:,3)<=100;
redCoords = find(redPoints == 1)
redRows = floor(redCoords / size(redPoints, 1))
redCols = rem(redCoords, size(redPoints, 2))

%set up the looping
[rowLen, colLen] = size(redPoints);
i = 1;
j = 1;
checkVals = zeros(rowLen, colLen);

%Goal: find clusters of x and y points that have red, and store them as
%pages in a 3D array
while i <= rowLen
    while j <= colLen
        if (redPoints(i, j) == 1)
    end
end

% [centers, radii, metric] = imfindcircles(im,[5 14]);
% centersStrong5 = centers(1:10,:); 
% radiiStrong5 = radii(1:10);
% metricStrong5 = metric(1:10);
% viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');
