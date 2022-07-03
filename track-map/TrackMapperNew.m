clc;
clear all;
close all;

%load the image and find its red point indices
im = imread('testMap.jpg');
imshow(im)
redPoints = im(:,:,1)>=130 & im(:,:,2)<=60 & im(:,:,3)<=100;
redCoords = find(redPoints == 1);


imRows = size(redPoints, 1);
imCols = size(redPoints, 2);
redX = floor(redCoords / imRows);
redY = rem(redCoords, imRows);
figure;
hold on;
redY2 = -1 .* redY;
for i = 1: length(redX)
    scatter(redX(i), redY2(i))
end

%set up the looping
[rowLen, colLen] = size(redPoints);

%Goal: find clusters of x and y points that have red, and store them as
%pages in a 3D array
%general strategy: check points to the left and top of a given element
nRedSpotsPerCluster = [];
redMat = zeros(rowLen, colLen);

for i = 1: length(redY)
    redMat(redY(i), redX(i)) = 1;
end


i = imRows;
j = 1;
checkVals = zeros(rowLen, colLen);
numSpots = 1;
pointClusters = [];

while i > 0
    while j <= colLen
        %check if a point is red
        if (redMat(i, j) == 1)
            %check if it's the first row
            if (i == imRows)
                %check if it's the first column
                if (j == 1)
                    [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                        addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                elseif (redMat(i, j - 1) == 1)
                    [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                        addToClusterLeft(checkVals, nRedSpotsPerCluster, pointClusters, i, j);
                else
                    [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                        addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                end
            else
                if (j == 1)
                    if (redMat(i + 1, j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j);    
                    else
                        [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                            addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                    end
                else
                    if (redMat(i + 1, j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j);                        
                    elseif (redMat(i, j - 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToClusterLeft(checkVals, nRedSpotsPerCluster, pointClusters, i, j);
                    else
                        [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                            addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                    end
                end
            end
        end
        j = j + 1;
    end
    j = 1;
    i = i - 1;
end

pointClusters(:, 1, :) = -1 .* pointClusters(:, 1, :);
pointClSize = size(pointClusters);

figure;
hold on;
pointsPlotted = 0;
for i = 1: pointClSize(3)
    while (j <= pointClSize(1) && pointClusters(j, 2, i) ~= 0)
        scatter(pointClusters(j, 2, i), pointClusters(j, 1, i));
        j = j + 1;
        pointsPlotted = pointsPlotted + 1;
    end
    j = 1;
end


%functions to streamline the adding of points to respective arrays
function [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
    addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j)
    temp = checkVals(i + 1, j);
    checkVals(i, j) = temp;
    nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
    pointClusters(nRedSpotsPerCluster(temp), :, temp) = [i, j];
end

function [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
    addToClusterLeft(checkVals, nRedSpotsPerCluster, pointClusters, i, j)
    temp = checkVals(i, j - 1);
    checkVals(i, j) = temp;
    nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
    pointClusters(nRedSpotsPerCluster(temp), :, temp) = [i, j];
end


function [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
    addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j)
    checkVals(i, j) = numSpots;
    nRedSpotsPerCluster(length(nRedSpotsPerCluster) + 1) = 1;
    pointClusters(1, :, numSpots) = [i, j];
    numSpots = numSpots + 1;
end
