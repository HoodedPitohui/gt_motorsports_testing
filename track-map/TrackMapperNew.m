clc;
clear all;
close all;

%% Load the image and find its red point indices, identify basic characteristics
im = imread('test45.4.jpg');
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
                        addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left1');
                else
                    [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                        addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                end
            else
                if (j == 1)
                    if (redMat(i + 1, j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'top1');
                    elseif (redMat(i + 1, j + 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'right1top1');
                    elseif (i + 1 < imRows && redMat(i + 2, j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'top2');
                    elseif (i + 1 < imRows && redMat(i + 2, j + 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'right1top2');
                    elseif (i + 1 < imRows && redMat(i + 2, j + 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'right2top2'); 
                    elseif (redMat(i + 1, j + 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, ' '); 
                    else
                        [checkVals, nRedSpotsPerCluster, pointClusters, numSpots] = ...
                            addCluster(checkVals, nRedSpotsPerCluster, pointClusters, numSpots, i, j);
                    end
                else
                    if (redMat(i, j - 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left1');
                    elseif (j - 1 > 1 && redMat(i, j - 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left2');
                    elseif (redMat(i + 1, j - 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left1top1');
                    elseif (j - 1 > 1 && redMat(i + 1, j - 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left2top1');
                    elseif (j - 1 > 1 && i + 1 < imRows && redMat(i + 2, j - 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left2top2');
                    elseif (i + 1 < imRows && redMat(i + 2, j - 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'left1top2');
                    elseif (redMat(i + 1, j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'top1');
                    elseif (i + 1 < imRows && redMat(i + 2, j) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'top2');
                    elseif (j < imCols && redMat(i + 1, j + 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'right1top1');
                    elseif (j < imCols && i + 1 < imRows && redMat(i + 2, j + 1) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'right1top2');
                    elseif (j + 1 < imCols && redMat(i + 2, j + 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, 'right2top2');
                    elseif (j + 1 < imCols && redMat(i + 1, j + 2) == 1)
                        [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
                            addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, ' ');
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

%% Post-Processing
%Converts the points into a way that is correctly displayed. This will be
%how we will handle the points to find centers and latitude/longitude coordinates
pointClusters2 = pointClusters;
pointClusters2(:, 1, :) = -1 .* pointClusters2(:, 1, :);
pointClSize = size(pointClusters);

%Another progress-checking graph, feel free to comment out/leave in as
%needed

j = 1;
figure;
hold on;
pointsPlotted = 0;
for i = 1: pointClSize(3)
    while (j <= pointClSize(1) && pointClusters(j, 2, i) ~= 0)
        scatter(pointClusters2(j, 2, i), pointClusters2(j, 1, i));
        j = j + 1;
        pointsPlotted = pointsPlotted + 1;
    end
    j = 1;
end

%% Finding the center point
%find the distance matrix of the red clusters
centers = {};
dists = {};
for i = 1: pointClSize(3)
    numNonZero = sum(pointClusters2(:, :, i) ~= 0);
    dists{i} = zeros(numNonZero(1), numNonZero(1));
    dists{i} = calculateDistMatrix(pointClusters2(1: numNonZero, :, i), ...
        dists{i});
    centers{i} = calcCenterPoint(pointClusters2(1: numNonZero, :, i), ...
        dists{i}, numNonZero);
end

figure;
hold on;
for i = 1: pointClSize(3)
    point = centers{i};
    scatter(point(2), point(1));
end

%% Use these for latitude/longitude calculations
botLat = 33.777083;
topLat = 33.778333;
leftLong = -84.400556;
rightLong = -84.39944;

diffLat = topLat - botLat;
diffLong = rightLong - leftLong;
centerLats = {};
centerLongs = {};
for i = 1: length(centers)
    centerLats{i} = centers{i}(2) / imCols * diffLat + botLat;
    centerLongs{i} = abs(centers{i}(1)) / imRows * diffLong + leftLong;
end
filename = 'ConePositions.xlsx';
combinedMat = [cell2mat(centerLats); cell2mat(centerLongs)];
writematrix(combinedMat, filename, 'Sheet', 1);
%% Supplementary functions
%add to cluster in above point
function [temp] = getTempVal(keyWord, checkVals, i, j)
    if (strcmp(keyWord, 'left1'))
        temp = checkVals(i, j - 1);
    elseif (strcmp(keyWord, 'left2'))
        temp = checkVals(i, j - 2);
    elseif (strcmp(keyWord, 'left1top1'))
        temp = checkVals(i + 1, j - 1);
    elseif (strcmp(keyWord, 'left2top1'))
        temp = checkVals(i + 1, j - 2);
    elseif (strcmp(keyWord, 'left2top2'))
        temp = checkVals(i + 2, j - 2);
    elseif (strcmp(keyWord, 'left1top2'))
        temp = checkVals(i + 2, j - 1);
    elseif (strcmp(keyWord, 'top1'))
        temp = checkVals(i + 1, j);
    elseif (strcmp(keyWord, 'top2'))
        temp = checkVals(i + 2, j);
    elseif (strcmp(keyWord, 'right1top1'))
        temp = checkVals(i + 1, j + 1);
    elseif (strcmp(keyWord, 'right1top2'))
        temp = checkVals(i + 2, j + 1);
    elseif (strcmp(keyWord, 'right2top2'))
        temp = checkVals(i + 2, j + 2);
    else %right 2 top 1
        temp = checkVals(i + 1, j + 2);
    end
end
function [temp, checkVals, nRedSpotsPerCluster, pointClusters] = ...
    addToCluster(checkVals, nRedSpotsPerCluster, pointClusters, i, j, keyWord)
    temp = getTempVal(keyWord, checkVals, i, j);
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

%find centerpoint function
function [centerPoint] = calcCenterPoint(pointMatrix, distMatrix, numRows)
    if (numRows <= 2)
        centerPoint = pointMatrix(1, :);
    else
        meanDists = (mean(distMatrix))';
        centerPoint = pointMatrix(find(min(meanDists)), :);
    end
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