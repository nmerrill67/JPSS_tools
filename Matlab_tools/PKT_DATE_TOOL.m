function varargout = PKT_DATE_TOOL(varargin)
% PKT_DATE_TOOL MATLAB code for PKT_DATE_TOOL.fig
%      PKT_DATE_TOOL, by itself, creates a new PKT_DATE_TOOL or raises the existing
%      singleton*.
%
%      H = PKT_DATE_TOOL returns the handle to a new PKT_DATE_TOOL or the handle to
%      the existing singleton*.
%
%      PKT_DATE_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PKT_DATE_TOOL.M with the given input arguments.
%
%      PKT_DATE_TOOL('Property','Value',...) creates a new PKT_DATE_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PKT_DATE_TOOL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PKT_DATE_TOOL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PKT_DATE_TOOL

% Last Modified by GUIDE v2.5 28-Mar-2017 00:29:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PKT_DATE_TOOL_OpeningFcn, ...
                   'gui_OutputFcn',  @PKT_DATE_TOOL_OutputFcn, ...
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


% --- Executes just before PKT_DATE_TOOL is made visible.
function PKT_DATE_TOOL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PKT_DATE_TOOL (see VARARGIN)

    % Choose default command line output for PKT_DATE_TOOL
    handles.output = hObject;

    handles.epoch = datenum('01-01-1958', 'mm-dd-yyyy');
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes PKT_DATE_TOOL wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PKT_DATE_TOOL_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;



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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.guide
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
        if isempty(get(handles.edit1, 'string'))
            set(handles.edit1, 'string', '1')
        end

        if isempty(get(handles.edit2, 'string'))
            set(handles.edit2, 'string', '0')
        end

        if isempty(get(handles.edit3, 'string'))
            set(handles.edit3, 'string', '0')
        end


        handles.dates = str2num(get(handles.edit1,'String'));
        handles.millsec = str2num(get(handles.edit2,'String'));
        handles.micsec = str2num(get(handles.edit3,'String'));

        handles.sec = (handles.millsec / 1000) + (handles.micsec / 1000000); % setting time vector
        nSecs1 = handles.sec;

        handles.startT = datestr(nSecs1/86400, 'HH:MM:SS.FFF');
        elapsedsec = sec2time(handles.sec, handles.dates, handles.epoch);
        handles.elapsedsec  = elapsedsec;

        handles.startdatestr = datestr(handles.dates(1) + handles.epoch, 'dd-mmm-yyyy');

        set(handles.text2, 'string', ['Date: ', handles.startdatestr]);
        set(handles.text3, 'string', ['Time: ', handles.startT]);
    catch
       % if user preses go without inputting numbers 
       h = errordlg('Invalid input');
       uiwait(h);
    end