function varargout = roomlight(varargin)
% ROOMLIGHT MATLAB code for roomlight.fig
%      ROOMLIGHT, by itself, creates a new ROOMLIGHT or raises the existing
%      singleton*.
%
%      H = ROOMLIGHT returns the handle to a new ROOMLIGHT or the handle to
%      the existing singleton*.
%
%      ROOMLIGHT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROOMLIGHT.M with the given input arguments.
%
%      ROOMLIGHT('Property','Value',...) creates a new ROOMLIGHT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before roomlight_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to roomlight_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help roomlight

% Last Modified by GUIDE v2.5 03-Apr-2017 16:28:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @roomlight_OpeningFcn, ...
                   'gui_OutputFcn',  @roomlight_OutputFcn, ...
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


% --- Executes just before roomlight is made visible.
function roomlight_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to roomlight (see VARARGIN)

% Choose default command line output for roomlight
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes roomlight wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = roomlight_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global se;
display('Communicating Arduino');
PORT=get(handles.edit1,'String');
PORT=strcat('COM',PORT);
se=serial(PORT,'BaudRate',9600);
fopen(se);
fprintf(se,'*0000#');
display('PORT Connected');

             
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global se
[filename pathname] = uigetfile({'*.png';'*.jpg'},'File Selector');
axes(handles.axes1);
default=imread('image.png');
data=imread(filename);

diff_im = imsubtract(data(:,:,1), rgb2gray(data));
diff_im=medfilt2(diff_im,[3 3]);
diff_im1=im2bw(diff_im,0.2);

diff_im = imsubtract(data(:,:,2), rgb2gray(data));
diff_im=medfilt2(diff_im,[3 3]);
diff_im2=im2bw(diff_im,0.2);

diff_im = imsubtract(data(:,:,3), rgb2gray(data));
diff_im=medfilt2(diff_im,[3 3]);
diff_im3=im2bw(diff_im,0.2);

data2=imcomplement(data);
diff_im = imsubtract(data(:,:,3), rgb2gray(data2));
diff_im=medfilt2(diff_im,[3 3]);
diff_im4=im2bw(diff_im,0.2);

diff_im=diff_im1+diff_im2+diff_im3+diff_im4;
diff_im=imsubtract(data,default);
diff_im=im2bw(diff_im);
imshow(diff_im);

    diff_im=bwareaopen(diff_im,50);
    bw=bwlabel(diff_im,8);
    stats=regionprops(bw,'Centroid');
    
    imshow(diff_im);
    
    quad1=0;
    quad2=0;
    quad3=0;
    quad4=0;
    
     hold on
     if ~isempty(stats)
         set(handles.text4,'String',strcat('PERSON(S) :',num2str(length(stats))));
         i=1;
         while i<=length(stats)
             bc=stats(i).Centroid;
             if(bc(1)<300 && bc(2)<160)
                 quad1=quad1+1;
             elseif(bc(1)<300 && bc(2)>=160)
                 quad3=quad3+1;
             elseif(bc(1)>=300 && bc(2)<160)
                 quad2=quad2+1;
             elseif(bc(1)>=300 && bc(2)>=160)
                 quad4=quad4+1;
             end
             
             i=i+1;
         end
         
     end
     
     temp='*';
     if(quad1>0&&quad1<15)
         temp=(strcat(temp,'1'));
     elseif(quad1>0&&quad1>=15)
         temp=(strcat(temp,'2'));
     else
         temp=(strcat(temp,'0'));
     end 
     if(quad2>0&&quad2<15)
         temp=(strcat(temp,'1'));
     elseif(quad2>0&&quad2>=15)
         temp=(strcat(temp,'2'));
     else
         temp=(strcat(temp,'0'));
     end
     if(quad3>0&&quad3<15)
         temp=(strcat(temp,'1'));
     elseif(quad3>0&&quad3>=15)
         temp=(strcat(temp,'2'));
     else
         temp=(strcat(temp,'0'));
     end
     if(quad4>0&&quad4<15)
         temp=(strcat(temp,'1'));
     elseif(quad4>0&&quad4>=15)
         temp=(strcat(temp,'2'));
     else
         temp=(strcat(temp,'0'));
     end
         temp=strcat(temp,'#');
         fprintf(se,temp);
         
             display(quad1);
             display(quad2);
             display(quad3);
             display(quad4);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global se;
fclose(se);
display('Closing Serial');
close all
clear all
clc
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
