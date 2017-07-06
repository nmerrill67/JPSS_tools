function varargout = housekeeping(varargin)
% HOUSEKEEPING MATLAB code for housekeeping.fig
%      HOUSEKEEPING, by itself, creates a new HOUSEKEEPING or raises the existing
%      singleton*.
%
%      H = HOUSEKEEPING returns the handle to a new HOUSEKEEPING or the handle to
%      the existing singleton*.
%
%      HOUSEKEEPING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOUSEKEEPING.M with the given input arguments.
%
%      HOUSEKEEPING('Property','Value',...) creates a new HOUSEKEEPING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before housekeeping_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to housekeeping_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help housekeeping

% Last Modified by GUIDE v2.5 21-Jul-2015 15:45:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @housekeeping_OpeningFcn, ...
                   'gui_OutputFcn',  @housekeeping_OutputFcn, ...
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


% --- Executes just before housekeeping is made visible.
function housekeeping_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to housekeeping (see VARARGIN)

% Choose default command line output for housekeeping

%These are used as names in the listboxes (normal underscores)
handles.labels = {'Software Version/Serial Number' 'SPA_P5V_A/B_VMON' 'SPA_P15V_A/B_VMON' 'SPA_N15V_A/B_VMON' ...
            'RCV_P6V_RF_VMON' 'RCV_P12V_RF2_VMON' 'RCV_P15V_RF_VMON' 'RCV_N15V_RF_VMON' 'RCV_P15V_ANA_VMON' ...
            'RCV_N15V_ANA_VMON' 'K_RFE_PRT [1]' 'K_RFE_PRT [2]' 'V_RFE_PRT [1]' 'V_PRI_PLO_PRT [2]' ...
            'V_RED_PLO_PRT [1]' 'V_IF_PRT [1]' 'W_RFE_PRT [2]' 'SAW_FILT_PRT [1]' 'W_IF_PRT [2]' 'W_PRI_LO_PRT [1]' ...
            'W_RED_LO_PRT [2]' 'G_PRI_LO_PRT [1]' 'G_RED_LO_PRT [2]' 'G1_IF_PRT [2]' 'G2_IF_PRT [1]' 'W_SHELF_PRT' ...
            'KKA_SHELF_PRT' 'G_SHELF_PRT' 'V_SHELF_PRT' 'RCVPS_A_PRT [1]' 'RCVPS_B_PRT [2]' 'OCXO_PRI_PRT [2]' ...
            'OCXO_RED_PRT [2]' 'DSPA_1553_PRT [2]' 'DSPB_1553_PRT[1]' 'SPA_PS_A_PRT[2]' 'SPA_PS_B_PRT [1]' ...
            'DSPA_PROC_PRT [1]' 'DSPB_PROC_PRT [2]' 'SD_MECH_TEMP' 'SD_PS_PRT' 'V_PLO_A_LOCK_VMON' 'V_PLO_B_LOCK_VMON' ...
            'HK_2WREST1_A/B' 'HK_2WREST2_A/B' '4W_GND_A/B' '2W_GND_A/B' 'VD_REF_A/B Module 1' 'VD_REF_A/B Module 2' ...
            'VD_REF_A/B Module 3' 'VD_REF_A/B Module 4' 'VD_GND_A/B Module 1' 'VD_GND_A/B Module 2' 'VD_GND_A/B Module 3' ...
            'VD_GND_A/B Module 4' 'SD_P5V_VMON' 'SD_P12V_VMON' 'SD_N12V_VMON' 'MAIN_MOTOR_CUR' 'COMP_MOTOR_CUR' ...
            'RESOLVER_VMON' 'SD_MAIN_MOTOR_VEL' 'SD_COMP_MOTOR_VEL' 'SD_MAIN_LOOP_ERROR' 'SD_MAIN_LOOP_INT_ERROR'...
            'SD_MAIN_LOOP_VEL_ERROR' 'SD_COMP_LOOP_ERROR' 'SD_MAIN_MOTOR_REQ_VOLTAGE' 'SD_COMP_MOTOR_REQ_VOLTAGE' ...
            'SD_FEED_FORWARD_VOLTAGE' 'COMP_MOTOR_POS' 'SD_MODE_&_ERRORS [3]' 'INSTRUMENT_MODE [3]' 'ERROR_STATUS [3]'};

        %used as axis labels (formatted underscores)
