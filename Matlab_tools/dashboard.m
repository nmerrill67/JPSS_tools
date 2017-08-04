function varargout = dashboard(varargin)
    % DASHBOARD MATLAB code for dashboard.fig
    %      DASHBOARD, by itself, creates a new DASHBOARD or raises the existing
    %      singleton*.
    %
    %      H = DASHBOARD returns the handle to a new DASHBOARD or the handle to
    %      the existing singleton*.
    %
    %      DASHBOARD('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in DASHBOARD.M with the given input arguments.
    %
    %      DASHBOARD('Property','Value',...) creates a new DASHBOARD or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before dashboard_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to dashboard_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help dashboard

    % Last Modified by GUIDE v2.5 20-Jul-2017 12:26:18

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @dashboard_OpeningFcn, ...
                       'gui_OutputFcn',  @dashboard_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
   
end


% --- Executes just before dashboard is made visible.
function dashboard_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to dashboard (see VARARGIN)

    % Choose default command line output for dashboard
    handles.output = hObject;

       
    handles.DBDptr = ''; % pointer to the read-in database definition table

    handles.epoch = datenum('01-jan-1958','dd-mmm-yyyy'); % this is used multiple times so we might as well store it for speed
    
    handles.prevPath1 = fullfile(pwd, 'data'); % changes later to point user in the last used directory for data
    handles.prevPath2 = handles.prevPath1; % there are only two paths, because we wnat aux2, and aux3 to be from the same time frame
        
    handles.DBname = ''; % name of curr database stripped of extension
    
    % Update handles structure
    guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = dashboard_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) % GNERAL HK ENABLE PROCESS
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(handles.text8, 'visible', 'on')
    set(handles.pushbutton15, 'visible', 'on'); % Tlm Descr
    
    set(handles.pushbutton8,'visible','on'); %  EANBLE FFT BUTTON
    set(handles.pushbutton9,'visible','on');  % ENABLE LOAD MAIN FILE BUTTON

    set(handles.pushbutton25, 'visible','on'); % clear Main visible
    set(handles.pushbutton24, 'visible','on'); % clear AUX visible
    set(handles.text18, 'visible','on'); % clear Main visible


    set(handles.pushbutton16,'visible','on');  % ENABLE LOAD AUX 1 FILE BUTTON
    %set(handles.pushbutton17,'visible','on');  % ENABLE LOAD AUX 2 FILE BUTTON
    set(handles.radiobutton5, 'value',1); % SET FIRST PLOT DEFAULT TO LINE PLOT

    set(handles.radiobutton7, 'value',1); % SET SECOND PLOT DEFAULT TO lINE PLOT

    set(handles.radiobutton3, 'value',1); % SET Main Plot to Time Series
    set(handles.radiobutton4, 'value',0); % Default is Time Series and not 3D


    set(handles.radiobutton6, 'value',0); % RESET FIRST PLOT SCATTER PLOT BUTTON
    set(handles.radiobutton8, 'value',0); % RESET SECOND PLOT SCATTER PLOT BUTTON

    set(handles.radiobutton17, 'value',0); % reset Calibrated Plot Button for PLOT Main

    set(handles.radiobutton18, 'value',0); % reset Calibrated Plot Button for PLOT AUX

    set(handles.radiobutton21, 'value',0); % reset the AUX 1 Sort Function
    set(handles.radiobutton22, 'value',0); % reset the AUX 1 Delte Dups function

    set(handles.radiobutton15, 'value',0); % reset the AUX 2 Sort Function
    set(handles.radiobutton16, 'value',0); % reset the AUX 2 Delte Dups function

    set(handles.radiobutton19, 'value',0); % reset the Main Plot Sort Function
    set(handles.radiobutton20, 'value',0); % reset the Main Plot Dups function





    handles.file3 = 0; % initialize file state as 'zero' meaning NOT open
    handles.file2 = 0;
    handles.file1 = 0;

    radiobutton3_Callback(hObject, eventdata, handles)

    %add code to clear file names and paths and clear AXES1 and AXES2

    handles.pb15_first_time = 0;
    guidata(hObject,handles);
end

% --- Executes on button press in popup2.
function popup2_Callback(hObject, eventdata, handles) % ATMS PopUp Select menue
    % hObject    handle to popup2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    contents = get(handles.popup2,'String');
    popCheck = contents(get(handles.popup2,'Value'));
    
    % swtich to change to other GUI window
    switch strip(popCheck{1})
        case 'Data Evaluation'
            return % We are already here, so return
        case 'Science 3D EMI'
            science3d_emi
            close(handles.figure1)
        case 'Dwell FFT'
            dwell_fft_tool
            close(handles.figure1)
        case 'Frequency Calculator'
            frequency_gui
            close(handles.figure1)            
    end
end



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles) % FFT PUSHBUTTON
    % hObject    handle to pushbutton8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    %TODO add capablity for sample subset based on time
    if handles.indiciesA4 ~= 1
        h = warndlg('A temporal Fourier Transform will be calculated. Cannot perform FFT over telemetry data domain');
        uiwait(h)
    end
    
    if ~isfield(handles, 'labels1')
        errordlg('Must load data first')
        return
    end
    
    handles.y1label = handles.labels1(1, handles.indiciesA5);
        
    
    mins = handles.dates1 + handles.epoch + floor(handles.sec1/60)/1440; % only carry up to min for slider
    [mins, origInds, ~] = unique(mins); % get the row ind of where the data came from for later use
    minsStr = datestr(mins, 'mm/dd/yy HH:MM');
    

    f = figure('Name' ,'Fourier Tranform Options', 'Color', [1 1 1]);         
    set(f, 'MenuBar', 'none')
    set(f, 'ToolBar', 'none')
    
    uicontrol('style', 'text', 'String', 'Select the time frame to perform the FFT on (hint: use the arrows or arrow keys to move the slider by 1 minute)',...
        'position', [10, 300, 500, 40]);    
    
    uicontrol('style', 'text', 'String', 'FFT Start Time:', 'position', [10, 260, 75, 20]);
    t11 = uicontrol('style', 'text', 'position',[100, 260, 75, 20], 'parent', f);    
    s1 = uicontrol('style', 'slider', 'parent',f,...
        'position',[10 210 500 20], 'Min', 1, 'Max',  length(mins), 'SliderStep',...
        [0.004 0.1], 'Value', 1, 'Callback', @s1Callback, 'ButtonDownFcn', @s1Callback);
    set(t11, 'String', minsStr(floor(get(s1, 'Value')),:))
    
    uicontrol('style', 'text', 'String', 'FFT End Time:', 'position', [10, 160, 75, 20]);
    t22 = uicontrol('style', 'text', 'position', [100, 160, 75, 20],'parent', f)    ;
    s2 = uicontrol('style', 'slider', 'parent', f, 'position',[10 110 500 20]...
        , 'Min', 1, 'Max',  length(mins), 'SliderStep', [0.004 0.1], 'Value', size(minsStr,1), ...
        'Callback', @s2Callback, 'ButtonDownFcn', @s2Callback );
    set(t22, 'String', minsStr(floor(get(s2, 'Value')),:))
    b1 = uicontrol('style', 'pushbutton', 'parent',f, ...
        'String', 'Ok', 'position', [10, 10, 100, 20], ...
        'CallBack' ,@b1Callback);
    uiwait(f)

    if isvalid(f)
        startStop = round(get(b1, 'UserData'));
    else % user closed the fft options box
        return
    end
    
    close(f)
    
    function s2Callback(src, event)
        set(t22, 'String', minsStr(floor(get(src, 'Value')),:))
    end
            
    function s1Callback(src, event)
        set(t11, 'String', minsStr(floor(get(src, 'Value')),:))
    end

    function b1Callback(src, event)

        ss = [get(s1, 'Value'); get(s2, 'Value')]; 
        set(src, 'UserData', ss) % put the values from the sliders in b1.UserData for access
        uiresume()
    end

    start = startStop(1); stop = startStop(2);

    inds = origInds(start):origInds(stop); % the range of row indices to use in the data matrix
    numRows = length(inds); % number of samples in Fourier Transform
    
    if (stop-start)<1
        h = errordlg('Invalid time frame');
        uiwait(h)
        return
    end
    
   % datestr(handles.sec1(origInds(startStop))/86400 + ... 
   % handles.dates1(origInds(startStop)) + handles.epoch, 'dd-mmm-yyyy ...
   % HH:MM') % testing
    
    delta_t = handles.delta_t1;
    delf = (1/numRows)*(1/delta_t);% frequency increment for fft
    nf = round((numRows/2)+1);
    fr = 0:delf:(nf-1)*delf; % frequency


    fft_plot1 = fft(handles.telemdata1(inds,handles.indiciesA5)); % only take the specified rows from the slider

    f1=fft_plot1(1:nf, :);
    
    fmag1=2*abs(f1)/numRows;
    
    mags = max(fmag1, [], 1);% max mags across the columns
    fmag1 = fmag1./mags; % normalize amplitude

    size_fmag=max(size(fmag1));
    size_fr=max(size(fr));
    plot_size = min(size_fmag,size_fr);
    
    fig = figure('name' ,'Fourier Transform Plots');

    textBox = uicontrol('style','text');
    set(textBox,'String', handles.name1);
    set(textBox, 'Position', [15 710 275 20]); 
    textBox2 = uicontrol('style','text');
    set(textBox2,'String', [handles.startdatestr1, ': ', handles.startT1, '  -  ', handles.stopdatestr1, ': ', handles.stopT1]);
    set(textBox2, 'Position', [450 710 275 20]); 

    % some simple math to get the right number of subplots for multiple
    % selected telemetry data
    numPlots = size(f1, 2);
    sq = sqrt(numPlots);
    rows = ceil(sq);
    cols = ceil(numPlots/rows);
    
    for i = 1:numPlots
        subplot(rows, cols, i)
        plot(fr(2:plot_size), fmag1(2:nf, i), 'Linewidth', 1.5);
        xlabel('\nu (Hz)');
        h = title(handles.y1label(i));
        set(h, 'Interpreter', 'none')
    end
    
    dc = datacursormode(fig); % fix data cursor to show time
    set(dc, 'UpdateFcn', @dcUpdateFFT)    
    set(dc, 'SnapToDataVertex', 'on')
    guidata(hObject, handles);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)% ------- APID/SYBSYSTEM LIST OF AUX 1 PLOT
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox1
    handles.indiciesA1 = get(handles.listbox1,'Value');
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA1 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on selection change in listbox2. - AUX 2 FILE TLM LIST
function listbox2_Callback(hObject, eventdata, handles)% ------- SECOND TLM LIST OF FIRST PLOT
    % hObject    handle to listbox2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox2
    handles.indiciesA2 = get(handles.listbox2,'Value');
    guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA2 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject, handles);
