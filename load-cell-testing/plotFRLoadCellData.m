function [] = plotFRLoadCellData(time, frData, minimum, maximum, speed, numRow, numCol, index)
    %Plot the FR Load Cell data
    subplot(numRow, numCol, index);
    plot(time(minimum: maximum), frData(minimum:maximum));
    xlabel('time (s)');
    ylabel('load (lbs)');
    seta = min(frData);
    setb = max(frData);
    if ~isreal(seta)
        seta = 0;
    else
    end
    if setb > 1000
        setb = 10000;
    else
    end
%     ylim([seta setb]);

    tString = [' from t = ', num2str(time(minimum)), ' - ', num2str(time(maximum))];
    title(['FR Load Cell Data (lbs) vs. Time (s)', tString]);
    subplot(numRow, numCol, index + 1);
    plotSpeedData(time, speed, minimum, maximum);
end