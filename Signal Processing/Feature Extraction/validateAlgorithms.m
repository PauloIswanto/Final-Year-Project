clear
clc

matFiles = dir('*.mat');

systolicErrors = {};
diastolicErrors = {};
meanErrors = {};
pressureChangeErrors = {};
dicroticNotchErrors = {};
dicroticPeakErrors = {};
heartRateErrors = {};

onsets = {};

isBeatAbnormal = {};

% LPF
cutoff = 25;
[b, a] = butter(1, cutoff/(125/2), 'low');

for i = 1:length(matFiles)
    
    load(matFiles(i).name);
    
    % Check if signal is clean
    if ~any(~isnan(signals{1}(:)))
        continue
    end
    
    signals{1}(isnan(signals{1})) = 0;
    
    % Filter signal
    filteredSignal = filter(b, a, signals{1});
    
    % Detect beats
    for j = round(logspace(log10(1), log10(length(signals{1})-7500), 10))
        
        onsets{i} = wabp(filteredSignal(j:end));
        
        if ~isempty(onsets{i})
            break
        end
        
    end
    
    onsets{i} = onsets{i} + j - 1;
    
    % Extract features
    
    systolicEstimates = {};
    diastolicEstimates = {};
    meanEstimates = {};
    pressureChangeEstimates = {};
    dicroticNotchEstimates = {};
    dicroticPeakEstimates = {};
    heartRateEstimates = {};
    
    for j = 1:length(onsets{i})-1
        
        signal = filteredSignal(onsets{i}(j):onsets{i}(j+1));
        
        % SYSTOLIC PRESSURE (index)
        
        % Max
        systolicEstimates{1}(j) = systolicMax(signal);
        
        % Inflexion + zero-point crossing
        systolicEstimates{2}(j) = systolicInflexion(signal);
        
        % Find peaks
        systolicEstimates{3}(j) = systolicFindPeaks(signal);
        
        % AMPD
        systolicEstimates{4}(j) = systolicAMPD(signal);
        
        % DIASTOLIC PRESSURE (index)
        
        % Min
        diastolicEstimates{1}(j) = diastolicMin(signal, systolicEstimates{2}(j));
        
        % Waveform end
        diastolicEstimates{2}(j) = length(signal);
        
        % MEAN PRESSURE
        
        % One third, two thirds
        meanEstimates{1}(j) = meanOneThirdTwoThirds(signal(systolicEstimates{2}(j)), signal(diastolicEstimates{1}(j)));
        
        % Integral
        meanEstimates{2}(j) = meanIntegral(signal, signals{6}(onsets{i}(j):onsets{i}(j+1)), diastolicEstimates{1}(j));
        
        % MAX DP/DT
        
        pressureChangeEstimates{1}(j) = (signal(systolicEstimates{2}(j)) - signal(1))/(systolicEstimates{2}(j)/signals{8});
        
        % DICROTIC NOTCH (index)
        
        % Maximum of difference between straight line between systole and
        % diastole and signal
        dicroticNotchEstimates{1}(j) = notchStraightLineMax(signal, systolicEstimates{2}(j), diastolicEstimates{1}(j));
        
        % Inflexion + zero-point crossing after systole
        dicroticNotchEstimates{2}(j) = notchInflexion(signal, systolicEstimates{2}(j));
        
        % DICROTIC PEAK (index)
        
        % Minimum of difference between straight line between systole and
        % diastole and signal
        dicroticPeakEstimates{1}(j) = peakStraightLineMin(signal, systolicEstimates{2}(j), diastolicEstimates{1}(j), dicroticNotchEstimates{1}(j));
        
        % Local maximum following dicrotic notch
        dicroticPeakEstimates{2}(j) = peakMax(signal, dicroticNotchEstimates{1}(j));
        
        % HEART RATE
        
        % Whole Signal
        heartRateEstimates{1}(j) = 60/(length(signal)/signals{8});
        
        % Signal Until Diastole
        heartRateEstimates{2}(j) = 60/(diastolicEstimates{1}(j)/signals{8});
        
        % Restore values from indices
        systolicEstimates{1}(j) = signal(systolicEstimates{1}(j));
        systolicEstimates{2}(j) = signal(systolicEstimates{2}(j));
        systolicEstimates{3}(j) = signal(systolicEstimates{3}(j));
        systolicEstimates{4}(j) = signal(systolicEstimates{4}(j));
        diastolicEstimates{1}(j) = signal(diastolicEstimates{1}(j));
        diastolicEstimates{2}(j) = signal(diastolicEstimates{2}(j));
        dicroticNotchEstimates{1}(j) = signal(dicroticNotchEstimates{1}(j));
        dicroticNotchEstimates{2}(j) = signal(dicroticNotchEstimates{2}(j));
        dicroticPeakEstimates{1}(j) = signal(dicroticPeakEstimates{1}(j));
        dicroticPeakEstimates{2}(j) = signal(dicroticPeakEstimates{2}(j));
        
    end
    
    % Average estimates over 60 second periods
    
    systolicAverageEstimates = {};
    diastolicAverageEstimates = {};
    meanAverageEstimates = {};
    pressureChangeAverageEstimates = {};
    dicroticNotchAverageEstimates = {};
    dicroticPeakAverageEstimates = {};
    heartRateAverageEstimates = {};
    
    for j = 1:size(systolicEstimates, 2)
        systolicAverageEstimates{j} = averageEstimates(systolicEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(diastolicEstimates, 2)
        diastolicAverageEstimates{j} = averageEstimates(diastolicEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(meanEstimates, 2)
        meanAverageEstimates{j} = averageEstimates(meanEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(pressureChangeEstimates, 2)
        pressureChangeAverageEstimates{j} = averageEstimates(pressureChangeEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(dicroticNotchEstimates, 2)
        dicroticNotchAverageEstimates{j} = averageEstimates(dicroticNotchEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(dicroticPeakEstimates, 2)
        dicroticPeakAverageEstimates{j} = averageEstimates(dicroticPeakEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(heartRateEstimates, 2)
        heartRateAverageEstimates{j} = averageEstimates(heartRateEstimates{1, j}, signals{6}, onsets{i});
    end
    
    % Compare estimates to ground truth
    
    for j = 1:size(systolicEstimates, 2)
        systolicErrors{i}{j} = getRMSE(systolicAverageEstimates{1,j}(:,1), signals{2}(2:end));
    end
    
    for j = 1:size(diastolicEstimates, 2)
        diastolicErrors{i}{j} = getRMSE(diastolicAverageEstimates{1,j}(:,1), signals{3}(2:end));
    end
    
    for j = 1:size(meanEstimates, 2)
        meanErrors{i}{j} = getRMSE(meanAverageEstimates{1,j}(:,1), signals{4}(2:end));
    end
    
    for j = 1:size(pressureChangeEstimates, 2)
        pressureChangeErrors{i}{j} = getRMSE(pressureChangeAverageEstimates{1,j}(:,1), (signals{2}(2:end) - signals{3}(1:end-1))/0.03);
    end
    
    for j = 1:size(dicroticNotchEstimates, 2)
        dicroticNotchErrors{i}{j} = getRMSE(dicroticNotchAverageEstimates{1,j}(:,1), diastolicAverageEstimates{1,1}(:,1));
    end
    
    for j = 1:size(dicroticPeakEstimates, 2)
        dicroticPeakErrors{i}{j} = getRMSE(dicroticPeakAverageEstimates{1,j}(:,1), systolicAverageEstimates{1,2}(:,1));
    end
    
    for j = 1:size(heartRateEstimates, 2)
        heartRateErrors{i}{j} = getRMSE(heartRateAverageEstimates{1,j}(:,1), signals{5}(2:end));
    end
    
    % Check if beat is abnormal
    for j = 1:length(onsets{i})-1
        if(j-1 > 0)
            previousSystolicPressure = systolicEstimates{1,2}(j-1);
            previousDiastolicPressure = diastolicEstimates{1,2}(j-1);
            previousMeanPressure = meanEstimates{1,1}(j-1);
        else
            previousSystolicPressure = systolicEstimates{1,2}(1);
            previousDiastolicPressure = diastolicEstimates{1,1}(1);
            previousMeanPressure = meanEstimates{1,1}(1);
        end
        
        isBeatAbnormal{i}(j) = abnormalityDetection(systolicEstimates{1,2}(j), previousSystolicPressure, ...
            diastolicEstimates{1,1}(j), previousDiastolicPressure, ...
            meanEstimates{1,1}(j), previousMeanPressure, ...
            heartRateEstimates{1,1}(j), pressureChangeEstimates{1,1}(j), ...
            dicroticNotchEstimates{1,2}(j), dicroticPeakEstimates{1,2}(j));
    end
    
end