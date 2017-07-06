function fname = writeCSVForDecom()    
% transform excel file into csv for quick reading. time to read in excel =
% 30 sec, time to read csv < 1 sec.
% this function creeates the csvs for the matlab tools and the cpp decom
% the reading of the excel only needs to happen once ever

    [filename, fpath] = uigetfile(fullfile(pwd, 'DBD_XLS', '*.xls*'), 'Select Database Definition Excel File');

        if ~filename, fname = ''; return; end
        f = strsplit(filename, '.');
        c = f(1);
        fname = c{1}; % filename with no extension
        name1 = strcat('../database_CSVs/',fname, '.csv'); 

        h = waitbar(0, '  ===>  Checking for existing database directive files  ===>   ');    
        
        if ~exist(fullfile('../database_CSVs', strcat(fname, '.csv')), 'file') ... 
                || ~exist(fullfile(pwd, 'DBD_CSVs', strcat(fname, '.txt')), 'file')
            
            waitbar(1/16, h, 'Checking for Databases')

            % this function is in the helperFunctions dir, but it is called in the
            % Matlab_tools root, so that is the working directory for this
            % function, hence referencing helperFunctions as a sub directory
            if ~ismember(fullfile(pwd,'helperFunctions/myxlsread'), strsplit(path,';')) % check if myxlsread is in the matlab path
                path(path, fullfile(pwd,'helperFunctions/myxlsread')); % if not, add it
            end

            waitbar(1/8.5, h, 'No matching database found')

            waitbar(1/8.25, h, 'Extracting database from Excel')
            
            tmp = readtable(fullfile(fpath, filename), 'Sheet', 'Flight Tlm List', 'Range', 'C:R');
            
            waitbar(1/8, h, 'Writing Permanent database files')  

            M = tmp{:,[1 6 8 9]}; % extract the cols we want

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
            waitbar(1/4, h, 'Writing Permanent database files')
            % write csv for decom use
            writetable(T(2:end,:), name1) % first row is headers from excel, so cut it out
            waitbar(1/2, h,'Writing Permanent database files')

            %Now write the one for matlab use
            M = tmp{:, [14 16 1 3 4 6 8 9]};

            M = M(any(cellfun(@numel, M), 2), :);
            %one liner to remove rows with entire rows missing. Notice I
            %use any here instead of all, because some of the mnemonics I
            %need dont have certain cells from the row, but most of the row
            %remains

            name2 = strcat('DBD_CSVs/',fname, '.txt');
            V = {'units', 'conversion', 'mnemonic', 'description',...
                'SS', 'type', 'APID', 'byte_bit'};
            T = array2table(M, 'VariableNames', V); 
            
            disp hey
            writetable(T(2:end,:), name2, 'Delimiter', ';') % tab and comma didnt work because they exist in the DB

            waitbar(3/4, h, 'Writing Permanent database files')

        end    
        
        delete  ../databases/scdatabase.csv
        waitbar(7/8, h, 'Placing database file for decommutation engine')
        if ispc
            system(['copy /Y ' fullfile('..\database_CSVs',strcat(fname, '.csv')) ' ..\databases\scdatabase.csv']); 
        % put the csv in the right place with the right name for decom tool
        else
            system(['cp -f' fullfile('../database_CSVs',strcat(fname, '.csv')) ' ../databases/scdatabase.csv']); 

        end
                        
        waitbar(1, h, 'Done')
        delete(h)

end













