function [] = plotRRLoadCellData(time, rrData, min, max, speed, rowNum, index)
    figure;
    subplot(2, rowNum, index);
    plot(time(min: max), rrData(min:max));
    xlabel('time (s)');
    ylabel('load (lbs)');
    tString = [' from t = ', num2str(time(min)), ' - ', num2str(time(max))]
    title(['FR Load Cell Data (lbs) vs. Time (s)', tString]);
    subplot(2, rowNum, index + 1);
    plotSpeedData(time, speed, min, max);
end