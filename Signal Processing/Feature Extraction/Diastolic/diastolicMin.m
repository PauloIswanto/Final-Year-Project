function [estimateIndex] = diastolicMin(signal, systolicIndex)
[~, index] = min(signal(systolicIndex:end));
estimateIndex = index(1) + systolicIndex - 1;
end

