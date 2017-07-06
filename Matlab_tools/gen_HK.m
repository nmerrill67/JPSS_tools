function varargout = gen_HK(varargin)
% GEN_HK MATLAB code for gen_HK.fig
%      GEN_HK, by itself, creates a new GEN_HK or raises the existing
%      singleton*.
%
%      H = GEN_HK returns the handle to a new GEN_HK or the handle to
%      the existing singleton*.
%
%      GEN_HK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEN_HK.M with the given input arguments.
%
%      GEN_HK('Property','Value',...) creates a new GEN_HK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gen_HK_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gen_HK_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gen_HK

% Last Modified by GUIDE v2.5 02-May-2017 13:03:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gen_HK_OpeningFcn, ...
                   'gui_OutputFcn',  @gen_HK_OutputFcn, ...
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


% --- Executes just before gen_HK is made visible.
function gen_HK_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gen_HK (see VARARGIN)

% Choose default command line output for gen_HK

%These are used as names in the listboxes (normal underscores)
%handles.labels = 
        %used as axis labels (formatted underscores)
%handles.names = 
%handles.units = 
%handles.raw_units = 
                


handles.output = hObject;
guidata(hObject, handles);
% UIWAIT makes gen_HK wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gen_HK_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% getting the selected values in the listbox
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
handles.indiciesA1 = get(handles.listbox1,'Value');
guidata(hObject, handles);
         

% sets first item as selected if nothing is clicked
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
guidata(hObject, handles);


% getting the selected values in the listbox.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
handles.indiciesA2 = get(handles.listbox2,'Value');
guidata(hObject, handles);

% sets first item as selected if nothing is clicked
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


% getting the selected values in the listbox
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
handles.indiciesB1 = get(handles.listbox3,'Value');
guidata(hObject, handles);

% sets first item as selected if nothing is clicked
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.indiciesB1 = 1;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% getting the selected values in the listbox
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4
handles.indiciesB2 = get(handles.listbox4,'Value');
guidata(hObject, handles);

% sets first item as selected if nothing is clicked
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
handles.indiciesB2 = 1;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% Gets file and loads data from it
% **************** BROUSE FILES *************************
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	[handles.name, path] = uigetfile('*.txt'); %Modify for csv, txt, etc
    if path==0; 
        errordlg('No File Selected!');
    else
       set(handles.text2,'String', ['File Chosen: ', handles.name]);
    end
A = importdata(fullfile(path, handles.name));
handles.labels = A.colheaders;

%Setting list box contents
set(handles.listbox1,'String',handles.labels);
set(handles.listbox3,'String',handles.labels);
set(handles.listbox4,'String',['Time', handles.labels]);
set(handles.listbox2,'String',['Time', handles.labels]);


handles.telem = double(A.data);
[handles.rows,handles.cols] = size(handles.telem);
handles.telemdata = handles.telem(2:handles.rows,:); % throw away first row as it might contain corrupted info
[handles.data_rows,handles.data_cols] = size(handles.telemdata);

for i = 1, handles.data_cols;
    units{i} = ' counts ';
    raw_units{i} = ' counts ';
end;

handles.units = units;
handles.raw_units = raw_units;



set(handles.radiobutton1, 'value', 0) ;
set(handles.radiobutton2, 'value', 1) ;
            
handles.names = handles.labels;

handles.dates = handles.telem(2:handles.rows ,1 ) ;
%handles.time = handles.telem(2:handles.rows ,2) ;
%handles.time_sec = handles.telem(2:handles.rows ,3) ;
handles.seq_cnt = handles.telem(2:handles.rows ,4) ;

handles.millisec = handles.telemdata(: , 2);
handles.micsec = handles.telemdata(: ,3);
handles.delta_t = (handles.millisec(3) - handles.millisec(2)) / 1000; % calculate delta time for FFT
set(handles.text19,'string',['Sample Rate = ',num2str(1/handles.delta_t),' HZ']);
%handles.pktcount = handles.telem(:,4); % hours
handles.sec = double((handles.millisec ./ 1000) + (handles.micsec ./ 1000000)); % setting time vector
    nSecs1 = handles.sec(1);
    nSecs2 = handles.sec(handles.data_rows);
    handles.startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF');
    handles.stopT = datestr(nSecs2/86400, 'HH:MM:SS.FFF');
    [ elapsedsec ] = sec2time(handles.sec);
    handles.elapsedsec  = elapsedsec;