end


% --- Executes on button press in radiobutton3. - Time Series SELECTION FOR MAIN
% FILE PLOT
function radiobutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton3
    if get(handles.radiobutton3, 'value')
        set(handles.text37, 'string', 'MAIN Y-Axis')
        set(handles.pushbutton26, 'visible', 'off') % config 3d plot button
        set(handles.radiobutton4, 'value',0 );  % turn off 3D button
        set(handles.edit3,'visible','off');  % turn off # of Slices window
        set(handles.edit4,'visible','off');  % turn off Current Slice window
        set(handles.edit5,'visible','off');  % turn off Column Start window
        set(handles.edit6,'visible','off');  % turn off Column End window    

        set(handles.pushbutton19,'visible','off');  % turn off left arrow button
        set(handles.pushbutton20,'visible','off');  % turn off right arrow button
        set(handles.listbox4,'visible','on');  % make sure that List Box 4 is Visible
        set(handles.text38, 'visible', 'on'); 
    else
        set(handles.text37, 'string', 'Data Columns')
        set(handles.pushbutton26, 'visible', 'on') % config 3d plot button
        set(handles.radiobutton4, 'value',1);   % turn on 3D button 
        set(handles.edit3,'visible','on');  % turn on # Slices window
        set(handles.edit4,'visible','on');  % turn on Current Slice window
        set(handles.edit5,'visible','on');  % turn on Column Start window
        set(handles.edit6,'visible','on');  % turn on Column End window    
        set(handles.pushbutton19,'visible','on');  % turn on left arrow button
        set(handles.pushbutton20,'visible','on');  % turn on right arrow button
        set(handles.listbox4,'visible','off');  % Listbox 4 not needed when in 3D mode
        set(handles.text38, 'visible', 'off'); 

    end
    if isfield(handles, 'sec1'),pushbutton11_Callback(hObject, eventdata, handles); end   
    guidata(hObject,handles);
end


% --- Executes on button press in radiobutton4. - 3D SELECTION FOR
% MAIN FILE PLOT
function radiobutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton4
    if get(handles.radiobutton4, 'value')
        set(handles.text37, 'string', 'Data Columns')
        set(handles.text38, 'visible', 'off'); 
        set(handles.pushbutton26, 'visible', 'on') %  config 3D plot button
        set(handles.radiobutton3, 'value',0 );  % turn off 'TIME Series' button     
        set(handles.edit3,'visible','on');  % turn on # of Slices to partition the data into
        set(handles.edit4,'visible','on');  % turn on Current Slice window
        set(handles.edit5,'visible','on');  % turn on Column start window
        set(handles.edit6,'visible','on');  % turn on Column End window
        set(handles.pushbutton19,'visible','on');  % turn on left arrow function
        set(handles.pushbutton20,'visible','on');  % turn on right arrow function
        set(handles.listbox4,'visible','off');  % listbox 4 not needed in 3D mode

        pushbutton26_Callback(hObject, eventdata, handles)
    else
        set(handles.text37, 'string', 'MAIN Y-Axis')  
        set(handles.text38, 'visible', 'off'); 
        set(handles.pushbutton26, 'visible', 'off') %  config 3D plot button
        set(handles.pushbutton26, 'visible', 'on')
        set(handles.radiobutton3, 'value',1);  % enable Time series button  
        set(handles.edit3,'visible','off');  % turn off # Slices window
        set(handles.edit4,'visible','off');  % turn off Current Slice window
        set(handles.edit5,'visible','off');  % turn off Column Start window
        set(handles.edit6,'visible','off');  % turn off Column End window
        set(handles.pushbutton19,'visible','off');  % turn off left arrow button
        set(handles.pushbutton20,'visible','off');  % turn off right arrow button
        set(handles.listbox4,'visible','on');  % listbox needed in time series mode
    end
    
    if isfield(handles, 'sec1'),pushbutton11_Callback(hObject, eventdata, handles); end   

    guidata(hObject,handles);
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)% ------- APID/SYBSYSTEM LIST OF MAIN PLOT
    % hObject    handle to listbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox3
    handles.indiciesA3 = get(handles.listbox3,'Value');
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA3 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject, handles);
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)% ------- SECOND TLM LIST FOR MAIN PLOT
    % hObject    handle to listbox4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox4
    handles.indiciesA4 = get(handles.listbox4,'Value');
    guidata(hObject,handles);
end



% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles) 
    % hObject    handle to listbox4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA4 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on button press in pushbutton9.  - LOAD MAIN FILE PUSHBUTTON
