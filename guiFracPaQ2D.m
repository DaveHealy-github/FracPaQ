function varargout = guiFracPaQ2D(varargin)
% GUIFRACPAQ2D MATLAB code for guiFracPaQ2D.fig
%      GUIFRACPAQ2D, by itself, creates a new GUIFRACPAQ2D or raises the existing
%      singleton*.
%
%      H = GUIFRACPAQ2D returns the handle to a new GUIFRACPAQ2D or the handle to
%      the existing singleton*.
%
%      GUIFRACPAQ2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFRACPAQ2D.M with the given input arguments.
%
%      GUIFRACPAQ2D('Property','Value',...) creates a new GUIFRACPAQ2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiFracPaQ2D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiFracPaQ2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%% Copyright
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.


% Edit the above text to modify the response to help guiFracPaQ2D

% Last Modified by GUIDE v2.5 12-Aug-2016 12:39:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiFracPaQ2D_OpeningFcn, ...
                   'gui_OutputFcn',  @guiFracPaQ2D_OutputFcn, ...
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


%   my initialisation can go here... 


% --- Executes just before guiFracPaQ2D is made visible.
function guiFracPaQ2D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiFracPaQ2D (see VARARGIN)

% %   get a list of possible files for the filename popup menu
% list_temp = [ dir('*.txt') ; dir('*.jpeg') ; dir('*.tiff') ; dir('*.tif') ] ; 
% handles.lsFracPaQ_files = {list_temp.name} ;

% Choose default command line output for guiFracPaQ2D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiFracPaQ2D wait for user response (see UIRESUME)
% uiwait(handles.figure_main);
axes(handles.axes_logo) ;
imLogo = imread('FracPaQlogo.jpeg') ; 
imshow(imLogo) ; 

axes(handles.axes_icon) ;
imIcon = imread('FracPaQicon.jpeg') ; 
imshow(imIcon) ; 

axes(handles.axes_tracemap) ; 

set(handles.popupmenu_histolengthbins,'Value',2) ;
set(handles.popupmenu_histoanglebins,'Value',2) ;
set(handles.popupmenu_rosebins,'Value',2) ;

% --- Outputs from this function are returned to the command line.
function varargout = guiFracPaQ2D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_triangle.
function checkbox_triangle_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_triangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_triangle


% --- Executes on button press in checkbox_permellipse.
function checkbox_permellipse_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_permellipse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_permellipse


% --- Executes on button press in checkbox_intensitymap.
function checkbox_intensitymap_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_intensitymap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_intensitymap
if get(hObject, 'Value') || get(handles.checkbox_densitymap, 'Value')
    set(handles.checkbox_showcircles, 'Enable', 'on') ; 
    set(handles.edit_numscancircles, 'Enable', 'on') ; 
    set(handles.label_numscancircles, 'Enable', 'on') ; 
else 
    set(handles.checkbox_showcircles, 'Enable', 'off') ; 
    set(handles.checkbox_showcircles, 'Value', 0) ; 
    set(handles.edit_numscancircles, 'Enable', 'off') ; 
    set(handles.edit_numscancircles, 'Value', 0) ; 
    set(handles.label_numscancircles, 'Enable', 'off') ; 
end ; 


% --- Executes on button press in checkbox_densitymap.
function checkbox_densitymap_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_densitymap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_densitymap
if get(hObject, 'Value') || get(handles.checkbox_intensitymap, 'Value')
    set(handles.checkbox_showcircles, 'Enable', 'on') ; 
    set(handles.edit_numscancircles, 'Enable', 'on') ; 
    set(handles.label_numscancircles, 'Enable', 'on') ; 
else 
    set(handles.checkbox_showcircles, 'Enable', 'off') ; 
    set(handles.checkbox_showcircles, 'Value', 0) ; 
    set(handles.edit_numscancircles, 'Enable', 'off') ; 
    set(handles.edit_numscancircles, 'Value', 0) ; 
    set(handles.label_numscancircles, 'Enable', 'off') ; 
end ; 


