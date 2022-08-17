function TrackMapperGUI
    %% Set constants and clear the environment
    all_fig = findall(0, 'type', 'figure');
    close(all_fig);
    clear all;
    
    %constants -> used later, change as necessary
    botLat = 33.777083;
    topLat = 33.778333;
    leftLong = -84.400556;
    rightLong = -84.39944;
    
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
    outputPanel.Title = 'Data Output Preview';
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
    calcConesBtn = uibutton(btnPanel, 'Text', 'Calc. Cone Positions', 'Position', btnCalcPos, ...
        'ButtonPushedFcn', @(btn, event) calcButtonPushed(btn, mainFig));
    
    btnDefLatPos = btnUploadPos;
    btnDefLatPos(2) = panelSize(2) / 1.4;
    defaultLatBtn = uibutton(btnPanel, 'Text', 'Use Def. Latitude', 'Position',...
        btnDefLatPos, 'ButtonPushedFcn', @(btn, event) setDefaultLat(btn, ...
        latMinEdit, latMaxEdit, botLat, topLat));
    
    btnDefLongPos = btnDefLatPos;
    btnDefLongPos(1) = latLeftPos;
    defaultLongBtn = uibutton(btnPanel, 'Text', 'Use Def. Longitude', 'Position',...
        btnDefLongPos, 'ButtonPushedFcn', @(btn, event) setDefaultLong(btn, ...
        longMinEdit, longMaxEdit, leftLong, rightLong));
end

%% Button Functions
function uplButtonPushed(btn, imgPanel)
    [File_Name, Path_Name] = uigetfile('D:\Users\Public\Pictures\Sample Pictures');
    im = uiimage(imgPanel);
    im.ImageSource = strcat(Path_Name, File_Name);
end

function calcButtonPushed(btn, givenFig)
    [File_Name, Path_Name] = uigetfile('D:\Users\Public\Pictures\Sample Pictures');
    im = uiimage(imgPanel);
    im.ImageSource = strcat(Path_Name, File_Name);
end

function setDefaultLat(btn, minField, maxField, latMin, latMax)
    minField.Value = latMin;
    maxField.Value = latMax;
end

function setDefaultLong(btn, minField, maxField, longMin, longMax)
    minField.Value = longMin;
    maxField.Value = longMax;
end