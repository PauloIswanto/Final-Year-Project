function [ newSignal, xSpace ] = changeSamplingFrequency( signal, samplingFrequency, newSamplingFrequency )

    duration = length(signal) / samplingFrequency;
    oldx = linspace(0, duration, length(signal));
    xSpace = linspace(0, duration, newSamplingFrequency * duration);

    newSignal = interp1(oldx, signal, xSpace, 'pchip');
end