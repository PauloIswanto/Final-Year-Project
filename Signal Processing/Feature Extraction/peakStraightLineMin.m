function [estimateIndex] = peakStraightLineMin(signal, systolicIndex, diastolicIndex, dicroticNotchIndex)
a = (signal(diastolicIndex) - signal(systolicIndex))/(diastolicIndex - systolicIndex);
b = signal(systolicIndex) - a*systolicIndex;

straightLineBetweenSystoleAndDiastole = a*(1:length(signal))+b;

differenceBetweenStraightLineAndSignal = straightLineBetweenSystoleAndDiastole - signal;

[~, estimateIndex] = min(differenceBetweenStraightLineAndSignal(dicroticNotchIndex:diastolicIndex));

estimateIndex = estimateIndex(1) + dicroticNotchIndex - 1;
end

