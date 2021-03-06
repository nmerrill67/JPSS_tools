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

    handles.instr = 'ATMS' ; % so we knwo how to pllot the data
    
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
    [name, path] = uigetfile(fullfile(handles.prevPath,'*.txt'));
    if ~path
        set(handles.text2, 'String', str)
        return;
    else
        handles.prevPath = path;
       set(handles.text2,'String', ['File Chosen: ', name]);
    end
    
    % find out which instrument we have
    instr = {'ATMS', 'OMPS', 'CERES', 'VIIRS', 'CrIS'};
    handles.instr = instr{ismember(lower(instr), lower(strsplit(name, '_')))};  
       
    set(handles.figure1, 'pointer', 'watch') % hourglass pointer (nice aesthetic)
    

    
    handles.main_file = 1;
    data = readtable(fullfile(path, name), 'delimiter',','); % Whole Matrix
    
    varNames= string(data.Properties.VariableNames)'; % names in first row
    
    data = table2array(data); % convert to regular matrix
    
    if any(isnan(data(:,end))) % sometimes readtable adds an extra column
        data = data(:,1:end-1); % cut off the last column, which contains a ton of NaN
    end    
    
    if get(handles.radiobutton4,'value') || get(handles.radiobutton5,'value') % if Delete Dups or sort requested
        data = dataCorrection(data, ...
            get(handles.radiobutton4,'value'), get(handles.radiobutton5,'value'));
    end

    [handles.rows,handles.cols] = size(data);
    
    
    handles.dates = data(: , 1); % DAY field
    handles.millsec = data(: , 2); % Millisecond field
    handles.usec = data(: , 3); % Microsecond field

    handles.time = handles.dates + handles.epoch + ...
        (handles.millsec/1000+ handles.usec/1000000)/86400;  % setting time vector (in days from 00-00-0000)    


    switch handles.instr % check which instrument we are looking at. Load data in format for that instrument
        
        case 'OMPS'
            
            if isfield(handles, 'data_pow'), handles = rmfield(handles, 'data_pow'); end % delete useless matrix for OMPS 
            
            set(handles.axes7, 'visible', 'off')
            set(handles.axes8, 'visible', 'off')
            set(handles.axes5, 'visible', 'off')
            set(handles.axes6, 'visible', 'off')
            set(handles.text37, 'visible', 'on')
            set(handles.text38, 'visible', 'on')
            set(handles.text40, 'visible', 'on')
            set(handles.text41, 'visible', 'on')
            set(handles.text42, 'visible', 'on')
            set(handles.radiobutton3, 'visible', 'off')
            set(handles.text30, 'visible', 'off')
            set(handles.text31, 'visible', 'off')
            set(handles.pushbutton15, 'visible', 'off')
            set(handles.text33, 'visible', 'off')                   
            set(handles.togglebutton1, 'visible', 'off')
            set(handles.edit5, 'visible', 'off')
            set(handles.text43, 'visible', 'on')
            set(handles.text44, 'visible', 'on')
            set(handles.text45, 'visible', 'on')
            set(handles.text46, 'visible', 'on')
            set(handles.text47, 'visible', 'on')            
            set(handles.text48, 'visible', 'on')
            % these last six are actually popupmenus now
            set(handles.text49, 'visible', 'on')
            set(handles.text50, 'visible', 'on')
            set(handles.text51, 'visible', 'on')
            set(handles.text52, 'visible', 'on')
            set(handles.text53, 'visible', 'on')
            set(handles.text54, 'visible', 'on')
            set(handles.listbox2, 'visible', 'off')      
            set(handles.listbox3, 'visible', 'off')      
            set(handles.listbox4, 'visible', 'off')      
            set(handles.listbox5, 'visible', 'off')      
            set(handles.text18, 'visible', 'off')      
            set(handles.text19, 'visible', 'off')      
            set(handles.text28, 'visible', 'off')      
            set(handles.text29, 'visible', 'off')      
                      
            
            handles.slices = handles.rows; % one OMPS img per row
            handles.index = 1 ; % number of rows to jump when going to next slice AKA next row. Thi field is used more for ATMS science data, where you need to jump 300 rows
            pixVars = regexp(varNames, 'Pixel[_]?[0-9]*', 'match'); % find all pixel variables. the _<number> is added on by matlab since the pixel varname repeats
            pixVars = strip(string([pixVars{:}]')); % coerce to string array
            
            startPix = find(varNames == pixVars(1)); % index of pix start
            endPix = find(varNames == pixVars(end));
            
            handles.counts = data(:,startPix:endPix)'; % extract counts. Transpose to make it column major for speed
            handles.ompsTlm = data(:, 1:startPix-1); % get the rest of the tlm data
            
            % Find the non-optional parameters
            handles.TC_T_CCD_ind = find(varNames=='TC_T_CCD');
            handles.NP_T_CCD_ind = find(varNames=='NP_T_CCD');
            handles.M_T_MTR_DRV_BD_ind = find(varNames=='M_T_MTR_DRV_BD');
            handles.NP_P_HTR_SET_ind = find(varNames=='NP_P_HTR_SET');
            handles.TC_P_HTR_SET_ind = find(varNames=='TC_P_HTR_SET');
           
            % Optional Parameters 
            set(handles.text49, 'string', varNames(1:startPix-1))
            set(handles.text50, 'string', varNames(1:startPix-1))
            set(handles.text51, 'string', varNames(1:startPix-1))
            set(handles.text52, 'string', varNames(1:startPix-1))
            set(handles.text53, 'string', varNames(1:startPix-1))
            set(handles.text54, 'string', varNames(1:startPix-1))
            
            
            
        case 'ATMS'
            
            if isfield(handles, 'ompsTlm'), handles = rmfield(handles, 'ompsTlm'); end % delete this data if it exists. It is useless and taking up memory space
            
            set(handles.axes5, 'visible', 'on')
            set(handles.axes6, 'visible', 'on')
            set(handles.axes7, 'visible', 'on')
            set(handles.axes8, 'visible', 'on')
            set(handles.text30, 'visible', 'on')
            set(handles.text31, 'visible', 'on')
            set(handles.pushbutton15, 'visible', 'on')
            set(handles.text33, 'visible', 'on')
            set(handles.text37, 'visible', 'off')
            set(handles.text38, 'visible', 'off')
            set(handles.text40, 'visible', 'off')
            set(handles.text41, 'visible', 'off')
            set(handles.text42, 'visible', 'off')
            set(handles.radiobutton3, 'visible', 'on')
            set(handles.togglebutton1, 'visible', 'on')
            set(handles.edit5, 'visible', 'on')
            set(handles.text43, 'visible', 'off')
            set(handles.text44, 'visible', 'off')
            set(handles.text45, 'visible', 'off')
            set(handles.text46, 'visible', 'off')
            set(handles.text47, 'visible', 'off')            
            set(handles.text48, 'visible', 'off')
            set(handles.text49, 'visible', 'off')
            set(handles.text50, 'visible', 'off')
            set(handles.text51, 'visible', 'off')
            set(handles.text52, 'visible', 'off')
            set(handles.text53, 'visible', 'off')
            set(handles.text54, 'visible', 'off')      
            
            set(handles.listbox2, 'visible', 'on')      
            set(handles.listbox3, 'visible', 'on')      
            set(handles.listbox4, 'visible', 'on')      
            set(handles.listbox5, 'visible', 'on')      
            set(handles.text18, 'visible', 'on')      
            set(handles.text19, 'visible', 'on')      
            set(handles.text28, 'visible', 'on')      
            set(handles.text29, 'visible', 'on')      
            
            
            
            
            % Used to Slice up Data
            handles.slices = floor(handles.rows/300); % always want about 300 scans per slice

            % number of rows to jump when going to next slice
            handles.index = 300;    

            % check for gaps - if there are, generate fill records. THis is
            % usefull for comparing aux data to the science, as when there
            % are data gaps, the timelines do not match up correctly. 

            two_scans = (2.667 + 0.1) * 2 / 86400; % set up 2 scans as limit of acceptability delta time (in days). Add tolerance of 0.1 sec

            gap_delta = diff(handles.time); % dt vector throughout. an index indicating a gap in this vector is the start index for the gap in the time vector    


            % check for the gaps in the data

            if any(gap_delta > two_scans)

                h = warndlg('There are time gaps in this data. Fill data is being generated to preserve the timeline. It will show up as monochromatic. Note that this is  not from sensor noise');
                uiwait(h)



                gapInds = find(gap_delta > two_scans); % find the startInds of the gaps
                one_scan = 2.667/86400;  % time of one scan in days  
                gapTimes = handles.time(gapInds); % times in the time vector containing the start of a gap
                %datestr(gapTimes,'HH:MM:SS')
                num_missed_scans = floor( (handles.time(gapInds+1) - gapTimes)/one_scan - 1); % vector of number of missed scans (scalar if only one gap in data)

                num_scans_in_a_day = 32396;

                if any(num_missed_scans > num_scans_in_a_day) 

                    h = errordlg('There is a time gap of over a day in this data. Fill data will not be generated. Please consider decomming a subset of this data for better viewing quality');
                    uiwait(h)

                else


                    filler = mean(mean(data(:, floor(3*size(data,2)/4):floor(7*end/8)))); % choose a fill data value from scan data (scalar value)

                    % Preallocate tmp arrays so matlab doesnt have to
                    % allocate a new array every loop iteration
                    addedLength = sum(num_missed_scans);
                    handles.rows = handles.rows + addedLength;
                    tmpData = zeros(handles.rows, handles.cols);
                    tmpTime = zeros(handles.rows, 1);

                    prevIndOrig = 1; % index of previous start of the extraction from original array. Starts at 1 so that the data can be copied from the beginning, then moves on to the index of the last gap + 1
                    prevIndTmp = 1; % index of the start of insert for the current insertion of fill data and fake data mixed.

                    for i = 1:length(num_missed_scans) 

                        gapIndsI = gapInds(i); % faster to store this value since it is accessed so many times
                        nmsI = num_missed_scans(i);

                        fill_times = gapTimes(i) + one_scan * (1:nmsI)'; % create fake time for filling in
                         % datestr(fill_times, 'HH:MM:SS')

                        % make sure this code is correct, and that we are
                        % not overwriting any data with this assert
                        assert( all( tmpTime(prevIndTmp:(prevIndTmp + gapIndsI - prevIndOrig)) == 0 ) )


                        tmpTime(prevIndTmp:(prevIndTmp + gapIndsI - prevIndOrig)) = handles.time(prevIndOrig:gapIndsI); % copy over the non-gapped data
                        tmpTime((prevIndTmp - prevIndOrig + gapIndsI + 1):(prevIndTmp - prevIndOrig + gapIndsI + nmsI )) = fill_times; % copy over generated data

                        tmpData(prevIndTmp:(prevIndTmp + gapIndsI - prevIndOrig), :) = data(prevIndOrig:gapIndsI, :);
                        tmpData((prevIndTmp - prevIndOrig + gapIndsI + 1):(prevIndTmp - prevIndOrig + gapIndsI + nmsI ), :) = filler * ones(nmsI, handles.cols);  % create fake data. It wll be monochromatic, but will leave the colormap relatively the same as with no fill data

                        prevIndOrig = gapIndsI + 1;

                        if i == 1 
                            prevIndTmp = prevIndTmp + gapIndsI + nmsI;
                        else
                            prevIndTmp = prevIndTmp + gapIndsI - gapInds(i-1) + nmsI; % there will be gaps of zeros in the arrays if we dont do this (check it on paper)
                        end

                    end

                    % copy over the last few rows of data after the last
                    % gap
                    tmpTime(prevIndTmp:end) = handles.time(prevIndOrig:end);
                    tmpData(prevIndTmp:end, :) = data(prevIndOrig:end, :);


                    data = tmpData; % copy back over, then the tmps will go out of scope and be deleted
                    handles.time = tmpTime;
                    assert(all(handles.time > 0))
                end
            end

            if handles.cols == 300
                % Diag data
                handles.counts = data(:, 153:300); %
                handles.angle = data(:,5:152);
            else
                % Normal data
               handles.counts = data(:, 108:211); % 211 to include calibration positions or 204 for earth scan only
               handles.angle = data(:,4:107);
            end
            

            
        otherwise 
            
            h=errordlg('Unrecognized instrument science file!');
            uiwait(h)
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
        if isfield(handles, 'counts'), counts = handles.counts; end
    else % called from saveAsPPTX
        hObject = varargin{1};
        eventdata = varargin{2};
        handles = varargin{3};        
        if isfield(handles, 'counts')
            counts = varargin{4};
        else 
            h = errordlg('Please load and plot science data once before exporting to PPTX');
            uiwait(h)
        end

    end

    if ~(handles.main_file || handles.sc_file)
        h = errordlg('Load data first');
        uiwait(h)
        return; 
    end
   

%    str=get(handles.popupmenu1,'String'); % Plot Calibrated or not calibrated science data
 %   val=get(handles.popupmenu1,'Value');
    
    currslice = str2double(get(handles.edit4, 'string'));
   
    if currslice > handles.slices
        currslice = handles.slices;
        set(handles.edit4, 'string', num2str(currslice))
    end
        
    %First row index in slice
    if currslice == 1
        startInd = 1;
    else
        startInd = handles.index*(currslice - 1);
    end
    
    if handles.main_file
        if startInd > length(handles.time)
            startInd = length(handles.time) - 300; % handle overshooting the end of the array
        end
    else
        if startInd > length(handles.time_sc)
            startInd = length(handles.time_sc) - 300;
        end
    end
    
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

    
    
    startIndAux = startInd ;% align timestamps
    endIndAux =  endInd;
    % align plot times in left and right (since they are diff rates we need a diff index range to match timestamps)    
    if handles.main_file && handles.sc_file

        [~, startIndAux] = min(abs(handles.time_sc - handles.time(startInd))) ;

        [~, endIndAux] = min(abs(handles.time_sc - handles.time(endInd)));
        
    end  

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
                
      
        
        switch handles.instr
            
            case 'ATMS'
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
                % counts(startInd:endInd, 1:end_position) 
                surf(handles.axes3, 1:end_position, handles.time(startInd:endInd), ...
                    counts(startInd:endInd, 1:end_position) ...
                    ,'EdgeColor','None', 'FaceColor', 'interp'); %  modify the col to zoom in scan (ie. 1:20)
               

                
                view(2);
                xlabel('Scan Position');

                zlabel('Counts');

                colormap jet;
                colorbar('eastoutside');
                axis tight;

                set(handles.axes3, 'YTickLabel', [])   
                set(handles.axes3, 'XTickLabelRotation', 45)               
                title(['Science Scans ',num2str(startInd), ' - ', num2str(endInd)]);

                set(handles.axes3, 'YTickLabelMode', 'auto') 
                set(handles.axes3, 'XTickLabelRotation', 45)
                set(handles.axes3, 'YTickLabelRotation', 45) 
                set(handles.axes3, 'YTickMode', 'auto')        
                datetick('y', 'HH:MM:SS', 'keeplimits', 'keepticks')

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
                
                
            case 'OMPS'
                
                
                % We need the database to calibrate the non-optional parameters. If it does not exist yet, get it from the new databse fnc button           
                if isempty(handles.DBDptr), handles = pushbutton11_Callback(hObject, eventdata, handles); end

                
                nonOptData = [handles.ompsTlm(startInd, handles.TC_T_CCD_ind) ... 
                    handles.ompsTlm(startInd, handles.NP_T_CCD_ind) ... 
                    handles.ompsTlm(startInd, handles.M_T_MTR_DRV_BD_ind ) ...
                    handles.ompsTlm(startInd, handles.NP_P_HTR_SET_ind) ...
                    handles.ompsTlm(startInd,  handles.TC_P_HTR_SET_ind) ];  % put the nonoptional dta in one row matrix for calibration
                
                
                nonOptLabs = {'OMTCCCDT'; 'OMNPCCDT';  'OMMDBT'; ...
                    'OMNPWNDSP'; 'OMTCWNDSP'}; % These points have different names in the LFight tlm database
                
                [nonOptData, nonOptLabsUnits] = calibrateData(nonOptData, handles.DBDptr, nonOptLabs); 
                
                unitsOnly = regexp(nonOptLabsUnits, nonOptLabs, 'split'); % extract just the units
                
                % populate non-optional parameters
                set (handles.text37, 'string' , ['NP CCD Temp: ', num2str(nonOptData(1)), unitsOnly{1}{end}])
                set (handles.text38, 'string' , ['TC CCD Temp: ', num2str(nonOptData(2)), unitsOnly{2}{end}])
                set (handles.text40, 'string' , ['Mtr Driver Board Temp: ', num2str(nonOptData(3)), unitsOnly{3}{end}])
                set (handles.text41, 'string' , ['NP Heater Power: ', num2str(nonOptData(4)), unitsOnly{4}{end}])
                set (handles.text42, 'string' , ['TC Heater Power: ', num2str(nonOptData(5)), unitsOnly{5}{end}])

                
                axes(handles.axes3);
                
                
                ompsCol = 38; % cols in OMPS image
                
                img = vec2mat(counts(:, startInd),ompsCol); % resize OMPS image vector
                
                
                
                surf(img,'EdgeColor','None', 'FaceColor', 'interp'); %  modify the col to zoom in scan (ie. 1:20)

                view(2);
                xlabel('Spatial Dimmension');
                ylabel('Wavelength');
                zlabel('Counts');

                colormap jet;
                colorbar('eastoutside');
                axis tight;

                set(handles.axes3, 'YTickLabel', [])   
                title(['OMPS Image: ' datestr(handles.time(endInd), 'dd-mmm-yyyy HH:MM:SS')]);

                set(handles.axes3, 'XTickLabel', [])
                
                
                
                % Optional parameter text boxes. Set these based on
                % popupmenu selection. The popup menus were originally
                % text, so they are called text49-54
                
                ind1 = get(handles.text49, 'value');
                ind2 = get(handles.text50, 'value');
                ind3 = get(handles.text51, 'value');
                ind4 = get(handles.text52, 'value');
                ind5 = get(handles.text53, 'value');
                ind6 = get(handles.text54, 'value');
                
                namesArr = get(handles.text49, 'string'); % we can just take the first, since they are all the same for all the popupmenus
                
                set(handles.text43, 'string', strcat(namesArr(ind1), {': '}, {num2str(handles.ompsTlm(startInd, ind1))} ))
                set(handles.text44, 'string', strcat(namesArr(ind2), {': '}, {num2str(handles.ompsTlm(startInd, ind2))} ))
                set(handles.text45, 'string', strcat(namesArr(ind3), {': '}, {num2str(handles.ompsTlm(startInd, ind3))} ))
                set(handles.text46, 'string', strcat(namesArr(ind4), {': '}, {num2str(handles.ompsTlm(startInd, ind4))} ))
                set(handles.text47, 'string', strcat(namesArr(ind5), {': '}, {num2str(handles.ompsTlm(startInd, ind5))} ))
                set(handles.text48, 'string', strcat(namesArr(ind6), {': '}, {num2str(handles.ompsTlm(startInd, ind6))} ))
                
        end
       
    end    
    
    ylabel(handles.axes8, 'Time (HH:MM:SS)')
   

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
    
    slices = handles.slices;
    
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
    
    slices = handles.slices;
    
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
       
       if handles.main_file && ~strcmp(path_sc, handles.prevPath)
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
    
    
    if ~handles.main_file
        handles.slices = floor(handles.rows_sc/300); % always want about 300 scans per slice
    end
        %    set(handles.text4, 'string', ['Number of Slices: ' num2str(handles.slices)])
    if ~handles.main_file, handles.index = 300; end
      
    
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
