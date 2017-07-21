% John Cymerman
% JPSS
%
% This script runs science3d_emi.fig, which imports science channel data
% and creats a 3D histogram of the data, sliced up into a
% specified number of slices. 
%
%
function varargout = science3d_emi(varargin)
% SCIENCE3D_EMI MATLAB code for science3d_emi.fig
%      SCIENCE3D_EMI, by itself, creates a new SCIENCE3D_EMI or raises the existing
%      singleton*.
%
%      H = SCIENCE3D_EMI returns the handle to a new SCIENCE3D_EMI or the handle to
%      the existing singleton*.
%
%      SCIENCE3D_EMI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCIENCE3D_EMI.M with the given input arguments.
%
%      SCIENCE3D_EMI('Property','Value',...) creates a new SCIENCE3D_EMI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before science3d_emi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%
% 
%   for x = 1:10
% 
%   for x = 1:10
%       disp(x)
%   end
% 
%       disp(x)
%   end
% 
%      stop.  All inputs are passed to science3d_emi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help science3d_emi

% Last Modified by GUIDE v2.5 20-Jul-2017 15:25:48

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @science3d_emi_OpeningFcn, ...
                       'gui_OutputFcn',  @science3d_emi_OutputFcn, ...
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

% --- Executes just before science3d_emi is made visible.
function science3d_emi_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to science3d_emi (see VARARGIN)

    % Choose default command line output for science3d_emi
    handles.output = hObject;

    set(handles.axes8, 'YTickMode', 'auto')    
    set(handles.axes8, 'YTickLabel', [])  
    
    set(handles.axes7, 'YTickMode', 'auto')    
    set(handles.axes7, 'YTickLabel', []) 
    
    set(handles.axes3, 'YTickMode', 'auto')    
    set(handles.axes3, 'YTickLabel', []) 
    
    set(handles.axes5, 'YTickMode', 'auto')    
    set(handles.axes5, 'YTickLabel', [])  
    
    set(handles.axes6, 'YTickLabel', [])      
    set(handles.axes6, 'YTickMode', 'auto') 
    ylabel(handles.axes3, '') % not sure why the ylabel was permanently saved
    
    grid(handles.axes8, 'on')
    grid(handles.axes3, 'on')
    grid(handles.axes5, 'on')
    grid(handles.axes6, 'on')   
    grid(handles.axes7, 'on')    

    pushbutton13_Callback(hObject, eventdata, handles)
    
    handles.gains = [38.5, 48.8, 38.8, 36.7, 34.2, 35.3, 28.2, 32.6, 32.9, 34.8, 35.1, 39.4, 40.4, 42.3, 41.3, 35.4, 16.52, 14.0, 14.48, 15.9, 15.52, 14.78];

    handles.sc_file = 0; % set flag to indicate that no S/C file has been opened yet
    handles.main_file = 0;
    handles.pow_file = 0;
    for i = 1:23
        if i == 1
            handles.chStrings{i} = 'Uncalibrated';
        else
            handles.chStrings{i} = ['Channel ',num2str(i-1)];
        end
    end
    
%    set(handles.popupmenu1, 'String', handles.chStrings);

    handles.prevPath = fullfile(pwd, 'data');
        
    dc = datacursormode(handles.figure1); % fix data cursor to show time
    set(dc, 'UpdateFcn', @dcUpdateEMI)
    
    set(handles.radiobutton4, 'value',0); % reset the Sort Function
    set(handles.radiobutton5, 'value',0); % reset the Delete Dups function
    handles.epoch = datenum('01-01-1958', 'dd-mm-yyyy');
    
    handles.DBname = '';
    handles.DBDptr = '';
    
             
    guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = science3d_emi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;
end

