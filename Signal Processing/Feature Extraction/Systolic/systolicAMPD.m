function [estimateIndex] = systolicAMPD(signal)
if ~isrow(signal)
    signal = signal';
    
end

[polynomialCoefficients, S] = polyfit(1:length(signal), signal, 1);
polynomialValue = polyval(polynomialCoefficients, 1:length(signal), S);

trendRemovedSignal = signal - polynomialValue;

N = length(trendRemovedSignal);
L = ceil(N/2.0)-1;

RNG = RandStream('mt19937ar');
LSM = 1 + rand(RNG, L, N);

for k = 1:L
    for i = k+2:N-k+1
        if(signal(i-1) > signal(i-k-1) && signal(i-1) > signal(i+k-1))
            LSM(k,i) = 0;
        end
    end
end

G = sum(LSM, 2);
[~, minIndex] = min(G);

LSM = LSM(1:minIndex, :);

S = std(LSM);

estimateIndex = find(S==0)-1;

if isempty(estimateIndex)
    estimateIndex = 1;
end

[~, bestPeak] = max(signal(estimateIndex(1):end));
maxIndex = bestPeak(1) + estimateIndex(1) - 1;
estimateIndex = maxIndex;
end