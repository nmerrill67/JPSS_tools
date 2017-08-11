function varargout = Online_OMPS_Window(varargin)
% ONLINE_OMPS_WINDOW MATLAB code for Online_OMPS_Window.fig
%      ONLINE_OMPS_WINDOW, by itself, creates a new ONLINE_OMPS_WINDOW or raises the existing
%      singleton*.
%
%      H = ONLINE_OMPS_WINDOW returns the handle to a new ONLINE_OMPS_WINDOW or the handle to
%      the existing singleton*.
%
%      ONLINE_OMPS_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONLINE_OMPS_WINDOW.M with the given input arguments.
%
%      ONLINE_OMPS_WINDOW('Property','Value',...) creates a new ONLINE_OMPS_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Online_OMPS_Window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Online_OMPS_Window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Online_OMPS_Window

% Last Modified by GUIDE v2.5 11-Aug-2017 09:35:08

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Online_OMPS_Window_OpeningFcn, ...
                       'gui_OutputFcn',  @Online_OMPS_Window_OutputFcn, ...
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

% --- Executes just before Online_OMPS_Window is made visible.
function Online_OMPS_Window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Online_OMPS_Window (see VARARGIN)

% Choose default command line output for Online_OMPS_Window
    handles.output = hObject;

    % Update handles structure

    % This sets up the initial plot - only do when we are invisible
    % so window can get raised using Online_OMPS_Window.
    if strcmp(get(hObject,'Visible'),'off')
        plot(rand(5));
    end
    
    handles.epoch = datenum('01-01-1958', 'mm-dd-yyyy');
  
    handles.startFileInd = 1; % for use in playback
    
    cla(handles.axes1)
    % UIWAIT makes Online_OMPS_Window wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Online_OMPS_Window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% this function allows the user to select a root directory for a huge
% directory tree ( or not), and will find the paths and names to all h5 files in all
% subdirectories including the selected directory. 

    dname = uigetdir('../Decom_tools/data', 'Select h5 directory');
 
    d = dir([dname '/**/*.h5']); % get dir info for all subdirs too. specify wildcard to avoid '..' and '.'

    handles.files = sort(fullfile({d.folder},{d.name})) ;% all filenames with full path. Sorted in time ascending order
    guidata(hObject, handles)





% --- Executes on selection change in popupmenu2. - Choose Spacecraft
% Telemetry
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
    handles = updatePannel(handles);
    guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



%Mike Walker

%Get an array of granule data from the h5 file -----
function gran = getGranule( rdrType, granuleID, file)
    str = ['/All_Data/' rdrType '/RawApplicationPackets_' num2str(granuleID)];
    gran = h5read(file, str);
  
    
function num = numAPIDs(granule)
% used to get the number of APIDs from the static  header in a granule
    num = swapbytes(typecast(granule(37:40), 'uint32')); % get the number of APIDs in the granule from the static header

    
function [apLst, pktTrk, apStr] = getOffsets(granule)
% Used to get the offsets to find the APID list from the static header, the
% packet tracker list from the APID list, and finally the start of that
% particular APID in the APID storage field from one granule (hdf5 group)
% in an h5 file
        apLst = swapbytes(typecast(granule(41:44), 'uint32')); % get the index of the start of the APID list from the static header
        pktTrk = swapbytes(typecast(granule(45:48), 'uint32')); % get the index of the start of the pktTracker from the static header
        apStr = swapbytes(typecast(granule(49:52), 'uint32')); % get the index of the start of the pktTracker from the static header

    
function [bytes, bits, type] = getByteBitsAndType(numType)
    types = struct('d', 'uint', 'u', 'uint', 's', 'int'); % struct for converting DB types to matlab syntax
    handles.numType = char(numType); % can only index char type
    
    parBitSize = str2double(numType(2:end)); % get the size of the parameter in bits
    bytes = floor(parBitSize/8);
    bits = mod(parBitSize, 8); % get the leftover bits if any
    
    type = [types.(lower(numType(1))) numType(2:end)]; % get  the MATLAB syntax fromt the struct. i.e uint8, int16, ...
    % if there is less than 1 byte, then the type variable is unused 
    
    