% Browse File button - Main science FILE INGEST
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%reset(handles.axes8);
%reset(handles.axes7);
%reset(handles.axes3);
    str = get(handles.text2, 'string');
    set(handles.text2, 'String', 'loading ...')
    [name_atms, path_atms] = uigetfile(fullfile(handles.prevPath,'*.txt'));
    if ~path_atms
        set(handles.text2, 'String', str)
        return;
    else
        handles.prevPath = path_atms;
       set(handles.text2,'String', ['File Chosen: ', name_atms]);
    end
    set(handles.figure1, 'pointer', 'watch') % hourglass pointer (nice aesthetic)
    

    handles.main_file = 1;
    handles.data_atms = table2array(readtable(fullfile(path_atms, name_atms), 'delimiter',',')); % Whole Matrix

    if any(isnan(handles.data_atms(:,end))) % sometimes readtable adds an extra column
        handles.data_atms = handles.data_atms(:,1:end-1); % cut off the last column, which contains a ton of NaN
    end    
    
    if get(handles.radiobutton4,'value') || get(handles.radiobutton5,'value') % if Delete Dups or sort requested
        handles.data_atms = dataCorrection(handles.data_atms, ...
            get(handles.radiobutton4,'value'), get(handles.radiobutton5,'value'));
    end

    [handles.rows_atms,handles.cols_atms] = size(handles.data_atms);
    
    % Used to Slice up Data
    handles.slices = floor(handles.rows_atms/400); % always want about 400 scans per slice
%    set(handles.text4, 'string', ['Number of Slices: ' num2str(handles.slices)])
    handles.index = floor((handles.rows_atms)/handles.slices);    
    
    handles.dates = handles.data_atms(: , 1); % DAY field
    handles.millsec = handles.data_atms(: , 2); % Millisecond field
    handles.usec = handles.data_atms(: , 3); % Microsecond field
    
    handles.time = handles.dates + handles.epoch + ...
        (handles.millsec/1000+ handles.usec/1000000)/86400;  % setting time vector (in days from 00-00-0000)    

    % check for gaps - if there are, generate fill records 
    two_scans = 2.667 * 2 / 86400; % set up 2 scans as limit of acceptability delta time (in days)

    gap_delta = handles.time(2:end) - handles.time(1:(end-1)); % dt vector throughout. an index indicating a gap in this vector is the start index for the gap in the time vector    

    if any(gap_delta > two_scans)
        gapInds = find(gap_delta > two_scans); % find the startInds of the gaps
        one_scan = 2.667/86400;  % time of one scan in days  
        gapTimes = handles.time(gapInds);
        %datestr(gapTimes,'HH:MM:SS')
        num_missed_scans = floor( (handles.time(gapInds+1) - gapTimes)/one_scan ); % vector of number of missed scans (scalar if only one gap in data)
        filler = mean(mean(handles.data_atms(:, floor(3*size(handles.data_atms,2)/4):end))); % choose a fill data value from scan data
        for i = 1:length(num_missed_scans)    
            fill_times = gapTimes(i) + one_scan * (1:num_missed_scans(i));
            handles.time((gapInds(i) + 1):(gapInds(i) + num_missed_scans(i))) = fill_times;% fix the timestamps
            %datestr(fill_times, 'HH:MM:SS')
            handles.data_atms((gapInds(i) + 1):(gapInds(i) + num_missed_scans(i)), :) = filler*ones(num_missed_scans(i), handles.cols_atms);  % fill with NaN so Matlab skips it in the plot
        end

        handles.rows_atms = size(handles.data_atms, 1); % update size
    end


    if handles.cols_atms == 300
        % Diag data
        handles.counts = handles.data_atms(:, 153:300); %
        handles.angle = handles.data_atms(:,5:152);
    else
        % Normal data
       handles.counts = handles.data_atms(:, 108:211); % 211 to include calibration positions or 204 for earth scan only
       handles.cal_cold = mean(handles.data_atms(:, 204:207)); % Average of Cold Cal targets (nothing for diag data)
       handles.cal_hot = mean(handles.data_atms(:, 208:211)); % Average of internal Warm target
       handles.angle = handles.data_atms(:,4:107);
    end
    
    handles.main_dt = mean(handles.time(2:end)-handles.time(1:(end-1)));
    set(handles.figure1, 'pointer', 'arrow') % hourglass pointer (nice aesthetic)
  
    guidata(hObject, handles);

