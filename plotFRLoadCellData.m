function [] = plotFRLoadCellData(time, frData, min, max, speed, numRow, numCol, index)
    %Plot the FR Load Cell data
    subplot(numRow, numCol, index);
    plot(time(min: max), frData(min:max));
    xlabel('time (s)');
    ylabel('load (lbs)');
    tString = [' from t = ', num2str(time(min)), ' - ', num2str(time(max))];
    title(['FR Load Cell Data (lbs) vs. Time (s)', tString]);
    subplot(numRow, numCol, index + 1);
    plotSpeedData(time, speed, min, max);
end