function pushbutton9_Callback(hObject, eventdata, handles)

    % hObject    handle to pushbutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    set(handles.listbox4, 'value', 1); % this prevents the listbox from crashing due to dissapearing fields
    set(handles.listbox5, 'value', 1); % this prevents the listbox from crashing due to dissapearing fields
    tmpStr = get(handles.text24, 'string');
    set(handles.text24, 'String', 'loading ...')    
    [handles.name1, path1] = uigetfile(fullfile(handles.prevPath1,'*.txt')); %Modify for csv, txt, etc
       
    if ~path1
        set(handles.text24, 'String', tmpStr)    
        return
    else
        handles.prevPath1 = [path1 '/..'];
    end

    set(handles.figure1, 'pointer', 'watch') % hourglass pointer (nice aesthetic)
    
    
    A = readtable(fullfile(path1, handles.name1),'delimiter', ','); % automatically assigns varnames to files with no headers

    handles.indiciesA4 = 1;
    handles.indiciesA5 = 1;

    handles.file1 = 1;

    if any(isnan(A{:,end})) % sometimes readtable adds an extra column
        A = A(:,1:end-1); % cut off the last column, which contains a ton of NaN
    end
    handles.labels1 = A.Properties.VariableNames;
    if ~strcmp(handles.labels1{1}(1:3), 'Var') % sorts like Var1, Var100, Var2, Var23. So make it leave those alone
        [handles.labels1, sortInds] = sort(handles.labels1);
    else
        sortInds = 1:length(handles.labels1);
    end
    handles.telemdata1 = table2array(A);
    
    handles.telemdata1 = dataCorrection(handles.telemdata1, ...
        get(handles.radiobutton19,'value'), get(handles.radiobutton20,'value')); % data correction


    [handles.rows1, handles.cols1] = size(handles.telemdata1);

    handles.defaultAnswer = {'4', num2str(handles.cols1)};% for 3D plot config

    set(handles.listbox4,'String',['Time', handles.labels1]);

    set(handles.listbox5,'String',handles.labels1);


    set(handles.pushbutton25,'visible','on'); %  EANBLE CLEAR MAIN PLOT BUTTON
    set(handles.pushbutton11,'visible','on'); %  EANBLE MAIN PLOT BUTTON

    handles.dates1 = handles.telemdata1(: ,1 );



    handles.millisec1 = handles.telemdata1(: , 2);
    handles.micsec1 = handles.telemdata1(: ,3);
    
    %handles.pktcount = handles.telem(:,4); % hours
    handles.sec1 = double((handles.millisec1 / 1000) + (handles.micsec1 / 1000000)); % seconds since midnight that day
    
    handles.delta_t1 = mean((handles.dates1(2:end)*86400 + handles.sec1(2:end)) -...
        (handles.dates1(1:end-1)*86400 + handles.sec1(1:end-1))); % get a more robust freq measurement this way

    
    set(handles.text8,'string',['Avg Main Rate: ',num2str(1/handles.delta_t1),' HZ']);
    
    nSecs11 = handles.sec1(1);
    nSecs21 = handles.sec1(handles.rows1);

    handles.startT1 = datestr(nSecs11/86400, 'HH:MM:SS.FFF');
    handles.stopT1 = datestr(nSecs21/86400, 'HH:MM:SS.FFF');
    handles.elapsedsec1 = sec2time(handles.sec1, handles.dates1, handles.epoch);

    handles.startdatestr1 = datestr(handles.dates1(1) + handles.epoch, 'dd/mmm/yyyy');
    handles.stopdatestr1 = datestr(handles.dates1(end) + handles.epoch, 'dd/mmm/yyyy');
    set(handles.text12, 'string', ['Start Date: ', handles.startdatestr1]);
    set(handles.text5, 'string', ['Stop Date: ', handles.stopdatestr1]);

    set(handles.figure1, 'pointer', 'arrow') % hourglass pointer back to normal
    set(handles.text24,'String', ['Main File: ', handles.name1]);
    
    handles.telemdata1 = handles.telemdata1(:, sortInds); % reorder based on alphebetization
    guidata(hObject,handles);
end

% --- Executes on button press in screen_copy_button. ------------- SAVE WINDOW IMAGE FILE PUSHBUTTON
function screen_copy_button_Callback(hObject, eventdata, handles)
    % hObject    handle to screen_copy_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % all pictures saved to ./SAVED_SCREENS
    
    
    tmp = strsplit(get(handles.edit3, 'string'), ':'); % # slices
    handles.slices = str2double(tmp{2});

    handles.index1 = floor((handles.rows1)/handles.slices);
    currslice = str2double(get(handles.edit4, 'string'));   % current slice     

    endInd = floor(handles.index1*currslice); % Last row index in slice

    %First row index in slice
    if currslice == 1
        startInd = 1;
    else
        startInd = handles.index1 * (currslice - 1);
    end

    t = [handles.sec1(startInd)/86400 + handles.epoch + handles.dates1(startInd);...
        handles.sec1(endInd)/86400 + handles.epoch + handles.dates1(endInd)];
    
    saveScreen(handles.prevPath1, @pushbutton11_Callback, handles.text24, handles.figure1...
        , t, hObject, eventdata, handles);
end



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)% ------------- SAVE FILE NAME
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)% --------- TLM LIST OF MAIN PLOT
    % hObject    handle to listbox5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox5

    handles.indiciesA5 = get(handles.listbox5,'Value');
    guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA5 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on button press in pushbutton11.% -- PLOT PUSHBUTTON MAIN
