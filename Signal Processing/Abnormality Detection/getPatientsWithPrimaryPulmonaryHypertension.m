%% Set preferences
prefs = setdbprefs('DataReturnFormat');
setdbprefs('DataReturnFormat','table')

%% Make connection to database
conn = database('mimic','postgres','postgres','Vendor','POSTGRESQL','Server','localhost','PortNumber',5432);

%% Execute query and fetch results
curs = exec(conn,'SELECT DISTINCT subject_id FROM mimic.mimiciii.diagnoses_icd where icd9_code like ''4160''');
curs = fetch(curs);
data = curs.Data;
close(curs)

%% Close connection to database
close(conn)

%% Restore preferences
setdbprefs('DataReturnFormat',prefs)

%% Clear variables
clear prefs conn curs

%% Get subject_id of patients in PAP Dataset

matFiles = dir('*.mat');

datasetPatientID = zeros(size(matFiles, 1), 1);

for i = 1:size(matFiles, 1)
   
    datasetPatientID(i) = str2double(matFiles(i).name(2:7));
    
end

patientsFromPAPDatasetWithPrimaryPulmonaryHypertension = intersect(data.subject_id(:), datasetPatientID);;