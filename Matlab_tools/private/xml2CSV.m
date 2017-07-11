function xml2CSV()
% select XML folder, process all the XML into lookup tables for decom and
% later Calibration use.

    dname = uigetdir('DBD_XML','Select XML folder. Please limit to one instrument per folder'); % get xml folder
    if ~dname, return; end % user cancelled. Prevent errors
    d = dir([dname '/**/*.xml']); % get dir info for all subdirs too. specify wildcard to avoid '..' and '.'
    if size(unique(char(d.folder), 'rows'), 1) > 1 % they chose a root directory of a huge file tree.
        h = errordlg('Please choose directory containing only one instrument or purely spacecraft XML files');
        uiwait(h)
        xml2CSV();
        return
    end
    dnames = lower([d.folder]); % str of sub directory name 
    
    insNames = {'omps'; 'atms'; 'ceres'; 'cris'; 'viirs'};
    instr = insNames(ismember(insNames, strsplit(dnames, {'_', '-'}))); % figure out which instrument we are dealing with
    if isempty(instr) || length(instr)~=1
        h = errordlg('Please choose a correct directory. It must contain XML files from only one instrument or spacecraft');
        uiwait(h)
        xml2CSV();
        return
    end
    
    fnames = fullfile({d.folder},{d.name}); % all filenames with full path
 
    T = []; % cant preallocate. We dont know the size
    h = waitbar(0, 'Reading XML files');
    len = length(fnames);
    parfor i = 1:len % parallelized for loop is faster for large number of files
        tmp = xml2Arr(fnames{i});
        if isempty(tmp), continue; end % useless file for decom
        T = [T; tmp];
        waitbar((len-i)/len, h); % parfor starts with i = len? its weird
    end
    delete(h)
    V = {'Mnemonic', 'Type', 'Packet', 'bit_byte', 'Units', 'Conversion', 'Description'};
    spl = strsplit(dname ,{'/','\'}); % split the dirname from the path for writing purposes
    writetable(array2table([T(:,1) T(:,3) T(:,7) T(:,6) T(:,4) T(:,5) T(:,2)],...
        'VariableNames', V), [spl{end} '.csv']); % fix the column order for decom engine 
end

function T = xml2Arr(file)
    % converts xml database to a lookup table for easy viewing and decom
    % use. This is a wrapper for the original xml2struct. It gets the
    % struct from a modified xml2struct and creates a table with decomm
    % info
    
    % file is assumed to be a full path file
    % returns a string array representing the lookup table 

    
    s = xml2struct(file);

    apid = s.applicationPacket.apidNumber;
    
    % If this field doesnt exist, we dont want that data
    if ~isfield(s.applicationPacket, 'userFieldsSegment'), T = ''; return; end
    
    m = s.applicationPacket.userFieldsSegment.userField;
    T = string(zeros(length(m), 7)); % preallocate array
    
    for i = 1:length(m)
        mi = fixConvRuleAndValAndByteBitAndUnpackRule(m{i}); % fix up the struct to a useable format
        mi.Packet = ['APID' repelem('0' ,4-length(apid)) apid]; % APID
        tmp = struct2cell(mi);
        T(i, :) = strip(string(char(tmp)))'; % put it in the array
    end
    
end


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
        str = ['c0=' mi.conversionRule.polynomial.coefficientSet.(fn{1})];
        for i = 2:length(fn)
            c = ['c' num2str(i-1) '='];
            str = [str ' ' c mi.conversionRule.polynomial.coefficientSet.(fn{i})];        
        end
        mi = rmfield(mi, 'conversionRule');
        mi.conversion = str;    
    end
    % (byte:bit) conversion to original form
    startBit = str2double(mi.startBit); % convert to number
    leftoverBit = mod(startBit, 8);
    byte = (startBit - leftoverBit)/8; % figure out numebr of bytes in the bit number
    byte = num2str(byte); % convert back to string
    bytebit = ['/' repelem('0', 4-length(byte)) byte]; % /bbbb. always need four slots here
    
    numBits = str2double(mi.numBits);
    if mod(numBits, 8) % not U16, U32, Single or double precision (D3 or something) 
        rangeStart = num2str(leftoverBit);
        rangeEnd = num2str(leftoverBit + numBits - 1);
        if rangeEnd==rangeStart % D1
            bytebit = [bytebit ':' rangeStart];
        else
            bytebit = [bytebit ':' rangeStart '-' rangeEnd];
        end
    end
    
    mi = rmfield(mi, 'startBit');
    mi = rmfield(mi, 'numBits');
    mi.byte_bit = bytebit;
    
    if strcmp(mi.unpackRule, 'ByteString')
        mi.unpackRule = ['D' num2str(numBits)];
    else
        mi.unpackRule = [mi.unpackRule(1) num2str(numBits)]; % unsigned or signed
    end
    
end

function [ s ] = xml2struct( file )
% Edited by Nate Merrill, JPSS flight Intern
% I edited this to get rid of the annoying text field that wrapped every
% leaf field in the large tree-like structure 


%Convert xml file into a MATLAB structure
% [ s ] = xml2struct( file )
%
% A file containing:
% <XMLname attrib1="Some value">
%   <Element>Some text</Element>
%   <DifferentElement attrib2="2">Some more text</Element>
%   <DifferentElement attrib3="2" attrib4="1">Even more text</DifferentElement>
% </XMLname>
%
% Will produce:
% s.XMLname.Attributes.attrib1 = "Some value";
% s.XMLname.Element = "Some text";
% s.XMLname.DifferentElement{1}.Attributes.attrib2 = "2";
% s.XMLname.DifferentElement{1}.Text = "Some more text";
% s.XMLname.DifferentElement{2}.Attributes.attrib3 = "2";
% s.XMLname.DifferentElement{2}.Attributes.attrib4 = "1";
% s.XMLname.DifferentElement{2} = "Even more text";
%
% Please note that the following characters are substituted
% '-' by '_dash_', ':' by '_colon_' and '.' by '_dot_'
%
% Written by W. Falkena, ASTI, TUDelft, 21-08-2010
% Attribute parsing speed increased by 40% by A. Wanner, 14-6-2011
% Added CDATA support by I. Smirnov, 20-3-2012
%
% Modified by X. Mo, University of Wisconsin, 12-5-2012

    if (nargin < 1)
        clc;
        help xml2struct
        return
    end
    
    if isa(file, 'org.apache.xerces.dom.DeferredDocumentImpl') || isa(file, 'org.apache.xerces.dom.DeferredElementImpl')
        % input is a java xml object
        xDoc = file;
    else
        %check for existance
        if (exist(file,'file') == 0)
            %Perhaps the xml extension was omitted from the file name. Add the
            %extension and try again.
            if (~contains(file,'.xml'))
                file = [file '.xml'];
            end
            
            if (exist(file,'file') == 0)
                error(['The file ' file ' could not be found']);
            end
        end
        %read the xml file
        xDoc = xmlread(file);
    end
    
    %parse xDoc into a MATLAB structure
    s = parseChildNodes(xDoc);
    
end

% ----- Subfunction parseChildNodes -----
function [children,ptext,textflag] = parseChildNodes(theNode)
    % Recurse over node children.
    children = struct;
    ptext = struct; textflag = 'Text';
    if hasChildNodes(theNode)
        childNodes = getChildNodes(theNode);
        numChildNodes = getLength(childNodes);

        for count = 1:numChildNodes
            theChild = item(childNodes,count-1);
            [text,name,attr,childs,textflag] = getNodeData(theChild);
            
            if (~strcmp(name,'#text') && ~strcmp(name,'#comment') && ~strcmp(name,'#cdata_dash_section'))
                %XML allows the same elements to be defined multiple times,
                %put each in a different cell
                if (isfield(children,name))
                    if (~iscell(children.(name)))
                        %put existsing element into cell format
                        children.(name) = {children.(name)};
                    end
                    index = length(children.(name))+1;
                    %add new element
                    children.(name){index} = childs;
                    if(~isempty(fieldnames(text)))
                        children.(name){index} = text; 
                    end
                    if(~isempty(attr)) 
                        children.(name){index}.('Attributes') = attr; 
                    end
                else
                    %add previously unknown (new) element to the structure
                    children.(name) = childs;
                    if ischar(text) || (~isempty(text) && ~isempty(fieldnames(text)))
                        children.(name) = text; 
                    end
                    if(~isempty(attr)) 
                        children.(name).('Attributes') = attr; 
                    end
                end
            else
                ptextflag = 'Text';
                if (strcmp(name, '#cdata_dash_section'))
                    ptextflag = 'CDATA';
                elseif (strcmp(name, '#comment'))
                    ptextflag = 'Comment';
                end
                
                %this is the text in an element (i.e., the parentNode) 
                if (~isempty(regexprep(text.(textflag),'[\s]*','')))
  
                    if (~isfield(ptext,ptextflag) || isempty(ptext.(ptextflag)))
                        if strcmp(ptextflag, 'Text')
                            ptext = text.(textflag);
                        else
                            ptext.(ptextflag) = text.(textflag);
                        end
                    else
                        %what to do when element data is as follows:
                        %<element>Text <!--Comment--> More text</element>
                        
                        %put the text in different cells:
                        % if (~iscell(ptext)) ptext = {ptext}; end
                        % ptext{length(ptext)+1} = text;
                        
                        %just append the text
                        if strcmp(ptextflag, 'Text')
                            ptext = [ptext text.(textflag)];
                        else
                            ptext.(ptextflag) = [ptext.(ptextflag) text.(textflag)];
                        end
                    end
                end
            end
            
        end
    end
end

% ----- Subfunction getNodeData -----
function [text,name,attr,childs,textflag] = getNodeData(theNode)
    % Create structure of node info.
    
    %make sure name is allowed as structure name
    name = toCharArray(getNodeName(theNode))';
    name = strrep(name, '-', '_dash_');
    name = strrep(name, ':', '_colon_');
    name = strrep(name, '.', '_dot_');

    attr = parseAttributes(theNode);
    if (isempty(fieldnames(attr))) 
        attr = []; 
    end
    
    %parse child nodes
    [childs,text,textflag] = parseChildNodes(theNode);
    
    if ~ischar(text) && (isempty(fieldnames(childs)) && isempty(fieldnames(text)))
        %get the data of any childless nodes
        % faster than if any(strcmp(methods(theNode), 'getData'))
        % no need to try-catch (?)
        % faster than text = char(getData(theNode));
        text.(textflag) = toCharArray(getTextContent(theNode))';
    elseif ischar(text)
        text = toCharArray(getTextContent(theNode))';
    end
    
end

% ----- Subfunction parseAttributes -----
function attributes = parseAttributes(theNode)
    % Create attributes structure.

    attributes = struct;
    if hasAttributes(theNode)
       theAttributes = getAttributes(theNode);
       numAttributes = getLength(theAttributes);

       for count = 1:numAttributes
            %attrib = item(theAttributes,count-1);
            %attr_name = regexprep(char(getName(attrib)),'[-:.]','_');
            %attributes.(attr_name) = char(getValue(attrib));

            %Suggestion of Adrian Wanner
            str = toCharArray(toString(item(theAttributes,count-1)))';
            k = strfind(str,'='); 
            attr_name = str(1:(k(1)-1));
            attr_name = strrep(attr_name, '-', '_dash_');
            attr_name = strrep(attr_name, ':', '_colon_');
            attr_name = strrep(attr_name, '.', '_dot_');
            attributes.(attr_name) = str((k(1)+2):(end-1));
       end
    end
end
