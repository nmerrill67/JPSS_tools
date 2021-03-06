function handles = runDecom(hObject, eventdata, handles, newDBfun)
    % runs decom binaries and py script. newDBfun
    % hObject, eventdata, handles - all things from normal GUI callbacks
    % newDBfun - function handle to a functions that updates the DBDptr and
   
    
    currSupportedInstr = 'atms, omps, ceres'; % add more as we get more capabilities
    
    [sciDbNeeded, scNeededFlag, scidInDB] = checkDBs(currSupportedInstr); % check for which Sci DBs we need
    
    if isempty(dir('../Decom_tools/databases/*database.csv')) && isempty(handles.DBname)% if there is no DB of any kind for the decom (checked usng glob), prompt for all of them by default

        handles = newDBfun(hObject, eventdata, handles); % update the handles pointer
        
        if isempty(handles.DBDptr), return; end % user cancelled
        
        writeCSVForDecom(currSupportedInstr) % place all the science DBs in the right place
    
    elseif ~isempty(sciDbNeeded) || scNeededFlag % there are some dbs, but not all of them 
        
        if ~isempty(sciDbNeeded) % if sci DB(s) needed
            writeCSVForDecom(sciDbNeeded);
        end
        
        if scNeededFlag % if sc DB needed
             handles = newDBfun(hObject, eventdata, handles); % update the handles pointer
        end
        
    else % give the option to use the existing DB, or choose a new one
        
        % create uibutton group  figure window
        f = figure('name', 'Spacecraft Database Options');
        set(f, 'MenuBar', 'none')
        set(f, 'ToolBar', 'none')
        set(f, 'Position', [100 100 500 600])
        
        h = uibuttongroup('parent', f);
        
        uicontrol('Style', 'text', 'String', 'Choose desired SC Database', ...
            'pos', [10 500 500 20], 'parent', h, 'fontweight', 'bold', 'fontsize', 12)
        
        uicontrol('Style', 'radio', 'String', ... % use current SC DB
            ['Use current SC database: ' handles.DBname],...
            'pos', [10 400 1000 20], 'tag', 'b1', 'parent', h);
        
        uicontrol('Style', 'radio', 'String', 'Get new SC database',... % choose new SC DB
            'pos',[10 350 1000 20], 'tag', 'b2', 'parent', h);
        
        uicontrol('Style', 'checkbox', 'String', 'Get new ATMS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
            'pos', [10 300 1000 20], 'tag', 'atms', 'parent', h)
        
        uicontrol('Style', 'checkbox', 'String', 'Get new OMPS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
            'pos', [10 250 1000 20], 'tag', 'omps', 'parent', h)
        
        uicontrol('Style', 'checkbox', 'String', 'Get new CERES database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
            'pos', [10 200 1000 20], 'tag', 'ceres', 'parent', h)
        
        uicontrol('Style', 'checkbox', 'String', 'Get new VIIRS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
            'pos', [10 150 1000 20], 'tag', 'viirs', 'parent', h, 'enable', 'off') % TODO Eneble once Viirs DB works  
        
        uicontrol('Style', 'checkbox', 'String', 'Get new CrIS database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
            'pos', [10 100 1000 20], 'tag', 'cris', 'parent', h, 'enable', 'off')         % TODO Eneble once CRiS DB works 
        
        b3 = uicontrol('Style', 'PushButton', 'String','Ok', ... % also choose/not choose Sci DB
            'pos', [10 50 100 20], 'Callback' ,@b3Callback, 'parent', h);
        
        
        
        uiwait(f)
        
        if ~isvalid(f), return; end % user cancelled
        
        bStruct = get(b3, 'UserData'); % contains the SC database choice, as well as sci
        
        close(f)
        
        if strcmp(bStruct.sel, 'b2') % SC database choice
            handles = newDBfun(hObject, eventdata, handles);
        end
        
        if ~isempty(bStruct.insStr)
            writeCSVForDecom(bStruct.insStr);
        end
        



    end
    
    function b3Callback(src, event)
        % for use in proc_bin_button_Callback
        sel = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        
        children = get(get(src, 'Parent'), 'Children'); 
        sciBs = children(2:6); % all the children representing science button options
        
        insStr = {}; % this will be turned into a comma-separated list of instrument names for writeCSVForDecom 
        
        for j = 1:length(sciBs)
            
            sciB = sciBs(j);
            if strcmp(get(sciB, 'enable'), 'on') && get(sciB, 'value')
                insStr = {insStr{:}, get(sciB, 'tag')}; % The tags of the buttons have been named according to their instrument
            end
        end
        
        toReturn = struct('sel', sel, 'insStr', strjoin(insStr, ', ')); % create struct for User Data field of b4, so it can be accessed after this function returns.
        
        set(src, 'UserData', toReturn)

        
        uiresume()
    end
   
    if isempty(handles.DBDptr), return; end      
    
    % these next few blocks call the  CXXDecomQt executable, wait for it to exit, then this
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
    
        system('cd ..\Decom_tools && CXXDecomQtWin\CXXDecomQt.exe && cd ..\Matlab_tools');
    end
    if isunix
        setenv('LD_LIBRARY_PATH', LD_LIBRARY_PATH); % set the path back to the original
    end
    
    if ~exist('../Decom_tools/output', 'dir'), return; end % user stopped execution of CXXDecomQt
       
    if exist('../Decom_tools/output/Error_Log.txt', 'file')
     % the error log is for debugging Decom. We dont want to move it into the data directory by accident, so rename it
        if isunix, system('mv ../Decom_tools/output/Error_Log.txt ../Decom_tools/output/Error_Log'); 

        
        else, system('move ..\Decom_tools\output\Error_Log.txt ..\Decom_tools\output\Error_Log'); 

        end
    end
    
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
    dfExists = exist(datesF, 'file');
    if dfExists % OMPS, or ATMS files have date in the name, so use that. Otherwise it is CERES or CriS data, which doesnt have a useful naming scheme in any shape or form
    
        id = fopen(datesF);
        line1 = fgetl(id); % get the first and only line from the file
        fclose(id);

        delete(datesF); % delete this file. We dont need it anymore

        namesWithPath = strsplit(line1, '.h5'); % get the basnames of the two filenames, with full  path
        [~,baseName1] = fileparts(namesWithPath{1}); % strip the path
        [~,baseName2] = fileparts(namesWithPath{2});
    
    else % CERES, CRiS, or whoever else doest use h5
        % we need to go into one of the text files, read in the first and
        % last line to get the start and end time
        fTmp = {f2.name};
        f1 = fTmp{1}; % get one filename from the output to get the times
        numL = perl('countLines.pl'); % This perl function quickely counts the number of lines in the file
        line1 = dlmread(f1, ',', [1 0 1 2]); % Read first data line, and just the first three cols to get the time and date
        lineN = dlmread(f1, ',', [numL-1 0 numL-1 2]) ;% read the last line, first three cols
        
        t1 = line1(1) + line1(2)/86400000 + line1(3)/86400000000; % convert to days
        t2 = lineN(1) + lineN(2)/86400000 + lineN(3)/86400000000; % convert to days
        
        % create a fake base filename for below to extract the date;
        % scidInDb is just the scid found in the database that the user
        % chose. THere is no other way to tell which SCID we have.
        baseName1 = ['_' scidInDb '_d' datestr(t1, 'yyyymmdd') '_t' datestr(t1, 'HHMMSSF')]; 
        baseName2 = ['_' scidInDb '_d' datestr(t2, 'yyyymmdd') '_t' datestr(t2, 'HHMMSSF')]; 
        
        % TODO test this

    end
        
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
    


