function TrackMapperGUI
    %% Set constants and clear the environment
    system('taskkill /F /IM EXCEL.EXE');
    all_fig = findall(0, 'type', 'figure');
    close(all_fig);
    clear all;
    
    %constants -> used later, change as necessary
    botLat = 33.777083;
    topLat = 33.778333;
    leftLong = -84.400556;
    rightLong = -84.39944;
    outputFileName = 'ConePositions2.xlsx';
    
    %% Set up the basic figure
    screenSize = get(groot, 'ScreenSize');
    buttonSize = [125 40];
    panelSize = [screenSize(3) / 3; screenSize(4) / 3];
    mainFig = uifigure('WindowState', 'maximized');
    mainFig.Name = 'Track Mapper';
    
    %% Format panels
    origImgPanel = uipanel(mainFig);
    origImgPanel.Title = 'Original Image';
    origImgPanel.Position = [screenSize(3) / 8, screenSize(4) * 4.5 / 8, panelSize(1), panelSize(2)];
    
    checkImgPanel = uipanel(mainFig);
    checkImgPanel.Title = 'Found Circles';
    checkImgPanel.Position = [screenSize(3) * 7/ 8 - panelSize(1), screenSize(4) * 4.5 / 8, panelSize(1), panelSize(2)];
    
    outputPanel = uipanel(mainFig);
    outputPanel.Title = 'Data Output Preview - Group #1';
    outputPanel.Position = [screenSize(3) / 8, screenSize(4) * 1 / 8, panelSize(1), panelSize(2)];
    
    btnPanel = uipanel(mainFig);
    btnPanel.Title = 'Set Up Environment';
    btnPanel.Position = [screenSize(3) * 7 / 8 - panelSize(1), screenSize(4) * 1 / 8, panelSize(1) * 5 / 4, panelSize(2)];

    %% Set up the Controls Panel
    btnUploadPos = [panelSize(1) / 32, panelSize(2) / 16, buttonSize(1), buttonSize(2)];
    %latitude editing
    latLeftPos = btnUploadPos(1) + buttonSize(1) * (5 / 4);
    buttonFourStackingPos = [btnUploadPos(2), btnUploadPos(2) * 3, btnUploadPos(2) * 5, ...
        btnUploadPos(2) * 7];
    latMinEdit = uieditfield(btnPanel, 'numeric', 'ValueDisplayFormat', '%.8f');
    latMinEdit.Position = [latLeftPos, buttonFourStackingPos(3), buttonSize(1), buttonSize(2)];
    latMaxEdit = uieditfield(btnPanel, 'numeric', 'ValueDisplayFormat', '%.8f');
    latMaxEdit.Position = [latLeftPos, buttonFourStackingPos(1), buttonSize(1), buttonSize(2)];
    latMinLabel = uilabel(btnPanel, 'Text', 'Minimum Latitude', 'Position', ...
        [latLeftPos, buttonFourStackingPos(4), buttonSize(1), buttonSize(2)]);
    latMaxLabel = uilabel(btnPanel, 'Text', 'Maximum Latitude', 'Position', ...
        [latLeftPos, buttonFourStackingPos(2), buttonSize(1), buttonSize(2)]);
    
    %longitude editing
    longLeftPos = btnUploadPos(1) + buttonSize(1) * (10 / 4);
    longMinEdit = uieditfield(btnPanel, 'numeric', 'ValueDisplayFormat', '%.8f');
    longMinEdit.Position = [longLeftPos, buttonFourStackingPos(3), buttonSize(1), buttonSize(2)];
    longMaxEdit = uieditfield(btnPanel, 'numeric', 'ValueDisplayFormat', '%.8f');
    longMaxEdit.Position = [longLeftPos, buttonFourStackingPos(1), buttonSize(1), buttonSize(2)];
    longMinLabel = uilabel(btnPanel, 'Text', 'Minimum Longitude', 'Position', ...
        [longLeftPos, buttonFourStackingPos(4), buttonSize(1), buttonSize(2)]);
    longMaxLabel = uilabel(btnPanel, 'Text', 'Maximum Longitude', 'Position', ...
        [longLeftPos, buttonFourStackingPos(2), buttonSize(1), buttonSize(2)]);
    
    %% Set up operations buttons
    uplImgBtn = uibutton(btnPanel, 'Text', 'Upload Image', 'Position', btnUploadPos, ...
        'ButtonPushedFcn', @(btn, event) uplButtonPushed(btn, origImgPanel));
    btnCalcPos = [longLeftPos + buttonSize(1) * (5/4), panelSize(2) / 16, buttonSize(1), buttonSize(2)];
    
    btnDefLatPos = btnUploadPos;
    btnDefLatPos(2) = panelSize(2) / 1.4;
    defaultLatBtn = uibutton(btnPanel, 'Text', 'Use Default Latitude', 'Position',...
        btnDefLatPos, 'WordWrap', 'On','ButtonPushedFcn', @(btn, event) setDefaultLat(btn, ...
        latMinEdit, latMaxEdit, botLat, topLat));
    
    btnDefLongPos = btnDefLatPos;
    btnDefLongPos(1) = latLeftPos;
    defaultLongBtn = uibutton(btnPanel, 'Text', 'Use Default Longitude', 'Position',...
        btnDefLongPos, 'WordWrap', 'On', 'ButtonPushedFcn', @(btn, event) setDefaultLong(btn, ...
        longMinEdit, longMaxEdit, leftLong, rightLong));
    
    editGroupsLabel = uilabel(btnPanel, 'Text', 'Set Number of Groups', 'Position', ...
    [longLeftPos + buttonSize(1) * (5/4), buttonFourStackingPos(4), buttonSize(1), buttonSize(2)]);
    editGroupsPos = [longLeftPos + buttonSize(1) * (5/4), buttonFourStackingPos(3), buttonSize(1), buttonSize(2)];
    numGroupsField = uieditfield(btnPanel, 'numeric', 'Value', 2, 'Position', editGroupsPos);
    
    calcConesBtn = uibutton(btnPanel, 'Text', 'Calc. Cone Positions', 'Position', btnCalcPos, ...
        'ButtonPushedFcn', @(btn, event) calcButtonPushed(btn, origImgPanel, checkImgPanel, latMinEdit, latMaxEdit,...
        longMinEdit, longMaxEdit, outputFileName, numGroupsField, outputPanel));
