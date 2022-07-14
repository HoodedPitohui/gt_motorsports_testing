function [] = plotRRLoadCellData(time, rrData, min, max, speed, numRow, numCol, index)
    %Plot the RR load cell data
    subplot(numRow, numCol, index);
    plot(time(min: max), rrData(min:max));
    xlabel('time (s)');
    ylabel('load (lbs)');
    tString = [' from t = ', num2str(time(min)), ' - ', num2str(time(max))];
    title(['RR Load Cell Data (lbs) vs. Time (s)', tString]);
    subplot(numRow, numCol, index + 1);
    plotSpeedData(time, speed, min, max);
end