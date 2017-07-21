% Nick Azzopardi
% 2015 JPSS Summer Intern
%
% Edited by Nate Merrill
% 2017 JPSS Summer Intern
%
% This script runs dwell_fft_tool.fig, which plots the dwell data for main motor
% current. The top two plots are the raw motor current data (left) and
% the fft for the whole dataset (right). The bottom two plots are the fft
% sliced into a user specified number of slices, shown in two different
% frequency views.
% 
%
function varargout = dwell_fft_tool(varargin)
% dwell_fft_tool MATLAB code for dwell_fft_tool.fig
%      dwell_fft_tool, by itself, creates a new dwell_fft_tool or raises the existing
%      singleton*.
%
%      H = dwell_fft_tool returns the handle to a new dwell_fft_tool or the handle to
%      the existing singleton*.
%
%      dwell_fft_tool('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in dwell_fft_tool.M with the given input arguments.
%
%      dwell_fft_tool('Property','Value',...) creates a new dwell_fft_tool or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dwell_fft_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dwell_fft_tool_OpeningFcn via varargin.
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dwell_fft_tool

% Last Modified by GUIDE v2.5 20-Jul-2017 15:41:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dwell_fft_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @dwell_fft_tool_OutputFcn, ...
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


% --- Executes just before dwell_fft_tool is made visible.
function dwell_fft_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dwell_fft_tool (see VARARGIN)
% Choose default command line output for dwell_fft_tool
handles.output = hObject;
% Update handles structure

handles.epoch = datenum('01-01-1958' ,'dd-mm-yyyy');


% Sets expected frequencies for stem plots. These are known frequencies
% that have issues for ATMS. They can be changed via pushbutton15
handles.main_x = [ 0.08,0.09,1.4,2.8,3.1,3.4,4.2,5.6,5.9,7.0,8.4,9,11.2,24.2 ];
handles.comp_x = [ 0.14,0.16,2.47,4.93,5.45,6.12 ];

handles.prevPath = fullfile(pwd, 'data'); % The previous path that the user selected. default is ./data 

handles.delta_t = (8/3)/(148); % Sets time increment (sec) - fixed at 148 samples per scan

dc = datacursormode(handles.figure1); % fix data cursor to show time/frequency
set(dc, 'UpdateFcn', @dcUpdateDwellFFT)    
set(dc, 'SnapToDataVertex', 'on')

guidata(hObject, handles);
% UIWAIT makes dwell_fft_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = dwell_fft_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% Edit box for setting number of slices
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white backgroutruend on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function showDates(handles)
% hlper function to show the file dates in text7 and text8. This is a
% separate function because two functions use this capability

    t1 = handles.time(1);
    startT = datestr(t1, 'dd-mmm-yyyy HH:MM:SS.FFF');
    stopT = datestr(handles.time(end), 'dd-mmm-yyyy HH:MM:SS.FFF');

    set(handles.text7,'String',(['File Start: ', startT]));
    set(handles.text8,'String',(['File Stop: ', stopT]));  
    guidata(handles.text7, handles)
    
    
% Plot button: Runs the code & plots figures based on inputs
function h = pushbutton1_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    if ~isfield(handles, 'dwell') % if user did not load data first
        handles = pushbutton2_Callback(handles.pushbutton2, eventdata, handles); % need to have handles returned to mutate the structure. 
        if ~isfield(handles, 'data'), return; end % user really doesnt want to load data 
    end
    
    set(handles.text9,'String','Plotting...');
    
    scan_slices = str2double(get(handles.edit2,'String')); % number of scans to determine averages (taken from input in edit box)
    
    
    switch get(get(handles.uibuttongroup1,'SelectedObject'),'Tag')
        case 'radiobutton1' % Sets data to be used for demodulated plots 
            if get(handles.radiobutton5, 'value') 
                handles.label = 'for All Scan Positions - De-Trended';
            else
                handles.label = 'for All Scan Positions - Raw Data';
            end
        case 'radiobutton2'
            handles.label = 'Earth Scan Positions Only';
    end
            
    if isnan(scan_slices) || isempty(scan_slices)
        scan_slices = 200;
    end
  
    handles.slices = round(handles.rows/scan_slices);
    
    set(handles.edit2, 'string', num2str(scan_slices))


    Num_points = length(handles.dwell);
    t1 = handles.time(1);
    showDates(handles)    
    dt_days = handles.delta_t/86400; % converted to days 
    t = zeros(Num_points,1); % make this column major! This will make an order of magnitude speedup fr all calculations with t!
    t(:) = t1:dt_days:(t1 + dt_days*(Num_points-1)); % time vector. Need extra points since there are more dwell points than timestamps
    % Creates the top left plot 
    plot(handles.axes2, t, handles.dwell);
    datetick(handles.axes2,'x', 'mm/dd', 'keepticks', 'keeplimits')
    grid(handles.axes2, 'on');
    xlabel(handles.axes2, ' Date (mm/dd) ');
    if get(handles.radiobutton3, 'value') 
        ylabel(handles.axes2, ' Raw Counts ');
    else
        ylabel(handles.axes2, 'Amps')
    end
    title(handles.axes2, [' ATMS Main Motor Current ', handles.label]);
    axis(handles.axes2, [t1 t(end) min(handles.dwell) max(handles.dwell)]) % set axes limits so data looks nice
   	
    delf = (1/Num_points)*(1/handles.delta_t); %frequency increment for fft

    nf=round(Num_points/2)+1;  % Number of points in frequency plots 
    
    fr = zeros(nf, 1);
    fr(:) = (0:(nf-1))*delf; % freq vector
    ff=fft(handles.dwell); % call to Matlab's Fast Fourier program
    f=ff(1:nf); % positive components
    fmag=2*abs(f)/Num_points; % see only positive spikes

    if get(handles.radiobutton5, 'value') % demod
        fmag = detrend(fmag); % remove the giant blob of data below the spikes by removeing a straight line fit of the data
    end
    
    if get(handles.radiobutton9, 'value') % if hanning window requested
        hwc = hanning(length(fmag)); %get Hanning window coefficients
        fmag = fmag.* hwc; % multiply element wise 
    end
    
    plot(handles.axes3, fr,fmag);
        
        
    Yaxis = max(fmag(floor(end/4):floor(3*end/4))); % for ax lims. Skip 0 Hz, as it is usually massive
    hold(handles.axes3,  'on');
    if get(handles.radiobutton7, 'value') == 1
        stem(handles.axes3, handles.main_x, Yaxis/2 * ones(size(handles.main_x)),'r');
        stem(handles.axes3, handles.comp_x, Yaxis/2 * ones(size(handles.comp_x)),'g');    
    end
    axis(handles.axes3, [0 fr(end) 0 Yaxis]); % sets axis dimensions, can be changed in switch above (line 108)
    xlabel(handles.axes3, '\nu (Hz)');
    ylabel(handles.axes3, 'Magnitude');
    title(handles.axes3, ' PSD results for entire data set');
    grid(handles.axes3,  'on');
    hold(handles.axes3,  'off');
    %figure;

    % Changes frequency vector to adjust for new, sliced plots.
    handles.pointsPerSlice = round(Num_points/handles.slices);

    nf = round(handles.pointsPerSlice/2+1); % reassign for bottom plots
    
    delf = (1/nf)*(1/handles.delta_t); %frequency increment for fft
    handles.fr = zeros(nf, 1);
    handles.fr(:) = (0:(nf-1))*delf; % we need this extra line so that fr is column major. THis make an order of magnitude time difference
    
    plotBottomWindows(handles);
    
    set(handles.text9,'String','Done');
    
    h = handles;
    guidata(hObject, handles);
    
    
function plotBottomWindows(handles)
% Hleper function to plot the bottom two windows for single use and
% playback

% handles - the gui handles struct

    Xaxis1 = 5; Xaxis2 = 30;
    finish = handles.slices;
    currslice = str2double(get(handles.edit7, 'String'));
    %Start/finish assimilation, allows you to go backwards through the slices
    if currslice >= finish || currslice < 1
        currslice = 1;
        set(handles.edit7, 'String', '1');
    end

    %Time/Date of current slice
    if currslice == 1
        startInd = 1;
        endInd = round((currslice)*handles.rows/finish);
    else
        startInd = round((currslice -1)*handles.rows/finish);
        endInd = round((currslice)*handles.rows/finish); 
    end   
    slicestartT = datestr(handles.time(startInd), 'dd-mmm-yyyy HH:MM:SS.FFF');
    slicestopT = datestr(handles.time(endInd), 'dd-mmm-yyyy HH:MM:SS.FFF'); 

    set(handles.text21,'String',(['Slice Start: ', slicestartT]));
    set(handles.text22,'String',(['Slice Stop: ',  slicestopT]));

    % calculate individual hanning windows if requested
    % cannot do hanning for all points, because we cut off higher frequencies below. So find the end of the visible window    
    [~, endInd1] =  min(abs(2*Xaxis1 - handles.fr));
    [~, endInd2] = min(abs(2*Xaxis2 - handles.fr));
    endInd12 = floor(endInd1/2);
    endInd22 = floor(endInd2/2); % stoire these indexes for use in taking part of fft result
    
    hwc1 = ones(endInd12 + 1, 1);
    hwc2 = ones(endInd22 + 1, 1); % create placeholders incase hanning not requested
    
    if get(handles.radiobutton9, 'value') % if hanning window requested
        hwc1 = hanning(endInd12 + 1); %get Hanning window coefficients
        hwc2 = hanning(endInd22 + 1);
    end
    
    % current index in dwell data
    ind = currslice*handles.pointsPerSlice;
    
    % call to Matlab's Fast Fourier program for the larger amount of data
    % so that we only have to do it once
    ff=fft(handles.dwell(ind:(ind+endInd2)));
   
    % just take the first half to avoid excessive noise. Also take abs to
    % make all entries positive, because we only care sboutr the spike, not
    % the actual value
    f = 2*abs( ff(1:(endInd12 + 1) ) )/(1+endInd12); 
    %Bottom Left Plot
    if get(handles.radiobutton5, 'value') % demod
        % multiply hanning coefficients. If they are ones, then hanning was not
        % requested and the values will remain raw. Otherwise central
        % frequencies will be more noticeable
        A = hwc1.* detrend(f);
    else    
        A = hwc1.* f;
    end
    
    plot(handles.axes4, handles.fr(1:endInd12+1), A); 
    

    Yaxis = max(A);
    hold(handles.axes4, 'on')
    if get(handles.radiobutton7, 'value') 
        stem(handles.axes4, handles.main_x, Yaxis/2  * ones(size(handles.main_x)),'r');
        stem(handles.axes4,handles.comp_x, Yaxis/2  * ones(size(handles.comp_x)),'g');    
    end
    axis(handles.axes4,[0 Xaxis1 0 max(A(floor(end/4):floor(3*end/4)))]);
    grid(handles.axes4, 'on'); 
    title(handles.axes4,[' ATMS ', handles.label]); %Change Dates
    xlabel(handles.axes4,' \nu (Hz)');
    ylabel(handles.axes4,'Magnitiude');
    hold(handles.axes4, 'off')

    %Bottom Right Plot;
   
    % reassign with the new indices for the bottom right plot
    f = 2*abs( ff(1:(endInd22 + 1) ) )/(1+endInd22); 

    
    if get(handles.radiobutton5, 'value') % detrend
        A = hwc2.* detrend(f); % detrend f, removing alot of noise by taking out a straight line fit of the original, non-windowed data
    else    
        A = hwc2.* f;
    end    
    
    Yaxis = max(A);
    
    plot(handles.axes5, handles.fr(1:(endInd22+1)),A);
    
    hold(handles.axes5, 'on')
    if get(handles.radiobutton7, 'value') == 1
        stem(handles.axes5, handles.main_x, Yaxis/2 * ones(size(handles.main_x)),'r');
        stem(handles.axes5, handles.comp_x, Yaxis/2 * ones(size(handles.comp_x)),'g');    
    end
    axis(handles.axes5, [0 Xaxis2 0 max(A(floor(end/4):floor(3*end/4)))]); 
    grid(handles.axes5, 'on');
    title(handles.axes5, [' ATMS ', handles.label]);
    xlabel(handles.axes5, ' \nu (Hz)');
    ylabel(handles.axes5, 'Magnitiude');
    hold(handles.axes5, 'off')

    set(handles.text16, 'String',sprintf('Current Slice: %g of %d', currslice, finish)); % Sets Current slice time in small text box
   
    guidata(handles.pushbutton1, handles);    
    
    
    
 % Browse button: gets the file and imports to "handles.dwell"
function h = pushbutton2_Callback(hObject, eventdata, handles) %Browse button
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    str = get(handles.text6, 'string');
    set(handles.text6, 'string', 'loading ...')
	[name, fpath] = uigetfile(fullfile(handles.prevPath,'*.txt')); %Modify for csv, txt, etc
    if ~fpath 
        set(handles.text6, 'string', str)
        h = handles;
        return
    else
        set(handles.text6,'String',name); %Displays filename in top right
        set(handles.text2,'String','File Chosen:');
        handles.prevPath = fpath;
    end
    % readtable is orders of magnitude faster than load, even with
    % table2array
    data = readtable(fullfile(fpath, name), 'ReadVariableNames', 0);
    dwell = data{:, 6:end}'; % coerce into array and transpose to make column-major indexing
    [handles.cols, handles.rows] = size(dwell); % switched because we transposed
    handles.dwell = dwell(:); % coerce into column vector ( column is faster in the column-major matlab engine)
    hdr = data{:,1:3}; % days milli micro, column major
    handles.time = hdr(:,1) + (hdr(:,2)/1000 + hdr(:,3)/1000000)/86400 + handles.epoch; % time in days since 00-00-0000
    h = handles; % return handles in case we use this in a nested function call
    guidata( hObject, handles );


% Scan_Slice edit box
function edit2_Callback(hObject, eventdata, handles) 
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
    guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles) 
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% 
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    plotBottomWindows(handles);
    guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function text16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% "Next" button, gets data from hidden edit box (edit7)
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.edit7, 'String', num2str(str2double(get(handles.edit7, 'String')) + 1));
    plotBottomWindows(handles);
    guidata(hObject, handles);



