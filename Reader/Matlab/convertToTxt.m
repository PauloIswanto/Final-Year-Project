% This script formats time and pressure measurements
% and outputs the data to a text file

% Rename fileName to the desired file name
fileName = 'pressureData.txt';
fileID = fopen(fileName,'wt');

%{
Data format is:
cXYYYYYYYYYYYYZZZZZ
- X: 1 character for channel (0: active, 1: reference and 2: catheter)
- Y: 12 characters for time (all integer, no decimal)
- Z: 5 characters for pressure (3 integer, 2 decimal)
All values are padded with 0s at the front if necessary
%}
fprintf(fileID,'c2%012.0f%03.2f c2%012.0f%03.2f c2%012.0f%03.2f\n',[1000*time(1:20:end); pressure(1:20:end); 1000*time(2:20:end); pressure(2:20:end); 1000*time(3:20:end); pressure(3:20:end)]);
fclose(fileID);