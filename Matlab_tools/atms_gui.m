% Nick Azzopardi
% 2015 JPSS Summer Intern
%
% This script runs atms_gui.fig, which plots the dwell data for main motor
% current. The top two plots are the raw motor current data (left) and
% the fft for the whole dataset (right). The bottom two plots are the fft
% sliced into a user specified number of slices, shown in two different
% frequency views.
%
%
function varargout = atms_gui(varargin)
% atms_gui MATLAB code for atms_gui.fig
%      atms_gui, by itself, creates a new atms_gui or raises the existing
%      singleton*.
%
%      H = atms_gui returns the handle to a new atms_gui or the handle to
%      the existing singleton*.
%
%      atms_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in atms_gui.M with the given input arguments.
%
%      atms_gui('Property','Value',...) creates a new atms_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before atms_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to atms_gui_OpeningFcn via varargin.
%xls

%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help atms_gui

% Last Modified by GUIDE v2.5 14-Jul-2016 15:36:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @atms_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @atms_gui_OutputFcn, ...
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


% --- Executes just before atms_gui is made visible.
function atms_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to atms_gui (see VARARGIN)
% Choose default command line output for atms_gui
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes atms_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = atms_gui_OutputFcn(hObject, eventdata, handles) 
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
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Plot button: Runs the code & plots figures based on inputs
function pushbutton1_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.text9,'String','Plotting...');
    slices = str2num(get(handles.edit1,'String')); % fft slices ( after the array is transformed into one dimensional vector
    handles.dates = handles.data(:, 1); % Array of Dates
    time_millsec = handles.data(:, 2); % Array of ms
    time_micsec = handles.data(:, 3); % Array of u_sec
    handles.seq_count = handles.data(:,4);
    sec = ((time_millsec ./ 1000) + (time_micsec ./ 1000000)); % creates single array of seconde 
    
    switch get(get(handles.uibuttongroup1,'SelectedObject'),'Tag')
        case 'radiobutton1', % Sets data to be used for demodulated plots 
            endcol = 153;
            val = 0;
            if get(handles.radiobutton5, 'value') == 1
                label = 'for All Scan Positions - de-modulated';
            else
                label = 'for All Scan Positions - Raw Data';
            end
            scan_slices = str2num(get(handles.edit2,'String')); % number of scans to determine averages (taken from input in edit box)
            Xaxis1 = 5;
            Xaxis2 = 30;
            Yaxis = 2;
            Yaxis2 = 1;
        case 'radiobutton2',
            endcol = 101;
            val = 1;
            label = 'Earth Scan Positions Only';
            Xaxis1 = 5;
            Xaxis2 = 30;
            Yaxis = .45;
            Yaxis2 = 0.05;
    end
            
    handles.dwell = handles.data(:, 6:endcol);
    [handles.rows,handles.cols] = size(handles.dwell);
    han_window = hanning(handles.cols); %get Hanning window coefficients
   	Num_points = handles.cols*handles.rows; 
    nSecs1 = sec(1);
    nSecs2 = sec(handles.rows);
    handles.startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF');
    handles.stopT = datestr(nSecs2/86400, 'HH:MM:SS.FFF');
    [mnth, day, yr, handles.startdatestr,hr,mins,secs,timestr] = day2date(handles.dates(1));
    [mnth, day, yr, handles.stopdatestr,hr,mins,secs,timestr] = day2date(handles.dates(handles.rows));
    set(handles.text7,'String',(['Start Date: ', handles.startdatestr])); %Setting Times and Dates
    set(handles.text4,'String',(['Start Time: ', handles.startT]));
    set(handles.text8,'String',(['Stop Date: ', handles.stopdatestr]));
    set(handles.text5,'String',(['Stop Time: ', handles.stopT]));
 
    if get(handles.radiobutton4, 'value') == 1;
        handles.dwell  = (handles.dwell.*0.021777 - 0.3888);
        if get(handles.radiobutton1, 'value') == 1
            Yaxis = Yaxis/20;
%            Yaxis2 = Yaxis2;
        else
            Yaxis = Yaxis/40;
%            Yaxis2 = Yaxis2/2;
        end
        
    else 
        handles.dwell = handles.data(:, 6:endcol);
    end
    
    % de-mod Option
    if val == 0; 
        if get(handles.radiobutton5, 'value') == 1
         for islice = 1:scan_slices:handles.rows; % loop calculates demodulated average
        
          if ((islice+scan_slices)>(handles.rows)) break;end;
        
             for icolumn = 1:(endcol-5);
        
             if ((islice+scan_slices)>(handles.rows)) break;end;
        
             raw_ave(islice, icolumn) = mean(handles.dwell(islice:islice+scan_slices-1,icolumn));
        
             handles.dwell(islice:islice+scan_slices-1,icolumn) = handles.dwell(islice:islice+scan_slices-1,icolumn) - raw_ave(islice,icolumn);
        
             end
        
         end  
        end
    end
    
    % Sets expected frequencies for stem plots
    main_x = [ 0.08,0.09,1.4,2.8,3.1,3.4,4.2,5.6,5.9,7.0,8.4,9,11.2,24.2 ];
    main_y = [ 2,2,2,2,2,2,2,2,2,2,2,2,2,2 ];
    
    comp_x = [ 0.14,0.16,2.47,4.93,5.45,6.12 ];
    comp_y = [ 2,2,2,2,2,2 ];

	delta_t = double((8/3)/(148)); % Sets time increment - fixed at 148 samples per scan

	t = 0: delta_t: round(delta_t*Num_points); % Sets whole time vector
    
    % data is read in as row(scans) and column(samples 1:(endcol))
    % the ':' operation will form a vector with each column formaing a
    % sequencial time series. column 1 then column 2 etc.
    handles.dwell = handles.dwell'; % transpose row/column to work with the ':' operator
	raw_col = (handles.dwell(:)); % make data in column order 
    size_t=max(size(t));
    size_raw=max(size(raw_col));
    plot_size=min(size_t,size_raw);
    
    % Creates the top left plot 
    axes(handles.axes2);
    plot(t(1:plot_size),raw_col(1:plot_size));
    grid on;
    xlabel(' Seconds ');
    if get(handles.radiobutton3, 'value') == 1
        ylabel(' data counts ');
    else
        ylabel('Amps')
    end
    title([' ATMS Main Motor Current ', label]);

delf=(1/Num_points)*(1/delta_t); %frequency increment for fft

nf=(Num_points/2)+1;  % Number of points in frequency plots 

fr=0:delf:(nf-1)*delf; % freq vector

ff=fft(raw_col); % call to Matlab's Fast Fourier program
    
f=ff(1:nf); % positive components

fmag=2*abs(f)/Num_points;

size_fmag=max(size(fmag)); 
size_fr=max(size(fr));
plot_size=min(size_fmag,size_fr);   

axes(handles.axes3); % Creates top right plot
plot(fr(1:plot_size),fmag(1:nf)); 
hold on;
if get(handles.radiobutton7, 'value') == 1
    stem(main_x,main_y,'r');
    stem(comp_x,comp_y,'g');    
end
axis([0 Xaxis2 0 Yaxis2]); % sets axis dimensions, can be changed in switch above (line 108)
xlabel(' Frequency(Hz)');
ylabel('FFT Magnitude');
title(' PSD results for entire data set');
grid on;
hold off;
%figure;

% Changes frequency vector to adjust for new, sliced plots.
II = round(Num_points/slices);

nf = round(II/2+1);
delf=(II-1)/II/t(II);
fr=0:delf:(nf-1)*delf; 

%fr=0:delta_t:(nf-1)*delta_t;

% slices up the fft
for islice = 0:1:(slices-2);
    raw = raw_col((islice*II+1):(islice+1)*II);
    ff = fft(raw);
    f = ff(1:nf);
    fmag_array(islice+1,1:nf)=2*abs(f)/II;
    fmag_array(islice+1,1) = 0;
end 

%scrsz=get(0,'ScreenSize');

% figure('Position',[500 scrsz(4)/1.2 scrsz(3)/1.2 scrsz(4)/1.2]);
% hold off;
start = 1;
iislice = start;
finish = str2double(get(handles.edit1,'String'));

set(handles.text9,'String','Done');

day = zeros(1,slices);

for i = 1:(slices - 1) %set day vector
if sec(round((i)*length(sec)/slices)) > sec(round((i+1)*length(sec)/slices))
    day((i+1):slices) = day(i+1)+1;
end
end

[ handles.elapsedsec ] = sec2time(sec); % Creates vector of total elapsed seconds


while(iislice < finish);
    % Slices edit box
    if isempty(get(handles.edit1))
        set(handles.edit1, 'String', '2000') % sets slices to 2000 if slices is empty
    end
    finish = str2double(get(handles.edit1,'String'));
    currslice = str2double(get(handles.edit8, 'String')); % gets the current slice and edits it from an invisible edit box in bottom right
    %Start/finish assimilation, allows you to go backwards through the slices
    if currslice == finish || currslice > finish
        currslice = start;
        set(handles.edit8, 'String', '1');
    end
    if currslice == 0
        currslice = finish - 1;
        set(handles.edit8, 'String', num2str(finish - 1));
    end
    iislice = currslice;
    
    %Time/Date of current slice
    if currslice == 1
        Secs1 = sec(1);
        Secs2 = sec(round((currslice)*handles.rows/slices));
    else
    Secs1 = sec(round((currslice -1)*length(sec)/slices));
    Secs2 = sec(round((currslice)*handles.rows/slices)); 
    end
    
    
    
    if day(currslice) > 0
        Secs1 = Secs1 + 86400*day(currslice); % More Time/date resolution
    end
    
    slicestartT = datestr(Secs1/86400, 'HH:MM:SS.FFF');
    slicestopT = datestr(Secs2/86400, 'HH:MM:SS.FFF'); 
    
    % gets date of year from day from epoch through LL function
    [mnth, days, yr, currdatestr,hr,mins,secs,timestr] = day2date(handles.dates(round(currslice*(handles.rows/slices))));
    
    set(handles.text21,'String',(['Slice Start Time: ', slicestartT]));
    set(handles.text24,'String',(['Current Day: ', currdatestr]));
    set(handles.text22,'String',(['Slice Stop Time: ',  slicestopT]));
    set(handles.text26,'String', (['Current Slice Start: ', num2str(handles.elapsedsec(round(currslice*(handles.rows/slices)))/10000), 'x10^4  Seconds']));
    
    %Bottom Left Plot
    axes(handles.axes4);
    plot(fr,fmag_array(currslice, 1:nf));
    hold on
    if get(handles.radiobutton7, 'value') == 1
        stem(main_x,main_y,'r');
        stem(comp_x,comp_y,'g');    
    end
    axis([0 Xaxis1 0 Yaxis*2]); grid on; 
    title([' ATMS ', label]); %Change Dates
    xlabel(' Frequency(Hz)');
    ylabel('FFT magnitiude');
    hold off
    
    %Bottom Right Plot
    axes(handles.axes5);
    %axes([ 0 30 0 .5 ]);
    plot(fr,fmag_array(currslice, 1:nf));
    hold on
    if get(handles.radiobutton7, 'value') == 1
     stem(main_x,main_y,'r');
     stem(comp_x,comp_y,'g');    
    end
    axis([0 Xaxis2 0 Yaxis*2]); grid on;
    title([' ATMS ', label]);
    xlabel(' Frequency(Hz)');
    ylabel('FFT magnitiude');
    hold off
    
    set(handles.text16, 'String',sprintf('Current Slice: %g of %d', currslice, finish)); % Sets Current slice time in small text box
   
    %Pausing/Continuing features
    if isempty(get(handles.edit9, 'String'))
    pausetime = 0.5;
    else
    pausetime = 1/str2double(get(handles.edit9, 'String'));
    end    
    if get(handles.togglebutton2,'Value')==1
    pause(pausetime);
    set(handles.edit8, 'String', num2str(str2double(get(handles.edit8, 'String')) + 1))
    continue
    end
    uiwait(gcf); 
    get(handles.togglebutton2);
    get(handles.pushbutton5); %advance currslice to entered slice
    get(handles.pushbutton9); %advance currslice 1
    get(handles.pushbutton11); % go back one slice
    guidata(hObject, handles);
end


% Browse button: gets the file and imports to "handles.dwell"
function pushbutton2_Callback(hObject, eventdata, handles) %Browse button
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	[name, path] = uigetfile('*.txt'); %Modify for csv, txt, etc
    if path==0; 
        errordlg('No File Selected!'); 
    else
        set(handles.text6,'String',name); %Displays filename in top right
        set(handles.text2,'String','File Chosen:');
    end
handles.data = load(fullfile(path, name)); %change xlsread to load function for csv/txt
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


% Close Button
function pushbutton3_Callback(hObject, eventdata, handles) %Close Button
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;

% 
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit8, 'String', get(handles.edit7, 'String'));
uiresume(gcbf);