end



% --- Executes on button press in pushbutton2.  THIS IS THE PLOT PB
function pushbutton2_Callback(varargin)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
    if nargin==3 % normal calling from guimainfun
        hObject = varargin{1};
        eventdata = varargin{2};
        handles = varargin{3};
        counts = handles.counts;
    else % called from saveAsPPTX
        hObject = varargin{1};
        eventdata = varargin{2};
        handles = varargin{3};
        counts = varargin{4}(:,108:211);
    end

    if ~(handles.main_file || handles.sc_file)
        h = errordlg('Load data first');
        uiwait(h)
        return; 
    end
   

%    str=get(handles.popupmenu1,'String'); % Plot Calibrated or not calibrated science data
 %   val=get(handles.popupmenu1,'Value');
    
    currslice = str2double(get(handles.edit4, 'string'));
   
    
    endInd = handles.index*currslice; % Last row index in slice
    if handles.main_file
        if endInd > length(handles.time)
            endInd = length(handles.time);
        end
    else
        if endInd > length(handles.time_sc)
            endInd = length(handles.time_sc);
        end
    end
    %First row index in slice
    
    if currslice == 1
        startInd = 1;
    else
        startInd = handles.index*(currslice - 1);
    end
    
    
%     if any(isnan(handles.counts(startInd:endInd,1)))
%         tmp = find( ~isnan(handles.counts(startInd:endInd,1)) ); % want to omit NaN from data gaps, as they throw off the aux plots
%         startInd = tmp(1); endInd = tmp(end);
%     end
    startIndAux = startInd ;% align timestamps
    endIndAux =  endInd;
    % align plot times in left and right (since they are diff rates we need a diff index range to match timestamps)    
    if handles.main_file && handles.sc_file 

        [~, startIndAux] = min(abs(handles.time_sc - handles.time(startInd))) ;

        [~, endIndAux] = min(abs(handles.time_sc - handles.time(endInd)));
        
    end  

    
    %datestr(handles.time(find(isnan(handles.counts(:,1)))), 'HH:MM:SS')

    % Plot right window

    
    if handles.sc_file % if auxillary file open
        
        %%%%%%%%%%%%% NOTICE %%%%%%%%%%%%%%%
        % This part will really throw you off with y and x labels. The y
        % axis is vertical in matlab, but I am calling it the X axis, as
        % that is how am using it. It needs to be this way for the
        % dateticks
        %%%%%%%%%%%%%%%%%%%%%%%
               
        X1 = handles.time_sc(startIndAux:endIndAux); % set up local variable for total time in days

        x1label = handles.labels_sc(1 ,handles.indicesA1) ;
        x2label = handles.labels_sc(1, handles.indicesA2) ; 
        x3label = handles.labels_sc(1, handles.indicesA3) ; 
        x4label = handles.labels_sc(1, handles.indicesA4) ; 
        
        
        calibFlag = get(handles.radiobutton6, 'value'); % calibrate?
        
        
        axes(handles.axes8); % select first SC TLM window

        % AUX 1
        if ~calibFlag
            data1 = handles.data_sc( startIndAux:endIndAux , handles.indicesA1);
        else
            [data1, x1label] = calibrateData(handles.data_sc(startIndAux:endIndAux, handles.indicesA1),...
                handles.DBDptr, x1label);
        end       
        
        plot(data1, X1, 'Linewidth', 1.5);
        set(handles.axes8, 'YTickLabelRotation', 45)  
        set(handles.axes8, 'YTickLabelMode', 'auto')  
        axis(handles.axes8, [mean(mean(data1))-1 mean(max(data1))+1 X1(1) X1(end)])
        h = legend(x1label, 'Location', 'Best');
        set(h, 'Interpreter', 'none')   
        title('AUX 1 Data')
        
        set(handles.axes8, 'YTickLabelMode', 'auto')   % we actually want the ticks on this one
        set(handles.axes8, 'YTickMode', 'auto')   
        set(handles.axes8, 'XTickLabelRotation', 45) 
        set(handles.axes8, 'YTickLabelRotation', 45) 

        datetick(handles.axes8, 'y', 'HH:MM:SS', 'keeplimits', 'keepticks')   
       
        
        % AUX 2
        if ~calibFlag
            data2 = handles.data_sc( startIndAux:endIndAux , handles.indicesA2);
        else
            [data2, x2label] = calibrateData(handles.data_sc(startIndAux:endIndAux, handles.indicesA2),...
                handles.DBDptr, x2label);
        end
        axes(handles.axes7); % select first SC TLM window
        plot(data2,X1, 'Linewidth', 1.5);
        set(handles.axes7, 'YTick', [])  

        set(handles.axes7, 'YTickLabel', [])
        %datestr(X1, 'HH:MM:SS')
        axis(handles.axes7, [min(min(data2))-1 max(max(data2))+1 X1(1) X1(end)])
        h = legend(x2label, 'Location', 'Best');
        set(h, 'Interpreter', 'none')       
        title('AUX 2 Data')
        
        
        set(handles.axes7, 'YTickLabel', [])     
        set(handles.axes7, 'XTickLabelRotation', 45) 
        set(handles.axes7, 'YTickMode', 'auto')  
        
        
        
        % AUX 3
        
        if ~calibFlag
            data3 = handles.data_sc( startIndAux:endIndAux , handles.indicesA3);
        else
            [data3, x3label] = calibrateData(handles.data_sc(startIndAux:endIndAux, handles.indicesA3),...
                handles.DBDptr, x3label);
        end
        axes(handles.axes5); % select first SC TLM window
        plot(data3,X1, 'Linewidth', 1.5);
        set(handles.axes5, 'YTick', [])    
        set(handles.axes5, 'YTickLabel', [])
        axis(handles.axes5, [max(min(data3))-1 max(max(data3))+1 X1(1) X1(end)])
        h = legend(x3label, 'Location', 'Best');
        set(h, 'Interpreter', 'none') 
        
        title('AUX 3 Data')
        
        set(handles.axes5, 'YTickLabel', [])     
        set(handles.axes5, 'XTickLabelRotation', 45) 
        set(handles.axes5, 'YTickMode', 'auto')        
        
        
        % AUX 4
        if ~calibFlag
            data4 = handles.data_sc( startIndAux:endIndAux , handles.indicesA4);
        else
            [data4, x4label] = calibrateData(handles.data_sc(startIndAux:endIndAux, handles.indicesA4),...
                handles.DBDptr, x4label);
        end
        axes(handles.axes6); % select fourth aux axes ( first on the left)
        plot(data4,X1, 'Linewidth', 1.5);
        yticks(handles.axes6, 'auto')    
        set(handles.axes6, 'YTickLabelRotation', 45)

        axis(handles.axes6, [min(min(data4))-1 max(max(data4))+1 X1(1) X1(end)])
        h = legend(x4label, 'Location', 'Best');
        set(h, 'Interpreter', 'none')
       
        title('AUX 4 Data')
        
        set(handles.axes6, 'YTickLabel', [])   % we actually want the ticks on this one
        set(handles.axes6, 'YTickMode', 'auto')   
        set(handles.axes6, 'XTickLabelRotation', 45) 
        

     
    end   
    
    
    if handles.main_file
                
      
 
        handles.calcounts = counts;