%    debugfile = 'debug' ;
%    save(debugfile,elapsedsec);
    
    [mnth, day, yr, handles.startdatestr,hr,min,secs,timestr] = day2date(handles.dates(1));
    [mnth, day, yr, handles.stopdatestr,hr,min,secs,timestr] = day2date(handles.dates(handles.data_rows));
%    handles.elapsedsec = zeros(1, handles.rows); % time vector (total elapsed seconds)
    set(handles.text10, 'string', ['Start Date: ', handles.startdatestr]);
    set(handles.text11, 'string', ['Start Time: ', handles.startT]);
    set(handles.text12, 'string', ['Stop Date: ', handles.stopdatestr]);
    set(handles.text13, 'string', ['Stop Time: ', handles.stopT]);

    %Cal
if get(handles.radiobutton1, 'value') == 1
        
        disp('Raw data being processed - calibration not available')

end  
    
%    handles.elapsedsec  = elapsedsec;
k = 1;
bad_index = {};
for i = 2:handles.data_rows ;
    seq_cnt_delta = (handles.seq_cnt(i) - handles.seq_cnt(i-1));
    if ((seq_cnt_delta) ~= 1) && (handles.seq_cnt(i) ~=0);
        bad_index{k} = i;
        k = k + 1;
        set(handles.text21,'string',['Sequence count error at data row ', num2str(i), ', Delta = ', num2str(seq_cnt_delta)]);
    end
end
%if isempty(bad_index)
%else
%disp(['Bad Packet Count Column Indicies:' bad_index]);
%end

guidata( hObject, handles );


% Plot Button
% ******************** PLOT *********************************
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        

if handles.indiciesA2 == 1 % x axis is either time or another telemetry point
    x1 = handles.elapsedsec(:);
    x1label = 'Time (s)';
else
    x1 = handles.telemdata(:, handles.indiciesA2 - 1);
    x1label = handles.names(1, handles.indiciesA2 - 1);
end

%dummy = handles.names

if get(handles.radiobutton1, 'value') == 1
        handles.y1label = strcat(handles.names(1, handles.indiciesA1), '--', handles.units(1, handles.indiciesA1));
        handles.y2label = strcat(handles.names(1, handles.indiciesB1), '--', handles.units(1, handles.indiciesB1));
else 
        handles.y1label = strcat(handles.names(1, handles.indiciesA1), '--', ' counts '); % handles.raw_units(1, handles.indiciesA1));
        handles.y2label = strcat(handles.names(1, handles.indiciesB1), '--', ' counts '); % handles.raw_units(1, handles.indiciesB1));
end

if get(handles.radiobutton1, 'value') == 1
        handles.y1labelSD = strcat(handles.labels(1, handles.indiciesA1), '--', handles.units(1, handles.indiciesA1));
        handles.y2labelSD = strcat(handles.labels(1, handles.indiciesB1), '--', handles.units(1, handles.indiciesB1));
else 
        handles.y1labelSD = strcat(handles.labels(1, handles.indiciesA1), '--', ' counts '); % handles.raw_units(1, handles.indiciesA1));
        handles.y2labelSD = strcat(handles.labels(1, handles.indiciesB1), '--', ' counts '); % handles.raw_units(1, handles.indiciesB1));
end

set(handles.text15, 'string', ['Standard Deviation of ', handles.y1labelSD, ' ', std(handles.telemdata(:, handles.indiciesA1))]);
set(handles.text16, 'string', ['Standard Deviation of ', handles.y2labelSD, ' ', std(handles.telemdata(:, handles.indiciesB1))]);
set(handles.text17, 'string', ['Mean:  ', num2str(mean(handles.telemdata(:, handles.indiciesA1)))]);
set(handles.text18, 'string', ['Mean:  ', num2str(mean(handles.telemdata(:, handles.indiciesB1)))]);
axes(handles.axes1);
if get(handles.radiobutton4, 'value') == 1
    plot( x1, handles.telemdata(:, handles.indiciesA1)); % first plot
else
    scatter( x1, handles.telemdata(:, handles.indiciesA1), 15);
end
    grid on;
ylim auto;
xlabel(x1label);
ylabel(handles.y1label);
legend(handles.y1label);
title('Plot 1');

if handles.indiciesB2 == 1
    x2 = handles.elapsedsec(:);
    x2label = 'Time (s)';
else
    x2 = handles.telemdata(:, handles.indiciesB2 - 1);
    x2label = handles.names(1, handles.indiciesB2 - 1);
end

axes(handles.axes2); % second plot
if get(handles.radiobutton6, 'value') == 1
    plot( x2, handles.telemdata(:, handles.indiciesB1));
else
    scatter( x2, handles.telemdata(:, handles.indiciesB1), 15);
