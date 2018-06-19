function [estimateIndex] = peakMax(signal, notchIndex)
[~, maxIndex] = max(signal(notchIndex:end));
estimateIndex = maxIndex(1) + notchIndex - 1;
end

