function [] = GUI_13()
    screenSize = get(groot, 'ScreenSize');
    buttonSize = [125 40];
    panelSize = [screenSize(3) / 3; screenSize(4) / 3];
    mainFig = uifigure('WindowState', 'maximized');
    mainFig.Name = 'Track Mapper';
    
end