handles.names = {'Software Version/Serial Number' 'SPA\_P5V\_A/B\_VMON' 'SPA\_P15V\_A/B\_VMON' 'SPA\_N15V\_A/B\_VMON' ...
            'RCV\_P6V\_RF\_VMON' 'RCV\_P12V\_RF2\_VMON' 'RCV\_P15V\_RF\_VMON' 'RCV\_N15V\_RF\_VMON' 'RCV\_P15V\_ANA\_VMON' ...
            'RCV\_N15V\_ANA\_VMON' 'K\_RFE\_PRT [1]' 'K\_RFE\_PRT [2]' 'V\_RFE\_PRT [1]' 'V\_PRI\_PLO\_PRT [2]' ...
            'V\_RED\_PLO\_PRT [1]' 'V\_IF\_PRT [1]' 'W\_RFE\_PRT [2]' 'SAW\_FILT\_PRT [1]' 'W\_IF\_PRT [2]' 'W\_PRI\_LO\_PRT [1]' ...
            'W\_RED\_LO\_PRT [2]' 'G\_PRI\_LO\_PRT [1]' 'G\_RED\_LO\_PRT [2]' 'G1\_IF\_PRT [2]' 'G2\_IF\_PRT [1]' 'W\_SHELF\_PRT' ...
            'KKA\_SHELF\_PRT' 'G\_SHELF\_PRT' 'V\_SHELF\_PRT' 'RCVPS\_A\_PRT [1]' 'RCVPS\_B\_PRT [2]' 'OCXO\_PRI\_PRT [2]' ...
            'OCXO\_RED\_PRT [2]' 'DSPA\_1553\_PRT [2]' 'DSPB\_1553\_PRT[1]' 'SPA\_PS\_A\_PRT[2]' 'SPA\_PS\_B\_PRT [1]' ...
            'DSPA\_PROC\_PRT [1]' 'DSPB\_PROC\_PRT [2]' 'SD\_MECH\_TEMP' 'SD\_PS\_PRT' 'V\_PLO\_A\_LOCK\_VMON' 'V\_PLO\_B\_LOCK\_VMON' ...
            'HK\_2WREST1\_A/B' 'HK\_2WREST2\_A/B' '4W\_GND\_A/B' '2W\_GND\_A/B' 'VD\_REF\_A/B Module 1' 'VD\_REF\_A/B Module 2' ...
            'VD\_REF\_A/B Module 3' 'VD\_REF\_A/B Module 4' 'VD\_GND\_A/B Module 1' 'VD\_GND\_A/B Module 2' 'VD\_GND\_A/B Module 3' ...
            'VD\_GND\_A/B Module 4' 'SD\_P5V\_VMON' 'SD\_P12V\_VMON' 'SD\_N12V\_VMON' 'MAIN\_MOTOR\_CUR' 'COMP\_MOTOR\_CUR' ...
            'RESOLVER\_VMON' 'SD\_MAIN\_MOTOR\_VEL' 'SD\_COMP\_MOTOR\_VEL' 'SD\_MAIN\_LOOP\_ERROR' 'SD\_MAIN\_LOOP\_INT\_ERROR'...
            'SD\_MAIN\_LOOP\_VEL\_ERROR' 'SD\_COMP\_LOOP\_ERROR' 'SD\_MAIN\_MOTOR\_REQ\_VOLTAGE' 'SD\_COMP\_MOTOR\_REQ\_VOLTAGE' ...
            'SD\_FEED\_FORWARD\_VOLTAGE' 'COMP\_MOTOR\_POS' 'SD\_MODE\_&\_ERRORS [3]' 'INSTRUMENT\_MODE [3]' 'ERROR\_STATUS [3]'};
        