% --- Executes during object creation, after setting all properties.
function text16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% "Go to slice:" edit box, used in plot button
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% "Next" button, gets data from hidden edit box (edit8)
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit8, 'String', num2str(str2double(get(handles.edit8, 'String')) + 1));
uiresume(gcbf);


% Hidden box which stores value of the current slice
function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
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
set(handles.edit8, 'String', num2str(str2double(get(handles.edit8, 'String')) - 1));
uiresume(gcbf);


% earth scan only
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(handles.edit2,'visible','off');
set(handles.text10,'visible','off');
set(handles.uibuttongroup3, 'visible', 'off');

% demodulated data
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
set(handles.edit2,'visible','on');
set(handles.text10,'visible','on');
set(handles.uibuttongroup3, 'visible', 'on')


% play button
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of togglebutton2
uiresume(gcbf);


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
set(handles.edit11, 'visible', 'on');
set(handles.pushbutton13, 'visible', 'on');
guidata(hObject, handles);

% Save Button
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.edit11)
    set(handles.edit11, 'string', 'Science Data');
end
savename = get(handles.edit11, 'string');
export_fig('%d.png', savename);
guidata(hObject, handles);


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

% necessary to show data without clicking plot button
    handles.dates = handles.data(:, 1); % Array of Dates
    time_millsec = handles.data(:, 2); % Array of ms
    time_micsec = handles.data(:, 3); % Array of u_sec
    handles.seq_count = handles.data(:,4);
    sec = ((time_millsec ./ 1000) + (time_micsec ./ 1000000)); % creates single array of seconde 
    
    switch get(get(handles.uibuttongroup1,'SelectedObject'),'Tag')
        case 'radiobutton1', % Sets data to be used for demodulated plots 
            endcol = 153;
            val = 0;
            label = 'for All Scan Positions - de-modulated';
            scan_slices = str2num(get(handles.edit2,'String')); % number of scans to determine averages (taken from input in edit box)
            Xaxis1 = 5;
            Xaxis2 = 30;
            Yaxis = 2;
            Yaxis2 = 1;
        case 'radiobutton2',
            endcol = 101;
            val = 1;
            label = 'Earth Scan Positions Only';
            Xaxis1 = 5;
            Xaxis2 = 20;
            Yaxis = .5;
            Yaxis2 = 0.45;
    end
            
    handles.dwell = handles.data(:, 6:endcol);
    [handles.rows,handles.cols] = size(handles.dwell);
    nSecs1 = sec(1);
    nSecs2 = sec(handles.rows);
    handles.startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF');
    handles.stopT = datestr(nSecs2/86400, 'HH:MM:SS.FFF');
    [mnth, day, yr, handles.startdatestr,hr,mins,secs,timestr] = day2date(handles.dates(1));
    [mnth, day, yr, handles.stopdatestr,hr,mins,secs,timestr] = day2date(handles.dates(handles.rows));
    set(handles.text7,'String',(['Start Date: ', handles.startdatestr])); %Setting Times and Dates
    set(handles.text4,'String',(['Start Time: ', handles.startT]));
    set(handles.text8,'String',(['Stop Date: ', handles.stopdatestr]));
    set(handles.text5,'String',(['Stop Time: ', handles.stopT]));

    if get(handles.radiobutton4, 'value') == 1;
        handles.dwell  = (handles.dwell.*0.021777 - 0.3888);
    else 
        handles.dwell = handles.data(:, 6:endcol);
    end
        
for i = 1:handles.cols
    dev(i) = std(handles.dwell(:, i));
    means(i) = mean(handles.dwell(:, i));
    devstring{i} = ['Position ', num2str(i), ':  Mean: ', num2str(means(i)), '   Standard Deviation: ', num2str(dev(i))];
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
text1 = uicontrol('style', 'text', 'position', [75 800 600 20]);


set(text1, 'String', ['Mean and Standard Deviation for all positions: ', handles.startdatestr, ' ', handles.startT, ' - ', handles.stopdatestr, ' ', handles.stopT] , 'HorizontalAlignment', 'left', 'FontSize', 10, 'FontWeight', 'bold');

set(SDevbox, 'String', devstring, 'FontSize', 10, 'FontWeight', 'bold');
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
set(handles.radiobutton10,'value','off');

% Hint: get(hObject,'Value') returns toggle state of radiobutton9


% --- Executes on button press in radiobutton10. HANNING WINDOW OFF
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton9,'value','off');

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