%             case 'Channel 1'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(1);
%             case 'Channel 2'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(2);
%             case 'Channel 3'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(3);
%             case 'Channel 4'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(4);
%             case 'Channel 5'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(5);
%             case 'Channel 6'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(6);
%             case 'Channel 7'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(7);
%             case 'Channel 8'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(8);
%             case 'Channel 9'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(9);
%             case 'Channel 10'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(10);
%             case 'Channel 11'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(11);
%             case 'Channel 12'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(12);
%             case 'Channel 13'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(13);
%             case 'Channel 14'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(14);
%             case 'Channel 15'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(15);
%             case 'Channel 16'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(16);
%             case 'Channel 17'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(17);
%             case 'Channel 18'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(18);
%             case 'Channel 19'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(19);
%             case 'Channel 20'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(20);
%             case 'Channel 21'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(21);
%             case 'Channel 22'
%                 handles.calcounts = (handles.counts - handles.cal)/handles.gains(22);     

        
        if get(handles.togglebutton1, 'value') % if scan position data required

            axes(handles.axes8);
            angles_cols = size(handles.angle, 2);
            
            handles.position_desired = str2double(get(handles.edit5, 'string'));
            
            ii=handles.position_desired;

            if(ii>angles_cols)
                ii = angles_cols;
                set(handles.edit5,'string',num2str(angles_cols));
            end

            angle_data = handles.angle(startInd:endInd,ii);

            plot(handles.axes8, angle_data, handles.time(startInd:endInd), 'Linewidth', 1.5);
            axis(handles.axes8, [min(angle_data) inf handles.time(startInd) handles.time(endInd)])
            grid on;
            xlabel('Angle (Deg)');

            pos_label = [' Position -- ',num2str(ii)];

            title(' Scan Position ');
            h = legend(pos_label);
            set(h, 'Interpreter', 'none')
            set(handles.axes8, 'YTickLabel', [])     
            set(handles.axes8, 'XTickLabelRotation', 45) 
            set(handles.axes8, 'YTickMode', 'auto')

        end

        axes(handles.axes3);
        if get(handles.radiobutton3, 'value') % If Earth Scan only requested ( only positions 1 thru 96 )
            end_position = 96;
        else
            end_position = 104;
        end

        surf(1:end_position, handles.time(startInd:endInd), ...
            handles.calcounts(startInd:endInd, 1:end_position) ...
            ,'EdgeColor','None', 'FaceColor', 'flat'); %  modify the col to zoom in scan (ie. 1:20)
        
        view(2);
        xlabel('Scan Position');
       % if strcmp(str{val}, 'Uncalibrated')
       
        zlabel('Counts');
