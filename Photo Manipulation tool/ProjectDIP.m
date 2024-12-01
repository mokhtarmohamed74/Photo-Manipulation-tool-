function varargout = ProjectDIP(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ProjectDIP_OpeningFcn, ...
                   'gui_OutputFcn',  @ProjectDIP_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% --- Executes just before ProjectDIP is made visible.
function ProjectDIP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProjectDIP (see VARARGIN)

% Choose default command line output for ProjectDIP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ProjectDIP wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ProjectDIP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
[a, b]=uigetfile();
    heros = strcat(b, a);
    heros = imread(heros);
    axes(handles.axes1);
    imshow(heros);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
scale = [0.09 0.09];
imgSize = size(heros);

newImgSize = max(floor(scale.*imgSize(1:2)),1);

rowIndex = min(round(((1:newImgSize(1))-0.5)./scale(1)+0.5),imgSize(1));
colIndex = min(round(((1:newImgSize(2))-0.5)./scale(2)+0.5),imgSize(2));

outputImg = heros(rowIndex,colIndex,:);
axes(handles.axes2);
imshow(outputImg)
title("Resampling up Image")
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
k = 8;
figure
while (k > 0)
 target_levels = 2^k;
 target_compr_factor = 256 / target_levels;
 reduced_image = uint8(floor(double(heros)/256 * target_levels) * target_compr_factor);
 subplot(3, 3, k); 
 imshow(reduced_image, [0 255]);
 if (k==1)
      title('Black & White');
 else
      title(['Grey-level resolution 2^',num2str(k)]);
 end
 k = k - 1;
end
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
[rows ,cols, matricesNo] = size(heros);
SamplingFactor = 16;
for metricesIndex=1:1:matricesNo
    resizedImage(:,:,metricesIndex) = subSampling(heros(:,:,metricesIndex),SamplingFactor);
end
axes(handles.axes3);
imshow(resizedImage);
title('Sub Sampling image');
imwrite(resizedImage,'resizedImage.png');
function [outImage] = subSampling(image, subSamplingFactor)
[rows, cols] = size(image);
outImage = image(1:subSamplingFactor:rows,1:subSamplingFactor:cols);
end
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
rmax=max(max(heros));
out=rmax-heros;
axes(handles.axes3);
imshow(out);
title("Negative Image");
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
out=heros;
axes(handles.axes2);
imshow(out);
title("Identity Image");
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
figure;
c=1;
grey_image = rgb2gray(heros);
double_value = im2double(grey_image);
heros1= c*(double_value.^1); 
heros2= c*(double_value.^0.5); 
heros3= c*(double_value.^1.5); 
axes(handles.axes2);
imshow(heros1);
title("Power=1")
axes(handles.axes3);
imshow(heros2);
title("Power=0.5")
axes(handles.axes4);
imshow(heros3);
title("Power=1.5");
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
figure;
grey_image = rgb2gray(heros);
double_value = im2double(grey_image);
heros1= 2*log(1+double_value);
heros2= 2.5*log(1+double_value);
heros3= 4*log(1+double_value);
axes(handles.axes2);
imshow(heros1);
title 'c=2';
axes(handles.axes3);
imshow(heros2);
title 'c=3';
axes(handles.axes4);
imshow(heros3);
title 'c=4';
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
heros=rgb2gray(heros);
[row, col] = size(heros);
rmin=min(min(heros));
rmax=max(max(heros));
for x=1:row 
        for y=1:col
           heros(x,y)=((255)/(rmax-rmin))*((heros(x,y))-(rmin));
        end
end
axes(handles.axes2);
imshow(heros)
title("Contrast Image")
end



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
[row, col] = size(heros);
 for x=1:row 
        for y=1:col
           if  heros(x,y)>128
                heros(x,y)=255;
           else
                heros(x,y)=0;
           end
        end
end 
axes(handles.axes3);
imshow(heros)
title("Thresholing");

end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
grey_image = rgb2gray(heros);  
newImage = grey_image;
[rows , cols] = size(grey_image);
for row_index=1:1:rows
    for col_index=1:1:cols
        if(grey_image(row_index,col_index)>=100 && grey_image(row_index,col_index)<=150)
            newImage(row_index,col_index) = 255;
        else
             newImage(row_index,col_index) = 0;
        end
    end
end
axes(handles.axes2);
imshow(newImage);
title("Gray Level Slicing Approach 1")
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global heros;
figure;
grey_image = rgb2gray(heros);  
newImage = grey_image;
[rows , cols] = size(grey_image);
for row_index=1:1:rows
    for col_index=1:1:cols
        if(grey_image(row_index,col_index)>=100 && grey_image(row_index,col_index)<=150)
            newImage(row_index,col_index) = 255;
        else
             newImage(row_index,col_index) = grey_image(row_index,col_index);
        end
    end
end
axes(handles.axes3);
imshow(newImage);
title("Gray Level Slicing Approach 2")
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
