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
redCols = floor(redCoords / imRows);
redRows = rem(redCoords, imRows);
figure;
hold on;
redRows2 = -1 .* redRows;
for i = 1: length(redRows2)
    scatter(redCols(i), redRows2(i))
end

%set up the looping
[rowLen, colLen] = size(redPoints);
i = -imRows;
j = 1;
checkVals = zeros(rowLen, colLen);
numSpots = 1;
pointClusters = [];

%Goal: find clusters of x and y points that have red, and store them as
%pages in a 3D array
%general strategy: check points to the left and top of a given element
nRedSpotsPerCluster = [];
redMat = [redRows2 redCols];

while (i < 0)
    while (j <= imCols)
        pair = [i j];
        if (findPairMatrix(pair, redMat) == 1)
            if (i == -imRows)
                if (j == 1)
                    [nRedSpotsPerCluster, pointClusters, redMat, numSpots] = ...
                        addNewCluster(nRedSpotsPerCluster, pointClusters, ...
                        redMat, numSpots, i, j);
                    
                elseif (findPairMatrix([i, j - 1], redMat) == 1)
                    [nRedSpotsPerCluster, pointClusters, redMat] = ...
                        addLeftPoint(nRedSpotsPerCluster, pointClusters, ...
                        redMat, i, j);
                else
                    [nRedSpotsPerCluster, pointClusters, redMat, numSpots] = ...
                        addNewCluster(nRedSpotsPerCluster, pointClusters, ...
                        redMat, numSpots, i, j);
                end
            else
                if (j == 1)
                    if (findPairMatrix([i - 1, j], redMat) == 1)
                        [nRedSpotsPerCluster, pointClusters, redMat] = ...
                            addBelowPoint(nRedSpotsPerCluster, pointClusters, ...
                            redMat, i, j);
                    else
                        [nRedSpotsPerCluster, pointClusters, redMat, numSpots] = ...
                            addNewCluster(nRedSpotsPerCluster, pointClusters, ...
                            redMat, numSpots, i, j);
                    end
                else
                    if (findPairMatrix([i - 1, j], redMat) == 1)
                        [nRedSpotsPerCluster, pointClusters, redMat] = ...
                            addBelowPoint(nRedSpotsPerCluster, pointClusters, ...
                            redMat, i, j);
                    elseif (findPairMatrix([i, j - 1], redMat) == 1)
                        [nRedSpotsPerCluster, pointClusters, redMat] = ...
                            addLeftPoint(nRedSpotsPerCluster, pointClusters, ...
                            redMat, i, j);
                    else
                        [nRedSpotsPerCluster, pointClusters, redMat, numSpots] = ...
                            addNewCluster(nRedSpotsPerCluster, pointClusters, ...
                            redMat, numSpots, i, j);
                    end
                end    
            end
        end
    end
    j = 1;
    i = i + 1;
end

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
        scatter(pointClusters(j, 2, i), pointClusters(j, 1, i), sz, 'filled');
    end
end

function [index] = findPairIndex(pair, givenMatrix)
    i = 1;
    isMatch = 0;
    while (i <= size(givenMatrix, 1) && isMatch == 0)
        if (pair(1) == givenMatrix(i, 1))
            if (pair(2) == givenMatrix(i, 2))
                isMatch = 1;
            else
                i = i + 1;
            end
        else
            i = i + 1;
        end
    end
    index = i;
end
function [isMatch] = findPairMatrix(pair, givenMatrix)
    i = 1;
    isMatch = 0;
    while (i <= size(givenMatrix, 1) && isMatch == 0)
        if (pair(1) == givenMatrix(i, 1))
            if (pair(2) == givenMatrix(i, 2))
                isMatch = 1;
            end
        end
        i = i + 1;
    end
end

%functions to streamline the adding of points to respective arrays
function [nRedSpotsPerCluster, pointClusters, redMat] = ...
    addLeftPoint(nRedSpotsPerCluster, pointClusters, redMat, i, j)

    temp = redMat(findPairIndex([i, j - 1]), 3);
    nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
    index = findPairIndex([i, j], redMat);
    redMat(index, 3) = temp;
    pointClusters(nRedSpotsPerCluster(temp), :, temp) = [i j];
end

function [nRedSpotsPerCluster, pointClusters, redMat] = ...
    addBelowPoint(nRedSpotsPerCluster, pointClusters, redMat, i, j)

    temp = redMat(findPairIndex([i - 1, j]), 3);
    nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
    index = findPairIndex([i, j], redMat);
    redMat(index, 3) = temp;
    pointClusters(nRedSpotsPerCluster(temp), :, temp) = [i j];
end


function [nRedSpotsPerCluster, pointClusters, redMat, numSpots] = ...
    addNewCluster(nRedSpotsPerCluster, pointClusters, redMat, numSpots, i, j)
    
    nRedSpotsPerCluster(length(nRedSpotsPerCluster) + 1) = 1;
    pointClusters(1, :, numSpots) = [i, j];
    index = findPairIndex([i, j], redMat);
    redMat(index, 3) = numSpots;
    numSpots = numSpots + 1;
end
  