%         else
%             zlabel('Degrees K');
%         end
        colormap jet;
        colorbar('eastoutside');
        axis tight;

       % set(handles.axes3, 'YTick', handles.time(startInd:endInd))
        set(handles.axes3, 'YTickLabel', [])   
        set(handles.axes3, 'XTickLabelRotation', 45)               
        title(['Science Scans ',num2str(startInd), ' - ', num2str(endInd)]);
        
        set(handles.axes3, 'YTickLabelMode', 'auto') 
        set(handles.axes3, 'XTickLabelRotation', 45)
        set(handles.axes3, 'YTickLabelRotation', 45) 
        set(handles.axes3, 'YTickMode', 'auto')        
        datetick('y', 'HH:MM:SS', 'keeplimits', 'keepticks')
       
    end    
    
    ylabel(handles.axes8, 'Time (HH:MM:SS)')
   
    grid(handles.axes8, 'on')
    grid(handles.axes3, 'on')
    grid(handles.axes5, 'on')
    grid(handles.axes6, 'on')   
    grid(handles.axes7, 'on')    
    
    % Power supply info
    if handles.pow_file && (handles.main_file || handles.sc_file)


        if handles.main_file, [~, indPow] = min(abs(handles.time_pow - handles.time(startInd))) ;
        else, [~, indPow] = min(abs(handles.time_pow - handles.time_sc(startInd))) ; 
        end
        
        AB = handles.data_pow(indPow, :);
        if AB(1)
            set(handles.text31, 'String' ,'A')
        elseif AB(2)
            set(handles.text31, 'String' ,'B')
        else
           set(handles.text31, 'String' ,'None')
        end
             
    end
    guidata(hObject, handles);

end