% 
function pushbutton11_Callback(varargin)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if nargin==3 % normal calling from guimainfun
        hObject = varargin{1};
        eventdata = varargin{2};
        handles = varargin{3};
        telemdata1 = handles.telemdata1;
    else % called from saveAsPPTX
        hObject = varargin{1};
        eventdata = varargin{2};
        handles = varargin{3};
        telemdata1 = varargin{4};
    end

    pushbutton25_Callback(hObject, eventdata, handles) % clear plot to resolve random issues of things remaining
    if get(handles.radiobutton4, 'value') % if #3D plot requested
    % Used to Slice up Data
        if get(handles.radiobutton17, 'value')
            h = warndlg('Calibration not available for 3D plot');
            uiwait(h);
            set(handles.radiobutton17, 'value', 0)
        end    
           
        tmp = strsplit(get(handles.edit3, 'string'), ':'); % # slices
        handles.slices = str2double(tmp{2});
        
        handles.index1 = floor((handles.rows1)/handles.slices);
        currslice = str2double(get(handles.edit4, 'string'));   % current slice     
        
        endInd = floor(handles.index1*currslice); % Last row index in slice

        %First row index in slice
        if currslice == 1
            startInd = 1;
        else
            startInd = handles.index1 * (currslice - 1);
        end

        if strcmp(handles.edit5, 'Start Col')
            set(handles.edit5, 'string', strcat({'Start Col: '}, {'1'}));  % initialize start column for 3D plot at column 1
        end

        if strcmp(handles.edit6, 'End Col')
            set(handles.edit6, 'string', strcat({'End Col: '}, {num2str(handles.rows1)}));
        end
        %nSecs1 = handles.sec1(startInd); % seconds of slice start time period
         %   nSecs1_T = handles.sec_atms_total(startInd); % seconds of slice start time period
        %nSecs2 = handles.sec1(endInd); % seconds of slice end time period

        %startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF'); % formatted tiem of day for slice start
        %stopT = datestr(nSecs2/86400, 'HH:MM:SS.FFF'); % formatted time of day for slice end


         %   set(handles.text12, 'string', ['File Content: ', filestartdate, ' ', filestart, ' - ', filestopdate, ' ', filestop]);

            % Set left plot   LEFT OVER FROM ORIGINAL 3D PLOT
        axes(handles.axes2);

        tmp = get(handles.edit5, 'string');
        tmp = strsplit(tmp, ': ');% annoying cell array stuff
        tmp = tmp(end);
        start_col = str2double(tmp{1});
        if(start_col<0)
            start_col = 1;
            set(handles.edit5,'string',num2str(start_col));
        end

        tmp = get(handles.edit6, 'string');
        tmp = strsplit(tmp, ': ');% annoying cell array stuff
        tmp = tmp(end);

        end_col = str2double(tmp{1});

        if(end_col>handles.cols1)
            end_col = handles.cols1;
            set(handles.edit6,'string',strcat({'End Col: '},{num2str(end_col)}));
        end
        
        
        
        t = handles.sec1/86400 + handles.epoch + handles.dates1;
        surf(t(startInd:endInd), start_col:end_col,rot90(telemdata1(startInd:endInd, start_col:end_col)),...
            'EdgeColor','None', 'facecolor', 'flat');
        view(2);
        handles.colormap = colormap('jet');
        handles.colorbar = colorbar('eastoutside');
        axis tight;
        ylabel('Data Column');

        %if strcmp(str{val}, 'Uncalibrated');
        zlabel('Counts');
        %    zlabel('Degrees K')
        %end
        title(['Slice ', num2str(currslice), ', Scans ', num2str(startInd), '-', num2str(endInd)]);

        datetick('x', 'HH:MM:SS', 'keepticks', 'keeplimits' )
        %ylabel('Scan Number')
        
        set(gca, 'YtickLabelRotation', 45)
        set(gca, 'XtickLabelRotation', 45)
        set(gca, 'FontSize', 8)
        set(gca, 'FontWeight', 'bold')
        set(gca, 'XtickMode', 'auto')


    else % 2D plot
        try delete(handles.colorbar);catch; end % colorbar seems to remain otherwise
        try delete(handles.colormap);catch; end % colorbar seems to remain otherwise

        if handles.indiciesA4 == 1 % x axis is  time
            x1 = handles.sec1/86400+ handles.epoch + handles.dates1;% change epoch to matlab's 00-00-0000
            %handles.elapsedsec1;
            

            %x1label = 'Time (s)';
        else
            x1 = telemdata1(:, handles.indiciesA4 - 1); % minus 1 used to make up for adding 'time' to the list
            x1label = handles.labels1(1, handles.indiciesA4 - 1);
        end

        y1label = handles.labels1(1, handles.indiciesA5);
        handles.y1label = y1label;

        if get(handles.radiobutton17, 'value') == 0 % raw counts
            data = telemdata1(:, handles.indiciesA5);
            y1label = y1label';
        else % calibrated
            [data, y1label] = calibrateData(telemdata1(:, handles.indiciesA5), handles.DBDptr, y1label);
        end

        axes(handles.axes2)
        if get(handles.radiobutton7, 'value') == 1 % if line plot
            plot( x1, data, 'Linewidth', 1.5); % first plot
        else % scatter plot
            hold on
            i = 1;
            while i <= size(data,2)
                scatter(x1, data(:,i), 2, 'filled');
                i = i + 1;
            end

            hold off

        end

        
        set(handles.axes2, 'XTickLabelRotation', 45)
        set(handles.axes2, 'YTickLabelRotation', 45)
        set(handles.axes2, 'XTickLabelMode', 'auto')
        set(handles.axes2, 'XMinorTick', 'on')
        set(handles.axes2, 'FontSize', 8)
        set(handles.axes2, 'FontWeight', 'bold')
        set(handles.axes2, 'XtickMode', 'auto')

        
        if handles.indiciesA4 == 1 % x axis is  time
            datetick('x', 'HH:MM:SS', 'keeplimits', 'keepticks')%, 'keepticks')
            x1label = 'Time of day (HH:MM:SS)';
            dc = datacursormode(handles.figure1); % fix data cursor to show time
            set(dc, 'UpdateFcn', @dcUpdate)
            set(dc, 'SnapToDataVertex', 'on')

        end
        
        grid on;
        ylim auto;
        xlabel(x1label);
        %ylabel(y1label);
        h = legend(y1label, "location", "best");
        set(h, 'Interpreter', 'none') % tex interpreter turns '_' into subscript
        title('Main Plot');


        colns = repStr(size(y1label, 1), ': ');

        new_std_entries = strcat({char(y1label)}, {colns}, {num2str(std(data)','%1.3e')}); % get new stdevs
        set(handles.listbox12, 'string', cellstr(new_std_entries)); % put them in the listbox for main StDev

        new_mean_entries = strcat({char(y1label)}, {colns}, {num2str(mean(data)','%1.3e')}); % get new means
        set(handles.listbox13, 'string', cellstr(new_mean_entries)); % put them in the listbox for  main mean    

    end

    guidata(hObject, handles);
end



% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)% ---------- FIRST TLM LIST OF AUX PLOT
    % hObject    handle to listbox6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox6 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox6
    handles.indiciesA6 = get(handles.listbox6,'Value');
    guidata(hObject,handles);
end



% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA6 = 1;

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton5. - LINE PLOT FOR AUX PLOT
function radiobutton5_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton5

    if get(handles.radiobutton5, 'value') == 1
        set(handles.radiobutton6, 'value',0 );
    else
        set(handles.radiobutton6, 'value',1);
    end

    pushbutton14_Callback(hObject, eventdata, handles)    
    guidata(hObject,handles);
end


% --- Executes on button press in radiobutton6. - SCATTER PLOT FOR AUX PLOT
function radiobutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton6
    if get(handles.radiobutton6, 'value')
        set(handles.radiobutton5, 'value',0 );
    else
        set(handles.radiobutton5, 'value',1);
    end
    pushbutton14_Callback(hObject, eventdata, handles)
    guidata(hObject,handles);
end




% --- Executes on button press in radiobutton7.  - LINE PLOT FOR MAIN PLOT
function radiobutton7_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton7
    if get(handles.radiobutton7, 'value')
        set(handles.radiobutton8, 'value',0 );
    else
        set(handles.radiobutton8, 'value',1);
    end
    if isfield(handles, 'sec1'),pushbutton11_Callback(hObject, eventdata, handles); end   
    guidata(hObject,handles);
end




% --- Executes on button press in radiobutton8. - SCATTER PLOT FOR MAIN
% PLOT
function radiobutton8_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton8
    if get(handles.radiobutton8, 'value')
        set(handles.radiobutton7, 'value',0 );
    else
        set(handles.radiobutton7, 'value',1);
    end
    if isfield(handles, 'sec1'),pushbutton11_Callback(hObject, eventdata, handles); end   
    guidata(hObject,handles);
end



% % --- Executes on button press in radiobutton2.
% function radiobutton2_Callback(hObject, eventdata, handles) % what is this?
%     % hObject    handle to radiobutton2 (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
%     % Hint: get(hObject,'Value') returns toggle state of radiobutton2
%     if get(handles.radiobutton2, 'value') == 0
%         set(handles.radiobutton10, 'value',0);
%     end
%     guidata(hObject,handles);
% end

% --- Executes on button press in radiobutton10.
% function radiobutton10_Callback(hObject, eventdata, handles)
%     % hObject    handle to radiobutton10 (see GCBO)
%     % eventdata  reserved - to be defined in a future version of MATLAB
%     % handles    structure with handles and user data (see GUIDATA)
% 
%     % Hint: get(hObject,'Value') returns toggle state of radiobutton10
%     if get(handles.radiobutton10, 'value') == 1
%         set(handles.radiobutton2,'value',1);
%     %    set(handles.radiobutton10,'value',1);
%     end
%     guidata(hObject,handles);
% end



% --- Executes on button press in radiobutton8. - SORT PLOT FOR MAIN
% PLOT
function radiobutton19_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton8
    if get(handles.radiobutton19, 'value')
        handles.telemdata1 = dataCorrection(handles.telemdata1, ...
            get(handles.radiobutton19,'value'), get(handles.radiobutton20,'value'));
    else
        pushbutton9_Callback(hObject, eventdata, handles)
    end
        
    guidata(hObject,handles);
end



% --- Executes on button press in radiobutton8. - delete dups FOR MAIN
% PLOT
function radiobutton20_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if get(handles.radiobutton20, 'value')
        handles.telemdata1 = dataCorrection(handles.telemdata1, ...
            get(handles.radiobutton19,'value'), get(handles.radiobutton20,'value')); 
    else
        pushbutton9_Callback(hObject, eventdata, handles)
    end
    % Hint: get(hObject,'Value') returns toggle state of radiobutton8
    
end

% --- Executes on button press in proc_bin_button. - PROCESS BINARY - CALL
% FORTRAN DECOM ROUTINE
function proc_bin_button_Callback(hObject, eventdata, handles)
    % hObject    handle to proc_bin_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)\
    
    handles = runDecom(hObject, eventdata, handles, @pushbutton22_Callback);
    
    guidata(hObject, handles)
end

% ------------ SC ID FOR AUX PLOT
function edit_sc_id_Callback(hObject, eventdata, handles)
    % hObject    handle to edit_sc_id (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit_sc_id as text
    %        str2double(get(hObject,'String')) returns contents of edit_sc_id as a double
end

    % --- Executes on selection change in listbox7. - APID/SYBSYSTEM LISTBOX FOR
    % AUX 2 FILE
function listbox7_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox7 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from listbox7
    handles.indiciesA7 = get(handles.listbox7,'Value');
    guidata(hObject,handles);
end



% --- Executes during object creation, after setting all properties.
function listbox7_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.indiciesA7 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton15. - SORT BUTTON FOR AUX2
% FILE
function radiobutton15_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton15
    if get(handles.radiobutton15, 'value')
        handles.telemdata3 = dataCorrection(handles.telemdata3, ...
            get(handles.radiobutton15,'value'), get(handles.radiobutton16,'value'));
    else
        pushbutton17_Callback(hObject, eventdata, handles)
    end
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton16. - Del Dups BUTTON FOR
% AUX2 FILE
function radiobutton16_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton16 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton16
    if get(handles.radiobutton16, 'value')
        handles.telemdata3 = dataCorrection(handles.telemdata3, ...
            get(handles.radiobutton15,'value'), get(handles.radiobutton16,'value'));  
    else
        pushbutton17_Callback(hObject, eventdata, handles) % need to reload data in orig form. Cant store old versions in memory
    end
    guidata(hObject,handles);
end



% --- Executes on button press in pushbutton14. - PLOT AUX FILE(S)
function pushbutton14_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton14 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    pushbutton24_Callback(hObject, eventdata, handles) % clearing plot
    if ~isfield(handles, 'file2'), return; end

    if ~(handles.file2 || handles.file3) % check to see if a Auxillary file is loaded
        h = errordlg('Please load an auxilary data file');
        guiwait(h);
        return
    elseif handles.file3 && ~handles.file2
        h = errordlg('Please load an auxilary data file 1 before 2');
        guiwait(h);
        return;
    end

    x2label = 'Time of Day (HH:MM:SS)';  % both plots are time based always
    if handles.file2 
        x2 = handles.sec2/86400+ handles.epoch + handles.dates2; 
        y2label = handles.labels2(1, handles.indiciesA6); % pick up name of aux1 plot parameter     

        if get(handles.radiobutton18, 'value') % calibrated
            [data2, y2label_tmp] = calibrateData(handles.telemdata2(:, handles.indiciesA6), handles.DBDptr, y2label);
        else % raw counts
            data2 = handles.telemdata2(:, handles.indiciesA6);
            y2label_tmp = y2label;
        end 

        if ~handles.file3
            colns = repStr(size(y2label', 1), ': ');

            new_std_entries = strcat({char(y2label)}, {colns}, {num2str(std(data2)','%1.3e')}); % get new stdevs
            set(handles.listbox14, 'string', cellstr(new_std_entries)); % put them in the listbox for aux1 stdev

            new_mean_entries = strcat({char(y2label)}, {colns}, {num2str(mean(data2)','%1.3e')}); % get new means
            set(handles.listbox15, 'string', cellstr(new_mean_entries)); % put them in the listbox fo StDev
        end
        y2label = y2label_tmp;
        handles.y2label = y2label;
    end
    if handles.file3 && get(handles.radiobutton23, 'Value')
        x3 = handles.sec3/86400+ handles.epoch + handles.dates3;
        y3label = handles.labels3(1, handles.indiciesA2); % pick up name of aux2 plot parameter   

        if get(handles.radiobutton18, 'value') % calibrated
            [data3, y3label_tmp] = calibrateData(handles.telemdata3(:, handles.indiciesA2), handles.DBDptr, y3label);
        else % raw counts
            data3 = handles.telemdata3(:, handles.indiciesA2);
            y3label_tmp = y3label;
        end 

        labels = char(char(handles.y2label), char(y3label_tmp));
        colns = repStr(size(labels, 1), ': ');

        new_std_entries = strcat({labels}, {colns}, {num2str([std(data2) std(data3)]','%1.3e')}); % get new stdevs
        set(handles.listbox14, 'string', cellstr(new_std_entries)); % put them in the listbox for aux1 stdev

        new_mean_entries = strcat({char(labels)}, {colns}, {num2str([mean(data2) mean(data3)]','%1.3e')}); % get new means
        set(handles.listbox15, 'string', cellstr(new_mean_entries)); % put them in the listbox fo StDev

        y3label = y3label_tmp; % this one has units attached
        handles.y3label = y3label;
    end

    if get(handles.radiobutton24, 'value') % if plot AUX derivatives requested
       for i = 1:size(data2, 2) % iterate over columns for different nemonics. If we take grad(data2) then it sees it as a vector field, not separate vectors
           % Aprox time derivative using centered finite diffrence formula.
           % Divide element wise for d/dt(j) data2(j,i)
            data2(:,i) = gradient( data2(:,i) )./gradient(x2); 
            y2label{i} = ['d/dt (' y2label{i} ')']; % renmae the label to correspond to derivative
       end
       if handles.file3 % do the same for aux 3
           for i = 1:size(data3, 2)
              data3(:,i) = gradient( data3(:,i) )./gradient(x3); 
              y3label{i} = ['d/dt (' y3label{i} ')']; % renmae the label to correspond to derivative
              
           end
       end        
    end    
    
    axes(handles.axes1);
    if get(handles.radiobutton5, 'value') % if line plot

        if handles.file3 && get(handles.radiobutton23, 'value') % radbutton23 is 'include aux'
            [handles.axes1, h1, h2] = plotyy(x2, data2, x3, data3);
            set(h1, 'Linewidth',1.5); set(h2, 'Linewidth', 1.5);

            set(handles.axes1(1), 'XTickLabelRotation', 45)
            set(handles.axes1(1), 'YTickLabelRotation', 45)
            set(handles.axes1(1), 'XTickLabelMode', 'auto')            
            set(handles.axes1(1), 'FontSize', 8)
            set(handles.axes1(1), 'FontWeight', 'bold')             
            
            set(handles.axes1(2), 'XTickLabelRotation', 45)
            set(handles.axes1(2), 'YTickLabelRotation', 45)
            set(handles.axes1(2), 'XTickLabelMode', 'auto')            
            set(handles.axes1(2), 'FontSize', 8)
            set(handles.axes1(2), 'FontWeight', 'bold') 

            h = legend([h1; h2], char(char(y2label), char(y3label)), "location", "best");

        else
            if handles.file3 && isvalid(handles.axes1(2))
                cla(handles.axes1(2));
            end % clear the plot
            handles.h2 = plot( x2, data2, 'Linewidth', 1.5); % plot only left
            h = legend(y2label, "location", "best");
            set(handles.axes1(1), 'XTickLabelRotation', 45)
            set(handles.axes1(1), 'YTickLabelRotation', 45)
            set(handles.axes1(1), 'XTickLabelMode', 'auto')            
            set(handles.axes1(1), 'FontSize', 8)
            set(handles.axes1(1), 'FontWeight', 'bold')             

        end

    else % if scatter plot
        
        if handles.file3 && get(handles.radiobutton23, 'value') % radbutton23 is 'include aux'
            [ax, h1, h2] = plotyy(x2, data2, x3, data3); % dont use the plot, just the handles
            delete(h1); delete(h2); % get the lines out of there, but keep the nice axes settings
            hold(ax(1), 'on')
            i = 1;
            len = size(data2,2) + size(data3, 2);
            axs = zeros(len, 1);
            while i <= size(data2,2)
                s = scatter(ax(1), x2, data2(:,i), 2, 'filled');
                s.MarkerFaceColor = s.CData; % workaround for Matlab bug with legend
                axs(i) = s;
                i = i + 1;
            end

            hold(ax(2), 'on'); % plot right side for aux2
            j = size(data2,2)+1;
            while j <= len
                s = scatter(ax(2), x3, data3(:,j-i+1), 2, 'filled');
                s.MarkerFaceColor = s.CData;
                axs(j) = s;
                j = j + 1;
            end
            hold(ax(1), 'off'); hold(ax(2), 'off');
            handles.axes1 = ax;
            
            set(handles.axes1(1), 'XTickLabelRotation', 45)
            set(handles.axes1(1), 'YTickLabelRotation', 45)
            set(handles.axes1(1), 'XTickLabelMode', 'auto')            
            set(handles.axes1(1), 'FontSize', 8)
            set(handles.axes1(1), 'FontWeight', 'bold')             
            
            set(handles.axes1(2), 'XTickLabelRotation', 45)
            set(handles.axes1(2), 'YTickLabelRotation', 45)
            set(handles.axes1(2), 'XTickLabelMode', 'auto')
            set(handles.axes1(2), 'FontSize', 8)
            set(handles.axes1(2), 'FontWeight', 'bold')             
            h = legend(axs', char(char(y2label), char(y3label)), "location", "best");
    
        else
            if handles.file3 && size(handles.axes1, 2)
                cla(handles.axes1(2));
            end % clear the plot

            hold on
            i = 1;
            
            len = size(data2,2);
            
            ax = zeros(len, 1); % axes vector so the legend works nicely
            
            while i <= len
                ax(i) = scatter(x2, data2(:,i), 2, 'filled');
                i = i + 1;
            end
            hold off;
            set(handles.axes1(1), 'XTickLabelRotation', 45)
            set(handles.axes1(1), 'YTickLabelRotation', 45)
            set(handles.axes1(1), 'XTickLabelMode', 'auto')
            set(handles.axes1(1), 'FontSize', 8)
            set(handles.axes1(1), 'FontWeight', 'bold') 
            h = legend(ax, y2label, "location", "best");

        end
    end
    grid on;
    ylim auto;
    
    xlabel(x2label);
    title(handles.axes1(1), 'AUX Plot');
    datetick(handles.axes1(1), 'x','HH:MM:SS', 'keepticks', 'keeplimits')   

    set(h, 'Interpreter', 'none') % dont want '_' to be subscript from tex interpreter
    w = warning('query','last');
    warning('off', w.identifier) % suppress annoying axesmanager warning 
    guidata(hObject, handles);
end    



function strArr = repStr(len, str)
% make a repeating char array of a string
    strArr = char(str);
    for i = 1:(len-1)
        strArr = char(strArr,str);
    end
end   



% --- Executes on selection change in month_list.
function month_list_Callback(hObject, eventdata, handles)
    % hObject    handle to month_list (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns month_list contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from month_list
    handles.month_index = get(handles.month_list,'Value');
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function month_list_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to month_list (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.month_index = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end



% --- Executes on selection change in day_list.
function day_list_Callback(hObject, eventdata, handles)
    % hObject    handle to day_list (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns day_list contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from day_list
    handles.day_index = get(handles.day_list,'Value');
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function day_list_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to day_list (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.day_list = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on selection change in hr_list.
function hr_list_Callback(hObject, eventdata, handles)
    % hObject    handle to hr_list (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns hr_list contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from hr_list
    handles.hr_index = get(handles.hr_list,'Value');
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function hr_list_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to hr_list (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    handles.hr_list = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end




% --- Executes on button press in pushbutton15. - TLM Descr
function pushbutton15_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % hanldes.DBDptr - struct with fields [units conversion mnemonic description S/S type APID (byte:bit)] 

    if isempty(handles.DBDptr), [handles.DBDptr, handles.DBname] = getCalibMat(); end % may need to load db file
     
    if isempty(handles.DBDptr)
        return
    end

    
    if isfield(handles, 'labels1')
        handles.y1label = handles.labels1(1, handles.indiciesA5);
    end % in case its selected but not plotted 
    if isfield(handles, 'labels2')
        handles.y2label = handles.labels2(1, handles.indiciesA6);    
    end
    if isfield(handles, 'labels3')
        handles.y3label = handles.labels3(1, handles.indiciesA2);  
    end

    % TODO display the repeats as to not confuse the user
    [tlmName, unqRows, ~] = unique(handles.DBDptr.mnemonic); % mnemonic (some repeats, use unique to find the new indices
    descr = handles.DBDptr.description(unqRows); 
    type = handles.DBDptr.type(unqRows);
    apid = handles.DBDptr.APID(unqRows);
    bb = handles.DBDptr.byte_bit(unqRows); % byte:bit

    names = '';
    descrips = '';
    types = '';
    apids = '';
    bbs = '';
    
    isEmpty = true;
    if isfield(handles, 'y1label') && ~isempty(handles.y1label)
        isEmpty = false;
        
        names = {' ', 'Main Plot',' ', handles.y1label{:}}';
    
        names = remEmptyCell(names);
        [~,ind1] = ismember(handles.y1label, tlmName); % get the indices for the coresponding names, regardless of order 
       
        unknownInds = find(~ind1); % day, milli, micro, seqcnt are not in Database
        
        filler = {''};
        if ~isempty(unknownInds)
            len = length(unknownInds);
            ind1 = ind1(len+1:end);
            filler = cellstr(repStr(len, ' -- '));
        end 
        
        descrip1 = descr(ind1); % pull out the description for plot1 variable
        ss1 = SS(ind1); type1 = type(ind1); apid1 = apid(ind1); bb1 = bb(ind1);

        descrips = {' ',' ',' ', filler{:}, descrip1{:}}';
        SSs = {' ',' ',' ', filler{:}, ss1{:}}';
        types = {' ',' ',' ', filler{:}, type1{:}}';
        apids = {' ',' ',' ', filler{:},apid1{:}}';
        bbs = {' ',' ',' ', filler{:}, bb1{:}}';

    end

    if isfield(handles, 'y2label') && ~isempty(handles.y2label)
        isEmpty = false;       
 
        names2 = handles.y2label;
        names2 = remEmptyCell(names2);
        [~,ind2] = ismember( handles.y2label, tlmName);
        
        names = {names{:},' ', 'Aux1 Plot',' ', names2{:}}';
        
        unknownInds = find(~ind2); % day, milli, micro, seqcnt are not in Database
        
        filler = {''};
        if ~isempty(unknownInds)
            len = length(unknownInds);
            ind2 = ind2(len+1:end);
            filler = cellstr(repStr(len, ' -- '));
        end        

        descrip2 = descr(ind2); % pull out the description for plot1 variable
        ss2 = SS(ind2); type2 = type(ind2); apid2 = apid(ind2); bb2 = bb(ind2);
        
        SSs = {SSs{:}, ' ',' ',' ', filler{:}, ss2{:}}';
        types = {types{:},' ',' ',' ',  filler{:}, type2{:}}';
        apids = {apids{:}, ' ',' ',' ', filler{:}, apid2{:}}';
        bbs = {bbs{:}, ' ',' ',' ', filler{:}, bb2{:}}';
        descrips = {descrips{:}, ' ',' ',' ', filler{:}, descrip2{:}}';

     end

    if isfield(handles, 'y3label') && ~isempty(handles.y3label)
        isEmpty = false;        
       

        names3 = handles.y3label;
 
        names3 = remEmptyCell(names3);
        [~,ind3] = ismember(handles.y3label, tlmName);
        names = {names{:}, ' ', 'Aux2 Plot',' ' names3{:}}';
        
        unknownInds = find(~ind3); % day, milli, micro, seqcnt are not in Database
        
        filler = {''};
        if ~isempty(unknownInds)
            len = length(unknownInds);
            ind3 = ind3(len+1:end);
            filler = cellstr(repStr(len, ' -- '));
        end

        descrip3 = descr(ind3); % pull out the description for plot1 variable
        ss3 = SS(ind3); type3 = type(ind3); apid3 = apid(ind3); bb3 = bb(ind3);
        
        SSs = {SSs{:}, ' ',' ',' ', filler{:}, ss3{:}}';
        types = {types{:}, ' ',' ',' ', filler{:}, type3{:}}';
        apids = {apids{:},  ' ',' ',' ', filler{:},apid3{:}}';
        bbs = {bbs{:},  ' ',' ',' ', filler{:},bb3{:}}';
        descrips = {descrips{:}, ' ',' ',' ', filler{:}, descrip3{:}}';

        
    end

    if ~isEmpty

        colNames = {'Name', 'Descr', 'S/S', 'Type', 'APID', '(byte:bit)'};   
        names = remEmptyCell(names); % see function def for this below
        descrips = remEmptyCell(descrips);
        SSs = remEmptyCell(SSs);
        types = remEmptyCell(types);
        apids = remEmptyCell(apids);
        bbs = remEmptyCell(bbs);
        data = { names{:}; descrips{:}; SSs{:}; types{:}; apids{:}; bbs{:}}';% make a disaply table for the needed info
        
        hFig = figure('Name', 'Telem Descriptions');
        uitable(hFig, 'data', data, 'ColumnName', colNames, 'unit', 'normalized' ...
            , 'position', [0 0 1 1], 'ColumnWidth', {90 180 50 50 65 65});
    else 
        errordlg('Telem descriptions are only available for data that is loaded and selected') 
        
    end
    guidata( hObject, handles );
   
end

function newArr = remEmptyCell(cellArr)
% removes empty cells from cell array

    newArr = cellArr(~cellfun('isempty', cellArr));

end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles) % LOAD AUX FILE #1
    % hObject    handle to pushbutton16 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    set(handles.listbox6, 'value', 1); % this prevents the listbox from crashing due to dissapearing fields
    
    tmpStr = get(handles.text20, 'string');
    set(handles.text20, 'String', 'loading ...')
    
    [handles.name2, path2] = uigetfile(fullfile(handles.prevPath2,'*.txt')); %Modify for csv, txt, etc
    
    
    if ~path2
        set(handles.text20, 'String', tmpStr)
        return
    else
       handles.prevPath2 = [path2 '/..']; % to point user to last used directory

       %set(handles.text21,'String', ['AUX1 path: ',path2]);
    end

    set(handles.figure1, 'pointer', 'watch') % hourglass pointer (nice aesthetic)
    A2 = readtable(fullfile(path2, handles.name2), 'delimiter', ',');

    handles.indiciesA6 = 1;
    handles.file2 = 1;

    if any(isnan(A2{:,end})) % sometimes readtable adds an extra column
        A2 = A2(:,1:end-1); % cut off the last column, which contains a ton of NaN
    end
    
    [handles.labels2, sortInds] = sort(A2.Properties.VariableNames); 
    handles.telemdata2 = table2array(A2);    
    
    %Setting list box contents
   
    set(handles.listbox6,'String',handles.labels2);

    set(handles.pushbutton14,'visible','on'); %  EANBLE PLOT BUTTON

    handles.telemdata2 = dataCorrection(handles.telemdata2, ...
    get(handles.radiobutton21,'value'), get(handles.radiobutton22,'value')); % data correction 


    [handles.rows2,handles.cols2] = size(handles.telemdata2);

    handles.dates2 = handles.telemdata2(: ,1 ) ; % days

    handles.millisec2 = handles.telemdata2(: , 2);
    handles.micsec2 = handles.telemdata2(: ,3);
    handles.sec2 = double((handles.millisec2 / 1000) + (handles.micsec2 / 1000000)); % setting time vector
   

    handles.delta_t2 = mean( (handles.dates2(2:end)*86400 + handles.sec2(2:end)) -...
        (handles.dates2(1:end-1)*86400 + handles.sec2(1:end-1)) ); % get a more robust freq measurement this way
        
    set(handles.text18,'string',['Avg Aux1 Rate: ',num2str(1/handles.delta_t2),' HZ']);
    
    %handles.pktcount = handles.telem(:,4); % hours
    nSecs12 = handles.sec2(1);
    nSecs22 = handles.sec2(handles.rows2);
    handles.startT2 = datestr(nSecs12/86400, 'HH:MM:SS.FFF');
    handles.stopT2 = datestr(nSecs22/86400, 'HH:MM:SS.FFF');
    handles.elapsedsec2 = sec2time(handles.sec2, handles.dates2, handles.epoch);

    startdatestr2 = datestr( handles.dates2(1) + handles.epoch , 'dd/mmm/yyyy');
    stopdatestr2 = datestr( handles.dates2(end) + handles.epoch, 'dd/mmm/yyyy');

    set(handles.text16, 'string', ['Start Date: ', startdatestr2]);
    set(handles.text14, 'string', ['Stop Date: ', stopdatestr2]);

    set(handles.pushbutton24,'visible','on');  % ENABLE CLEAR AUX PLOT BUTTON    
    set(handles.pushbutton14,'visible','on');  % ENABLE AUX PLOT BUTTON
    set(handles.pushbutton17,'visible','on');  % ENABLE LD AUX2 Button
    set(handles.text19,'visible','on');  % ENABLE RATE2 text
    
    set(handles.figure1, 'pointer', 'arrow') % hourglass pointer off
    set(handles.text20,'String', ['AUX1 file: ', handles.name2]);
    
    handles.telemdata2 = handles.telemdata2(:, sortInds); % reorder based on alphebetization
    
    guidata( hObject, handles );
    
end

% --- Executes on button press in pushbutton17.  -- LOAD AUX 2 FILE
function pushbutton17_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton17 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    set(handles.listbox2, 'value', 1); % this prevents the listbox from crashing due to dissapearing fields

    tmpStr = get(handles.text22, 'string');
    set(handles.text22, 'String', 'loading ...')
    
    [handles.name3, path3] = uigetfile(fullfile(handles.prevPath2,'*.txt')); %Modify for csv, txt, etc
    
    if ~path3
        set(handles.text22, 'string', tmpStr)
        return
    else
        handles.prevPath2 = [path3 '/..'];
        %set(handles.text23,'String', ['AUX2 path: ', path3]);
    end
    set(handles.figure1, 'pointer', 'watch') % hourglass pointer (nice aesthetic)

    A3 = readtable(fullfile(path3, handles.name3), 'delimiter', ',');

    
    if any(isnan(A3{:,end})) % sometimes readtable adds an extra column
        A3 = A3(:,1:end-1); % cut off the last column, which contains a ton of NaN
    end
    
    [handles.labels3, sortInds] = sort(A3.Properties.VariableNames); 
    handles.telemdata3 = table2array(A3);
    
    handles.indiciesA2 = 1; % reset index for listbox 2

    handles.file3 = 1;

    %Setting list box contents

    set(handles.listbox2,'String',handles.labels3);
    set(handles.pushbutton14,'visible','on'); %  EANBLE PLOT BUTTON

    handles.telemdata3 = dataCorrection(handles.telemdata3, ...
        get(handles.radiobutton15,'value'), get(handles.radiobutton16,'value'));

    [handles.rows3,handles.cols3] = size(handles.telemdata3);

    [handles.rows3,handles.cols3] = size(handles.telemdata3);
    
    handles.dates3 = handles.telemdata3(: ,1 ) ;
    handles.millisec3 = handles.telemdata3(: , 2);
    handles.micsec3 = handles.telemdata3(: ,3);
    handles.sec3 = double((handles.millisec3 ./ 1000) + (handles.micsec3 ./ 1000000)); % setting time vector

    handles.delta_t3 = mean((handles.dates3(2:end)*86400 + handles.sec3(2:end)) -...
        (handles.dates3(1:end-1)*86400 + handles.sec3(1:end-1))); % get a more robust freq measurement this way
        
    set(handles.text19,'string',['Avg Aux2 Rate: ',num2str(1/handles.delta_t3),' HZ']); % 

    nSecs13 = handles.sec3(1);
    nSecs23 = handles.sec3(handles.rows3);
    handles.startT3 = datestr(nSecs13/86400, 'HH:MM:SS.FFF');
    handles.stopT3 = datestr(nSecs23/86400, 'HH:MM:SS.FFF');
    handles.elapsedsec3  = sec2time(handles.sec3, handles.dates3, handles.epoch);

    startdatestr3 = datestr( handles.dates3(1) + handles.epoch, 'dd/mmm/yyyy');
    stopdatestr3 = datestr(handles.dates3(end) + handles.epoch, 'dd/mmm/yyyy');
    set(handles.text16, 'string', ['Start Date: ', startdatestr3]);
    set(handles.text14, 'string', ['Stop Date: ', stopdatestr3]);

    set(handles.pushbutton14,'visible','on');  % ENABLE PLOT BUTTON
    set(handles.radiobutton23, 'value', 1)
    set(handles.figure1, 'pointer', 'arrow') % hourglass pointer off
    set(handles.text22,'String', ['AUX2 file: ', handles.name3]);    
   
    handles.telemdata3 = handles.telemdata3(:, sortInds); % reorder based on alphebetization
    
    
    guidata( hObject, handles );
    
end

% --- Executes on button press in pushbutton18. % RUN PACKET DATE TOOL -
% WILL CONVERT DAY/MILLISECONDS/MICROSECONDS TO CALENDAR DATE AND TIME OF
% DAY.
function pushbutton18_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton18 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
     PKT_DATE_TOOL % start packet time tool
end

% --- Executes on key press with focus on listbox6 and none of its controls.
function listbox6_KeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to listbox6 (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
end


function edit3_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit3 as text
    %        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function edit4_Callback(hObject, eventdata, handles)
    % hObject    handle to edit4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit4 as text
    %        str2double(get(hObject,'String')) returns contents of edit4 as a double
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', '1')
end

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton19 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    edit4strnum = str2num(get(handles.edit4, 'string'));
    
    tmp = strsplit(get(handles.edit3, 'string'), ':'); % # slices
    handles.slices = str2double(tmp{2});    
    
    if edit4strnum == 1
        set(handles.edit4, 'string', num2str(handles.slices));
    elseif edit4strnum > handles.slices
        set(handles.edit4, 'string', num2str(handles.slices));
    elseif edit4strnum < 1
        set(handles.edit4, 'string', num2str(handles.slices));
    else
    set(handles.edit4, 'string', num2str(edit4strnum-1));
    end
    pushbutton11_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end



% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton20 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    edit4strnum = str2num(get(handles.edit4, 'string'));

    tmp = strsplit(get(handles.edit3, 'string'), ':'); % # slices
    handles.slices = str2double(tmp{2});    
    
    if edit4strnum == handles.slices
        set(handles.edit4, 'string', '1');
    elseif edit4strnum > handles.slices
        set(handles.edit4, 'string', num2str(handles.slices));
    elseif edit4strnum < 1
        set(handles.edit4, 'string', num2str(handles.slices));
    else
        set(handles.edit4, 'string', num2str(edit4strnum+1));
    end
    pushbutton11_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);

end    

% --- Executes on button press in instr_button.
function pushbutton21_Callback(hObject, eventdata, handles)
    % hObject    handle to instr_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if isunix 
        % Must have evince installed
        ! evince Docs/BASIC_INSTRUCTIONS.pdf 
    else % windows
        ! .\Docs\BASIC_INSTRUCTIONS.pdf
    end
end



function edit5_Callback(hObject, eventdata, handles)
    % hObject    handle to edit5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit5 as text
    %        str2double(get(hObject,'String')) returns contents of edit5 as a double
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function edit6_Callback(hObject, eventdata, handles)
    % hObject    handle to edit6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit6 as text
    %        str2double(get(hObject,'String')) returns contents of edit6 as a double
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in radiobutton18 - calibrated data.
function radiobutton18_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton18 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton18
    if get(handles.radiobutton18, 'value') && isempty(handles.DBDptr)c
        [handles.DBDptr, handles.DBname] = getCalibMat(); % units, calibration, mnemonic, description
        if isempty(handles.DBDptr)
            set(handles.radiobutton18, 'value', 0)
            set(handles.radiobutton17, 'value', 0)
        end
    end
    pushbutton14_Callback(hObject, eventdata, handles)
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton17 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton17 
    if get(handles.radiobutton17, 'value') && isempty(handles.DBDptr) % empty string array if DBDptr has not been made into a struct yet
        [handles.DBDptr, handles.DBname] = getCalibMat(); % units, calibration, mnemonic
        if isempty(handles.DBDptr)
            set(handles.radiobutton18, 'value', 0)
            set(handles.radiobutton17, 'value', 0)
        end
    end
    
    if isfield(handles, 'sec1'),pushbutton11_Callback(hObject, eventdata, handles); end   
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton21. Sort hdr aux1
function radiobutton21_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton21 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton21
    if get(handle.radiobutton21, 'value')
        handles.telemdata2 = dataCorrection(handles.telemdata2, ...
            get(handles.radiobutton21,'value'), get(handles.radiobutton22,'value'));
    else
        pushbutton16_Callback(hObject, eventdata, handles)
    end
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton22. delete dups aux1
function radiobutton22_Callback(hObject, eventdata, handles)
    % hObject    handle to radiobutton22 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of radiobutton22
    if get(handle.radiobutton21, 'value')
        handles.telemdata2 = dataCorrection(handles.telemdata2, ...
            get(handles.radiobutton21,'value'), get(handles.radiobutton22,'value'));
    else
        pushbutton16_Callback(hObject, eventdata, handles)
    end
    guidata(hObject,handles);
end

% --- Executes on selection change in listbox12.
function listbox12_Callback(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox12
end

% --- Executes during object creation, after setting all properties.
function listbox12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in listbox13.
function listbox13_Callback(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox13
end

% --- Executes during object creation, after setting all properties.
function listbox13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in listbox14.
function listbox14_Callback(hObject, eventdata, handles)
% hObject    handle to listbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox14
end

% --- Executes during object creation, after setting all properties.
function listbox14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on selection change in listbox15.
function listbox15_Callback(hObject, eventdata, handles)
% hObject    handle to listbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox15

end



% --- Executes during object creation, after setting all properties.
function listbox15_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end    

% --- Executes during object creation, after setting all properties.
function radiobutton18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'value',0);
end

% --- Executes during object creation, after setting all properties.
function radiobutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'value',1);
end

% --- Executes during object creation, after setting all properties.
function radiobutton17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'value',0);
end

% --- Executes during object creation, after setting all properties.
function radiobutton7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'value',1);
end

% --- Executes on button press in pushbutton22. - New Database
function handls = pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hanlds     for use in other functions that arent affected by guidata
    [handles.DBDptr, handles.DBname] = getCalibMat(); % units, calibration, mnemonic, description
    if isempty(handles.DBDptr)    % user pressed cancel
        set(handles.radiobutton18, 'value', 0)
        set(handles.radiobutton17, 'value', 0)
    end
    
    handls = handles;
    guidata(hObject,handles);
    
end

% --- Executes on button press in pushbutton24. - CLEAR AUX
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if size(handles.axes1, 2)==1 % only one plot on axes1
        cla(handles.axes1);
    else % two plots on there)
        cla(handles.axes1(1));

        try cla(handles.axes1(2)); % want to proctect the code from deleted axes errors
        catch
        end
    end
end

% --- Executes on button press in pushbutton25. - CLEAR MAIN
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    cla(handles.axes2)
    set(handles.listbox12, 'string','')
    set(handles.listbox13, 'string','')  
end

% --- Executes on button press in pushbutton26. - CONFIG 3D Plot
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if ~isfield(handles,'cols1')
        errordlg('Please load data first')
        pushbutton1_Callback(hObject, eventdata, handles)
        return
    end

    name = '3D Plot Config';
    prompt = {'Start Column (1st 3 are timestamp): ', 'End Column: '};
    numlines = [1 50; 1 50];
    options.Resize='on';
    options.WindowStyle='normal';

    answer = inputdlg(prompt, name, numlines, handles.defaultAnswer, options);
    
    if isempty(answer)% user pressed cancel or x, and there is no 3D plot data already
        h = errordlg('Need configuration for 3D plot! Reverting to 2D');
        uiwait(h)
        set(handles.radiobutton3, 'value', 1)
        set(handles.radiobutton4, 'value', 0)
        radiobutton3_Callback(hObject, eventdata, handles)
        return
    end
    
    if isempty(answer) && isfield(handles, 'slices'), return; end % do nothing. Plot is already there, looking pretty
    
    a2 = str2double(answer{2});
    a1 = str2double(answer{1});
    if a1<4 || a2<1 || a2>handles.cols1 || a2-a1<1 ...
            || isnan(a1 + a2) % check for string in boxes, or out of range values
        h = errordlg('Invalid input. Reverting to 2D');
        uiwait(h)
        set(handles.radiobutton3, 'value', 1)
        set(handles.radiobutton4, 'value', 0)
        radiobutton3_Callback(hObject, eventdata, handles)
        
    else
        handles.defaultAnswer = answer; % save the response for next time
        handles.slices = ceil(handles.rows1/400);  % want 400 scans per view every time
        set(handles.edit3, 'string', ['# Slices: ' num2str(handles.slices)]); % these three edits have 
        %been reverted to text boxes, but I kept the names the same fo convenience
        set(handles.edit5, 'string', ['Start Col: ' answer{1}]);
        set(handles.edit6, 'string', ['End Col: ', answer{2}]);
        set(handles.edit4, 'string', '1')
        pushbutton11_Callback(hObject, eventdata, handles)
    end
    guidata(hObject,handles);
end



% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton23
    if ~handles.file3
        set(hObject, 'value', 0)
        return
    end
    pushbutton14_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton24
    if handles.file2 % if AUX data loaded, plot it
        pushbutton14_Callback(hObject, eventdata, handles); 
        
    end
end
