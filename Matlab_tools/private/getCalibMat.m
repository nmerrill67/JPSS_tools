function [DBDptr, fname] = getCalibMat()
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % requests and parses a database definition file in csv format.
        % must be the flight tlm sheet or the test tlm sheet exported to csv, but can have
        % columns in any order (Future releases may do this, but not sure)
        % DBDptr     cell array - the matrix of [units conversion mnemonic description S/S type APID (byte:bit)] 
        % filename - name of DB file stripped of extension 

    fname = writeCSVForDecom();
    if isempty(fname) % filename is '' if user presses cancel
        DBDptr = '';
        fname = '';
        h = errordlg('Error getting database. Plots will remain uncalibrated');
        uiwait(h)
        return
    end

    filename = fullfile(pwd, '.DBD_CSVs',strcat(fname, '.txt'));

    h = waitbar(0, 'Excel file already loaded. Loading Database ...');
    % Parse each line of the data 
    DBDptr = readtable(filename, 'delimiter', ';'); 
    waitbar(1/2, h)
    DBDptr = DBDptr{:,:}; % drop the table wrapper and just make a cell array

    waitbar(3/4, h)
    
    waitbar(1, h)
    delete(h)
end