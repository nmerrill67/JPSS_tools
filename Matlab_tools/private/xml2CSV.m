function [fnames_out, ins_names_out] = xml2CSV(insStr)
% select XML folder, process all the XML into lookup tables for decom and
% later Calibration use.
% insStr - comma separated string of instrument databases needed

    fnames_out = '';

    insArr = lower(strip(string(strsplit(insStr, ',')))); % coerce comma separated list into string array 
    
    
    lenIA = length(insArr); % use this to see if the user picked the right number of instrument databases with the correct instruments
    
    insArrDone = cell(lenIA, 1); % Place finished instrument names here

    isSC = 0; % used to determine how to decode xml. SC xml is different than Science
    if strcmp(insStr, 'spacecraft'), isSC = 1; end 
    
    isCorrectDirCount = 0;

    fnames_out = ""; % preset incase the user cancels, an the function is returned early
    ins_names_out = "";
    
    while ~isCorrectDirCount
        % use this open-sourced multi=select uigetdir to select multiple XML folders for multiple instruments
        if ~isSC ,dnames_tot = uipickfiles('FilterSpec', 'DBD_XML', 'Prompt', ['Choose the directories for at least ' insStr ' science XML databases']);
        else, dnames_tot = string(uigetdir('DBD_XML', 'Choose the directory containing the Spacecraft database')); % convert the output to string so that the length comparison is not based on number of chars in string
        end
        
        lenDnT = length(dnames_tot);

        if lenIA > lenDnT % too few dirs 
            h = errordlg('Incorrect number of instrument science XML database folders');
            uiwait(h)
        else % correct number
            isCorrectDirCount = 1;
        end

        if ~( iscell(dnames_tot) || (isstring(dnames_tot) && ~strcmp(dnames_tot, "0")) ), disp ended; return; end % user cancelled
    
    end
        
    fnames_out = cell(lenDnT, 1); % this array will contain the names of dirctories returned, which also happens to be the name of the csv written
    ins_names_out = fnames_out; % this will contain the corresponding instrument names
    
    insNames = {'omps'; 'atms'; 'ceres'; 'cris'; 'viirs'}; % for use in determining that we've extracted the xml from all the necessary instrument databases
    scNames = {'npp'; 'j1'; 'j2' ; 'j3'; 'j4'}; % incase this is a spacecraft database, use this to name the database for the decom engine. 
    scNamesActual = {'npp'; 'jpss1'; 'jpss2' ; 'jpss3'; 'jpss4'}; %  for use in figuring out which of te above names to use, since the filenaming scheme uses these mnemonics for the spacecrafs
 
    
    for j = 1:lenDnT % iterate through all chosen XML dirs, where each one is specific to an instrument or the spacecraft bus. 
        dname = dnames_tot{j};
                
        if ~isSC, d = dir([dname '/**/*.xml']); % get dir info for all subdirs too. specify wildcard to avoid '..' and '.'
        else
            try d = dir([dname '/TlmUnit/*.xml']); % Only use the Tlm Unit dir for SC, since the others contain information not pertitnent to these tools
            catch
                h = errordlg('Incorrect Tlm Database. Please use a Tlm database in its original file tree structure.');
                uiwait(h)
                return
            end
        end    
        
        if size(unique(char(d.folder), 'rows'), 1) > 1 % they chose a root directory of a huge file tree.
            h = errordlg('Please choose directory containing only one instrument or purely spacecraft XML files');
            uiwait(h)
            continue
        end
        
        dnames = lower([d.folder]); % str of sub directory name. THis is called dnames, as for SCi databases, there are sometimes many subdirs

        
        if ~isSC, instr = insNames(ismember(insNames, strsplit(dnames, {'_', '-'}))); % figure out which instrument we are dealing with if this is a Sci database
        else, instr = scNames(ismember(scNamesActual, strsplit(dnames, {'/','\','tlm'}))); % figure out whic SC we are looking at if this is a SC database
        end
        
        if isempty(instr) || length(instr)~=1
            h = errordlg('Please choose a correct directory. It must contain XML files from only one instrument');
            uiwait(h)
            continue
        end

        if ~isSC, [isMember, mInd] = ismember(instr, insArr);
        % We don't know the SC before, so the insStr arg is always 'spacecraft', and the user will only be prompted to choose one XMl folder for SC data.
    %Therefore we don;t have to check tat the user got all of the required XMLs, and can set isMember to 1 always, signalling that the user chose the corret folder for the correct SC.       
        else, isMember = 1; mInd = 1;
        end
        
        if isMember
            insArrDone{j} = insArr(mInd);
        else
            insArrDone{j} = '';
        end % use this to make sure user picked at least the correct instruments, could pick others as well 
        
        fnames = fullfile({d.folder},{d.name}); % all filenames with full path

        T = []; % cant preallocate. We dont know the size
        h = waitbar(0, ['Reading ' instr ' XML files']);
        len = length(fnames);
        
        if isSC % decide if we need to decode science daabase xml or spacecraft database xml. St the correct function to use accordingly, because the formats are very different
            xml2ArrFun = @xml2ArrSC;
        else
            xml2ArrFun = @xml2ArrSci;
        end
        
        
        for i = 1:len 
            
            tmp = xml2ArrFun(fnames{i}, dname);  % use the function handle specifed above to decode the xml into a lookup table csv formt 
            
            try waitbar(i/len, h); 
            catch; end
            
            if isempty(tmp), continue; end % useless file for decom -- there was only heade info, which is not needed
            T = [T; tmp];
            
        end
        
        try delete(h)
        catch; end
        
        V = {'mnemonic', 'type', 'packet', 'byte_bit', 'units', 'conversion', 'description'}; 
        
        spl = strsplit(dname ,{'/','\'}); % split the dirname from the path for writing purposes
        
        fnames_out{j} = spl{end}; % add the output filename and its correspoinding instrument name to the output cell array
        ins_names_out{j} = instr;
        
        writetable(array2table(T(:,1:4),'VariableNames', V(1:4)), ['../Decom_tools/database_CSVs/' spl{end} '.csv'], 'Delimiter', ','); 
        writetable(array2table(T,'VariableNames', V), ['DBD_CSVs' spl{end} '.csv'], 'Delimiter', ';'); 

  
    end
    
    insArrDone = lower(strip(string(insArrDone))); % coerce into string array
    insArrDone = insArrDone( ~strcmp(insArrDone, "")); % remove empty strings
    
    if ~all(ismember(insArrDone, insArr)) % double check that the user picked the right instrument DBs
        
        [~, unFinInd] = ismember(insArr, insArrDone); % find out which instruments have not been selected
        insArrNotDone = insArr(unFinInd == 0);
        insArrNotDone = strjoin(insArrNotDone, ', '); % place in comma separated string 
        h = errordlg(['You did not choose the prompted instruments. Decom cannot continue without' insArrNotDone ' databases']);
        uiwait(h)
        
        [fnames_out_recurse, ins_names_out_recurse] = xml2CSV(insArrNotDone); % recursively call to get the unfinished names
        
        fnames_out = strip(string(char(fnames_out{:}, fnames_out_recurse{:}))); % append to this call's output. There may be recursion depth > 1
        ins_names_out = strip(string(char(ins_names_out{:}, ins_names_out_recurse{:}))); 
        
    end
end

function T = xml2ArrSci(file, varargin)
    % converts xml science database to a lookup table for easy viewing and decom
    % use. This is a wrapper for the original xml2struct. It gets the
    % struct from a modified xml2struct and creates a table with decomm
    % info. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % THIS DOES NOT WORK FOR VIIRS AND CRIS YET
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % file -- assumed to be a full path file
    % returns a string array representing the lookup table 
    % varargin -- unused in this function
    % T - lookup table part with column order  {'mnemonic', 'type', 'packet', 'byte_bit', 'units', 'conversion', 'description'}
    
    s = xml2struct(file);

    apid = s.applicationPacket.apidNumber;
    
    % If this field doesnt exist, we dont want that data
    if ~isfield(s.applicationPacket, 'userFieldsSegment'), T = ''; return; end
    
    m = s.applicationPacket.userFieldsSegment.userField;
    T = string(zeros(length(m), 7)); % preallocate array to the length of the number of menmonics in the xml file by the number of columns we are creating
    
    for i = 1:length(m) 
        mi = fixConvRuleAndValAndByteBitAndUnpackRule(m{i}); % fix up the struct to a useable format
        mi.Packet = ['APID' repelem('0' ,4-length(apid)) apid]; % APID
        tmp = struct2cell(mi);
        T(i, :) = strip(string(char(tmp)))'; % put it in the array
    end
    
    T = [T(:,1) T(:,3) T(:,7) T(:,6) T(:,4) T(:,5) T(:,2)]; % fix the ordering for the decom engine
    
end

function T = xml2ArrSC(file, varargin)
    % converts xml SPACECRAFT database to a lookup table for easy viewing and decom
    % use. This is a wrapper for the original xml2struct. It gets the
    % struct from a modified xml2struct and creates a table with decomm
    % info. 
    % file -- assumed to be a full path file
    % returns a string array representing the lookup table 
    % varargin -- used to pass the string of the root directory name of the xml file tree 
    % T - lookup table part with column order  {'mnemonic', 'type', 'packet', 'byte_bit', 'units', 'conversion', 'description'}

    
    root = varargin{1}; % get the root dir of the xml dir tree 
    
    convPath = fullfile(root, 'ConvXML'); % get the path to the dir where the conversion coefficient groups are stored
    
    s = xml2struct(file);

    s = s.TlmUnit; % strip the outer layer of the struct
    
    mnemonic = strip(s.TlmMnemonic); % JPSS menmonic string. Thewre is only one per SC xml file
           
    sCore = s.TlmCoreElements;
    
    numAPIDs= length(sCore.TlmPktElements); % this is an array containg each APID for this one mneminc and its byte:bit location in that APID's packet
    
    T = string(zeros(numAPIDs, 7)); % preallocate array. There may be more than one APID for this mnemonic, so make extra rows accordingly 
    
    s_or_u  = strip(upper(sCore.TmSignedUnsigned)); % The XML does not specify D for byte strings smaller than one byte, so use this to convert to the old naming convention of D1, D3, ... for bits
    
    if strcmp(s_or_u, '*'), s_or_u = 'U'; end % Why do they call unsigned *? I have no idea.
    
    sizeInBits = str2double(sCore.SizeInBits);
    
    if sizeInBits < 8 % chek if we have a bits field. These will always be unsigned
        s_or_u = 'D';
    end
    
    numType = [s_or_u sCore.SizeInBits]; % convert to U32, S16, ... for the decom engine
    
    for i = 1:numAPIDs 
        
        T(i, 1) = mnemonic;
        T(i, 2) = numType;
        
        if ~iscell(sCore.TlmPktElements), pktElts = sCore.TlmPktElements; % store this in memory, as we will access it multiple times in this loop, and this is faster than not storing it
        else, pktElts = sCore.TlmPktElements{i};
        end
        
        apid = strip(pktElts.APID); % extract the string of the APID number. Use strip incase thee are any trailing or leading white spaces
        T(i, 3) = ['APID' repelem('0', 4-length(apid)) apid]; % APID in the decomm engine's APID ormatting scheme
        
        if ~iscell(pktElts.TlmPktDecomm) , tlmPktDecomm1 = pktElts.TlmPktDecomm;
        else, tlmPktDecomm1 = pktElts.TlmPktDecomm{1};
        end
        
        byteStart = tlmPktDecomm1.DecommWord; % The start byte in the APID's packet
        
        leftoverBit = tlmPktDecomm1.StartBit; % the start bit in the byte index.
        
        % Now do some math to calculate the byte:bit structure with the
        % format /byte:bitStart-bitEnd
        bytebit = fixByteBit(byteStart, sizeInBits, str2double(leftoverBit))
        
        T(i, 4) = bytebit; 
        
        if ~isfield(sCore, 'ConvUnits'), units = '-'; % Unitless param, such as boolean
        else, units = sCore.ConvUnits; % units of the parameter
        end
        
        T(i, 5) = units;
        
        % Conversion info is in another subdir in the XML file tree, so
        % using the conv group number we must find the corresponding file
        % and use its conversion
        
        if ~isfield(s, 'TlmConvSet'), convStr = '-';
        elseif length(s.TlmConvSet) > 1, convStr = '-'; % This happens when there is a piecewise calibration. We cant support that yet, so skip it
        else, convStr = getConvXML(s.TlmConvSet.ConvGroupNumber, convPath) ; % get te conversion string in format: c0=<num> c1=<num> ... for calibration curve
        end
        
        T(i, 6) = convStr;
        
        % finally, the description
        T(i, 7) = s.TlmDescriptiveInfo.Description;
        
    end
    
end

function convStr = getConvXML(groupNumStr, convPath)
% get the conversion for calibration from the ConvXML directory in the xml
% directory structure. Return convStr in form c0=<num> c1=<num> ...
% This is only for Tlm XML. Sci XML has the conv in each file
% groupNumStr - the string of the group number that corresponds to the
% conversion xml file. The conversion files aer named with the convention
% CONV<groupNumStr>.xml
% convPath - the path to the ConvXML directory containing all the conv xml files

    convFile = fullfile(convPath, ['CONV' groupNumStr '.xml']); % get the full filename
    convStruct = xml2struct(convFile);
    convStruct = convStruct.ConvUnit; % strip outer struct layer
    coeff = [convStruct.CoefficientValues{:}]; % extract substructs into struct array
    coeff = {coeff.CoefficientValue} ; % values of coefficient, such as {0.0 1.0} for c0=0 c1=1
    convStr = strjoin(strcat('c'+string(0:length(coeff)-1) + '=', coeff ), ' '); % place in the conventional format

end


% This is for SCIENCE XML ONLY, for OMPS, ATMS, CERES
function mi = fixConvRuleAndValAndByteBitAndUnpackRule(mi)
    % puts conversion rule as a single string so that calibrateData() can use
    % it. calibrateData() runs on the order of miliseconds, so there is no
    % reason to change how it works becasue of a new xml format
    
    % Also, there is no support for field validation yet, so remove that
    % field for now
    
    % mi - m{i} from loop above
    if isfield(mi, 'fieldValidation')
        mi = rmfield(mi, 'fieldValidation'); % dont need these fields for decom
    end

    fn = fieldnames(mi.conversionRule);
    fn = fn{1}; % there is only one field name here
    if ~strcmp(fn, 'polynomial') % only support polynomial now
        mi.conversionRule = '--';
        mi.Units = '--';
    else
        mi.Units = mi.conversionRule.polynomial.finalUnits; % extract units

        % create conversion string 'c0=num c1=num...' for calibratedata()
        fn = fieldnames(mi.conversionRule.polynomial.coefficientSet); % coefficient_0, coefficient_1...
        len= length(fn);
        coeffArr = cell(len, 1); 
        coeffStruct = mi.conversionRule.polynomial.coefficientSet; 
        for i = 1:len % need this loop as dynamic struct access cannot be vetorized
            coeffArr{i} = coeffStruct(fn{i});        
        end
        mi.conversion = strjoin(strcat('c'+string(0:len-1) + '=', coeffArr ), ' '); % join the string into the conventional c0=<num> c1=<num> ... format
        mi = rmfield(mi, 'conversionRule'); % remove uneeded field
    end
    % (byte:bit) conversion to original form
    startBit = str2double(mi.startBit); % convert to number
    leftoverBit = mod(startBit, 8);
    byte = (startBit - leftoverBit)/8; % figure out numebr of bytes in the bit number
    byte = num2str(byte); % convert back to string
    
    numBits = str2double(mi.numBits);
    
    bytebit = fixByteBit(byte, numBits, leftoverBit);
    
    mi = rmfield(mi, 'startBit');
    mi = rmfield(mi, 'numBits');
    mi.byte_bit = bytebit;
    
    if strcmp(mi.unpackRule, 'ByteString')
        mi.unpackRule = ['D' num2str(numBits)];
    else
        mi.unpackRule = [upper(mi.unpackRule(1)) num2str(numBits)]; % unsigned or signed
    end
    
end

function bytebit = fixByteBit(byte, numBits, leftoverBit)
% given the byte start in the packet, the number of bits, and the leftover
% bit in the byte index, create the format /byte:bitStart-bitEnd

    bytebit = ['/' repelem('0', 4-length(byte)) byte]; % /bbbb. always need four slots here
    
    if mod(numBits, 8) % not U16, U32, Single or double precision (D3 or something) 
        rangeStart = num2str(leftoverBit);
        rangeEnd = num2str(leftoverBit + numBits - 1);
        if rangeEnd==rangeStart % D1
            bytebit = [bytebit ':' rangeStart];
        else
            bytebit = [bytebit ':' rangeStart '-' rangeEnd];
        end
    end
end

