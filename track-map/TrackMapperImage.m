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
redRows = floor(redCoords / imRows);
redCols = rem(redCoords, imRows);
figure;
hold on;
redCols = -1 .* redCols;
for i = 1: length(redRows)
    scatter(redRows(i), redCols(i))
end

%set up the looping
[rowLen, colLen] = size(redPoints);
i = 1;
j = 1;
checkVals = zeros(rowLen, colLen);
numSpots = 1;
pointClusters = [];
%Goal: find clusters of x and y points that have red, and store them as
%pages in a 3D array
%general strategy: check points to the left and top of a given element
nRedSpotsPerCluster = [];
while i <= rowLen
    while j <= colLen
        %check if a point is red
        if (redPoints((i - 1) * imCols + j) == 1)
            %check if it's the first row
            if (i == 1)
                %check if it's the first column
                if (j == 1)
                    [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                        addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                elseif (redPoints((i - 1) * imCols + j - 1) == 1)
                    [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                        addToClusterLeft(checkVals, nRedSpotsPerCluster, pointClusters, i, j);
                else
                    [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                        addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                end
            else
                if (j == 1)
                    if (redPoints((i - 2) * imCols + j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j);    
                    else
                        [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                            addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                    end
                else
                    if (redPoints((i - 2) * imCols + j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j);                        
                    elseif (redPoints((i - 1) * imCols + j - 1) == 1)
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
    i = i + 1;
end


%Normalize the points so they are how they actually will be represented on
%an image, per: https://www.mathworks.com/matlabcentral/answers/269694-how-to-plot-some-points-on-an-image
%This means that we essentially have to subtract all of our y-coordinates
%by 912, and then take the absolute value of that

for i = 1: length(nRedSpotsPerCluster')
    for j = 1: length(pointClusters(:, 1, i))
        pointClusters(j, 2, i) = abs(pointClusters(j, 2, i) - imRows); %should be an abs but the graph won't plot like that
    end
end

%create new graph
figure;
hold on;
sz = 2;
xlim([0 imCols]);
ylim([0 imRows]);
for i = 1: length(nRedSpotsPerCluster')
    for j = 1: length(pointClusters(:, 1, i))
        scatter(pointClusters(j, 1, i), pointClusters(j, 2, i), sz, 'filled');
    end
end

%functions to streamline the adding of points to respective arrays
function [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
    addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j)
    temp = checkVals(i - 1, j);
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