%  Forward button
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     tmp = strsplit(get(handles.text4, 'string'), ':'); % # slices
%     handles.slices = str2double(tmp{2});

    edit4strnum = str2double(get(handles.edit4, 'string')); % # Slices
    if handles.main_file, slices = ceil(handles.rows_atms/400);
    elseif handles.sc_file, slices = ceil(handles.rows_sc/400);
    else, return
    end
    
    if edit4strnum == slices
        set(handles.edit4, 'string', '1');
    elseif edit4strnum > slices
        set(handles.edit4, 'string', num2str(slices));
    elseif edit4strnum < 1
        set(handles.edit4, 'string', num2str(slices));
    else
    set(handles.edit4, 'string', num2str(edit4strnum+1));
    end
    pushbutton2_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end

% Back Button
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     tmp = strsplit(get(handles.text4, 'string'), ':'); % # slices
%     handles.slices = str2double(tmp{2});
    
    edit4strnum = str2double(get(handles.edit4, 'string'));
    if handles.main_file, slices = floor(handles.rows_atms/400);
    elseif handles.sc_file, slices = floor(handles.rows_sc/400);
    else, return
    end
    if edit4strnum == 1
        set(handles.edit4, 'string', num2str(slices));
    elseif edit4strnum > handles.slices
        set(handles.edit4, 'string', num2str(slices));
    elseif edit4strnum < 1
        set(handles.edit4, 'string', num2str(slices));
    else
        set(handles.edit4, 'string', num2str(edit4strnum-1));
    end
    pushbutton2_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end
    
% Invisible slice tracker
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%init_slice = 1;
%set(handles.edit2, 'string', num2str(init_slice));
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% save screen button
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    currslice = str2double(get(handles.edit4, 'string'));
    endInd = handles.index*currslice; % Last row index in slice

    if endInd > length(handles.time)
        endInd = length(handles.time);
    end

    %First row index in slice
    if currslice == 1
        startInd = 1;
    else
        startInd = handles.index*(currslice - 1);
    end

    t = [handles.time(startInd);handles.time(endInd)];
    
    saveScreen(handles.prevPath, @pushbutton2_Callback, handles.text2,handles.figure1...
        , t, hObject, eventdata, handles);
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
end

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
end

% save
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isempty(handles.edit3)
        set(handles.edit3, 'string', 'Science Data');
    end
    savename = get(handles.edit3, 'string');
    export_fig('%d.jpg', savename); % uses export_fig function from matlab file exchange
    guidata(hObject, handles);
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in pushbutton8. - AUXILLARY FILE INGEST
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    str = get(handles.text15, 'string');
    set(handles.text15, 'string', 'loading ...')
	[name_sc, path_sc] = uigetfile(fullfile(handles.prevPath, '*.txt')); %Modify for csv, txt, etc
    
    if ~path_sc
        set(handles.text15, 'string', str)
        return;
    else
       set(handles.text15,'String', ['File Chosen: ', name_sc]);
       
       if handles.main_file && path_sc~=handles.prevPath
           h = warndlg('Warning: Spacecraft file is not from the same time period as the Science file');
           uiwait(h)
       else
           handles.prevPath = [path_sc '..']; % points the user back there next time
       end
       
    end
    set(handles.figure1, 'pointer', 'watch') % hourglass pointer (nice aesthetic)
    
    
    A = readtable(fullfile(path_sc, name_sc), 'delimiter',','); % Whole Table
    
    if any(isnan(A{:,end})) % sometimes readtable adds an extra column
        A = A(:,1:end-1); % cut off the last column, which contains a ton of NaN
    end
    
    [handles.labels_sc, sortInds] = sort(A.Properties.VariableNames); % alphebetize colheaders

    handles.indicesA1 = 1;
    handles.indicesA2 = 1;
    handles.indicesA3 = 1;
    handles.indicesA4 = 1;    
    
    set(handles.listbox2, 'value', 1) % prevents index out of range errors
    set(handles.listbox3, 'value', 1)
    set(handles.listbox4, 'value', 1) % prevents index out of range errors
    set(handles.listbox5, 'value', 1)
    
    
    handles.sc_file = 1 ; % indicate that Spacecraft file has been loaded.

    handles.data_sc = table2array(A);% data 

    handles.data_sc = dataCorrection(handles.data_sc, ...
        get(handles.radiobutton4,'value'), get(handles.radiobutton5,'value'));
    % sort headers and delete dups

    [handles.rows_sc,handles.cols_sc] = size(handles.data_sc);

    %Setting list box contents

    %
    set(handles.listbox2,'String',handles.labels_sc); % PLOT SC #1 WINDOW
    set(handles.listbox3,'String',handles.labels_sc); % PLOT SC #2 WINDOW
    set(handles.listbox4,'String',handles.labels_sc); % PLOT SC #3 WINDOW
    set(handles.listbox5,'String',handles.labels_sc); % PLOT SC #4 WINDOW
    
    dates_sc = handles.data_sc(1:handles.rows_sc ,1 ) ;
    handles.seq_cnt_sc = handles.data_sc(1:handles.rows_sc ,4) ;

