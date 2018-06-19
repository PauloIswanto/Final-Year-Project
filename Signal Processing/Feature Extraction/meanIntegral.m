function [estimate] = meanIntegral(signal, xSpace, diastolicIndex)
if diastolicIndex > 1
    estimate = trapz(xSpace(1:diastolicIndex), signal(1:diastolicIndex));
else
    estimate = trapz(xSpace, signal);
end
end