handles.units = {'Counts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Counts', 'Counts', 'Counts', 'Counts', ...
                'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', ...
                'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Degrees C', 'Degrees C', ...
                'Volts', 'Volts', 'Counts', 'Counts', 'Counts', 'Counts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', 'Volts', ...
                'Volts', 'Volts', 'Volts', 'Amps', 'Amps', 'Volts', 'Deg/Sec', 'Deg/Sec', 'Degrees', 'Degrees', 'Deg/Sec', 'Deg/Sec', 'Volts', 'Volts', ...
                'Volts', 'degrees', 'Counts', 'Counts', 'Counts'};
handles.raw_units = {'Counts','Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', ...
                     'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts','Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', ...
                     'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts','Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', ...
                     'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts', 'Counts' };
                
%Setting list box contents
set(handles.listbox1,'String',handles.labels);
set(handles.listbox3,'String',handles.labels);
set(handles.listbox4,'String',['Time', handles.labels]);
set(handles.listbox2,'String',['Time', handles.labels]);

handles.output = hObject;
guidata(hObject, handles);
% UIWAIT makes housekeeping wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = housekeeping_OutputFcn(hObject, eventdata, handles) 
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
handles.telem = load(fullfile(path, handles.name));
[handles.rows,handles.cols] = size(handles.telem);
handles.telemdata = handles.telem(:, 5:78);

for i = 55:74
    for k = 1:handles.rows
        if handles.telemdata(k, i) > 32768;
            handles.telemdata(k, i) = handles.telemdata(k, i) - 65536;
        end
    end
end            
     
handles.dates = handles.telem(:,1);
handles.millsec = handles.telem(:,2);
handles.micsec = handles.telem(:,3);
handles.pktcount = handles.telem(:,4); % hours
handles.sec = double((handles.millsec ./ 1000) + (handles.micsec ./ 1000000)); % setting time vector
    nSecs1 = handles.sec(1);
    nSecs2 = handles.sec(handles.rows);
    handles.startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF');
    handles.stopT = datestr(nSecs2/86400, 'HH:MM:SS.FFF');
    [ elapsedsec ] = sec2time(handles.sec);
    handles.elapsedsec  = elapsedsec;
%    debugfile = 'debug' ;
%    save(debugfile,elapsedsec);
    
    [mnth, day, yr, handles.startdatestr,hr,min,secs,timestr] = day2date(handles.dates(1));
    [mnth, day, yr, handles.stopdatestr,hr,min,secs,timestr] = day2date(handles.dates(handles.rows));
%    handles.elapsedsec = zeros(1, handles.rows); % time vector (total elapsed seconds)
    set(handles.text10, 'string', ['Start Date: ', handles.startdatestr]);
    set(handles.text11, 'string', ['Start Time: ', handles.startT]);
    set(handles.text12, 'string', ['Stop Date: ', handles.stopdatestr]);
    set(handles.text13, 'string', ['Stop Time: ', handles.stopT]);
    
    handles.serial_number = int16(handles.telemdata(3,1)) ; % get serial number of the instrument from the third row - to make sure that it's valid data
        
    handles.serial_number = bitand( bitshift(handles.serial_number, -8), hex2dec('FF')); 
        
        if handles.serial_number == 49;
            SN_LABEL = 'EDU';
        else if handles.serial_number == 50;
                SN_LABEL = 'PFM';
            else if handles.serial_number == 51;
                    SN_LABEL = 'FM1';
                else if handles.serial_number == 52;
                        SN_LABEL = 'FM2';
                    else if handles.serial_number == 53;
                            SN_LABEL = 'FM3';
                        else if handles.serial_number == 54;
                                SN_LABEL = 'FM4';
                            else if handles.serial_number == 55;
                                    SN_LABEL = 'FM5';
                                end
                            end
                        end
                    end
                end
            end
        end
        
    handles.sn_label = SN_LABEL ; % set global variable
    
    set(handles.text19, 'string', ['SERIAL #: ', SN_LABEL]);
    
    
    %Cal
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
        disp('yes')
elseif get(handles.radiobutton2, 'value') == 1
        %handles.y1label = strcat(handles.names(1, handles.indiciesA1), '--', handles.raw_units(1, handles.indiciesA1));
        %handles.y2label = strcat(handles.names(1, handles.indiciesB1), '--', handles.raw_units(1, handles.indiciesB1));
        disp('no')