% --- Go to slice edit box
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% Back Button
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.edit7, 'String', num2str(str2double(get(handles.edit7, 'String')) - 1));
    plotBottomWindows(handles);
    guidata(hObject, handles);

% uncalibrated

% earth scan only
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
    set(handles.edit2,'visible','off');
    set(handles.text10,'visible','off');
    set(handles.uibuttongroup3, 'visible', 'off');
    if ~get(handles.togglebutton2, 'value'),pushbutton1_Callback(hObject, eventdata, handles); end
    guidata(hObject, handles)

% demodulated data
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
    set(handles.edit2,'visible','on');
    set(handles.text10,'visible','on');
    set(handles.uibuttongroup3, 'visible', 'on')
    if ~get(handles.togglebutton2, 'value'),pushbutton1_Callback(hObject, eventdata, handles);end
    guidata(hObject, handles)

% play button
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton2
    %Pausing/Continuing features
    
    if ~isfield(handles, 'dwell') % if user did not load data first
        handles = pushbutton1_Callback(handles.pushbutton2, eventdata, handles); % need to have handles returned to mutate the structure. 
        if ~isfield(handles, 'dwell'), return; end
    end
    
    
    if isempty(get(handles.edit9, 'String'))
        pausetime = 0.5;
    else
        pausetime = 1/str2double(get(handles.edit9, 'String'));
    end   
    
    while get(handles.togglebutton2, 'value')
        plotBottomWindows(handles);
        if ~get(handles.togglebutton2, 'value'), return; end
        pause(pausetime);
        set(handles.edit7, 'String', num2str(str2double(get(handles.edit7, 'String')) + 1))

    end
        

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text

    
function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function togglebutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over togglebutton2.
function togglebutton2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    saveScreen();