% --- Executes on button press in checkbox_tracemap.
function checkbox_tracemap_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_tracemap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_tracemap
if get(hObject, 'Value') 
    set(handles.checkbox_shownodes, 'Enable', 'on') ; 
else 
    set(handles.checkbox_shownodes, 'Enable', 'off') ; 
    set(handles.checkbox_shownodes, 'Value', 0) ; 
end ; 
    
% --- Executes on button press in checkbox_shownodes.
function checkbox_shownodes_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_shownodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_shownodes


% --- Executes on button press in checkbox_histolength.
function checkbox_histolength_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_histolength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_histolength
if get(hObject, 'Value')
    set(handles.text_histolengthbins, 'Enable', 'on') ; 
    set(handles.popupmenu_histolengthbins, 'Enable', 'on') ; 
else 
    set(handles.text_histolengthbins, 'Enable', 'off') ; 
    set(handles.popupmenu_histolengthbins, 'Enable', 'off') ; 
end ; 


% --- Executes on button press in checkbox_logloglength.
function checkbox_logloglength_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_logloglength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_logloglength


% --- Executes on button press in checkbox_mle.
function checkbox_mle_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_mle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_mle


% --- Executes on button press in checkbox_histoangle.
function checkbox_histoangle_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_histoangle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_histoangle
if get(hObject, 'Value')
    set(handles.text_histoanglebins, 'Enable', 'on') ; 
    set(handles.popupmenu_histoanglebins, 'Enable', 'on') ; 
else 
    set(handles.text_histoanglebins, 'Enable', 'off') ; 
    set(handles.popupmenu_histoanglebins, 'Enable', 'off') ; 
end ; 


% --- Executes on button press in checkbox_rose.
function checkbox_rose_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_rose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_rose
if get(hObject, 'Value')
    set(handles.text_rosebins, 'Enable', 'on') ; 
    set(handles.popupmenu_rosebins, 'Enable', 'on') ; 
else 
    set(handles.text_rosebins, 'Enable', 'off') ; 
    set(handles.popupmenu_rosebins, 'Enable', 'off') ; 
end ; 


% --- Executes on button press in checkbox_crossplot.
function checkbox_crossplot_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_crossplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_crossplot


% --- Executes on button press in checkbox_showcircles.
function checkbox_showcircles_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_showcircles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_showcircles


% --- Executes on button press in checkbox_censor.
function checkbox_censor_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_censor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_censor



function edit_houghpeaks_Callback(hObject, eventdata, handles)
% hObject    handle to edit_houghpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_houghpeaks as text
%        str2double(get(hObject,'String')) returns contents of edit_houghpeaks as a double


% --- Executes during object creation, after setting all properties.
function edit_houghpeaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_houghpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_houghthreshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_houghthreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_houghthreshold as text
%        str2double(get(hObject,'String')) returns contents of edit_houghthreshold as a double


% --- Executes during object creation, after setting all properties.
function edit_houghthreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_houghthreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fillgap_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fillgap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fillgap as text
%        str2double(get(hObject,'String')) returns contents of edit_fillgap as a double


% --- Executes during object creation, after setting all properties.
function edit_fillgap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fillgap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minlength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minlength as text
%        str2double(get(hObject,'String')) returns contents of edit_minlength as a double


% --- Executes during object creation, after setting all properties.
function edit_minlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_degfromnorth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_degfromnorth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_degfromnorth as text
%        str2double(get(hObject,'String')) returns contents of edit_degfromnorth as a double


% --- Executes during object creation, after setting all properties.
function edit_degfromnorth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_degfromnorth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scaling_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scaling as text
%        str2double(get(hObject,'String')) returns contents of edit_scaling as a double


% --- Executes during object creation, after setting all properties.
function edit_scaling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_numscancircles_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numscancircles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numscancircles as text
%        str2double(get(hObject,'String')) returns contents of edit_numscancircles as a double


% --- Executes during object creation, after setting all properties.
function edit_numscancircles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numscancircles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_aperture_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aperture as text
%        str2double(get(hObject,'String')) returns contents of edit_aperture as a double


