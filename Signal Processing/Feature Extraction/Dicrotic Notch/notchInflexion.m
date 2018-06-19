function [estimateIndex] = notchInflexion(signal, systolicIndex)
derivative = diff(signal(systolicIndex:end));
[~, minIndex] = min(derivative);

i = minIndex;
if(~isempty(minIndex) && ~isempty(derivative))
    
    for i = minIndex(1):length(derivative)-1
        
        if(derivative(i) < 0 && derivative(i+1) >= 0)
            
            break;
            
        end
        
    end
    
end

if isempty(i)
    i = 1;
end

estimateIndex = i + systolicIndex - 1;

end