end
    SD_m_e1 = handles.telemdata(:, 72);
    inst_mode = handles.telemdata(:, 73);
    errStatus = handles.telemdata(:, 74);
    
   SDdescriptionsON = {'64X RTD Error Flag – Error indicator from the SDE', 'Unused. Always zero (0)', 'Compensator Motor Off', ...
       'Redundancy A is selected', 'There is no power to the main motor', 'An Illegal Command was received', ...
       'SDE received a command with an illegal length', 'Command received with an illegal parity', ...
       'Unused. Always zero (0)', 'Scan drive is in stare mode', 'Unused. Always zero (0)', ...
       'Unused. Always zero (0)', 'SDE is using scan profile loaded into RAM', 'SDE is using scan profile located in its PROM memory', ...
       'In Standby Mode. SDE enabled but SDM not energized', ...
       'Power Cycle Flag: Power on reset occured, which implies a prior degradation or loss of power.'};
   
   InstModedescriptionsON = {'Redundancy Block A/B. B is selected', 'Saw Filter A/B. B is selected', ...
       'Scan Drive Enabled. SDE has been enabled with a Subsystem Enable', ...
       'SPA A/B, B is selected','SD Compensator Enable. Scan drive compensator motor is enabled', ...
       'Receiver Enabled. Receiver subsystem has been enabled with a subsystem enable', ...
       'PLO Lock Indicator. Receiver is enabled and the PLO Lock signal detected', ...
       'Scan Drive Profile', 'Scan Drive Profile', 'Scan Drive Profile', ...
       'Synchronization Mode.Using 8-second pulse (NPP).', ...
       'Diagnostic Data Enabled. Diagnostic packets are being sent', 'Dwell Data Enabled. Dwell packets are enabled', ...
       'Continuous Sampling. Continuous Sampling Mode selected', ...
       'Safe-Hold Mode. Instrument is in Safe-hold','Unused. Always zero'};
       
   ErrStatusdescriptionsON = {'Housekeeping telemetry word position of item which violated safety limit definition', 'Housekeeping telemetry word position of item which violated safety limit definition', ...
       'Housekeeping telemetry word position of item which violated safety limit definition', 'Housekeeping telemetry word position of item which violated safety limit definition', ...
       'Housekeeping telemetry word position of item which violated safety limit definition', 'Housekeeping telemetry word position of item which violated safety limit definition' ...
       'Housekeeping telemetry word position of item which violated safety limit definition', ...
       'Scan Phase Error Correction Transmitted. A phase correction to the scan drive electronics was necessary during the previous eight-second period.', ...
       'SDE Command Transmit Timeout error occurred.', ...
       'SDE position data is not available. When Science data is enabled, position data should arrive automatically. No position information is detected', ...
       'The 9-bit telemetry header is detected with a bad parity', 'The 17-bit telemetry data is detected with a bad parity', ...
       'Problem related to the time-tagging of telemetry data is detected', 'Problem related to the time-tagging of telemetry data is detected', ...
       'A latchup condition due to excessive radiation is detected on the Video Digitizer CCA', ...
       'A latchup condition due to excessive radiation is detected on the Housekeeping CCA'};

   SDdescriptionsOFF = {'64X RTD Error Flag – No Error indicated from the SDE', 'Unused. Always zero (0)', 'Compensator Motor On', ...
       'Redundancy A not selected', 'There is power to the main motor', 'An Illegal Command not received', ...
       'The SDE didnt receive a command with an illegal length', 'Command was not received with an illegal parity', ...
       'Unused. Always zero (0)', 'Scan drive is not in stare mode', 'Unused. Always zero (0)', ...
       'Unused. Always zero (0)', 'SDE is not using scan profile loaded into RAM', 'SDE is using not scan profile located in its PROM memory', ...
       'Not in Standby Mode', ...
       '“Reset” command recieved (hex F5)'};
   
   InstModedescriptionsOFF = {'Redundancy Block A/B. A is selected', 'Saw Filter A/B. A is selected', ...
       'SPA A/B, A is selected', 'Scan Drive Not Enabled. SDE not enabled with a Subsystem Enable', ...
       'Scan drive compensator motor is NOT enabled', ...
       'Receiver NOT Enabled. The receiver subsystem has not been enabled with a subsystem enable', ...
       'PLO Lock Indicator off. The receiver is not enabled or the PLO Lock signal is not detected', ...
       'Scan Drive Profile', 'Scan Drive Profile', 'Scan Drive Profile', ...
       'Synchronization Mode: Using 1-second pulse (NPOESS)', ...
       'Diagnostic packets are NOT being sent', 'Dwell packets are NOT enabled', ...
       'Continuous Sampling Mode NOT selected', ...
       'Instrument is NOT in Safe-hold','Unused. Always zero'};
       
   ErrStatusdescriptionsOFF = {'Housekeeping telemetry word position of item which violated safety limit definition', 'Housekeeping telemetry word position of item which violated safety limit definition', ...
       'Housekeeping telemetry word position of item which violated safety limit definition', 'Housekeeping telemetry word position of item which violated safety limit definition', ...
       'Housekeeping telemetry word position of item which violated safety limit definition', 'Housekeeping telemetry word position of item which violated safety limit definition' ...
       'Housekeeping telemetry word position of item which violated safety limit definition', ...
       'Scan Phase Error Correction NOT Transmitted. A phase correction to the scan drive electronics was NOT necessary during the previous eight-second period.', ...
       'SDE Command Transmit Timeout error did NOT occur.', ...
       'SDE position data is available. When Science data is enabled, position data should arrive automatically.', ...
       '9-bit telemetry header is NOT detected with a bad parity', '17-bit telemetry data is NOT detected with a bad parity', ...
       'Problem related to the time-tagging of telemetry data is NOT detected', 'Problem related to the time-tagging of telemetry data is NOT detected', ...
       'A latchup condition due to excessive radiation is NOT detected on the Video Digitizer CCA', ...
       'A latchup condition due to excessive radiation is NOT detected on the Housekeeping CCA'};

   for i = 1:16
        bitpositiondouble(i) = 2^(i-1);
    end
    
    bitposition = uint16(bitpositiondouble);
    SD_m_e = uint16(SD_m_e1);
    
    for k = 1:handles.rows
        for i = 1:16
           bitsSD(k, i) = bitand(SD_m_e(k), bitposition(i));
        end
        for h = 1:16
           if bitsSD(k, h) ~=0
               bitsonSD(k, h) = 1;
           else
               bitsonSD(k, h) = 0;
           end  
        end
    end
    
    instmode = uint16(inst_mode);
    
    for k = 1:handles.rows
        for i = 1:16
           bitsinst(k, i) = bitand(instmode(k), bitposition(i));
        end
        for h = 1:16
           if bitsinst(k, h) ~=0
               bitsoninst(k, h) = 1; 
           else
               bitsoninst(k, h) = 0;
           end  
        end
    end
    
    errStat = uint16(errStatus);
    
    for k = 1:handles.rows
        for i = 1:16
           bitserr(k, i) = bitand(errStat(k), bitposition(i));
        end
        for h = 1:16
           if bitserr(k, h) ~=0
               bitsonerr(k, h) = 1; 
           else
               bitsonerr(k, h) = 0;
           end  
        end
    end
    handles.SD = {};
    handles.inst = {};
    handles.err = {};
    count = 1;
    count2 = 1;
    count3 = 1;
    
    for i = 2:handles.rows
          for k = 1:16
            if bitsonSD(i, k) ~= bitsonSD(i-1, k)
                if bitsonSD(i, k) == 1
                handles.SD{count} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(k-1), ': ', SDdescriptionsON(k)));
                count = count+1;
                else
                handles.SD{count} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(k-1), ': ', SDdescriptionsOFF(k)));
                count = count+1;
                end
            end
            
            
            if k~= 8 && k~= 9 && k~= 10 
             if bitsoninst(i, k) ~= bitsoninst(i-1, k)
                if bitsoninst(i, k) == 1
                handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(k-1), ': ', InstModedescriptionsON(k)));
                count2 = count2+1;
                else
                handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(k-1), ': ', InstModedescriptionsOFF(k)));
                count2 = count2+1;
                end
             end
            end
            if k == 8
               if (bitsoninst(i, k) ~= bitsoninst(i-1, k)) || (bitsoninst(i, k+1) ~= bitsoninst(i-1, k+1)) || (bitsoninst(i, k+2) ~= bitsoninst(i-1, k+2))
                   if strcmp(num2str(bitsoninst(i, 8:10)), '0  0  0')
                       handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(7), ', ',  num2str(8), ', ',  num2str(9) , ': Scan Drive Profile: PROM Profile'));
                       count2 = count2 + 1;
                   elseif  strcmp(num2str(bitsoninst(i, 8:10)), '0  0  1')
                       handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(7), ', ',  num2str(8), ', ',  num2str(9) , ': Scan Drive Profile: Loaded Profile 1'));
                       count2 = count2 + 1;
                   elseif strcmp(num2str(bitsoninst(i, 8:10)),'0  1  0')
                       handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(7), ', ',  num2str(8), ', ',  num2str(9) ,  ': Scan Drive Profile: Loaded Profile 2'));
                       count2 = count2 + 1;
                   elseif strcmp(num2str(bitsoninst(i, 8:10)), '0  1  1')
                        handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(7), ', ',  num2str(8), ', ',  num2str(9) ,  ': Scan Drive Profile: Loaded Profile 3'));
                        count2 = count2 + 1;
                   elseif strcmp(num2str(bitsoninst(i, 8:10)), '1  0  0')
                       handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ',num2str(7), ', ',  num2str(8), ', ',  num2str(9) ,  ': Scan Drive Profile: Loaded Profile 4'));
                       count2 = count2 + 1;
                   elseif strcmp(num2str(bitsoninst(i, 8:10)), '1  0  1')
                       handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ',num2str(7), ', ',  num2str(8), ', ',  num2str(9) ,  ': Scan Drive Profile: Stare Mode' ));
                       count2 = count2 + 1;
                   elseif strcmp(num2str(bitsoninst(i, 8:10)), '1  1  1')
                       handles.inst{count2} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(7), ', ',  num2str(8), ', ',  num2str(9) ,  ': Scan Drive Profile: SDM Off'));
                       count2 = count2 + 1;
                  end
               end
            end
            
             
         if k > 7 && k~= 13 && k~= 14
            if bitsonerr(i, k) ~= bitsonerr(i-1, k)
                if bitsonerr(i, k) == 1;
                handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(k-1), ': ', ErrStatusdescriptionsON(k)));
                count3 = count3+1;
                else
                handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(k-1), ': ', ErrStatusdescriptionsOFF(k)));
                count3 = count3+1;
                end
            end
         end
         if k == 1
             if bitsonerr(i, k) ~= bitsonerr(i-1, k) || bitsonerr(i, k+1) ~= bitsonerr(i-1, k+1) || bitsonerr(i, k+2) ~= bitsonerr(i-1, k+2) || bitsonerr(i, k+3) ~= bitsonerr(i-1, k+3) || bitsonerr(i, k+4) ~= bitsonerr(i-1, k+4) || bitsonerr(i, k+5) ~= bitsonerr(i-1, k+5)|| bitsonerr(i, k+6) ~= bitsonerr(i-1, k+6)
                 tag = num2str(bin2dec(strcat(num2str(bitsonerr(i, 1:7)))));
                 handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': HK Telemetry Word Position of Item Violating Safety Limit: ', tag));
                 count3 = count3 + 1;
             end 
         end
              if k == 13 
              if bitsonerr(i, k) ~= bitsonerr(i-1, k) || bitsonerr(i, k+1) ~= bitsonerr(i-1, k+1) 
                if strcmp(num2str(bitsonerr(i, 13:14)), '0  0')
                       handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(12), ', ',  num2str(13) , 'Telemetry Time Tagging Error: No Error'));            
                       count3 = count3 + 1;
                elseif strcmp(num2str(bitsonerr(i, 13:14)), '0  1')
                       handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(12), ', ',  num2str(13) , 'Telemetry Time Tagging Error: TOD Pulse'));   
                       count3 = count3+1;
                elseif strcmp(num2str(bitsonerr(i, 13:14)), '1  0')
                       count3 = count3+1;
                       handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(12), ', ',  num2str(13) , 'Telemetry Time Tagging Error: TOD Message'));   
                elseif strcmp(num2str(bitsonerr(i, 13:14)), '1  1')
                       handles.err{count3} = cellstr(strcat(datestr(handles.sec(i)/86400, 'HH:MM:SS.FFF'), ': Bit: ', num2str(12), ', ',  num2str(13) , 'Telemetry Time Tagging Error: Boundary Pulse'));
                       count3 = count3+1;
                end
              end
             end
          end
    end
    
    handles.SD = [handles.SD{:}];
    handles.inst = [handles.inst{:}];
    handles.err = [handles.err{:}];
    
    