%     if(handles.ceres_flag)
%         ceres_angle_constant = 0.0054931640625;
%         handles.data_sc(1:handles.rows_sc,57) = ceres_angle_constant * handles.data_sc(1:handles.rows_sc,57); % ceres elevation angle sample 4
%         handles.data_sc(1:handles.rows_sc,58) = ceres_angle_constant * handles.data_sc(1:handles.rows_sc,58); % ceres elevation angle sample 3        handles.data_sc(1:handles.rows_sc,59) = ceres_angle_constant .* handles.data_sc(1:handles.rows_sc,59); % ceres elevation angle sample 2
%         handles.data_sc(1:handles.rows_sc,60) = ceres_angle_constant * handles.data_sc(1:handles.rows_sc,60); % ceres elevation angle sample 1
%         handles.data_sc(1:handles.rows_sc,61) = ceres_angle_constant * handles.data_sc(1:handles.rows_sc,61); % ceres elevation angle sample 0
% 
%         handles.data_sc(1:handles.rows_sc,63) = ceres_angle_constant * handles.data_sc(1:handles.rows_sc,63); % ceres AZ angle sample 1
%         handles.data_sc(1:handles.rows_sc,64) = ceres_angle_constant * handles.data_sc(1:handles.rows_sc,64); % ceres AZ angle sample 0
% 
%     end

    millisec_sc = handles.data_sc(: , 2);
    micsec_sc = handles.data_sc(: ,3);

    handles.time_sc = dates_sc + handles.epoch + (millisec_sc/1000 + micsec_sc/1000000)/86400; % setting time vector for sc data
    handles.slices = floor(handles.rows_sc/400); % always want about 400 scans per slice
%    set(handles.text4, 'string', ['Number of Slices: ' num2str(handles.slices)])
    handles.index = floor((handles.rows_sc)/handles.slices);
      
    
    % create empty fill data (NaN will plot as blank) to account for data
    % gaps
    
    handles.sc_dt = mean(handles.time_sc(2:end)-handles.time_sc(1:(end-1)));
    % assume a constant rate
    handles.data_sc = handles.data_sc(:, sortInds); % reorder based on the alphebetized colum headers
    set(handles.figure1, 'pointer', 'arrow') % hourglass pointer (nice aesthetic)

    guidata(hObject,handles);

end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
    handles.indicesA1 = get(handles.listbox2,'Value');
    guidata(hObject,handles);
end
    
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

    handles.indicesA1 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end



% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
    handles.indicesA2 = get(handles.listbox3,'Value');
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

    handles.indicesA2 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on selection change in listbox3.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
    handles.indicesA3 = get(handles.listbox4,'Value');
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

    handles.indicesA3 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

% --- Executes on selection change in listbox3.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
    handles.indicesA4 = get(handles.listbox5,'Value');
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

    handles.indicesA4 = 1;
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    guidata(hObject,handles);
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%init_slice = 1;
%set(handles.edit4, 'string', num2str(init_slice));
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
    pushbutton2_Callback(hObject, eventdata, handles)
    guidata(hObject,handles);
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
    %set (handles.edit5,'value',1);
