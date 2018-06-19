function [rmse] = getRMSE(a, b)
rmse = sqrt((a - b).^2);
end

