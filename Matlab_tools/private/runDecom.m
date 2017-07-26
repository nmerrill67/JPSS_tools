function handles = runDecom(hObject, eventdata, handles, newDBfun)
    % runs decom binaries and py script. newDBfun
    % hObject, eventdata, handles - all things from normal GUI callbacks
    % newDBfun - function handle to a functions that updates the DBDptr and
    % DBname
    
    % SC database
    if ~exist('../Decom_tools/databases/*database.csv', 'file') || isempty(handles.DBname)% if there is no DB for the decom, prompt for one by default
        handles = newDBfun(hObject, eventdata, handles); % update the handles pointer
        
    
        
    else % give the option to use the existing one
        f = figure('name', 'Database Options');
        set(f, 'MenuBar', 'none')
        set(f, 'ToolBar', 'none')
        
        h = uibuttongroup('parent', f);
        
        uicontrol('Style', 'radio', 'String', ...
            ['Use current database: ' handles.DBname],...
            'pos', [10 350 1000 20], 'tag', 'b1', 'parent', h);
        
        uicontrol('Style', 'radio', 'String', 'Get new database',...
            'pos',[10 250 1000 20], 'tag', 'b2', 'parent', h);
        
        b3 = uicontrol('Style', 'PushButton', 'String','Ok', ...
            'pos', [10 150 100 20], 'Callback' ,@b3Callback, 'parent', h);
        
        uiwait(f)
        if ~isvalid(f), return; end
        b = get(b3, 'UserData');
        close(f)
        
        if strcmp(b, 'b2')
            handles = newDBfun(hObject, eventdata, handles);
        end

    end
   
    if isempty(handles.DBDptr), return; end      
    
    % these next few blocks call the  CXXDecomQt executable, waits for it to exit, then this
    % script waits for the python to exit.
     
    % if this is a UNIX system, MATLAB's version of Qt will by default take
    % precedence over the installed version, so we need to append the
    % correct paths to the front of the LD_LIBRARY_PATH environment
    % variable
    if isunix
        QTDIR = getenv('QTDIR'); % get the base path for Qt install. This should work for any unix system
        LD_LIBRARY_PATH = getenv('LD_LIBRARY_PATH');% get the original path
        % temporarily reset the LD_LIBRARY_PATH. If the Qt directory is
        % appended to the front of the path, the program still crashes
        setenv('LD_LIBRARY_PATH', [QTDIR '/plugins/platforms']); 
        system('cd ../Decom_tools && ./CXXDecomQt/build/bin/CXXDecomQt && cd ../Matlab_tools');

    else
    
        system('cd ../Decom_tools && ./CXXDecomQtWin/CXXDecomQt && cd ../Matlab_tools');
    end
    if isunix
        setenv('LD_LIBRARY_PATH', LD_LIBRARY_PATH); % set the path back to the original
    end
    
    if ~exist('../Decom_tools/output', 'dir'), return; end % user stopped python execution of CXXDecomQt
       
    
    f2 = dir('../Decom_tools/output/*.txt');
    f2 = [f2.name]; % all the txt filenames in ../Decom_tools/output
    if isempty(f2)       
        return
    end % user stopped the cpp code from executing. So dont bother running the rest of the code
    
    % We use ../Decom_tools/output/datesFile.dat to see the range of dates
    % present in the h5 files selected. the C++ program outputs this file
    % for use here. We use it here to create the directory structure that
    % is beneficial for the user to conveniently find data for the time
    % he/she wants
    
    datesF = '../Decom_tools/output/datesFile.dat';
    if ~exist(datesF, 'file'), return ; end % make sure it exists
    
    id = fopen(datesF);
    line1 = fgetl(id); % get the first and only line from the file
    fclose(id);
    
    delete(datesF); % delete this file. We dont need it anymore
    
    namesWithPath = strsplit(line1, '.h5'); % get the basnames of the two filenames, with full  path
    [~,baseName1] = fileparts(namesWithPath{1}); % strip the path
    [~,baseName2] = fileparts(namesWithPath{2});
    
    vec = strsplit(baseName1, '_'); % split filename based on '_' character to see the SCID. Assume that there is only one SCID in data
    
    % find out what sc the data is from
    if ismember('j01', vec)
        scid = 'JPSS1';
    elseif ismember('j02', vec)
        scid = 'JPSS2';
    elseif ismember('j03', vec)
        scid = 'JPSS3';
    elseif ismember('j04', vec)
        scid = 'JPSS4';
    elseif ismember('npp', vec)
        scid = 'NPP';
    else
        h = warndlg('Unrecognized spacecraft filename. Placing data in separate folder');
        scid = 'Unknown';
        uiwait(h)
    end
    
    % find out the time frame of the data

    d1 = regexp(baseName1, 'd\d{8}', 'match'); % search for start date of data in form  d<8 numbers> = dyyyymmdd
    d1 = d1{1}; % extract from cell array trhat regexp outputs
    t1 = regexp(baseName1, 't\d{7}', 'match'); % start time t<7 numbers> = tHHMMSSF
    t1 = t1{1};
    d2 = regexp(baseName2, 'd\d{8}', 'match'); % search for start date of data in form  d<8 numbers> = dyyyymmdd
    d2 = d2{1};
    t2 = regexp(baseName2, 't\d{7}', 'match'); % start time t<7 numbers> = tHHMMSSF
    t2 = t2{1};
    
    date = [d1(6:7) '-' d1(8:9) '-' d1(2:5) '_' t1(2:end-1) '__' d2(6:7) '-' d2(8:9) '-' d2(2:5) '_' t2(2:end-1)]; % now mm-dd-yyyy_HHMMSS__mm-dd-yyyy_HHMMSS
    
    if ~exist(fullfile(pwd, 'data'), 'dir'), system(['mkdir ' fullfile(pwd,'data')]); end
    
    if ~exist(fullfile(pwd,'data', scid), 'dir') % make the dirs if they dont exist
        system(['mkdir ' fullfile(pwd,'data', scid)]);
    end
    
    if ~exist(fullfile(pwd,'data', scid, date), 'dir') % make the dirs if they dont exist
        system(['mkdir ' fullfile(pwd,'data', scid, date)]);
    end    
    
    vec2 = strsplit(f2, {'.txt','_'});
    dataType = {};
    
    % see if science and/or SC data based on the file name
    if ismember('spacecraft', lower(vec2)) 
        dataType = {'Spacecraft_Data'};
    end
    if ismember('atms', lower(vec2)) || ismember('omps', lower(vec2)) || ...
            ismember('rbi', lower(vec2)) || ismember('ceres', lower(vec2)) || ...
            ismember('viirs', lower(vec2)) || ismember('cris', lower(vec2))
        if isempty(dataType)
            dataType = {'Science_and_Telem_Data'};
        else
            dataType = {dataType{:},'Science_and_Telem_Data'};
        end
    end

    % make new directories if we need to 
    newDirName = fullfile(pwd,'data', scid, date, dataType);
    for i = 1:length(newDirName)
        if ~exist(newDirName{i}, 'dir')
            system(['mkdir ' newDirName{i}]);
        end
    end
    
    
    % move the text files into the correct dir 
    if ispc
        for i = 1:length(newDirName)
            if strcmp(dataType{i}, 'Spacecraft_Data')
                wildcard = 'SPACECRAFT_* '; % all of this is in case the user decoms SC and science data at the same time
            else
                wildcard = '*.txt ';
            end
            system(['move ..\Decom_tools\output\' wildcard newDirName{i}]); % move or mv removes the files from the dir they were in
        end

    else % linux
        for i = 1:length(newDirName)
            if strcmp(dataType{i}, 'Spacecraft_Data')
                wildcard = 'SPACECRAFT_* '; % all of this is in case the user decoms SC and science data at the same time
            else
                wildcard = '*.txt ';
            end            
            system(['mv ../Decom_tools/output/' wildcard newDirName{i}]);
        end
    end
    
    msgbox(['Data files have been written to ' fullfile(pwd,'data', scid, date)])
    
    function b3Callback(src, event)
    % for use in proc_bin_button_Callback
        str = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        set(src, 'UserData', str)
        uiresume()
    end

end