function [isBeatAbnormal] = abnormalityDetection(systolicPressure, previousSystolicPressure, ...
    diastolicPressure, previousDiastolicPressure, ...
    meanPressure, previousMeanPressure, ...
    heartRate, maxPressureChangeRate, ...
    dicroticNotchPressure, dicroticPeakPressure)

isBeatAbnormal = 0;

if systolicPressure > 70 isBeatAbnormal = 1; end
if diastolicPressure < 25 isBeatAbnormal = 1; end
if meanPressure > 40 isBeatAbnormal = 1; end
if heartRate > 100 isBeatAbnormal = 1; end
if maxPressureChangeRate < 25 isBeatAbnormal = 1; end
if (abs(dicroticNotchPressure - diastolicPressure) < 1 || abs(dicroticNotchPressure - systolicPressure) < 1) isBeatAbnormal = 1; end
if abs(dicroticPeakPressure - dicroticNotchPressure) < 1 isBeatAbnormal = 1; end
if abs(systolicPressure - previousSystolicPressure) > 20 isBeatAbnormal = 1; end
if abs(diastolicPressure - previousDiastolicPressure) > 20 isBeatAbnormal = 1; end
if abs(meanPressure - previousMeanPressure) > 15 isBeatAbnormal = 1; end

end

