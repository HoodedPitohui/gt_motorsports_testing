function TrackMapperGUI
    all_fig = findall(0, 'type', 'figure');
    close(all_fig);
    clear all;
    screenSize = get(groot, 'ScreenSize');
    buttonSize = [100 40];
    panelSize = [screenSize(3) / 3; screenSize(4) / 3];
    mainFig = uifigure('WindowState', 'maximized');
    button1Pos = [screenSize(3) / 4 - buttonSize(1) / 4, 20, buttonSize(1), buttonSize(2)];
    %format panels
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
    btnPanel.Title = 'Controls';
    btnPanel.Position = [screenSize(3) * 7 / 8 - panelSize(1), screenSize(4) * 1 / 8, panelSize(1), panelSize(2)];
%     uplImgBtn = uibutton(mainFig, 'Text', 'Upload Image', 'Position', button1Pos, ...
%                         'ButtonPushedFcn', @(btn, event) uplButtonPushed(btn, origImgPanel));
    %set up the buttons
    btnUplPos = [panelSize(1) / 32, panelSize(2) / 16, buttonSize(1), buttonSize(2)];
    uplImgBtn = uibutton(btnPanel, 'Text', 'Upload Image', 'Position', btnUplPos, ...
        'ButtonPushedFcn', @(btn, event) uplButtonPushed(btn, origImgPanel));
end
% 
function uplButtonPushed(btn, imgPanel)
    [File_Name, Path_Name] = uigetfile('D:\Users\Public\Pictures\Sample Pictures');
    im = uiimage(imgPanel);
    im.ImageSource = strcat(Path_Name, File_Name);
end