%    handles.elapsedsec  = elapsedsec;
k = 1;
bad_index = {};
for i = 2:handles.rows
    if (handles.pktcount(i) - handles.pktcount(i-1)) ~= 1 && (handles.pktcount(i) ~=0)
        bad_index{k} = i;
        k = k + 1;
    end
end
if isempty(bad_index)
else
disp(['Bad Packet Count Column Indicies:' bad_index]);
end

guidata( hObject, handles );


% Plot Button
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        

if handles.indiciesA2 == 1; % x axis is either time or another telemetry point
    x1 = handles.elapsedsec(:);
    x1label = 'Time (s)';
else
    x1 = handles.telemdata(:, handles.indiciesA2 - 1);
    x1label = handles.names(1, handles.indiciesA2 - 1);
end
if get(handles.radiobutton1, 'value') == 1 % calibrate data
        handles.y1label = strcat(handles.names(1, handles.indiciesA1), '--', handles.units(1, handles.indiciesA1));
        handles.y2label = strcat(handles.names(1, handles.indiciesB1), '--', handles.units(1, handles.indiciesB1));
else 
        handles.y1label = strcat(handles.names(1, handles.indiciesA1), '--', handles.raw_units(1, handles.indiciesA1));
        handles.y2label = strcat(handles.names(1, handles.indiciesB1), '--', handles.raw_units(1, handles.indiciesB1));
