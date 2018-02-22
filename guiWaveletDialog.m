function varargout = guiWaveletDialog(varargin)
% GUIWAVELETDIALOG MATLAB code for guiWaveletDialog.fig
%      GUIWAVELETDIALOG, by itself, creates a new GUIWAVELETDIALOG or raises the existing
%      singleton*.
%
%      H = GUIWAVELETDIALOG returns the handle to a new GUIWAVELETDIALOG or the handle to
%      the existing singleton*.
%
%      GUIWAVELETDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIWAVELETDIALOG.M with the given input arguments.
%
%      GUIWAVELETDIALOG('Property','Value',...) creates a new GUIWAVELETDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiWaveletDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiWaveletDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiWaveletDialog

% Last Modified by GUIDE v2.5 20-Dec-2017 20:47:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiWaveletDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @guiWaveletDialog_OutputFcn, ...
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


% --- Executes just before guiWaveletDialog is made visible.
function guiWaveletDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiWaveletDialog (see VARARGIN)

% Choose default command line output for guiWaveletDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiWaveletDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiWaveletDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_Run.
function pb_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flagError = false ; 

sValue = get(handles.edit_aString, 'String') ; 
if isempty(str2double(sValue)) 
    hError = errordlg('a values must all be whole numbers, e.g. 2 4 8', 'Input error', 'modal') ; 
    uicontrol(handles.edit_aString) ; 
    flagError = true ; 
    return ; 
else 
    handles.a = str2num(sValue) ; 
end ; 

sValue = get(handles.edit_LString, 'String') ; 
if isempty(str2double(sValue)) 
    hError = errordlg('L values must all be whole numbers, e.g. 2 4 8', 'Input error', 'modal') ; 
    uicontrol(handles.edit_LString) ; 
    flagError = true ; 
    return ; 
else 
    handles.L = 1 ./ str2num(sValue) ; 
end ; 

sValue = get(handles.edit_DegString, 'String') ; 
if isnan(str2double(sValue)) || str2double(sValue) < 1 || str2double(sValue) > 360
    hError = errordlg('Angular increment must be a whole number, 1-360', 'Input error', 'modal') ; 
    uicontrol(handles.edit_DegString) ; 
    flagError = true ; 
    return ; 
else 
    handles.nTheta = str2num(sValue) ; 
end ; 

if get(handles.radiobutton_Morlet, 'Value')
    handles.fMorlet = true ; 
else 
    handles.fMorlet = false ; 
end ; 

if ~flagError
    guiFracPaQ2Dwavelet2(handles.a, handles.L, handles.nTheta, handles.fMorlet, '[0 0 1]') ; 
end ; 

% --- Executes on button press in pb_Cancel.
function pb_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close all ; 
close(gcf) ; 


function edit_aString_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aString as text
%        str2double(get(hObject,'String')) returns contents of edit_aString as a double


% --- Executes during object creation, after setting all properties.
function edit_aString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_DegString_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DegString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DegString as text
%        str2double(get(hObject,'String')) returns contents of edit_DegString as a double


% --- Executes during object creation, after setting all properties.
function edit_DegString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DegString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_LString_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LString as text
%        str2double(get(hObject,'String')) returns contents of edit_LString as a double


% --- Executes during object creation, after setting all properties.
function edit_LString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_Morlet.
function radiobutton_Morlet_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Morlet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Morlet
if get(hObject, 'Value') 
    handles.fMorlet = true ; 
end ; 

% --- Executes on button press in radiobutton_Mexican.
function radiobutton_Mexican_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Mexican (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Mexican
if get(hObject, 'Value') 
    handles.fMorlet = false ; 
end ; 
