function varargout = fourierTransform(varargin)
% FOURIERTRANSFORM MATLAB code for fourierTransform.fig
%      FOURIERTRANSFORM, by itself, creates a new FOURIERTRANSFORM or raises the existing
%      singleton*.
%
%      H = FOURIERTRANSFORM returns the handle to a new FOURIERTRANSFORM or the handle to
%      the existing singleton*.
%
%      FOURIERTRANSFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIERTRANSFORM.M with the given input arguments.
%
%      FOURIERTRANSFORM('Property','Value',...) creates a new FOURIERTRANSFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fourierTransform_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fourierTransform_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fourierTransform

% Last Modified by GUIDE v2.5 07-Jul-2017 12:30:35

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @fourierTransform_OpeningFcn, ...
                       'gui_OutputFcn',  @fourierTransform_OutputFcn, ...
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
% --- Executes just before fourierTransform is made visible.
function fourierTransform_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fourierTransform (see VARARGIN)

    % Choose default command line output for fourierTransform
    handles.output = hObject;
    handles.epoch = datenum('01-01-1958', 'mm-dd-yyyy');
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes fourierTransform wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = fourierTransform_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1. GETS FILE DATA
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [handles.name, path] = uigetfile('*.txt'); %Modify for csv, txt, etc
        if ~path
            errordlg('No File Selected!');
        else
           set(handles.text7,'String', ['File Chosen: ', handles.name]);
        end
    handles.telem = load(fullfile(path, handles.name)); % make sure that file has consistent size(row-col)
    [handles.rows,handles.cols] = size(handles.telem);

    if handles.cols==300
        handles.position = handles.telem(:, 5:152); % apid id 218(hex) has 104 or 148 scan positions
        handles.channel = handles.telem(:,153:300); % apid id 218(hex) has 104 or 148 science data samples
        handles.data_columns = 148;
    else

        handles.position = handles.telem(:, 4:107); % apid id 218(hex) has 104 or 148 scan positions
        handles.channel = handles.telem(:,108:211); % apid id 218(hex) has 104 or 148 science data samples
        handles.data_columns = 103;

    end

    set(handles.text10, 'String', (['Number of columns: ', num2str(handles.data_columns)]));

    handles.plotposition = handles.position;
    handles.plotchannel = handles.channel;
    handles.dates = handles.telem(:,1);
    handles.millsec = handles.telem(:,2);
    handles.micsec = handles.telem(:,3);
    handles.hours = handles.telem(:,4); % hours
    handles.sec = double((handles.millsec ./ 1000) + (handles.micsec ./ 1000000)); % setting time vector
    nSecs1 = handles.sec(2);
    nSecs2 = handles.sec(handles.rows);
    handles.startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF');
    handles.stopT = datestr(nSecs2/86400, 'HH:MM:SS.FFF');
    elapsedsec = sec2time(handles.sec, handles.dates, handles.epoch);
    handles.elapsedsec  = elapsedsec;
    set(handles.radiobutton1, 'value', 1); % default 'no filter'
    set(handles.radiobutton5, 'value', 1); % default for 'channel' data FFT
    set(handles.radiobutton2, 'value', 0);
    set(handles.radiobutton3, 'value', 0);
    set(handles.radiobutton4, 'value', 0);
    set(handles.radiobutton6, 'value', 0);
    set(handles.radiobutton7, 'value', 0);
    set(handles.radiobutton9, 'value', 0);
    set(handles.edit7,'visible','off');
    set(handles.edit8,'visible','off');
    set(handles.radiobutton9, 'visible','off');
