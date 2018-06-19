function [estimateIndex] = systolicInflexion(signal)
derivative = diff(signal);
[~, maxIndex] = max(derivative);

i = maxIndex;
if(~isempty(maxIndex) && ~isempty(derivative))
    
    for i = maxIndex(1):length(derivative)-1
        
        if(derivative(i) >= 0 && derivative(i+1) < 0)
            
            break;
            
        end
        
    end
    
end

if isempty(i)
    i = 1;
end

estimateIndex = i;

end

