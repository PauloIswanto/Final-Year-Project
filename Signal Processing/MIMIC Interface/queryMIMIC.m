%% Set preferences
prefs = setdbprefs('DataReturnFormat');
setdbprefs('DataReturnFormat','table')

%% Make connection to database
conn = database('mimic','postgres','postgres','Vendor','POSTGRESQL','Server','localhost','PortNumber',5432);

%% Execute query and fetch results
curs = exec(conn,'SELECT * FROM mimic.mimiciii.d_items where label like ''%PAP%''');
curs = fetch(curs);
data = curs.Data;
close(curs)

%% Close connection to database
close(conn)

%% Restore preferences
setdbprefs('DataReturnFormat',prefs)

%% Clear variables
clear prefs conn curs