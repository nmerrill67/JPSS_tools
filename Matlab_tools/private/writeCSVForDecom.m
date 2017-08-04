function fname = writeCSVForDecom(varargin)    
% transform excel file into csv for quick reading. 
% this function creates the csvs for the matlab tools and the cpp decom
% the reading of the excel only needs to happen once ever
    pwd;

    if nargin==0 % normal usage for sc database
        
        [filename, fpath] = uigetfile(fullfile(pwd, 'DBD_XLS', '*.xls*'), 'Select Database Definition Excel File');

        if ~filename, fname = ''; return; end

        f = strsplit(filename, '.');
        c = f(1);
        fname = c{1}; % filename with no extension
        name1 = strcat('../Decom_tools/database_CSVs/',fname, '.csv'); 

        h = waitbar(0, '  ===>  Checking for existing database directive files  ===>   ');    

        if ~exist(fullfile('../Decom_tools/database_CSVs', strcat(fname, '.csv')), 'file') ... 
                || ~exist(fullfile(pwd, 'DBD_CSVs', strcat(fname, '.txt')), 'file')

            try waitbar(1/16, h, 'Checking for Databases')
            catch; end

            % this function is in the private dir, but it is called in the
            % Matlab_tools root, so that is the working directory for this
            % function, hence referencing helperFunctions as a sub directory

            try 
                waitbar(1/8.5, h, 'No matching database found')
                waitbar(1/8.25, h, 'Extracting database from Excel')
            catch
            end

            tmp = readtable(fullfile(fpath, filename), 'Sheet', 'Flight Tlm List', 'Range', 'C:R');

            try waitbar(1/8, h, 'Writing Permanent database files')  
            catch; end

            M = tmp{:,[1 6 8 9]}; % extract the cols we want: [mnemonic type APID (byte:bit)] 

            M = M(all(cellfun(@numel, M), 2), :); % one liner to remove rows with missing cells

            % fix issues with byte:bit formatting and leading zeros
            bytebit = M(2:end,end);% drop header row 

            for i = 1:length(bytebit)
               spl = strsplit(bytebit{i}, ':');
               spl1 = spl{1};
               if length(spl1) ~= 5
                  fillz = repelem('0', 5-length(spl1)); % fix the leading zeros so gabes decom doesnt crash
                  spl1 = [spl1(1) fillz spl1(2:end)];
                  if length(spl)==1  
                    bytebit{i} = spl1; % put the corrected string back in
                  else
                    bytebit{i} = [spl1 ':' spl{2}]; % put the corrected string back in
                  end
               end   

            end

            M(2:end, end) = bytebit;            

            V = {'Mnemonic', 'Type', 'Packet', 'byte_bit'}; % column headers

            T = array2table(M, 'VariableNames', V); 
            try waitbar(1/4, h, 'Writing Permanent database files')
            catch; end

            % write csv for decom use
            if ~exist('../Decom_tools/database_CSVs', 'dir')
                mkdir ../Decom_tools/database_CSVs
            end
            if ~exist('../Decom_tools/databases', 'dir')
                mkdir ../Decom_tools/databases
            end
            if ~exist('DBD_CSVs', 'dir')
                mkdir DBD_CSVs
            end
            writetable(T(2:end,:), name1) % first row is headers from excel, so cut it out
            try waitbar(1/2, h,'Writing Permanent database files')
            catch; end

            %Now write the one for matlab use
            M = tmp{:, [14 16 1 3 4 8 9]}; % [units conversion mnemonic description S/S type APID (byte:bit)] 

            M = M(any(cellfun(@numel, M), 2), :);
            %one liner to remove rows with entire rows missing. Notice I
            %use any here instead of all, because some of the mnemonics I
            %need dont have certain cells from the row, but most of the row
            %remains

            name2 = strcat('DBD_CSVs/',fname, '.txt');
            V = {'units', 'conversion', 'mnemonic', 'description',...
                'type', 'APID', 'byte_bit'};
            T = array2table(M, 'VariableNames', V); 

            writetable(T(2:end,:), name2, 'Delimiter', ';') % tab and comma didnt work because those characters exist in the DB

            try waitbar(3/4, h, 'Writing Permanent database files')
            catch; end

        end    

        if exist('../Decom_tools/databases/scdatabase.csv', 'file')
            delete  ../Decom_tools/databases/scdatabase.csv
        end
        try waitbar(7/8, h, 'Placing database file for decommutation engine')
        catch; end
        
        
        scidArr = regexpi(fname,{'NPP','JPSS1', 'JPSS2', 'JPSS3', 'JPSS4'}, 'match'); % match the XLS file name substring with one of the know SCIDs, ignoreing case
        scid = [scidArr{:}]; % remove outer cell array wrapper, deleteing empty cells, leaving just the non-empty
        scid = scid{:}; % remove the last cell wrapper, leaving just the string for the scid
        
        % now we must translate the uppercase long SCID to the short
        % version used by CXXDecomQt's database reading scheme
        switch scid
            case 'NPP'
                scid = 'npp';
            case 'JPSS1'
                scid = 'j1';
            case 'JPSS2'
                scid = 'j2';                
            case 'JPSS3'
                scid = 'j3';
            case 'JPSS4'
                scid = 'j4';        
            otherwise 
                h = errordlg('Incorrectly named database file. Please keep the original JPSS naming scheme');
                uiwait(h)
        end  
                
        if ispc
            system(['copy /Y ' fullfile('..\Decom_tools\database_CSVs',strcat(fname, '.csv')) ' ..\Decom_tools\databases\' scid 'database.csv']); 
        % put the csv in the right place with the right name ,which pertains to the SCID, for decom tool
        else
            system(['cp -f ' fullfile('../Decom_tools/database_CSVs', [fname '.csv']) ' ../Decom_tools/databases/' scid 'database.csv']); 

        end

        try 
            waitbar(1, h, 'Done')
            delete(h)
        catch
        end

    else % Usage for XML science or Tlm database
        ins_needed = varargin{1} ;% comma separated string of instrument names needed for science databases
        
        [fnames, ins_written] = xml2CSV(ins_needed); % write CSVs (or just get the names if they already exist), get the file basenames
        
        if isempty(fnames), return; end
        
        for i = 1:length(fnames) % place all of the DBs in decom databases folder
            
            ins = ins_written{i}; % strip the first layer of cell array wrappers
            if iscell(ins), ins = ins{1}; end% sometimes 9not always) there is an extra layer of cell array. This only happens when there is more than one instrument returned
            
            fname = fnames{i};% for spacecraft, this return value will be used in the getCalibMat function
            
            if exist(['../Decom_tools/databases/' ins 'database.csv'], 'file')
                delete(['../Decom_tools/databases/' ins 'database.csv'])
            end
            
            if ispc
                system(['copy /Y ' fullfile('..\Decom_tools\database_CSVs',strcat(fname, '.csv')) ' ..\Decom_tools\databases\' ins 'database.csv']); 
            % put the csv in the right place with the right name for decom tool
            else
                system(['cp -f ' fullfile('../Decom_tools/database_CSVs', [fname '.csv']) ' ../Decom_tools/databases/' ins 'database.csv']); 

            end
            
        end
    end    
        
        
        
        