function param = getSingleParam(granule, paramInd, parByteSize, parBits, numType)
    % get the parameter from one packet in numeric form. parBits is the bit
    % size minus the bits in each byte i.e. for a D11 parBits will be 3

    if parBits == 0 % if the param is in multiples of 8 bits
        
        param = swapbytes(typecast(granule((paramInd):(paramInd + parByteSize - 1)) , numType));
        
    else% we are dealing with bits
        
        overShotByte = parByteSize + 1; % in the case of D11 or something else with at least one byte, but bits as well 
        paramIndByte = floor(paramInd/8); % get the byte before the param starts. Also may be the starting ind, we dont know yet
        paramIndBit = round(8*mod(paramInd, 1)) + 1; % get the bits where  it start. May be 0. add 1 to make it 1-indexed for matlab. This is necessary since paramInd will be a decimal if it is not on a byte
        
        if overShotByte == 1, tmpSize = '8';
        elseif overShotByte == 2, tmpSize = '16';
        elseif overShotByte > 2 && overShotByte < 4, tmpSize = '32';
        else, tmpSize = '64';
        end
        
        tmpType = ['uint' tmpSize]; 
        % read in slightly too much data. Convert to bits in place
        bits = d2b(swapbytes(typecast(granule((paramIndByte):(paramIndByte + parByteSize - 1)) , tmpType)));
        %exract our bits, converting back to base ten
        param = bits(paramIndBit:(paramIndBit + parByteSize*8 + parBits - 1)); 
        
        
    end
    