end    
grid on;
ylim auto;
ylabel(handles.y2label);
xlabel(x2label);
legend(handles.y2label);
title('Plot 2')
guidata(hObject, handles);

% fft plots
% ************************ FFT ****************************
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton4_Callback(hObject, eventdata, handles);

delta_t = handles.delta_t;
%Fs = 1/(max(handles.elapsedsec)-min(handles.elapsedsec));
delf = (1/handles.rows)*(1/delta_t);% frequency increment for fft
nf = round((handles.rows/2)+1);
fr = 0:delf:(nf-1)*delf;
%fmax = 0.5/Ts;
%freq = 0:delf:fmax; % Change to 0:Fs:Fmax to see zero component
T = 0:delta_t:round(handles.elapsedsec(handles.rows-1));

%nf = handles.rows/2;

%dummy = size(freq);
%disp([' size of frequency vector:' dummy]);
%display(dummy);
%dummy1 = size(handles.indiciesA1);
%disp([' size of fft array:' dummy1]);
%display(dummy1);

fft_plot1 = fft(handles.telemdata(:,handles.indiciesA1));

fft_plot2 = fft(handles.telemdata(:,handles.indiciesB1));

f1=fft_plot1(1:nf);
f2=fft_plot2(1:nf);

fmag1=2*abs(f1)/(handles.rows);
fmag2=2*abs(f2)/(handles.rows);

size_fmag=max(size(fmag1));
size_fr=max(size(fr));
plot_size = min(size_fmag,size_fr);

%for i = uint32(1:74);
%   fftspec(:, i) = abs(fft(handles.telemdata(:, i))); %call to Matlab's Fast Fourier program
%end

%fftspec=fftspec(2:nf, :)./nf; % Change to (1:nf, :) to see zero component

set(figure, 'name', 'FFT Plots', 'Position', [100, 100, 750, 750]);
textBox = uicontrol('style','text');
set(textBox,'String', handles.name);
boxPosition = get(textBox,'Position');
set(textBox, 'Position', [15 710 275 20]); 
textBox2 = uicontrol('style','text');
set(textBox2,'String', [handles.startdatestr, ': ', handles.startT, '  -  ', handles.stopdatestr, ': ', handles.stopT]);
boxPosition = get(textBox,'Position');
set(textBox2, 'Position', [450 710 275 20]); 

subplot(2,1,1);

%[r,c]=size(freq);
%[r1,c1]=size(fftspec(:,handles.indiciesA1));
%freq_size=max(size(freq));

%if(freq_size>r1);
%       fftspec(:,handles.indiciesA1)=fftspec(0:r1-1,handles.indiciesA1);
%end
%plot(freq, fftspec(:, handles.indiciesA1));
plot(fr(2:plot_size), fmag1(2:nf));
xlabel('Frequency (Hz)');
title(['FFT for ' handles.names(1, handles.indiciesA1)]);
subplot(2,1,2);
plot(fr(2:plot_size), fmag2(2:nf));
xlabel('Frequency (Hz)');
title(['FFT for ' handles.names(1, handles.indiciesB1)]);

guidata(hObject, handles);
  % gui_Result(gcbo, [], guidata(gcbo) );


% --- Executes on button press in pushbutton6.
% ****************** SAVE AS ***************************
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1, 'visible', 'on');
set(handles.pushbutton7, 'visible', 'on');
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% ************** GET FILE NAME *****************************
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton7.
% ***************** SAVE FILE ******************************
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.edit1)
    set(handles.edit1, 'string', 'Housekeeping');
end
savename = get(handles.edit1, 'string');
export_fig('%d.png', savename);
guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
% ************* ERROR STATUS - LEFTOVER FROM ATMS HK PROCESSING ***********
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
errorFig = figure();
set(errorFig, 'position', [10 100 1900 750]);
SDbox = uicontrol('style', 'listbox', 'position', [0 0 600 700]);
text1 = uicontrol('style', 'text', 'position', [0 700 600 20]);
set(text1, 'String', 'SD Mode & Error Status Changes', 'HorizontalAlignment', 'left', 'FontSize', 14, 'FontWeight', 'bold');
set(SDbox, 'String', handles.SD, 'FontSize', 10, 'FontWeight', 'bold');
SDPosition = get(SDbox,'Position');

instbox = uicontrol('style', 'listbox', 'position', [600 0 650 700]);
text2 = uicontrol('style', 'text', 'position', [600 700 600 20]);
set(text2, 'String', 'Instrument Mode Status Changes', 'HorizontalAlignment', 'left', 'FontSize', 14, 'FontWeight', 'bold');
set(instbox, 'String', handles.inst, 'HorizontalAlignment', 'left', 'FontSize', 10, 'FontWeight', 'bold');
instPosition = get(instbox,'Position');

