% This script formats time and pressure measurements
% and outputs the data to a text file

% Rename fileName to the desired file name
fileName = 'faultyPressureData.txt';
fileID = fopen(fileName,'wt');

%{
Data format is:
cXYYYYYYYYYYYYZZZZZ
- X: 1 character for channel (0: active, 1: reference and 2: catheter)
- Y: 12 characters for time (all integer, no decimal)
- Z: 5 characters for pressure (3 integer, 2 decimal)
All values are padded with 0s at the front if necessary
%}
for i = 1:5:numel(time)
    
    % Generate positive integers from a Gaussian distribution centered
    % around the true value
    timeInteger = abs(round(normrnd(12,1)));
    timeDecimal = abs(round(normrnd(0,1)));
    pressureInteger = abs(round(normrnd(3,1)));
    pressureDecimal = abs(round(normrnd(2,1)));
   
    fprintf(fileID,['c2%0' num2str(timeInteger) '.' num2str(timeDecimal) 'f%0' num2str(pressureInteger) '.' num2str(pressureDecimal) 'f\n'],[1000*time(i); pressure(i)]); 
end
fclose(fileID);