% --- Executes during object creation, after setting all properties.
function edit_aperture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lambda as text
%        str2double(get(hObject,'String')) returns contents of edit_lambda as a double


% --- Executes during object creation, after setting all properties.
function edit_lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all ; 
close(gcf) ; 


function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double
% handles.filename = uigetfile({'*.txt'; '*.jpeg'; '*.tiff'}, 'Select an input file for FracPaQ2D') ; 
% if length(handles.filename) > 0 
%     set(hObject, 'String', handles.filename) ; 
% else 
%     set(hObject, 'String', '(no file selected)') ; 
% end ; 

% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white') ;
end


% --- Executes on button press in pushbutton_browse.
function pushbutton_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_tracemap) ; 
handles.axes_tracemap.YDir = 'normal' ; 

%   for Linux and Mac users, offer access to *.svg input files 
if isunix
    sFileTypes = {'*.svg'; '*.txt'; '*.jpeg'; '*.jpg'; '*.tiff'; '*.tif'} ; 
else
    sFileTypes = {'*.txt'; '*.jpeg'; '*.jpg'; '*.tiff'; '*.tif'} ; 
end ; 

[ handles.selfile, handles.selpath ] = uigetfile(sFileTypes, 'Select an input file for FracPaQ2D') ; 

if ~isequal(handles.selfile, 0) 
    
    set(handles.edit_filename, 'String', handles.selfile) ; 
    set(handles.pushbutton_preview, 'Enable', 'on') ; 
    
    if ~isempty(strfind(handles.selfile, '.tif')) || ...
       ~isempty(strfind(handles.selfile, '.tiff')) || ...
       ~isempty(strfind(handles.selfile, '.jpeg')) || ...
       ~isempty(strfind(handles.selfile, '.jpg'))  
        set(handles.radiobutton_image, 'Value', 1) ;
        set(handles.edit_houghpeaks, 'Enable', 'on') ; 
        set(handles.edit_houghthreshold, 'Enable', 'on') ; 
        set(handles.edit_fillgap, 'Enable', 'on') ; 
        set(handles.edit_minlength, 'Enable', 'on') ; 
    else 
        set(handles.radiobutton_node, 'Value', 1) ;
        set(handles.edit_houghpeaks, 'Enable', 'off') ; 
        set(handles.edit_houghthreshold, 'Enable', 'off') ; 
        set(handles.edit_fillgap, 'Enable', 'off') ; 
        set(handles.edit_minlength, 'Enable', 'off') ; 
    end ; 
    
else 
    set(handles.edit_filename, 'String', '(no file selected)') ; 
    set(handles.pushbutton_preview, 'Enable', 'off') ; 
end ; 

set(handles.pushbutton_flipy, 'Enable', 'off') ; 
set(handles.pushbutton_run, 'Enable', 'off') ; 
set(handles.text_message, 'String', 'Click Preview to view the file contents.') ;                                 

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton_preview.
function pushbutton_preview_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes_tracemap) ; 

flagError = false ; 

if get(handles.radiobutton_image, 'Value')
    
    sValue = get(handles.edit_houghpeaks, 'String') ; 
    if isnan(str2double(sValue)) || str2double(sValue) < 100 || str2double(sValue) > 5000
        hError = errordlg('Hough peaks must be a whole number, 100-5000', 'Input error', 'modal') ; 
        uicontrol(handles.edit_houghpeaks) ; 
        flagError = true ; 
        return ; 
    end ; 

    sValue = get(handles.edit_houghthreshold, 'String') ; 
    if isnan(str2double(sValue)) || str2double(sValue) <= 0.0 || str2double(sValue) > 1.0  
        hError = errordlg('Hough threshold must be a number > 0.0, and <= 1.0', 'Input error', 'modal') ; 
        uicontrol(handles.edit_houghthreshold) ; 
        flagError = true ; 
        return ; 
    end ; 

    sValue = get(handles.edit_fillgap, 'String') ; 
    if isnan(str2double(sValue)) || str2double(sValue) <= 1.0    
        hError = errordlg('Merge gap must be a number of pixels, > 1 and < max. image size', 'Input error', 'modal') ; 
        uicontrol(handles.edit_fillgap) ; 
        flagError = true ; 
        return ; 
    end ; 

    sValue = get(handles.edit_minlength, 'String') ; 
    if isnan(str2double(sValue)) || str2double(sValue) <= 1   
        hError = errordlg('Discard length must be a number of pixels, > 1 and < max. image size', 'Input error', 'modal') ; 
        uicontrol(handles.edit_minlength) ; 
        flagError = true ; 
        return ; 
    end ; 

