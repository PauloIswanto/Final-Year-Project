function [estimateIndex] = systolicMax(signal)
[~, index] = max(signal);
estimateIndex = index(1);
end

