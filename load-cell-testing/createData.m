clc;
clear all;
close all;

%% Relevant code
numRows = 1305;
timeData = 0:0.01:numRows;
fr_loadcell_lbs = 41.50;
    
data = timeData;

%% Test
baseLoc = 41;
random_phase_offset = rand(1,1)*2*pi;
max_amplitude = 5;
random_amplitude = rand(1,1) * max_amplitude;
signal = random_amplitude * sin(0.25 * (timeData + random_phase_offset)) + baseLoc;
y1 = wgn(numRows * 100 + 1, 1, 0);
newSig = y1 + signal';

numSigRows = length(timeData);

%% Stack more noise
endInds = floor([1, 13000, 26000, 54000, 80000, 92800, 130501]);
for i = 1: length(endInds) - 1
    random_amplitude = rand(1,1) * max_amplitude;
    timeAdd = timeData(endInds(i): endInds(i + 1));
    signal2 = random_amplitude * sin(0.25 * (timeAdd + random_phase_offset)) + baseLoc;
    y1 = wgn(length(timeAdd), 1, 0);
    sig12 = signal2'
    newSig(endInds(i):endInds(i + 1)) = newSig(endInds(i): endInds(i + 1)) + y1 + sig12; 
end

plot(timeData, signal)
plot(timeData, newSig)