%Get an array of a parameter from an rdr file -----
function playBack(handles)
    % make sure we have the necessary fields to begin
    if ~(isfield(handles, 'numType') && isfield(handles, 'files'))
        errordlg('Please load data and databse first'); return; 
    end
    
    if isfield(handles, 'playback_rate'), handles.playback_rate = 1; end
    
    [parByteSize, parBits, numType] = getByteBitsAndType(handles.numType); % get the byte size, bit size, and numeric type
    
    if ismember('TELEMETRY', handles.rdrType) % determine the data type, and extract only the relevant file names
      type = 'ROLPT';
    else
      type = 'RNSCA';
    end
    
    files =  regexp(handles.files, ['.*' type '.*'], 'match'); % match only the needed files

    files = [files{:}]; % coerce into singleton cell array
    
    timeVec = nan(50,1); % these vectors will be used for plotting. We will cut the beginning off as needed whenn we have sufficient points
    paramVec = nan(50,1); % preallocate them for speed. We only use up to the amount of points we have to plot, so the zeros wil not be present

    vecInd = 1; % Use this to index the vectors.  Set  the threshold of points on the screen to 50
    
    i = 1; % This is so we can switch telem points mid playback. This initiates to 1
    
    % size of primary header plus one to account for the pkt length field
    % having one subtracted from it. Declare it here, as it is loop
    % invarient.
    primHdrPlus1 = uint32(7); 

    while i <= length(files)
        file = files{i}; % strip the cell array wrapper
        
        % use h5info to get the number of granules in the hdf5 file. 
        info = h5info(file);
        allData = info.Groups(strcmp({info.Groups.Name}, '/All_Data')); % find the All_data hdf5 group
        maxGran = length(allData.Groups) - 1; % This give the maxx num of granules in the hdf5 group. Subract 1 since they are 0-indexed

        
        for granNum=0:maxGran
            
            granule = getGranule(handles.rdrType, granNum, file);

            % get the tracker index, which is the index of the data fiel that contains the index of the start of the APID's first packet 
            % 21 is the offest between the APID list start and the tracker index
            % field in the APID list. Add 1 to account for matlab bein 1 indexed,
            % and the packet is assuming 0 indexed

            [apLstOffst,pktTrackerOffset,apStrgOffst] = getOffsets(granule);

            %disp(['In list: ' num2str(swapbytes(typecast(granule(apLstOffst+17:apLstOffst+20), 'uint32')))])

            %this APID. This index is one based by adding 1 to it.

            numAP = numAPIDs(granule); % total number of APIDs in granule

            apidFound = 0;
            ind = 0; % index in APID list (zero based)
            apidListElLen = 32; % length in bytes of element in PAID list

            % Use tis loop to find the APID in the APID list, to then find the
            % packets in the AP storage field
            while ~apidFound

                if ind==numAP
                    errordlg(['APID ' num2str(handles.APID) ' not present in packet. Please choose a different dataset, or a different telemetry point']); 
                    return
                end

                currInd = ind*apidListElLen;
                currAPID = swapbytes(typecast(granule((apLstOffst+17 + currInd):(apLstOffst+20 + currInd)), 'uint32'));
                if currAPID ==  handles.APID
                    apidFound = 1;
                else
                    ind = ind + 1;
                end
            end

            % retrieve the number of pkts recieved of the specific APID in this
            % granule
            numPkts = swapbytes(typecast(granule((apLstOffst+29+currInd):(apLstOffst+32+currInd)), 'uint32'));

            % this value tells us where the data is in the AP storage field
            trackerInd = swapbytes(typecast(granule((apLstOffst+21+currInd):(apLstOffst+24+currInd)), 'uint32')); %The first index in the pktTracker array that will contain an AP of
            % get the index of the start of the packet from the tracker index field
            % pertaining to that specific index
            firstPacketStartInd = swapbytes(typecast(granule((pktTrackerOffset+trackerInd+17):(pktTrackerOffset+trackerInd+20)), 'uint32')) + uint32(1);
            offset = uint32(0); % offset between firt packet and curr packet
            for j = 1:numPkts
                
                if ~get(handles.togglebutton2, 'value'), return;end
                
                packetStartInd = offset + firstPacketStartInd;
                % the 5th and 6th bytes is the packet size in bytes minus  1 (excluding the primary header). Add this to the offset for the next packet
                currInd = apStrgOffst + packetStartInd;
                nextPktSize = swapbytes(typecast(granule((currInd + 4):(currInd+5)), 'uint16')) ;
                offset = offset + uint32(nextPktSize) + primHdrPlus1 ;  % Add five to account for the primary header minus 1

                first2bytes = swapbytes(typecast(granule(currInd:currInd+1), 'uint16'));% fist bytes contains the flag for if there is a secondary hdr, and APID
                bits = d2b(first2bytes);
                APID_found = b2d(bits(end-10:end)); % APID found in packet

                if APID_found ~= handles.APID
                    error('Error parsing packets: APID is inconsitent in headers. Is this the correct database?')
                end
                    
                if vecInd == 50
                   paramVec(1:end-1) = paramVec(2:end); % lop off the beginning to keep the newest points
                   timeVec(1:end-1) = timeVec(2:end); 
                end
        
        
                OMNDPAMDI = double(getSingleParam(granule, 628, 2, 0, 'int16'));
                OMNDPBMDI = double(getSingleParam(granule, 630, 2, 0, 'int16'));
                OMLMPAMDI = double(getSingleParam(granule, 632, 2, 0, 'int16'));
                OMLMPBMDI = double(getSingleParam(granule, 634, 2, 0, 'int16'));
                
                OMNDP28I = double(getSingleParam(granule, 636, 2, 0, 'int16'));  
                OMTECI =double( getSingleParam(granule, 626, 2, 0, 'int16'));
                OMTCTECI = double(getSingleParam(granule, 638, 2, 0, 'int16'));
                OMNPTECI = double(getSingleParam(granule, 638, 2, 0, 'int16'));
    
                convAB = 0.00008558;
                convTecTot = 0.00123;
                convTecNpTc = 0.000305;
                conv28 = 0.000227;
                set(handles.text6, 'String', ['Nadir A Curr: ' num2str( convAB * OMNDPAMDI ) ' Amps'] )
                set(handles.text7, 'String', ['Nadir B Curr: ' num2str( convAB * OMNDPBMDI ) ' Amps'] )
                set(handles.text8, 'String', ['Limb A Curr: ' num2str( convAB * OMLMPAMDI ) ' Amps'] )
                set(handles.text9, 'String', ['Limb B Curr: ' num2str( convAB * OMLMPBMDI ) ' Amps'] )
                set(handles.text10, 'String', ['Nadir Inpt Curr: ' num2str( conv28 * OMNDP28I ) ' Amps'] )
                set(handles.text11, 'String', ['TEC Tot Curr: ' num2str( convTecTot * OMTECI ) ' Amps'] )
                set(handles.text12, 'String', ['TC TEC Curr: ' num2str( convTecNpTc * OMTCTECI ) ' Amps'] )
                set(handles.text13, 'String', ['NP TEC Curr: ' num2str( convTecNpTc * OMNPTECI ) ' Amps'] )

               
                
                timeVec(vecInd) = double(swapbytes(typecast(granule((currInd + 6):(currInd+7)), 'uint16'))) ... % days
                    + double(swapbytes(typecast(granule((currInd + 8):(currInd+11)), 'uint32')))/86400000 ...% millis
                    + double(swapbytes(typecast(granule((currInd + 12):(currInd+13)), 'uint16')))/86400000000 ...% micros
                    + handles.epoch ; % NASA epoch
                set(handles.text5, 'string',['Time: ' datestr(timeVec(vecInd), 'HH:MM:SS mm-dd-yyyy')]) % place time in text box12
                
                paramInd = currInd + handles.indInPkt;
                
                paramVec(vecInd) = getSingleParam(granule, paramInd, parByteSize, parBits, numType);
                
                if vecInd < 50  % keep the vector to 50 long at most, otherwise it would  grow unbounded
                    vecInd = vecInd + 1;
                else
                    vecInd = 50;
                end
                
                % Check if the user wants calibrated data. If so we need to
                % calibrate the whole vector, and not just one point.
                % Otherwise there would be a strange jump in the viewing
                % window. This way we calibrate the current point an past
                % visible points as well. We cannot se paramVec to the
                % output of calibrateData, otherwise it would stay
                % calibrated for a portion even if the user chose
                % uncalibrated again.
                
                if get(handles.radiobutton2, 'value') % calibrated
                    
                    % plot only up to the amount of data we have, since the
                    % arrays are preallocated. This will soon inlclude the
                    % entire array. after vecInd = 50. Add th e{} around
                    % handles.mnemonic, because calibrateDaa expects a cell
                    % input for the instruent/telemetry names
                    [calibData, ylab] = calibrateData(paramVec, handles.DBDptr, {handles.mnemonic});
                    plot(handles.axes1, timeVec,calibData, 'LineWidth', 2) ;
                    
                                      
                else % raw counts
                    
                    % plot only up to the amount of data we have, since the
                    % arrays are preallocated. This will soon inlclude the
                    % entire array. after vecInd = 50
                    plot(handles.axes1, timeVec, paramVec, 'LineWidth', 2);
                                        
                    ylab = handles.mnemonic;
                    
                end
                

                
                title(handles.plot_title)
                ylabel(ylab)
                
                % set the axis limits so that the newest point is not
                % touching the right wall of the axis window
                %  minPV = min(paramVec); maxPV = max(paramVec); 
                % axis(handles.axes1, [min(timeVec) (86400*max(timeVec)/86000) (minPV-abs(minPV)/4) (maxPV+maxPV/4)])
                
                set(handles.axes1, 'XTickLabelRotation', 45) % rotate the x axis
                
                % This is the main bottleneck
                datetick(handles.axes1, 'x', 'HH:MM:SS', 'keeplimits', 'keepticks') % make the x axis show date strings 
                
                guidata(handles.axes1, handles); % allows guifunction to update the graphics

                % TODO change this to real time. Maybbe increase max for
                % playback rate options
                pause(0.1/handles.playback_rate);
                
                

            end % end for


        end % end  for
        
        i = i + 1;
        
    end % end outer while
    

  
  