errbox = uicontrol('style', 'listbox', 'position', [1250 0 600 700]);
text3 = uicontrol('style', 'text', 'position', [1250 700 600 20]);
set(text3, 'String', 'Error Status Changes', 'HorizontalAlignment', 'left', 'FontSize', 14, 'FontWeight', 'bold');
set(errbox, 'String', handles.err, 'HorizontalAlignment', 'left', 'FontSize', 10, 'FontWeight', 'bold');

guidata(hObject, handles)


% --- Executes on button press in radiobutton1.
% ************* CALIBRATED DATA ******* NOT IMPLEMENTED IN THIS SCRIPT
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1
if get(handles.radiobutton1, 'value') == 1
        calparam1 = 0.000068666;
        handles.telemdata(:, 2)  = handles.telemdata(:, 2).*0.000085832;
        handles.telemdata(:, 3)  = handles.telemdata(:, 3).*0.00027466;
        handles.telemdata(:, 4)  = handles.telemdata(:, 4).*(-0.00027466);
        handles.telemdata(:, 5)  = handles.telemdata(:, 5).*0.00010717;
        handles.telemdata(:, 6)  = handles.telemdata(:, 6).*0.000212505;
        handles.telemdata(:, 7)  = (handles.telemdata(:, 7).*0.00025628 + 0.7);
        handles.telemdata(:, 8)  = (handles.telemdata(:, 8).*(-0.00025628) + 0.7);
        handles.telemdata(:, 9)  = handles.telemdata(:, 9).*0.00026560;
        handles.telemdata(:, 10)  = handles.telemdata(:, 10).*(-0.00026560);
        handles.telemdata(:, 40)  = (((handles.telemdata(:,40)-399.3371).*1000000)./(8905947 - (1907.3.*handles.telemdata(:, 40))));
        handles.telemdata(:, 41)  = (((handles.telemdata(:,41)-399.3371).*1000000)./(8905947 - (1907.3.*handles.telemdata(:, 41))));
        handles.telemdata(:, 42:43)  = handles.telemdata(:, 42:43).*0.00020399;
        handles.telemdata(:, 48:55)  = handles.telemdata(:, 48:55).*calparam1;
        handles.telemdata(:, 57)  = ((((handles.telemdata(:, 57).*4.284) - (45.08657.*handles.telemdata(:, 58)))./(handles.telemdata(:, 56)))+43.30089);
        handles.telemdata(:, 58)  = (((handles.telemdata(:, 58).*63.096)./(handles.telemdata(:, 56))) - 60.6212);
        handles.telemdata(:, 56)  = 5008./handles.telemdata(:, 56);
        handles.telemdata(:, 59)  = (handles.telemdata(:, 59).*0.021777 - 0.3888);
        handles.telemdata(:, 60)  = (handles.telemdata(:, 60).*0.021777 - 0.3888);
        handles.telemdata(:, 61)  = handles.telemdata(:, 61).*0.008817;
        handles.telemdata(:, 62)  = handles.telemdata(:, 62).*0.0625;
        handles.telemdata(:, 63)  = handles.telemdata(:, 63).*0.0625;
        handles.telemdata(:, 64)  = handles.telemdata(:, 64).*0.005493;
        handles.telemdata(:, 65)  = handles.telemdata(:, 65).*0.005493;
        handles.telemdata(:, 66)  = handles.telemdata(:, 66).*0.0625;
        handles.telemdata(:, 67)  = handles.telemdata(:, 67).*0.0625;
        handles.telemdata(:, 68)  = handles.telemdata(:, 68).*0.0005493164;
        handles.telemdata(:, 69)  = handles.telemdata(:, 69).*0.0005493164;
        handles.telemdata(:, 70)  = 458752./handles.telemdata(:, 70);
        handles.telemdata(:, 71)  = handles.telemdata(:, 71).*0.005493164;  
end

guidata(hObject, handles);


% --- Executes on button press in radiobutton2.
% *********** PROCESS RAW DATA - COUNTS *****************
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
%handles.telemdata = handles.telem(:, 5:78);
%for i = 55:74
    %for k = 1:handles.rows
        %if handles.telemdata(k, i) > 32768;
        %    handles.telemdata(k, i) = handles.telemdata(k, i) - 65536;
        %end
    %end
%end            
guidata(hObject, handles);


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