function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Mean and StDev button
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function creates a new figure window, and plots the mena ands stdev
% for each column position in the dwell data. For ATMS this corresponds to
% the scan position of the cross-track scanner. It also gives numberic
% values for mean and stdev
        
    if ~isfield(handles, 'dwell') % make sure user has loade data first
        handles = pushbutton2_Callback(hObject, eventdata, handles);
    end
    
    showDates(handles); % show dates in text7, text8

    % first we must reshape the dwell vector into a matrix temporarily. We
    % should not make a copy of this data, since it is ~44M elements long,
    % and takes multiple gigabytes of RAM. vec2mat wil place x in the
    % original row-major format
    handles.dwell = vec2mat(handles.dwell, handles.cols);
        
    devstring = cell(handles.cols, 1);
    dev = zeros(handles.cols,1);
    means = zeros(handles.cols, 1);
    for i = 1:handles.cols
        dev(i) = std(handles.dwell(:, i));
        means(i) = mean(handles.dwell(:, i));
        devstring{i} = ['Position ', num2str(i), ':  Mean: ', num2str(means(i)), '   StDev: ', num2str(dev(i))];
    end

    stDev = figure();
    set(stDev, 'position', [25 100 1750 850]);
    axes
    set(subplot(2,1,1), 'position', [.4 .55 .5 .4]);
    plot(dev);
    ylabel('Standard Deviation');
    xlabel('Position')
    title('Standard Deviation Profile')
    set(subplot(2,1,2), 'position', [.4 .05 .5 .4]);
    plot(means);
    ylabel('Mean')
    xlabel('Position')
    title('Mean Motor Current Profile')
    SDevbox = uicontrol('style', 'listbox', 'position', [75 0 500 800]);
    text1 = uicontrol('style', 'text', 'position', [75 850 600 50]);


    set(text1, 'String', ['Mean and Standard Deviation for all positions: ', ...
        get(handles.text7, 'string'),' - ', get(handles.text8, 'string')]...
        , 'HorizontalAlignment', 'left', 'FontSize', 10, 'FontWeight', 'bold');

    set(SDevbox, 'String', devstring, 'FontSize', 10, 'FontWeight', 'bold');
    
    handles.dwell = handles.dwell'; % make it column major
    handles.dwell = handles.dwell(:); % flatten it into a column vector
    
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uibuttongroup4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton8
pushbutton1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton6
    set(handles.edit2,'visible','off');
    set(handles.text10,'visible','off');
    pushbutton1_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton5
    set(handles.edit2,'visible','on');
    set(handles.text10,'visible','on');
    pushbutton1_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);


