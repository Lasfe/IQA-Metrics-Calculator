%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bursa Technical University Electrical and Electronics Engineering
% 2022-2023 Spring Semester EEM0402 Graduation Project
% Calculation of Image Quality Metrics using MATLAB GUI
% 19332629062 - Bilal BAĞCIOĞLU
% v1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = calculator(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @calculator_OutputFcn, ...
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


function calculator_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);

function varargout = calculator_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in buttonImage.

function buttonImage_Callback(hObject, eventdata, handles)

[filename,filepath]=uigetfile({'*.*'},'Select Your Image File');
selectedImage=imread(strcat(filepath,filename));
axes(handles.imageOriginal);
imshow(selectedImage);

noisedImage = imnoise(selectedImage,'salt & pepper', 0.02);
axes(handles.imageNoised);
imshow(noisedImage);

GrayImg = im2gray(selectedImage);
CanSeg = edge(GrayImg,'canny',0.01,1.5);
LogSeg = edge(GrayImg,'log',0.01,1.5);

% MSE Calculation {lower => greater similarity}
mseVal = immse(noisedImage, selectedImage);
set(handles.resultMSE,'String',mseVal);

% SSIM Calculation {closer to 1 => better quality}
gaussFilt = fspecial('Gaussian',[11 11],1.5);
replFilt = imfilter(selectedImage,gaussFilt,'replicate');
[ssimVal] = ssim(replFilt,selectedImage);
set(handles.resultSSIM,'String',ssimVal);

% pSNR and SNR Calculation {higher => better quality}
[peaksnrVal, snrVal] = psnr(noisedImage, selectedImage);
set(handles.resultPSNR,'String',peaksnrVal);
set(handles.resultSNR,'String',snrVal);

% Noised NIQE Calculation {(lower value => better quality) [among the images]}
niqeValNoised = niqe(noisedImage);
set(handles.resultNoisedNIQE,'String',niqeValNoised);
% Original NIQE Calculation
niqeValOriginal = niqe(selectedImage);
set(handles.resultOriginalNIQE,'String',niqeValOriginal);

% Noised BRISQUE Calculation {(lower value => better quality) [among the images]}
brisqueValNoised = brisque(noisedImage);
set(handles.resultNoisedBRISQUE,'String',brisqueValNoised);
% Original BRISQUE Calculation
brisqueValOriginal = brisque(selectedImage);
set(handles.resultOriginalBRISQUE,'String',brisqueValOriginal);

% Corelation Coefficent Calculation
% {(-1 => negative corelation, 0 => no corelation, +1 => positive corelation)}
selectedImageDouble = double(selectedImage);
noisedImageDouble = double(noisedImage);

corrCoefMatrix = corrcoef(noisedImageDouble,selectedImageDouble);
corrCoefVal = corrCoefMatrix(1,2);
set(handles.resultCorrCoef,'String',corrCoefVal);

% BDE Calculation {lower => better}
% ~ is returnStatus
[bdeVal, ~] = compare_image_boundary_error(CanSeg, LogSeg);
set(handles.resultBDE,'String',bdeVal);

% PRI & GCE and VOI Calculation
% PRI {close to 1 => greater similarity, close to 0 => difference}
% GCE {lower => better}
% We don't need to VOI value
[priVal, gceVal, ~] = compare_segmentations(CanSeg, LogSeg);
set(handles.resultPRI,'String',priVal);
set(handles.resultGCE,'String',gceVal);

% FSIM and FSIMc Calculation {}
[fsimVal, fsimcVal] = FSIM(selectedImage, noisedImage);
set(handles.resultFSIM,'String',fsimVal);
set(handles.resultFSIMc,'String',fsimcVal);


function tagMSE_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagMSE_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagPSNR_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagPSNR_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagSNR_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagSNR_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagSSIM_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagSSIM_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagBRISQUE_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagBRISQUE_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagNIQE_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagNIQE_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function refQualityMetricsTag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function refQualityMetricsTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function norefQualityMetricsTag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function norefQualityMetricsTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function originalImageTag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function originalImageTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function noisedValuesTag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function noisedValuesTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function originalValuesTag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function originalValuesTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function noisedImageTag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function noisedImageTag_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagCorrCoef_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagCorrCoef_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagBDE_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagBDE_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagPRI_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagPRI_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagGCE_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagGCE_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagFSIM_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagFSIM_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tagFSIMc_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function tagFSIMc_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over buttonImage.
function buttonImage_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to buttonImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