function handles = updatePannel(handles)
    dbInd = get(handles.popupmenu2, 'value'); % index to be used in the database

    handles.rdrType = 'OMPS-TELEMETRY-RDR_All';
    handles.numType =  handles.DBDptr.type{dbInd}; % U16, S16, ...
    
    byte_bit = strsplit(handles.DBDptr.byte_bit{dbInd}, {'/', ':', '-'}); % will end up as {"", "BBBB",'b1', 'b1'} 
    if length(byte_bit) > 2 % bits involved
        handles.indInPkt = str2double(byte_bit{2}) + str2double(byte_bit{3})/8; % obtain the index in bytes. This can be a decimal, and the code can handle that to pick out the bits
    else
        handles.indInPkt = str2double(byte_bit{2}) ; % obtain the index in bytes.
    end

    handles.APID = uint32(str2double(handles.DBDptr.APID{dbInd}(5:end))); % extract the APID number form the string 'APID<APID num>', then convert to uint32 for comparison in the packets headers
    handles.plot_title = handles.DBDptr.description{dbInd}; % The description makes a nice plot title                                           
                    
    % mnemonic is used in the calibrateData function
    handles.mnemonic = handles.DBDptr.mnemonic{dbInd}; 

        
        

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
    str =  get(handles.popupmenu4,'string');
    handles.playback_rate = str2double(str(get(handles.popupmenu4, 'value'))); 
    handles = updatePannel(handles);
    guidata(hObject, handles)
    
% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
    handles.isPlaying = get(handles.togglebutton2, 'value');
    playBack(handles)
    guidata(hObject, handles)


% --- Executes on button press in pushbutton5. - Load Database
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    DBDptr = getCalibMat(); % see private/getCalibMat.m. This function allows the user to load the databse from XML or XLS format
    
    % now we only want to keep the parts of the DB that correspond to OMPS.
    % regexp is a nice way to do this based on APID number. The OMPS apid
    % range is 544-649
    % regexp returns 1 for expression matches, and cell fun with ~isempty
    % creates a logical array from that.
    % We then use logical indexing to only pull out the elemtents in the
    % full DB corresponding to te regexp matches
    
    % Please see http://www.regular-expressions.info/numericranges.html for
    % how this regexp works
    handles.DBDptr = DBDptr(~cellfun(@isempty, regexp(DBDptr.APID, 'APID06[0-4][0-9]|APID05[4-9][0-9]', 'match')), :); 
    set(handles.popupmenu2, 'string', handles.DBDptr.description)
    guidata(hObject, handles)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    saveScreen