end ; 

%   convert .svg file to .txt file with C shell script 
if ~isempty(strfind(handles.selfile, '.svg')) && isunix 
    sFilename = [ handles.selpath, handles.selfile ] ; 
    [ status, ~ ] = system(['./svg2fracpaq.csh ', sFilename], '-echo') ; 
    if ~status 
        handles.selfile = strrep(handles.selfile, '.svg', '.txt') ; 
    end ; 
end ; 

sValue = get(handles.edit_scaling, 'String') ; 
if ~isempty(sValue)
    if isnan(str2double(sValue)) || str2double(sValue) <= 0.0 
        hError = errordlg('Scaling can be blank (i.e. scale as is) or a positive number', 'Input error', 'modal') ; 
        uicontrol(handles.edit_scaling) ; 
        flagError = true ; 
        return ; 
    end ; 
end ; 

if ~flagError 

    sFilename = [ handles.selpath, handles.selfile ] ; 
    
    if isempty(get(handles.edit_scaling, 'String'))
        nPixels = 0 ; 
    else
        nPixels = str2double(get(handles.edit_scaling, 'String')) ; 
    end ; 
    
    if get(handles.radiobutton_image, 'Value') 
        nHoughPeaks = str2double(get(handles.edit_houghpeaks, 'String')) ;
        dHoughThreshold = str2double(get(handles.edit_houghthreshold, 'String')) ;
        dfillgap = str2double(get(handles.edit_fillgap, 'String')) ;
        dminlength = str2double(get(handles.edit_minlength, 'String')) ;

        set(handles.text_message, 'String', 'Running Hough transform on image...') ;                                 
        [ handles.traces, handles.xmin, handles.ymin, handles.xmax, handles.ymax ] = guiFracPaQ2Dimage(sFilename, nPixels, ...
                                                            nHoughPeaks, dHoughThreshold, dfillgap, dminlength) ; 
    else
        set(handles.text_message, 'String', 'Reading node file...') ;                                 
        [ handles.traces, handles.xmin, handles.ymin, handles.xmax, handles.ymax ] = guiFracPaQ2Dlist(sFilename, nPixels) ; 
    end ; 
    
    set(handles.text_message, 'String', 'Collecting fracture trace data...') ;     

    setappdata(handles.pushbutton_run, 'Traces', handles.traces) ;                                                 
    setappdata(handles.pushbutton_run, 'xMax', handles.xmax) ;                                                 
    setappdata(handles.pushbutton_run, 'yMax', handles.ymax) ;                                                 
    setappdata(handles.pushbutton_run, 'xMin', handles.xmin) ;                                                 
    setappdata(handles.pushbutton_run, 'yMin', handles.ymin) ;                                                 

    handles.nTraces = length(handles.traces) ; 
    handles.nSegments = sum([handles.traces(:).nSegments]) ; 
    handles.nNodes = sum([handles.traces(:).nNodes]) ; 

    set(handles.label_stats, 'String', {['Min. X dimension: ', num2str(handles.xmin)], ...
                                        ['Min. Y dimension: ', num2str(handles.ymin)], ...
                                        ['Max. X dimension: ', num2str(handles.xmax)], ...
                                        ['Max. Y dimension: ', num2str(handles.ymax)], ...
                                        ' ', ...
                                        ['Number of traces: ', num2str(handles.nTraces)], ...
                                        ['Number of segments: ', num2str(handles.nSegments)], ...
                                        ['Number of nodes: ', num2str(handles.nNodes)]}) ;

    set(handles.text_message, 'String', 'Ready. Click Run to generate maps and graphs.') ;     
  
    set(handles.pushbutton_run, 'Enable', 'on') ; 
    set(handles.pushbutton_flipy, 'Enable', 'on') ; 
    uicontrol(handles.pushbutton_run) ; 
    