end

function [dbNeeded, scNeededFlag, scidInDB] = checkDBs(currSupportedInstr)
% check if the databases exist for all supported instrumen science,
% specified by thecomma separated list 'supporteedInstr'
    
    insList = strip(string(strsplit(currSupportedInstr, ','))); % extract a string array from the comma separated list

    % get a list of all the files to check for existence
    files = fullfile('../Decom_tools/databases', cellstr(insList + 'database.csv'));
    
    dbNeeded = {};
    
    % loop through al of the files an check for thei existence
    for i = 1:length(files)
        file = files{i}; % extract full path and file name with extension
        ins = insList{i}; % extract just ins name
    
        % check if the file exists, if it does, ad it to the list
        if ~exist(file, 'file'), dbNeeded = {dbNeeded{:}, ins};
        end
    end
    
    dbNeeded = strjoin(dbNeeded, ', '); % place it back in a list for writeCSVForDecom
    
    scNeededFlag = 0; 
    
    nppDB = '../Decom_tools/databases/nppdatabase.csv';
    j1DB = '../Decom_tools/databases/j1database.csv';
    j2DB = '../Decom_tools/databases/j2database.csv';
    j3DB = '../Decom_tools/databases/j3database.csv';
    j4DB = '../Decom_tools/databases/j4database.csv';
    
    scids = {'npp', 'j01', 'j02', 'j03', 'j04'};
    
    existArr = [exist(nppDB, 'file')>0, exist(j1DB, 'file')>0, exist(j2DB, 'file')>0 ...
            ,exist(j3DB, 'file')>0, exist(j4DB, 'file')>0] ; % logical array of existence for each database

    scidInDB = '';
    if any(existArr)
        scidInDB = scids{existArr}; % This is only used for CERES and CriS, since they dont have this info in the filename
    end
    
    % check if at least one of these files exists
    if ~any(existArr)
        scNeededFlag = 1;
    end
end