end
% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles) % Earth Scan Only
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3

    pushbutton2_Callback(hObject, eventdata, handles)
    guidata(hObject,handles);
end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
end

function figure1_SizeChangedFcn(hObject, eventdata, handles)
% this does nothing, but Matlab is expecting it to exist, hence its
% existence here.
end


% --- Executes on button press in pushbutton9. - Process Binary
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = runDecom(hObject, eventdata, handles, @pushbutton11_Callback);
    guidata(hObject, handles)
end


% --- Executes on button press in pushbutton11. - get new DB
function handls = pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hanlds     for use in other functions that arent affected by guidata due
% to nested function calls
    [handles.DBDptr, handles.DBname] = getCalibMat(); % units, calibration, mnemonic, description
    if isempty(handles.DBDptr)    % user pressed cancel
        set(handles.radiobutton6, 'value', 0)
    end
    handls = handles;
    guidata(hObject,handles);
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
    if get(handles.radiobutton6, 'value') && isempty(handles.DBDptr) % empty array
        if isempty(handles.DBDptr)
            [handles.DBDptr, handles.DBname] = getCalibMat(); % units, calibration, mnemonic, description
            if isempty(handles.DBDptr)
                set(handles.radiobutton6, 'value', 0)
            end
        end
    end
    pushbutton2_Callback(hObject, eventdata, handles)
    guidata(hObject,handles);
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    cla(handles.axes8)
    cla(handles.axes7)
    cla(handles.axes3)
    cla(handles.axes5)
    cla(handles.axes6)
    guidata(hObject,handles);    
end


% --- Executes on button press in pushbutton15. - LD Power Supply File
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    str = get(handles.text33, 'string');
    set(handles.text33, 'String', 'loading ...')
    [name_pow, path_pow] = uigetfile(fullfile(handles.prevPath,'*.txt'));
    if ~path_pow
        set(handles.text33, 'String', str)
        return;
    else
        filename  = fullfile(path_pow, name_pow);
        handles.prevPath = [path_pow '/..'];
        set(handles.text33, 'String', name_pow)
    end

    % figure out where the useful info is (dont wanna read in the whole
    % file)

    id = fopen(filename);
    vars = strsplit(fgetl(id), ','); % read the colheaders line into a string vec
    fclose(id);
    vars = strip(string(char(vars))); % coerce into string array from cell array
    Acol = find('ATA1PW'==vars, 1); % find the column for the A state
    Bcol = find('ATB1PW'==vars, 1); % find the column for the B state
    if isempty(Acol) || isempty(Bcol)
        errordlg('Power Supply States not found in file')
        return
    end
    % need to know number of rows in file for csvread, so use this quick
    % perl file for it
    
    numrows = str2double(perl('helperFunctions/countLines.pl', filename)); 
    Adata = dlmread(filename,',', [1 Acol-1 numrows-1 Acol-1]); % the indexing here is 0 based
    Bdata = dlmread(filename, ',', [1 Acol-1 numrows-1 Acol-1]); % the indexing here is 0 based
    time = dlmread(filename, ',', [1 0 numrows-1 2]);
    
    handles.pow_file = 1;
    handles.data_pow = [Adata Bdata];
    
    handles.time_pow = time(:,1) + handles.epoch + ...
        (time(:,2)/1000+ time(:,3)/1000000)/86400;  % setting time vector (in days from 00-00-0000)    
    
    handles.pow_dt = mean(handles.time_pow(2:end)-handles.time_pow(1:(end-1)));    
    
    guidata(hObject, handles);

end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
    contents = get(handles.popupmenu8,'String');
    popCheck = contents(get(handles.popupmenu8,'Value')); % value is the index
    
    % switch to change to other GUI window
    switch strip(popCheck{1})
        case 'Data Evaluation'
            dashboard
            close(handles.figure1)
        case 'Science 3D EMI'
            return
        case 'Dwell FFT'
            dwell_fft_tool
            close(handles.figure1)
        case 'Frequency Calculator'
            frequency_gui
            close(handles.figure1)
    end
end

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