%    debugfile = 'debug' ;
%    save(debugfile,elapsedsec);

    handles.startdatestr = datestr(handles.dates(2) + handles.epoch, 'dd-mmm-yyyy');
    handles.stopdatestr = datestr(handles.dates(end) + handles.epoch, 'dd-mmm-yyyy');
    handles.elapsedsec = zeros(1, handles.rows); % time vector (total elapsed seconds)
    set(handles.text2, 'String', (['Start Date: ', handles.startdatestr]));
    set(handles.text8, 'String', (['Start Time: ', handles.startT]));
    set(handles.text3, 'String', (['Stop Date: ', handles.stopdatestr]));
    set(handles.text9, 'String', (['Stop Time: ', handles.stopT]));
    num_scans = handles.rows;
    set(handles.text4, 'String', (['Number of scans: ', num2str(num_scans)]));
    set (handles.edit5, 'String', '2');  % set default value for starting scan
    set (handles.edit6, 'String', '200');  % set default value for ending scan
    set (handles.edit7, 'String', '0') ; % set default value for Special filter low
    set (handles.edit8, 'String', '360') ; % set default value for Special filter high
    guidata( hObject, handles );
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

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

% --- Executes during object creation, after setting all properties.
end

function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
end

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
end

% --- Executes on button press in pushbutton2.  THIS IS THE PLOT BUTTON
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if isempty(get(handles.edit5))
        set (handles.edit5, 'String', '1');  % set default value for starting scan for FFT
    end

    if isempty(get(handles.edit6))
        set (handles.edit6, 'String', '1');  % set default value for ending scan for FFT
    end


    j=1; % index for filtered data array
    if get(handles.radiobutton1, 'value') 
      
        handles.plotposition = handles.position;
        handles.plotchannel = handles.channel;
        set(handles.text4, 'String', (['Number of scans: ', num2str(handles.rows)]));
        [rowss,columnss] = size(handles.plotposition);
    end
    
    

    if get(handles.radiobutton2, 'value')
        
  %      handles.plotposition = handles.position;
  %      handles.plotchannel = handles.channel;
        [rowss,columnss] = size(handles.position);
 %       clear handles.plotposition;
        j = 1;

        for i = 1:handles.rows
            if ((handles.position(i,1)>82)&&(handles.position(i,1)<83)) 
                if ((handles.position(i,columnss)>82)&&(handles.position(i,columnss)<83)) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end

    if get(handles.radiobutton3, 'value') 
        
        [rowss,columnss] = size(handles.position);
%        clear handles.plotposition;
        j = 1;

        for i = 1:handles.rows
            if (handles.position(i,1)>193&&handles.position(i,1)<194) 
                if (handles.position(i,columnss)>193&&handles.position(i,columnss)<194) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end
   
    if get(handles.radiobutton4, 'value') 
        
        [rowss,columnss] = size(handles.position);
 %       clear handles.plotposition;
        j = 1;

        for i = 1:handles.rows
            if (handles.position(i,1)>322&&handles.position(i,1)<323) 
                if (handles.position(i,columnss)>322&&handles.position(i,columnss)<323) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end
    
    if get(handles.radiobutton7, 'value')
        
        [rowss,columnss] = size(handles.position);
%        clear handles.plotposition;
        j = 1;
         
        set(handles.edit7,'visible','on');
        set(handles.edit8,'visible','on');
        
        start_filter = str2double(get(handles.edit7,'String'));
        end_filter = str2double(get(handles.edit8,'String'));



