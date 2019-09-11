function varargout = Tarea4(varargin)
% TAREA4 MATLAB code for Tarea4.fig
%      TAREA4, by itself, creates a new TAREA4 or raises the existing
%      singleton*.
%
%      H = TAREA4 returns the handle to a new TAREA4 or the handle to
%      the existing singleton*.
%
%      TAREA4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAREA4.M with the given input arguments.
%
%      TAREA4('Property','Value',...) creates a new TAREA4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tarea4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tarea4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tarea4

% Last Modified by GUIDE v2.5 10-Sep-2019 11:50:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Tarea4_OpeningFcn, ...
    'gui_OutputFcn',  @Tarea4_OutputFcn, ...
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


% --- Executes just before Tarea4 is made visible.
function Tarea4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tarea4 (see VARARGIN)

% Choose default command line output for Tarea4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Tarea4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Tarea4_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DimensionalRed1.
function DimensionalRed1_Callback(hObject, eventdata, handles)
% hObject    handle to DimensionalRed1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.DimensionalRed1,'value') == 1)
    Spikes = handles.x;
    [~,sc]=pca(Spikes);
    x=[sc(:,1),sc(:,2),sc(:,3)];
    handles.sc = x;
    handles.cont = 1;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of DimensionalRed1
%------Aqui tiene que hacer el PCA------%

% --- Executes on button press in DimensionalRed2.
function DimensionalRed2_Callback(hObject, eventdata, handles)
% hObject    handle to DimensionalRed2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.DimensionalRed2,'value') == 1)
    Spikes = handles.x;
    sc = tsne(Spikes,[],3);
    handles.sc = sc;
    handles.cont = 2;

end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of DimensionalRed2



function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of File as text
%        str2double(get(hObject,'String')) returns contents of File as a double


% --- Executes during object creation, after setting all properties.
function File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cluster1.
function cluster1_Callback(hObject, eventdata, handles)
% hObject    handle to cluster1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of cluster1
%-------------CLustering---------------------------------%
 x = handles.sc;
    clustFcn = @(X,K) kmeans(X, K, ...
        'EmptyAction','singleton', 'Replicates',5, ...
        'Options',statset('MaxIter',200));
    cluster=evalclusters(handles.sc,clustFcn,'CalinskiHarabasz','KList',[1:8]);
    clusters= cluster.OptimalY;
    handles.clusters = clusters;

if(get(handles.cluster1,'value') == 1 && get(handles.DimensionalRed1,'value')==1)

    axes(handles.axes2)
    scatter3(x(:,1),x(:,2),x(:,3),25,clusters,'filled')
    title('PCA - K-means')
    xlabel('PCA 1'); ylabel('PCA 2'); zlabel('PCA 3')
     set(handles.cluster1,'value',0)
      set(handles.DimensionalRed1,'value',0)
elseif(get(handles.cluster1,'value') == 1 && get(handles.DimensionalRed2,'value')==1)
    axes(handles.axes3)
    scatter3(x(:,1),x(:,2),x(:,3),25,clusters,'filled')
    title('t-sne - K-means')
    xlabel('PCA 1'); ylabel('PCA 2'); zlabel('PCA 3');
    set(handles.cluster1,'value',0)
    set(handles.DimensionalRed2,'value',0)
end

guidata(hObject, handles);


% --- Executes on button press in cluster2.
function cluster2_Callback(hObject, eventdata, handles)
% hObject    handle to cluster2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 x = handles.sc;

% Hint: get(hObject,'Value') returns toggle state of cluster2
[clusters,~]=CLA(x,50);
if(get(handles.cluster2,'value') == 1 && get(handles.DimensionalRed1,'value')==1)
    axes(handles.axes4)
    scatter3(x(:,1),x(:,2),x(:,3),25,clusters,'filled')
    title('PCA - CLA')
    xlabel('PCA 1'); ylabel('PCA 2'); zlabel('PCA 3')
     set(handles.cluster2,'value',0)
     set(handles.DimensionalRed1,'value',0)
elseif(get(handles.cluster2,'value') == 1 && get(handles.DimensionalRed2,'value')==1)
    axes(handles.axes5)
    scatter3(x(:,1),x(:,2),x(:,3),25,clusters,'filled')
    title('t-sne - CLA')
    xlabel('PCA 1'); ylabel('PCA 2');zlabel('PCA 3')
    set(handles.cluster2,'value',0)
    set(handles.DimensionalRed2,'value',0)
end
% --- Executes on button press in LoadFile.
function LoadFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Permite buscar el archivo de interes
[filename,pathname,FilterIndex] = uigetfile('*.mat')
set(handles.File,'String',[pathname filename]);
data = load(get(handles.File,'String'));
Spikes = data.Spikes';
% handles.browse = browse;
x = Spikes; %Changes 'Spikes' by the real name of your matrix
handles.x = x;
guidata(hObject, handles);

% [~,sc]=pca(Spikes);
% x=[sc(:,1),sc(:,2),sc(:,3)];


% --- Executes on button press in Analysis.
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cont = handles.cont;
if(get(handles.Analysis,'value') == 1)
    if(size(handles.sc,2)>=3)
        clusters = handles.clusters;
        x = handles.sc;
%         figure;
%         uip = uipanel('Position',[.2 10 0.25 0.25]);
        subplot(2,2,cont,'Parent', uip)
        scatter3(x(:,1),x(:,2),x(:,3),25,clusters,'filled')
        title('PCA - K-means')
        xlabel('PCA 1'); ylabel('PCA 2'); zlabel('PCA 3')
%         view(-86,40)
        
    else
        clusters = handles.clusters;
        x = handles.sc;
        subplot(2,2,cont)
        scatter(x(:,1),x(:,2),25,clusters,'filled')
        title('PCA - K-means')
        xlabel('PCA 1'); ylabel('PCA 2');
%         view(-86,40)       
    end
end
    guidata(hObject, handles);
    % Spikes = handles.x;
    % %----First Dimensionality Reduction Method-----%
    % vDr1 = get(handles.DimensionalRed1,'value');
    % %----Second Dimensionality Reduction Method-----%
    % vDr2 = get(handles.DimensionalRed2,'value');
    % vC1 = get(handles.cluster1,'value');
    % vC2 = get(handles.cluster2,'value');
    % vecConditions = [vDr1 vDr2 vC1 vC2];
    % DRClUSTERING(Spikes,vecConditions);
    
    
%     function DRClUSTERING(Spikes,vecConditions)
%     Conditions = [1 0 1 0];
%     
%     if(isequal(vecConditions, Conditions))
%         
%         % [~,sc]=pca(Spikes);
%         sc = tsne(Spikes);
%         
%         x=[sc(:,1),sc(:,2),sc(:,3)];
%         
%         %-------------CLustering---------------------------------%
%         clustFcn = @(X,K) kmeans(X, K, ...
%             'EmptyAction','singleton', 'Replicates',5, ...
%             'Options',statset('MaxIter',200));
%         
%         cluster=evalclusters(x,clustFcn,'CalinskiHarabasz','KList',[1:8]);
%         clusters= cluster.OptimalY;
%     end
%     subplot(2,2,1)
%     scatter3(x(:,1),x(:,2),x(:,3),25,clusters,'filled')
%     title('PCA - K-means')
%     xlabel('PCA 1'); ylabel('PCA 2'); zlabel('PCA 3')
%     view(-86,40)
