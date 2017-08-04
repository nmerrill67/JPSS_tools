function [DBDptr, fname] = getCalibMat()
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % requests and parses a database definition file in csv format.
        % must be the flight tlm sheet or the test tlm sheet exported to csv, but can have
        % columns in any order (Future releases may do this, but not sure)
        % DBDptr     cell array - the matrix of [units conversion mnemonic description S/S type APID (byte:bit)] 
        % filename - name of DB file stripped of extension 
        
    pwd; % there is some sort of matlab bug where if this pwd comman is missing, it randomly does not reckognize that the working directory is .. whaen this private funct is called
    
    DBDptr = '';
    fname = '';
    
    f = figure('name', 'Database Options');
    set(f, 'MenuBar', 'none')
    set(f, 'ToolBar', 'none')
    



    h = uibuttongroup('parent', f);
    
    uicontrol('Style', 'text', 'String', 'Choose desired Database type', ...
        'pos', [10 300 500 20], 'parent', h, 'fontweight', 'bold', 'fontsize', 12)
    
    uicontrol('Style', 'radio', 'String', ...
        'This is an XML database',...
        'pos', [10 250 1000 20], 'tag', 'b1', 'parent', h);

    uicontrol('Style', 'radio', 'String', 'This is an Excel database (NPP only)',...
        'pos',[10 200 1000 20], 'tag', 'b2', 'parent', h);

    b3 = uicontrol('Style', 'PushButton', 'String','Ok', ...
        'pos', [10 50 100 20], 'Callback' ,@b3Callback, 'parent', h);

    uiwait(f)
    if ~isvalid(f), return; end % user exited
    b = get(b3, 'UserData');
    close(f)
    
    function b3Callback(src, event)
    % for use in the above figure window
        str = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        set(src, 'UserData', str)
        uiresume()
    end
    
    if strcmp(b, 'b2')
        fname = writeCSVForDecom(); % use a 
    else
        fname = writeCSVForDecom('spacecraft'); % using this flag signals writeCSVForDecom to run the xml2CSV function instead of readtable 
    end
    
    if isempty(fname) % filename is '' if user presses cancel
        DBDptr = '';
        fname = '';
        h = errordlg('Error getting database. Plots will remain uncalibrated');
        uiwait(h)
        return
    end

    filename = fullfile(pwd, 'DBD_CSVs',strcat(fname, '.txt'));

    h = waitbar(0, 'Loading Database ...');
    % Parse each line of the data 
    DBDptr = readtable(filename, 'delimiter', ';');  % leave DBDptr as a struct for quick field access
    waitbar(1/2, h)

    waitbar(3/4, h)
    
    waitbar(1, h)
    delete(h)
end