function varargout = frequency_gui(varargin)
% FREQUENCY_GUI MATLAB code for frequency_gui.fig
%      FREQUENCY_GUI, by itself, creates a new FREQUENCY_GUI or raises the existing
%      singleton*.
%
%      H = FREQUENCY_GUI returns the handle to a new FREQUENCY_GUI or the handle to
%      the existing singleton*.
%
%      FREQUENCY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FREQUENCY_GUI.M with the given input arguments.
%
%      FREQUENCY_GUI('Property','Value',...) creates a new FREQUENCY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before frequency_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to frequency_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help frequency_gui

% Last Modified by GUIDE v2.5 24-Jun-2015 14:31:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frequency_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @frequency_gui_OutputFcn, ...
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


% --- Executes just before frequency_gui is made visible.
function frequency_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to frequency_gui (see VARARGIN)

% Choose default command line output for frequency_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes frequency_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frequency_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5



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

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


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


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Input variables
phi =  str2double(get(handles.edit1, 'String'));
N = str2double(get(handles.edit2, 'String'));
Bd = str2double(get(handles.edit3, 'String'));
Pd = str2double(get(handles.edit4, 'String'));

%If any boxes are empty, they are set to zero:
if isempty(get(handles.edit1, 'String'))
    set(handles.edit1, 'String', '0');
end
if isempty(get(handles.edit2, 'String'))
    set(handles.edit2, 'String', '0');
end
if isempty(get(handles.edit3, 'String'))
    set(handles.edit3, 'String', '0');
end
if isempty(get(handles.edit4, 'String'))
    set(handles.edit4, 'String', '0');
end
if isempty(get(handles.edit5, 'String'))
    set(handles.edit5, 'String', '0');
end
if isempty(get(handles.edit6, 'String'))
    set(handles.edit6, 'String', '0');
end

%Resolves o/S and RPM unit differences
switch get(get(handles.uibuttongroup6,'SelectedObject'),'Tag')
    case 'radiobutton11'
    InSpeed = str2double(get(handles.edit5, 'String'));
    case 'radiobutton12'
    InSpeed = (1/6)*str2double(get(handles.edit5, 'String'));
end
switch get(get(handles.uibuttongroup7,'SelectedObject'),'Tag')
    case 'radiobutton13'
    OutSpeed = str2double(get(handles.edit6, 'String'));
    case 'radiobutton15'
    OutSpeed = (1/6)*str2double(get(handles.edit6, 'String'));
end

% Pitch/Ball Diameter are dimensionless in calculations, folowing code
% resolves differences between mm/In if they are different
if get(handles.radiobutton7,'Value') == 1
    if get(handles.radiobutton10, 'Value') == 1
        Pd = Pd/25.4;
    end
end
if get(handles.radiobutton8,'Value') == 1
    if get(handles.radiobutton9, 'Value') == 1
        Bd = Bd/25.4;
    end
end

% Degrees/Radians
switch get(get(handles.uibuttongroup1,'SelectedObject'),'Tag')
    case 'radiobutton1'
        phi = (pi/180)*str2double(get(handles.edit1, 'String'));
    case 'radiobutton2'
        phi = str2double(get(handles.edit1, 'String'));
end

% Frequency Calculations
if get(handles.checkbox1,'Value') == 1
    FTF = (1/60)*0.5*(InSpeed*(1 - (Bd*cos(phi))/Pd) + OutSpeed*(1+(Bd*cos(phi))/Pd));
    set(handles.text13, 'String', 'FTF (Hz):')
    set(handles.text8, 'String', num2str(FTF)); 
end

if get(handles.checkbox3,'Value') == 1
    BPFI = abs((1/60)*(N/2)*(InSpeed - OutSpeed)*(1+(Bd*cos(phi)/Pd)));
    set(handles.text14, 'String', 'BPFI (Hz):'); 
    set(handles.text10, 'String', num2str(BPFI)); 
end

if get(handles.checkbox4,'Value') == 1
    BPFO = abs((1/60)*(N/2)*(InSpeed - OutSpeed)*(1-(Bd*cos(phi)/Pd)));
    set(handles.text15, 'String', 'BPFO (Hz):'); 
    set(handles.text9, 'String', num2str(BPFO)); 
end

if get(handles.checkbox5,'Value') == 1
    BSFx2 = abs((1/60)*(Pd/Bd)*(InSpeed - OutSpeed)*(1 - (Bd^2)*(cos(phi)^2)/(Pd^2)));
    set(handles.text16, 'String', '2x BSF (Hz):');
    set(handles.text11, 'String', num2str(BSFx2)); 
end
if get(handles.checkbox2, 'Value') == 1
        BSF = 0.5*abs((1/60)*(Pd/Bd)*(InSpeed - OutSpeed)*(1 - (Bd^2)*(cos(phi)^2)/(Pd^2)));
        set(handles.text17, 'String', 'BSF (Hz):');
        set(handles.text12, 'String', num2str(BSF)); 
end
