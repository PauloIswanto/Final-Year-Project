function [estimate] = meanOneThirdTwoThirds(systolicEstimate, diastolicEstimate)
estimate = (systolicEstimate + 2*diastolicEstimate)/3;
end

