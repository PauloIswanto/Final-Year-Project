function [averagedEstimates] = averageEstimates(estimates, xSpace, onsets)

averagedEstimates = zeros(xSpace(end)/60, 2);

for i = 1:length(onsets)-1
    
    for j = floor(xSpace(onsets(i))/60)+1:floor(xSpace(onsets(i+1))/60)+1
       
        averagedEstimates(j, 1) = averagedEstimates(j, 1) + estimates(i);
        averagedEstimates(j, 2) = averagedEstimates(j, 2) + 1;
        
    end
    
end

averagedEstimates(:,1) = averagedEstimates(:,1)./averagedEstimates(:,2);

end