end ; 

% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flagError = false ; 

sValue = get(handles.edit_numscancircles, 'String') ; 
if isnan(str2double(sValue)) || str2double(sValue) < 2
    hError = errordlg('Number of scan circles must be a positive whole number (e.g. 10-20)', 'Input error', 'modal') ; 
    uicontrol(handles.edit_numscancircles) ; 
    flagError = true ; 
    return ; 
end ; 

sValue = get(handles.edit_degfromnorth, 'String') ; 
if isnan(str2double(sValue)) || str2double(sValue) > 360.0 || str2double(sValue) < -360.0
    hError = errordlg('Degrees from North must be a number <= 360 (use negative for CCW)', 'Input error', 'modal') ; 
    uicontrol(handles.edit_degfromnorth) ; 
    flagError = true ; 
    return ; 
end ; 

sValue = get(handles.edit_aperture, 'String') ; 
if isnan(str2double(sValue)) || str2double(sValue) <= 0.0
    hError = errordlg('Aperture must be a number (in pixels) > 0', 'Input error', 'modal') ; 
    uicontrol(handles.edit_aperture) ; 
    flagError = true ; 
    return ; 
end ; 

sValue = get(handles.edit_lambda, 'String') ; 
if isnan(str2double(sValue)) || str2double(sValue) <= 0.08333 || str2double(sValue) > 1.0
    hError = errordlg('Lamda factor must be a number, >= 1/12, <= 1.0', 'Input error', 'modal') ; 
    uicontrol(handles.edit_lambda) ; 
    flagError = true ; 
    return ; 
end ; 

