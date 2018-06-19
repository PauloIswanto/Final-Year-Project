function [estimateIndex] = notchStraightLineMax(signal, systolicIndex, diastolicIndex)
a = (signal(diastolicIndex) - signal(systolicIndex))/(diastolicIndex - systolicIndex);
b = signal(systolicIndex) - a*systolicIndex;

straightLineBetweenSystoleAndDiastole = a*(1:length(signal))+b;

differenceBetweenStraightLineAndSignal = straightLineBetweenSystoleAndDiastole - signal;

[~, estimateIndex] = max(differenceBetweenStraightLineAndSignal(systolicIndex:diastolicIndex));

estimateIndex = estimateIndex(1) + systolicIndex - 1;
end