%        [data_rows,data_col] = size(handles.plotposition);
        %data_rows
        %data_col

        if (start_filter>end_filter)
            start_filter = end_filter - 0.01;
            set (handles.edit7, 'String',num2str(start_filter));
        end
        
        if (start_filter<0)
            start_filter = 0;
            end_filter = 1;
            set (handles.edit7, 'String',num2str(start_filter));
            set (handles.edit8, 'String',num2str(end_filter));
        end

        for i = 1:handles.rows
            if ((handles.position(i,1))>=(start_filter))&&((handles.position(i,1))<(end_filter)) 
                if ((handles.position(i,columnss))>=(start_filter))&&((handles.position(i,columnss))<(end_filter)) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end
        
  
    start_scan = str2double(get(handles.edit5,'String'));
    end_scan = str2double(get(handles.edit6,'String'));



    [data_rows,data_col] = size(handles.plotposition);
    %data_rows
    %data_col

    if (start_scan>data_rows)
        start_scan = data_rows-1;
        set (handles.edit5, 'String',num2str(start_scan));
    end

    if (end_scan>data_rows)
        end_scan = data_rows;
        set (handles.edit6, 'String',num2str(end_scan));
    end

    if (end_scan<start_scan)
        end_scan = start_scan;
        set (handles.edit6, 'String',num2str(end_scan));
    end
    %        set(handles.edit8, 'String', num2str(finish - 1));
    num_scans = (end_scan - start_scan)+1;

    delta_t = (8/3)/148; %sample time between samples

    num_points = num_scans*data_col;
    delf = (1/num_points)*(1/delta_t);% frequency increment for fft
    nf = round((num_points/2)+1);

    fr = 0:delf:(nf-1)*delf;

    %T = 0:delta_t:round(handles.elapsedsec(handles.rows-1));

    axes(handles.axes1);
    pos = 1:data_col;
    hold off;
    for i = start_scan:end_scan
        plot(pos,handles.plotchannel((i),:));
        grid on;
        hold on;
    end
    hold off
    title([ 'ATMS APID Channel Data']);
    xlabel( ' Scan Position ');
    ylabel( ' Counts ');



    axes(handles.axes2);
    hold off;
    for i = start_scan:end_scan
        plot(pos,handles.plotposition((i),:));
        grid on;
        hold on;
    end
    hold off
    title( 'ATMS APID Position Data');
    xlabel( ' Scan Position ');
    ylabel( ' Resolver Position ');



    if (data_col == 104 )% if normal scan, then do fft only on the earth scan portion

        data_col = 104;
    end

    if get(handles.radiobutton6, 'value') % position data
        fft_rows = (handles.plotposition(start_scan:end_scan,1:data_col));
        if get(handles.radiobutton9, 'value') % if normalization to mean desired   
            [norm_rows,norm_cols] = size(fft_rows);
            for i = 1:norm_cols
                col_mean = mean(fft_rows(:,i));

                fft_rows(:,i) = fft_rows(:,i)-(col_mean);
            end

            axes(handles.axes2);
            hold off;

            for i = 1:norm_rows
                plot(pos(1:104),fft_rows(i,1:104));
                grid on;
                hold on;
            end
            hold off
            title([ 'ATMS APID Position Data - Normalized to Mean']);
            xlabel( ' Scan Position ');
            ylabel( ' Resolver Position - normalized ');

            fft_rows = fft_rows';
        end
    else
        fft_rows = (handles.plotchannel(start_scan:end_scan,1:data_col))';% channel data
    end

    fft_input = fft_rows(:);

    %mean(fft_input)

    fft_plot1 = fft(fft_input);

    f1 = fft_plot1(1:nf);

    fmag1 = (2*abs(f1))./num_points;

    size_fmag = max(size(fmag1));

    size_fr = max(size(fr));

    plot_size = min(size_fmag,size_fr);

    axes(handles.axes3);
    hold off;
    plot(fr(2:plot_size),fmag1(2:plot_size));
    grid on;
    title('ATMS FFT Results for selected rows');
    xlabel( ' Frequency(Hz) ');
    ylabel( ' FF Magnitude ');


    guidata(hObject, handles);
      % gui_Result(gcbo, [], guidata(gcbo) );
end

% --------------------------------------------------------------------
%function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1. % No Filter
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
        set(handles.radiobutton2, 'value', 0);
        set(handles.radiobutton3, 'value', 0);
        set(handles.radiobutton4, 'value', 0);
        set(handles.radiobutton7, 'value', 0);

    handles.plotposition = handles.position;
    handles.plotchannel = handles.channel;
    set(handles.text4, 'String', (['Number of scans: ', num2str(handles.rows)]));
    guidata(hObject, handles);
end


% --- Executes on button press in radiobutton2. - 82. deg position data
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2

    j=1; % index for filtered data array
    if get(handles.radiobutton2, 'value')
        set(handles.radiobutton1, 'value', 0);
        set(handles.radiobutton3, 'value', 0);
        set(handles.radiobutton4, 'value', 0);
        set(handles.radiobutton7, 'value', 0);
        
        
        columnss = size(handles.position, 2);

        for i = 1:handles.rows
            if ((handles.position(i,1)>82)&&(handles.position(i,1)<83)) 
                if ((handles.position(i,columnss)>82)&&(handles.position(i,columnss)<83)) 
                    %columns
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
      
