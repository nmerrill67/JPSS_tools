function handles = runDecom(hObject, eventdata, handles, newDBfun)
    % runs decom binaries and py script. newDBfun
    % hObject, eventdata, handles - all things from normal GUI callbacks
    % newDBfun - function handle to a functions that updates the DBDptr and
    % DBname
    if ~exist('../Decom_tools/databases/scdatabase.csv', 'file') || isempty(handles.DBname)% if there is no DB for the decom, prompt for one by default
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
    
    % this c executable calls Decom, waits for it to exit, then this
    % script waits for the python to exit.
    system('cd ../Decom_tools && ./CXXDecomQt/build/bin/CXXDecomQt && cd ../Matlab_tools');
  
    if ~exist('../Decom_tools/output', 'dir'), return; end % user stopped python execution of CXXDecomQt
    
    % create directory tree for ease of use
    f = dir('../Decom_tools/output/*.pkt');
    f = [f.name]; % all the pkt filenames in ../Decom_tools/output\
    if isempty(f), return; end % user stopped py execution, or something like that
    
    
    f2 = dir('../Decom_tools/output/*.txt');
    f2 = [f2.name]; % all the txt filenames in ../Decom_tools/output
    if isempty(f2)
    % move the text files into the correct dir 
        if ispc
            system('move ..\Decom_tools\output\*.pkt ..\Decom_tools\binaryFiles');

        else % linux
            system('mv ../Decom_tools/output/*.pkt ../Decom_tools/binaryFiles');
        end        
        return
    end % user stopped the cpp terminals from executing. So dont bother running the rest of the code
    
    
    vec = strsplit(f, '_');
    
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
    d1 = char(vec(end-3)); % start date of data yyyymmdd
    t1 = char(vec(end-2)); % start time HHMMSSF
    d2 = char(vec(end-1)); % end date yymmd
    t2 = char(vec(end));
    date = [d1(6:7) '-' d1(8:9) '-' d1(2:5) '_' t1(2:end-1) '__' d2(6:7) '-' d2(8:9) '-' d2(2:5) '_' t2(2:end-5)]; % now mm-dd-yyyy_HHMMSS__mm-dd-yyyy_HHMMSS
    
    if ~exist(fullfile(pwd, 'data'), 'dir'), system(['mkdir ' fullfile(pwd,'data')]); end
    
    if ~exist(fullfile(pwd,'data', scid), 'dir') % make the dirs if they dont exist
        system(['mkdir ' fullfile(pwd,'data', scid)]);
    end
    
    if ~exist(fullfile(pwd,'data', scid, date), 'dir') % make the dirs if they dont exist
        system(['mkdir ' fullfile(pwd,'data', scid, date)]);
    end    
    
    vec2 = strsplit(f2, {'.txt','_'});
    dataType = {};
    if ismember('spacecraft', lower(vec2)) % see if science and/or SC data
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
        system('move ..\Decom_tools\output\*.pkt ..\Decom_tools\binaryFiles');

    else % linux
        for i = 1:length(newDirName)
            if strcmp(dataType{i}, 'Spacecraft_Data')
                wildcard = 'SPACECRAFT_* '; % all of this is in case the user decoms SC and science data at the same time
            else
                wildcard = '*.txt ';
            end            
            system(['mv ../Decom_tools/output/' wildcard newDirName{i}]);
        end
        system('mv ../Decom_tools/output/*.pkt ../Decom_tools/binaryFiles');
    end
    
    msgbox(['Data files have been written to ' fullfile(pwd,'data', scid, date)])
    
    function b3Callback(src, event)
    % for use in proc_bin_button_Callback
        str = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        set(src, 'UserData', str)
        uiresume()
    end

end