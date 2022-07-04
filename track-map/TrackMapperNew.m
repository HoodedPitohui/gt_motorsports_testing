clc;
clear all;
close all;

%% Load the image and find its red point indices, identify basic characteristics
im = imread('testMap.jpg');
imshow(im)
redPoints = im(:,:,1)>=130 & im(:,:,2)<=60 & im(:,:,3)<=100; %rgbs for red
redCoords = find(redPoints == 1);
imRows = size(redPoints, 1);
imCols = size(redPoints, 2);

%find the red x-coordinates, this gets weird, as I found it easy to handle
%if I flipped the x- and y- coordinates, and then reversed the flip later
redX = floor(redCoords / imRows);
redY = rem(redCoords, imRows);

%uncomment the below code for troubleshooting, it prints a verifiable map of
%all the red points
% figure;
% hold on;
% redY2 = -1 .* redY;
% for i = 1: length(redX)
%     scatter(redX(i), redY2(i))
% end

%I found it easier to set up the whole sorting and point finding if I
%enabled for the red points to be mapped as they would in a matrix, as
%opposed to an image
nRedSpotsPerCluster = [];
redMat = zeros(imRows, imCols);
for i = 1: length(redY)
    redMat(redY(i), redX(i)) = 1;
end

%% Setting up the loop

%The objective of the following code is to find the clusters of red and
%store it in a matrix, this will enable for it to be possible to find the
%centers of groups of red points. 
%The default red circle finder in MATLAB was tested earlier, and doesn't
%work, as the points are too small.
i = imRows;
numSpots = 1;
pointClusters = [];

%The below matrix will eventually fill every red point with an integer
%value, indicating the cluster the point belongs to
checkVals = zeros(imRows, imCols);

%The following code basically starts at the top left of an image, and then
%finds clusters by checking every point to the left and top of it
while i > 0
    for j = 1: imCols
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
    end
    i = i - 1;
end

%Converts the points into a way that is correctly displayed. This will be
%how we will handle the points to find centers and latitude/longitude coordinates
pointClusters2 = pointClusters;
pointClusters2(:, 1, :) = -1 .* pointClusters2(:, 1, :);
pointClSize = size(pointClusters);

%Another progress-checking graph, feel free to comment out/leave in as
%needed
figure;
hold on;
pointsPlotted = 0;
j = 1;
for i = 1: pointClSize(3)
    while (j <= pointClSize(1) && pointClusters(j, 2, i) ~= 0)
        scatter(pointClusters2(j, 2, i), pointClusters2(j, 1, i));
        j = j + 1;
        pointsPlotted = pointsPlotted + 1;
    end
    j = 1;
end

%find the distance matrix of the red clusters
for i = 1: length(centers)
    numNonZero = sum(pointClusters(:, :, i) ~= 0);
    dists{i} = zeros(numNonZero(1), numNonZero(1));
    dists{i} = calculateDistMatrix(pointClusters(1: numNonZero, :, i), ...
        dists{i});
end

centers = zeros(pointClSize(3), 2);


%functions for manipulating point clusters
%add to cluster in above point
function [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
    addToClusterTop(checkVals, nRedSpotsPerCluster, pointClusters, i, j)
    temp = checkVals(i + 1, j);
    checkVals(i, j) = temp;
    nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
    pointClusters(nRedSpotsPerCluster(temp), :, temp) = [i, j];
end

%add to cluster in left point
function [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
    addToClusterLeft(checkVals, nRedSpotsPerCluster, pointClusters, i, j)
    temp = checkVals(i, j - 1);
    checkVals(i, j) = temp;
    nRedSpotsPerCluster(temp) = nRedSpotsPerCluster(temp) + 1;
    pointClusters(nRedSpotsPerCluster(temp), :, temp) = [i, j];
end

%create new cluster
function [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
    addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j)
    checkVals(i, j) = numSpots;
    nRedSpotsPerCluster(length(nRedSpotsPerCluster) + 1) = 1;
    pointClusters(1, :, numSpots) = [i, j];
    numSpots = numSpots + 1;
end

%distance matrix functions
function [distMatrix] = calculateDistMatrix(pointMatrix, distMatrix)
    for i = 1: length(distMatrix)
        j = length(distMatrix);
        while (j > i)
            distMatrix(i, j) = calculateDists(pointMatrix(i, :), pointMatrix(j, :));
            distMatrix(j, i) = distMatrix(i, j);
            j = j - 1;
        end
    end
end
function [dist] = calculateDists(point1, point2)
    dist = sqrt((point2(2) - point1(2))^2 + (point2(1) - point1(1))^2);
end