%        rowss
%        columnss
    end
    guidata(hObject, handles);
end       

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


    j=1; % index for filtered data array
    if get(handles.radiobutton3, 'value')
        set(handles.radiobutton1, 'value', 0);
        set(handles.radiobutton2, 'value', 0);
        set(handles.radiobutton4, 'value', 0);
        set(handles.radiobutton7, 'value', 0);
        
        columnss = size(handles.position, 2);

        for i = 1:handles.rows
            if (handles.position(i,1)>193&&handles.position(i,1)<194) 
                if (handles.position(i,columnss)>193&&handles.position(i,columnss)<194) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end
    guidata(hObject, handles);
end
  

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
    j=1; % index for filtered data array
    if get(handles.radiobutton4, 'value')
        set(handles.radiobutton1, 'value', 0);
        set(handles.radiobutton2, 'value', 0);
        set(handles.radiobutton3, 'value', 0);
        set(handles.radiobutton7, 'value', 0);
        
        columnss = size(handles.position, 2);

        for i = 1:handles.rows
            if (handles.position(i,1)>322&&handles.position(i,1)<323) 
                if (handles.position(i,columnss)>322&&handles.position(i,columnss)<323) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end
    guidata(hObject, handles);
end
  

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
    set(handles.radiobutton6, 'value', 0);
    set(handles.radiobutton9, 'value', 0);
    set(handles.radiobutton9, 'visible', 'off');
end

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

   set(handles.radiobutton5, 'value', 0);
   set(handles.radiobutton9, 'visible', 'on');
end

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
    if get(handles.radiobutton7, 'value')
        set(handles.radiobutton1, 'value', 0);
        set(handles.radiobutton2, 'value', 0);
        set(handles.radiobutton3, 'value', 0);
        set(handles.radiobutton4, 'value', 0);
        set(handles.edit7,'visible','on');
        set(handles.edit8,'visible','on');
%        set(handles.edit7,'String','0');
%        set(handles.edit8,'String','360');       
        
        columnss = size(handles.position, 2);
%        clear handles.plotposition;
        j = 1;
        

        start_filter = str2double(get(handles.edit7,'String'));
        end_filter = str2double(get(handles.edit8,'String'));



%        [data_rows,data_col] = size(handles.plotposition);
        %data_rows
        %data_col

        if (start_filter > end_filter)
            start_filter = end_filter - 0.01;
            set (handles.edit7, 'String',num2str(start_filter));
        end
        
        if (start_filter < 0)
            start_filter = 0;
            end_filter = 1;
            set (handles.edit7, 'String',num2str(start_filter));
            set (handles.edit8, 'String',num2str(end_filter));
        end

        for i = 1:handles.rows
            if ((handles.position(i,1))>=(start_filter))&&((handles.position(i,1))<(end_filter)) 
                if ((handles.position(i,columnss))>=(start_filter))&&((handles.position(i,columnss))<(end_filter)) 
                    handles.plotposition(j,:)=handles.position(i,:);
                    handles.plotchannel(j,:)=handles.channel(i,:);
                    j=j+1;
                end
            end
        end
        set(handles.text4, 'String', (['Number of scans: ', num2str(j-1)]));
        handles.plotposition = handles.plotposition(1:j-1,:);
        handles.plotchannel = handles.plotchannel(1:j-1,:);
    end
    guidata(hObject, handles);
end

% --- Executes on button press in radiobutton6.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

     if get(handles.radiobutton9, 'value')
            set(handles.radiobutton9, 'value', 0);

     else 
            set(handles.radiobutton9, 'value', 1);

     end

     %      set(handles.radiobutton5, 'value', 0);
     guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function radiobutton7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

end

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
end

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
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set (handles.edit10,'visible', 'on');
    set (handles.pushbutton5, 'visible', 'on');
    guidata(hObject, handles);
end


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if isempty(handles.edit10)
        set(handles.edit10,'string',Housekeeping');
    end
    savename = get(handles.edit10, 'string');
    export_fig('%d.png', savename);
    guidata(hObject, handles);
end
