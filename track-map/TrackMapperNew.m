clc;
clear all;
close all;

%% Load the image and find its red point indices, identify basic characteristics
outputFileName = 'ConePositions.xlsx';
im = imread('testMap1.jpg');
imshow(im)
redPoints = (im(:,:,1)>=130 & im(:,:,2)<=60 & im(:,:,3)<=100) | ...
    (im(:, :, 1) == 255 & im(:, :, 2) == 250 & im(:, :, 3) == 250) | ...
    (im(:, :, 1) == 244 & im(:, :, 2) == 194 & im(:, :, 3) == 194) | ...
    (im(:, :, 1) == 255 & im(:, :, 2) == 105 & im(:, :, 3) == 97) | ...
    (im(:, :, 1) == 255 & im(:, :, 2) == 92 & im(:, :, 3) == 92) | ...
    (im(:, :, 1) == 205 & im(:, :, 2) == 92 & im(:, :, 3) == 92) | ...
    (im(:, :, 1) == 227 & im(:, :, 2) == 66 & im(:, :, 3) == 52) | ...
    (im(:, :, 1) == 128 & im(:, :, 2) == 0 & im(:, :, 3) == 0) | ...
    (im(:, :, 1) == 112 & im(:, :, 2) == 28 & im(:, :, 3) == 28) | ...
    (im(:, :, 1) == 60 & im(:, :, 2) == 20 & im(:, :, 3) == 20) | ...
    (im(:, :, 1) == 50 & im(:, :, 2) == 20 & im(:, :, 3) == 20); %rgbs for red
%http://www.workwithcolor.com/red-color-hue-range-01.htm
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
%figure
% imshow(im)
% hold on;
% pointsPlotted = 0;
% for i = 1: pointClSize(3)
%     while (j <= pointClSize(1) && pointClusters(j, 2, i) ~= 0)
%         scatter(pointClusters2(j, 2, i), pointClusters(j, 1, i), 'filled');
%         j = j + 1;
%         pointsPlotted = pointsPlotted + 1;
%     end
%     j = 1;
% end
% title("Found Red Points Plotted Over Image Red Points (Verification");

%% Finding the center point
%find the distance matrix of the red clusters
centers = {};
for i = 1: pointClSize(3)
    numNonZero = sum(pointClusters2(:, :, i) ~= 0);
    centers{i} = calcCenterPoint(pointClusters2(1: numNonZero, :, i), numNonZero);
end

%figure;
imshow(im);
hold on;
for i = 1: pointClSize(3)
    point = centers{i};
    scatter(point(2), point(1) * (-1), 'filled');
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
combinedMat = [cell2mat(centerLats'), cell2mat(centerLongs')];

%% Group the data into how many the user wants and output
numGroups = input("Please enter how many groups of data you want: ");
numPerGroup = floor(length(centerLats) / numGroups);
numRem = rem(length(centerLats), numGroups);
groupedPoints = sortrows(combinedMat, 1);
groupedVals = {};
pointCounter = 1;
for i = 1: numGroups
    if (i <= numRem)
        tempMat = [];
        for j = 1: numPerGroup + 1
            tempMat(j, :) = groupedPoints(pointCounter, :);
            pointCounter = pointCounter + 1;
        end
        groupedVals{i} = tempMat;
    else
        tempMat = [];
        for j = 1: numPerGroup
            tempMat(j, :) = groupedPoints(pointCounter, :);
            pointCounter = pointCounter + 1;
        end
        groupedVals{i} = tempMat;
    end
end
delete(outputFileName);
%writecell(groupedVals, outputFileName, 'Sheet', 1);
for i = 1: numGroups
    coords1 = cell2mat(groupedVals(1));
    writematrix(coords1, outputFileName, 'Sheet', i);
end

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
function [centerPoint] = calcCenterPoint(pointMatrix, numRows)
    if (numRows <= 2)
        centerPoint = pointMatrix(1, :);
    else
        minY = min(pointMatrix(:, 1));
        maxY = max(pointMatrix(:, 1));
        minX = min(pointMatrix(:, 2));
        maxX = max(pointMatrix(:, 2));
        centerPoint = [(maxY + minY) / 2, (maxX + minX) / 2];
    end
end
