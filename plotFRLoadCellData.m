function [] = plotFRLoadCellData(time, frData, min, max, speed)
    figure;
    subplot(2, 1, 1);
    plot(time(min: max), frData(min:max));
    xlabel('time (s)');
    ylabel('load (lbs)');
    title('Front Load Cell Data (lbs) vs. Time (s)');
    subplot(2, 1, 2);
    plotSpeedData(time, speed, min, max);
end