if ~flagError 
    
    traces = getappdata(hObject, 'Traces') ; 
    xmin = getappdata(hObject, 'xMin') ; 
    ymin = getappdata(hObject, 'yMin') ; 
    xmax = getappdata(hObject, 'xMax') ; 
    ymax = getappdata(hObject, 'yMax') ; 

    if length(traces) > 0 

        %   get values from text boxes 
        if isempty(get(handles.edit_scaling, 'String'))
            nPixels = 0 ; 
        else
            nPixels = str2double(get(handles.edit_scaling, 'String')) ; 
        end ; 
        if strcmp(handles.axes_tracemap.YDir, 'reverse')
            flag_reverse = true ; 
        else
            flag_reverse = false ; 
        end ;
        nNorth = str2double(get(handles.edit_degfromnorth, 'String')) ;
        nAperture = str2double(get(handles.edit_aperture, 'String')) ;
        nLambda = str2double(get(handles.edit_lambda, 'String')) ;
        
        %   get values from drop down lists 
        list = get(handles.popupmenu_histolengthbins, 'String') ; 
        nHistoLengthBins = str2double(list{get(handles.popupmenu_histolengthbins, 'Value')}) ;
        
        list = get(handles.popupmenu_histoanglebins, 'String') ; 
        nHistoAngleBins = str2double(list{get(handles.popupmenu_histoanglebins, 'Value')}) ;
        
        list = get(handles.popupmenu_rosebins, 'String') ; 
        nRoseBins = str2double(list{get(handles.popupmenu_rosebins, 'Value')}) ; 
    
        %   call the various maps & graphs 
        flag_tracemap = get(handles.checkbox_tracemap, 'Value') ; 
        flag_shownodes = get(handles.checkbox_shownodes, 'Value') ; 

        flag_intensitymap = get(handles.checkbox_intensitymap, 'Value') ; 
        flag_densitymap = get(handles.checkbox_densitymap, 'Value') ; 
        flag_showcircles = get(handles.checkbox_showcircles, 'Value') ; 
        nCircles = round(str2double(get(handles.edit_numscancircles, 'String'))) ; 

        flag_histolength = get(handles.checkbox_histolength, 'Value') ; 
        flag_logloglength = get(handles.checkbox_logloglength, 'Value') ;
        flag_crossplot = get(handles.checkbox_crossplot, 'Value') ;
        flag_censor = get(handles.checkbox_censor, 'Value') ; 
        flag_mle = get(handles.checkbox_mle, 'Value') ;

        flag_histoangle = get(handles.checkbox_histoangle, 'Value') ;
        flag_roseangle = get(handles.checkbox_rose, 'Value') ;

        flag_triangle = get(handles.checkbox_triangle, 'Value') ;
        flag_permellipse = get(handles.checkbox_permellipse, 'Value') ;

        if flag_tracemap 
            guiFracPaQ2Dtracemap(traces, nPixels, xmin, ymin, xmax, ymax, flag_shownodes, flag_reverse) ; 
        end ; 

        flag_length = sum([flag_histolength, flag_logloglength]) ; 
        if flag_length
            guiFracPaQ2Dlength_new(traces, nPixels, nNorth, xmax, ymax, nHistoLengthBins, ...
                                    flag_histolength, flag_logloglength, flag_crossplot, flag_mle, flag_censor) ; 
        end ; 

        flag_angle = sum([flag_histoangle, flag_roseangle]) ; 
        if flag_angle
            guiFracPaQ2Dangle(traces, nNorth, xmax, ymax, nHistoAngleBins, nRoseBins, ...
                                    flag_histoangle, flag_roseangle, flag_reverse) ; 
        end ; 

        flag_pattern = sum([flag_intensitymap, flag_densitymap, flag_triangle]) ; 
        if flag_pattern
            guiFracPaQ2Dpattern(traces, nPixels, xmin, ymin, xmax, ymax, ...
                                    flag_intensitymap, flag_densitymap, flag_triangle, flag_showcircles, nCircles, flag_reverse) ; 
        end ; 

        if flag_permellipse
            guiFracPaQ2Dtensor(traces, xmin, ymin, xmax, ymax, nAperture, nLambda, flag_reverse) ; 
        end ; 

        set(handles.text_message, 'String', 'All done. Check current folder for plot figure .jpeg files.') ;   
        
        uicontrol(handles.pushbutton_run) ; 

    else 
        
        errordlg('No traces found; check the input file is OK.') ; 
        
        uicontrol(handles.pushbutton_browse) ; 

    end ; 
    
end ; 

% --- Executes on button press in radiobutton_image.
function radiobutton_image_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_image
set(handles.edit_houghpeaks, 'Enable', 'on') ; 
set(handles.edit_houghthreshold, 'Enable', 'on') ; 
set(handles.edit_fillgap, 'Enable', 'on') ; 
set(handles.edit_minlength, 'Enable', 'on') ; 


% --- Executes on button press in radiobutton_node.
function radiobutton_node_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_node (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_node
set(handles.edit_houghpeaks, 'Enable', 'off') ; 
set(handles.edit_houghthreshold, 'Enable', 'off') ; 
set(handles.edit_fillgap, 'Enable', 'off') ; 
set(handles.edit_minlength, 'Enable', 'off') ; 


% --- Executes during object creation, after setting all properties.
function figure_main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu_histolengthbins.
function popupmenu_histolengthbins_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_histolengthbins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_histolengthbins contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_histolengthbins


% --- Executes during object creation, after setting all properties.
function popupmenu_histolengthbins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_histolengthbins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_histoanglebins.
function popupmenu_histoanglebins_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_histoanglebins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_histoanglebins contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_histoanglebins


% --- Executes during object creation, after setting all properties.
function popupmenu_histoanglebins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_histoanglebins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_rosebins.
function popupmenu_rosebins_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_rosebins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_rosebins contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_rosebins


% --- Executes during object creation, after setting all properties.
function popupmenu_rosebins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_rosebins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_flipy.
function pushbutton_flipy_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_flipy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.axes_tracemap.YDir = 'reverse' ; 
set(handles.text_message, 'String', 'Y-axis flipped.') ;   