% --- Executes on button press in radiobutton9.  HANNING WINDOW ON
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     if get(handles.radiobutton9, 'value')
%         set(handles.radiobutton9,'value',1);
%         set(handles.radiobutton10,'value',0);
%     else
%         set(handles.radiobutton9,'value',0);
% 
%         set(handles.radiobutton10,'value',1);
%     end
    if ~get(handles.togglebutton2, 'value'), pushbutton1_Callback(handles.pushbutton1, eventdata, handles); end
    guidata(hObject, handles);
    

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on button press in radiobutton10. HANNING WINDOW OFF
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     if get(handles.radiobutton10, 'value')
%         set(handles.radiobutton10,'value',1);        
%         set(handles.radiobutton9,'value',0);
%     else
%         set(handles.radiobutton9,'value',1);
%         set(handles.radiobutton10,'value',0);        
%     end
    if ~get(handles.togglebutton2, 'value'),pushbutton1_Callback(handles.pushbutton1, eventdata, handles); end
   
    guidata(hObject, handles);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    main_xc = char(strjoin(strcat(string(handles.main_x), ','))); % convert numeric cell array to char vec separated by commas
    comp_xc = char(strjoin(strcat(string(handles.comp_x), ',')));
    
    answer = inputdlg({'Enter expected main frequencies (in Hz) separated by commas: ';...
        'Enter expected comp frequencies (in Hz) separated by commas: '}, ...
        'Expected Frequencies', 1, {main_xc(1:end-1), comp_xc(1:end-1)}); % inputdlg(PROMPT,NAME,NUMLINES,DEFAULTANSWER)

    if isempty(answer), return; end % user cancelled
    
    main_x = str2num(char(strsplit(answer{1}, ','))); % convert back to double array. ignore the str2num warning, because str2double will fail here
    comp_x = str2num(char(strsplit(answer{2}, ',')));

    if isempty(main_x) || isempty(comp_x) % isempty is true if user inputted words or left a box empty
        h=errordlg('Invalid input. Frequencies are being reverted to previous values');
        uiwait(h)
        return
    end
    handles.main_x = main_x;
    handles.comp_x = comp_x;
    guidata(hObject, handles);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
    if get(handles.radiobutton4, 'value') 
    % this is hard-coded but we could easily use the database method that dashboard and science_emi use to calibrate
        handles.dwell  = handles.dwell * 0.021777 - 0.3888;
    end
    if ~get(handles.togglebutton2, 'value'), pushbutton1_Callback(hObject, eventdata, handles); end
    guidata(hObject, handles);



% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
    if get(handles.radiobutton3, 'value')
        % undo the calibration if the box has been unchecked
        handles.dwell = (handles.dwell + 0.3888) / 0.021777;
    end
    if ~get(handles.togglebutton2, 'value'), pushbutton1_Callback(hObject, eventdata, handles); end  
    guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

    contents = get(handles.popupmenu1,'String');
    popCheck = contents(get(handles.popupmenu1,'Value')); % value is the index
    
    % switch to change to other GUI window
    switch strip(popCheck{1})
        case 'Data Evaluation'
            dashboard
            close(handles.figure1)
        case 'Science 3D EMI'
            science3d_emi
            close(handles.figure1)
        case 'Dwell FFT'
            return
        case 'Frequency Calculator'
            frequency_gui
            close(handles.figure1)
    end



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
