function [] = plotSpeedData(time, speed, min, max)
    plot(time(min: max), speed(min: max));
    xlabel('time (s)');
    ylabel('speed (mph)');
    title('Speed (mph) vs. Time (s)');
end