end

if get(handles.radiobutton1, 'value') == 1
        handles.y1labelSD = strcat(handles.labels(1, handles.indiciesA1), '--', handles.units(1, handles.indiciesA1));
        handles.y2labelSD = strcat(handles.labels(1, handles.indiciesB1), '--', handles.units(1, handles.indiciesB1));
else 
        handles.y1labelSD = strcat(handles.labels(1, handles.indiciesA1), '--', handles.raw_units(1, handles.indiciesA1));
        handles.y2labelSD = strcat(handles.labels(1, handles.indiciesB1), '--', handles.raw_units(1, handles.indiciesB1));
end

set(handles.text15, 'string', ['Standard Deviation of ', handles.y1labelSD, ' ', std(handles.telemdata(:, handles.indiciesA1))]);
set(handles.text16, 'string', ['Standard Deviation of ', handles.y2labelSD, ' ', std(handles.telemdata(:, handles.indiciesB1))]);
set(handles.text17, 'string', ['Mean:  ', num2str(mean(handles.telemdata(:, handles.indiciesA1)))]);
set(handles.text18, 'string', ['Mean:  ', num2str(mean(handles.telemdata(:, handles.indiciesB1)))]);
axes(handles.axes1);
if get(handles.radiobutton4, 'value') == 1;
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

if handles.indiciesB2 == 1;
    x2 = handles.elapsedsec(:);
    x2label = 'Time (s)';
else
    x2 = handles.telemdata(:, handles.indiciesB2 - 1);
    x2label = handles.names(1, handles.indiciesB2 - 1);
end

axes(handles.axes2); % second plot
if get(handles.radiobutton6, 'value') == 1;
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
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pushbutton4_Callback(hObject, eventdata, handles);

delta_t = 8;
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
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1, 'visible', 'on');
set(handles.pushbutton7, 'visible', 'on');
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
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
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
handles.telemdata = handles.telem(:, 5:78);
for i = 55:74
    for k = 1:handles.rows
        if handles.telemdata(k, i) > 32768;
            handles.telemdata(k, i) = handles.telemdata(k, i) - 65536;
        end
    end
end            
guidata(hObject, handles);
