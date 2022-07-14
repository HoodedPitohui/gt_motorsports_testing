function [] = plotSpeedData(time, speed, min, max)
    %Plot the speed test
    plot(time(min: max), speed(min: max));
    tString = [' from t = ', num2str(time(min)), ' - ', num2str(time(max))];
    xlabel('time (s)');   
    ylabel('speed (mph)');
    title(['Speed (mph) vs. Time (s)', tString]);
    
end