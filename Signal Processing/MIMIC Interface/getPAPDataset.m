% Script needs to be in WFDB mcode folder

recordsUrl = 'https://www.physionet.org/physiobank/database/mimic3wdb/matched/RECORDS';
waveformRecordsUrl = 'https://www.physionet.org/physiobank/database/mimic3wdb/matched/RECORDS-waveforms';
numericRecordsUrl = 'https://www.physionet.org/physiobank/database/mimic3wdb/matched/RECORDS-numerics';

options = weboptions('ContentType','text');

% Each records is 12 characters long
records = webread(recordsUrl, options);
records = strrep(records, records(13), '');
records = strtrim(records);

% Each waveform record is 36 characters long
waveformRecords = webread(waveformRecordsUrl, options);
waveformRecords = strrep(waveformRecords, waveformRecords(37), '');
waveformRecords = strtrim(waveformRecords);

% Each numeric record is 37 characters long
numericRecords = webread(numericRecordsUrl, options);
numericRecords = strrep(numericRecords, numericRecords(38), '');
numericRecords = strtrim(numericRecords);

numberOfWaveformRecords = 0;
numberOfNumericsRecords = 0;

for i = 1:12:length(records)-11
    
    if contains(strcat(waveformRecords), strcat(records(i:i+11)))
        
        tempWaveforms = [];
        tempWaveformIndices = strfind(strcat(waveformRecords), strcat(records(i:i+11)));
        
        for j = 1:length(tempWaveformIndices)
            
            tempWaveform = strcat(waveformRecords(tempWaveformIndices(j):tempWaveformIndices(j)+35));
            
            if contains(strcat(numericRecords), tempWaveform)
                
                siginfo = wfdbdesc(strcat('mimic3wdb/matched/', tempWaveform));
                
                if ~isempty(siginfo) && contains(strcat(siginfo.Description), 'PAP')
                    
                    numberOfWaveformRecords = numberOfWaveformRecords + 1;
                    
                    siginfoNumerics = wfdbdesc(strcat('mimic3wdb/matched/', tempWaveform, 'n'));
                    
                    if ~isempty(siginfoNumerics) && contains(strcat(siginfoNumerics.Description), 'HR') ...
                            && contains(strcat(siginfoNumerics.Description), 'PAPSys') ...
                            && contains(strcat(siginfoNumerics.Description), 'PAPDias') ...
                            && contains(strcat(siginfoNumerics.Description), 'PAPMean') ...
                            && contains(strcat(siginfoNumerics.Description), 'HR')
                        
                        try
                            
                            numberOfNumericsRecords = numberOfNumericsRecords + 1;
                            
                            % Read at most 6000 seconds
                            wfdb2mat(strcat('mimic3wdb/matched/', tempWaveform), [], 750001);
                            wfdb2mat(strcat('mimic3wdb/matched/', tempWaveform, 'n'), [], 101);
                            
                            [tm, signal, Fs, siginfo] = rdmat(strcat(tempWaveform(13:end), 'm'));
                            [tmNumerics, signalNumerics, FsNumerics, siginfoNumerics] = rdmat(strcat(tempWaveform(13:end), 'nm'));
                            
                            delete(strcat(tempWaveform(13:end), 'm.hea'), strcat(tempWaveform(13:end), 'm.mat'));
                            delete(strcat(tempWaveform(13:end), 'nm.hea'), strcat(tempWaveform(13:end), 'nm.mat'));
                            
                            signalIndex = find(cellfun(@(x)isequal(x,'PAP'), {siginfo.Description}));
                            sysIndex = find(cellfun(@(x)isequal(x,'PAPSys'), {siginfoNumerics.Description}));
                            diasIndex = find(cellfun(@(x)isequal(x,'PAPDias'), {siginfoNumerics.Description}));
                            meanIndex = find(cellfun(@(x)isequal(x,'PAPMean'), {siginfoNumerics.Description}));
                            hrIndex = find(cellfun(@(x)isequal(x,'HR'), {siginfoNumerics.Description}));
                            
                            if length(signalNumerics(:, sysIndex)) >= 100 && ...
                                    length(signalNumerics(:, diasIndex)) >= 100 && ...
                                    length(signalNumerics(:, meanIndex)) >= 100 && ...
                                    length(signalNumerics(:, hrIndex)) >= 100 && ...
                                    any(~isnan(signal(:, signalIndex)))
                                
                                signals = {signal(:, signalIndex), signalNumerics(:, sysIndex), ...
                                    signalNumerics(:, diasIndex), signalNumerics(:, meanIndex), signalNumerics(:, hrIndex) ...
                                    tm, tmNumerics, Fs, FsNumerics};
                            
                                save(tempWaveform(13:end), 'signals');
                                
                            end
                            
                        catch
                            
                            disp(['Problem with ' tempWaveform])
                            
                        end
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    
end