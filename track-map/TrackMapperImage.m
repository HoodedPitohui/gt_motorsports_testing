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


%set up the looping
[rowLen, colLen] = size(redPoints);
i = 1;
j = 1;
checkVals = zeros(rowLen, colLen);
numSpots = 1;
pointClusters = {};
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
                    checkVals(i * imCols + j) = numSpots;
                    nRedSpotsPerCluster(length(nRedspotsPerCluster) + 1) = 1;
                    numSpots = numSpots + 1;
                elseif (redPoints((i - 1) * imCols + j - 1) == 1)
                    temp = checkVals(i, j - 1);
                    checkVals(i, j) = temp;
                else
                    checkVals(i, j) = numSpots;
                    nRedSpotsPerCluster(length(nRedspotsPerCluster) + 1) = 1;
                    numSpots = numSpots + 1;
                end
            else
                if (j == 1)
                    if (redPoints((i - 2) * imCols + j) == 1)
                        temp = checkVals(i - 1, j);
                        nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
                        checkVals(i, j) = temp;
                    else
                        checkVals(i, j) = numSpots;
                        nRedSpotsPerCluster(length(nRedSpotsPerCluster) + 1) = 1;
                        numSpots = numSpots + 1;
                    end
                else
                    if (redPoints((i - 2) * imCols + j) == 1)
                        temp = checkVals(i - 1, j);
                        checkVals(i, j) = temp;
                        nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
                    elseif (redPoints((i - 1) * imCols + j - 1) == 1)
                        temp = checkVals(i, j - 1);
                        checkVals(i, j) = temp;
                        nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
                    else
                        checkVals(i, j) = numSpots;
                        nRedSpotsPerCluster(length(nRedSpotsPerCluster) + 1) = 1;
                        numSpots = numSpots + 1;
                    end
                end
            end
        end
        j = j + 1;
    end
    j = 1;
    i = i + 1;
end 


% [centers, radii, metric] = imfindcircles(im,[5 14]);
% centersStrong5 = centers(1:10,:); 
% radiiStrong5 = radii(1:10);
% metricStrong5 = metric(1:10);
% viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');