end

%% Button Functions
function uplButtonPushed(btn, imgPanel)
    [File_Name, Path_Name] = uigetfile('D:\Users\Public\Pictures\Sample Pictures');
    delete(get(imgPanel,'Children')); %delete previous image uploaded
    im = uiimage(imgPanel);
    im.ImageSource = strcat(Path_Name, File_Name);
    
    %get the image dimensions and use that to size it in the panel
    imSize = size(imread(im.ImageSource));
    
    %scale down to the panel size and adjust appropriately
    scaleFactor = imSize(1: 2) ./ imgPanel.Position(3: 4);
    
    if (scaleFactor(1) < scaleFactor(2)) %size based on height
        im.Position = [0, 0, imgPanel.Position(3), imSize(2) / scaleFactor(2)];
    else
        im.Position = [0, 0, imSize(1) / scaleFactor(1), imgPanel.Position(4)];
    end
    
end

function calcButtonPushed(btn, imgPanel, verifPanel, latMinEdit, latMaxEdit, longMinEdit, ...
    longMaxEdit, outputFileName, editGroupsPos, dataPanel)
    
    botLat = latMinEdit.Value;
    topLat = latMaxEdit.Value;
    leftLong = longMinEdit.Value;
    rightLong = longMaxEdit.Value;
    im = imread(imgPanel.Children.ImageSource); %need to know which image
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
    
    redX = floor(redCoords / imRows);
    redY = rem(redCoords, imRows);

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

    %% Finding the center point
    %find the distance matrix of the red clusters
    centers = {};
    for i = 1: pointClSize(3)
        numNonZero = sum(pointClusters2(:, :, i) ~= 0);
        centers{i} = calcCenterPoint(pointClusters2(1: numNonZero, :, i), numNonZero);
    end
    ax1 = uiaxes(verifPanel);
    ax1.Position = [ax1.Position(1), ax1.Position(2), ax1.Position(3),...
        ax1.Position(4) - 50];
    hold(ax1, 'on');
    
    for i = 1: pointClSize(3)
        point = centers{i};
        scatter(ax1, point(2), point(1), 'filled');
    end
    
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
    numGroups = editGroupsPos.Value;
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
        coords1 = cell2mat(groupedVals(i));
        writematrix(coords1, outputFileName, 'Sheet', i);
    end
    tableData = array2table(groupedVals{i}, 'VariableNames', {'Latitude', 'Longitude'});
    uitData = uitable(dataPanel, 'Data', tableData);
    uitData.Position = [dataPanel.Position(1) / 20, dataPanel.Position(2) * 3.75 / 6, ...
        dataPanel.Position(3) * 5 / 6, dataPanel.Position(4) * 4.0 / 6 ];   
    fullResultsBtnPos = [dataPanel.Position(1)/ 20, dataPanel.Position(4) * 0.25 / 6, ...
        125, 40];
    fullResultsBtn = uibutton(dataPanel, 'Text', 'See Full Results', 'Position', ...
        fullResultsBtnPos, 'ButtonPushedFcn', @(btn, event) resButtonPushed(btn, outputFileName));
 
end

function resButtonPushed(btn, outputFileName)
    winopen(outputFileName);
end



function setDefaultLat(btn, minField, maxField, latMin, latMax)
    minField.Value = latMin;
    maxField.Value = latMax;
end

function setDefaultLong(btn, minField, maxField, longMin, longMax)
    minField.Value = longMin;
    maxField.Value = longMax;
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
