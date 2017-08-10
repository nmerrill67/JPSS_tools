function [DBDptr, fname_SC] = getCalibMat()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % requests and parses a database definition file in csv format.
    % must be the flight tlm sheet or the test tlm sheet exported to csv, but can have
    % columns in any order (Future releases may do this, but not sure)
    % DBDptr     struct array - the struct with fields [units conversion mnemonic description S/S type APID (byte:bit)] 
    % filename - name of DB file (SC DB only) stripped of extension 
    % 
    % HTis function will add on science databases if the user requests it.
    % This is useful for calibrating science telemetry data.
    
    pwd; % there is some sort of matlab bug where if this pwd comman is missing, it randomly does not reckognize that the working directory is .. whaen this private funct is called
    
    DBDptr = '';
    fname_SC = '';
    
    f = figure('name', 'Database Options');
    set(f, 'MenuBar', 'none')
    set(f, 'Position', [100 100 500 600])




    h = uibuttongroup('parent', f);
    
    uicontrol('Style', 'text', 'String', 'Choose desired SC Database type', ...
        'pos', [10 500 500 20], 'parent', h, 'fontweight', 'bold', 'fontsize', 12)
    
    uicontrol('Style', 'radio', 'String', ...
        'This is an XML SC database',...
        'pos', [10 450 1000 20], 'tag', 'b1', 'parent', h);

    uicontrol('Style', 'radio', 'String', 'This is an Excel SC database (NPP only)',...
        'pos',[10 400 1000 20], 'tag', 'b2', 'parent', h);
    
   uicontrol('Style', 'text', 'String', 'Science database options', ...
        'pos', [10 350 500 20], 'parent', h, 'fontweight', 'bold', 'fontsize', 12)
    
    uicontrol('Style', 'checkbox', 'String', 'Load ATMS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
        'pos', [10 300 1000 20], 'tag', 'atms', 'parent', h')

    uicontrol('Style', 'checkbox', 'String', 'Load OMPS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
        'pos', [10 250 1000 20], 'tag', 'omps', 'parent', h)

    uicontrol('Style', 'checkbox', 'String', 'Load CERES database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
        'pos', [10 200 1000 20], 'tag', 'ceres', 'parent', h)

    uicontrol('Style', 'checkbox', 'String', 'Load VIIRS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
        'pos', [10 150 1000 20], 'tag', 'viirs', 'parent', h, 'enable', 'off') % TODO Eneble once Viirs DB works  

    uicontrol('Style', 'checkbox', 'String', 'Load CrIS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
        'pos', [10 100 1000 20], 'tag', 'cris', 'parent', h, 'enable', 'off')         % TODO Eneble once CRiS DB works 


    b3 = uicontrol('Style', 'PushButton', 'String','Ok', ...
        'pos', [10 50 100 20], 'Callback' ,@b3Callback, 'parent', h);

    uiwait(f)
    if ~isvalid(f), return; end % user exited
    
    bStruct = get(b3, 'UserData'); % contains the SC database choice, as well as sci

    close(f)

    if strcmp(bStruct.sel, 'b2') % SC database choice
        fname_SC = writeCSVForDecom(); % Excel SC database loading
    else
        fname_SC = writeCSVForDecom('spacecraft'); % XML SC database
    end

    fnames_Sci = '';
    if ~isempty(bStruct.insStr) % Choices of instruments from the figure window above. If no insturments aer chosen, the corresponding databases wont be loaded, and that data cannot be calibrated
        fnames_Sci = writeCSVForDecom(bStruct.insStr);
    end    
    
    
    function b3Callback(src, event)
        % for use in proc_bin_button_Callback
        sel = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        
        children = get(get(src, 'Parent'), 'Children'); 
        sciBs = children(2:6); % all the children representing science button options
        
        insStr = {}; % this will be turned into a comma-separated list of instrument names for writeCSVForDecom 
        
        for i = 1:length(sciBs)
            
            sciB = sciBs(i);
            if strcmp(get(sciB, 'enable'), 'on') && get(sciB, 'value')
                insStr = {insStr{:}, get(sciB, 'tag')}; % The tags of the buttons have been named according to their instrument
            end
        end
        
        toReturn = struct('sel', sel, 'insStr', strjoin(insStr, ', ')); % create struct for User Data field of b4, so it can be accessed after this function returns.
        
        set(src, 'UserData', toReturn)

        
        uiresume()
    end
    
    
    if isempty(fname_SC) % filename is '' if user presses cancel
        DBDptr = '';
        fname_SC = '';
        h = errordlg('Error getting database. Plots will remain uncalibrated');
        uiwait(h)
        return
    end

    if iscell(fname_SC), fname_SC = [fname_SC{:}]
    end % Remove all of the empy cells that xml2csv outpus, as readtable cannot read '<$PATH_TO>/.csv'
    
    filename_SC = fullfile(pwd, 'DBD_CSVs',strcat(fname_SC, '.txt'));

    h = waitbar(0, 'Loading Database ...');
    % Read the database csv, leave as a table struct for faster field
    % accessing
    DBDptr = readtable(filename_SC, 'delimiter', ';');
    
    try
        waitbar(1/2, h)    

    catch
    % do nothing fo waitbar errors    

    end

    if ~isempty(fnames_Sci)
        filenames_Sci = fullfile(pwd, 'DBD_CSVs',strcat(fnames_Sci, '.txt'));
        for j = 1:length(filenames_Sci) % loop through all the instruments selected, and add their databases to the overall database
            fname = filenames_Sci{j};
            DBDptr = vertcat(DBDptr, readtable(fname, 'delimiter', ';')); % read in the table and append it to the current database. We dont know the size before hand, so we cnat preallocate
        end
    end
    
    try
        waitbar(3/4, h)

        waitbar(1, h)

        delete(h)
    catch
    % do nothing fo waitbar errors    
    end
end