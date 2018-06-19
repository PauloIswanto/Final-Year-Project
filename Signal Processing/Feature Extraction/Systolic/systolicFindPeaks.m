function [estimateIndex] = systolicFindPeaks(signal)
[~, peakIndex] = findpeaks(signal);
[~, bestPeak] = max(signal(peakIndex));

if isempty(bestPeak)
    bestPeak = 1;
end

if isempty(peakIndex)
    peakIndex = 1;
end

estimateIndex = peakIndex(bestPeak(1));

end

