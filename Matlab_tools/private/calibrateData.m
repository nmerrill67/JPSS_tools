function [calibData, y_label] = calibrateData(data, DBDptr, instruments)
    % updates handles fields for calibrated data. THis will work for a
    % calibration with any number of coeeficients. Theoretically to +inf #
    % coefficients (obviously we would run out of memory, but you get the
    % [calibData, y_label] = calibrateData(data, DBDptr, instruments)
    % idea)
    % data           n x p data matrix of raw counts
    % DBDptr         ptr to the handles.DBDptr field
    % instruments    char array of instrument names for calibration 
    % calibData      the calibrated data matrix
    % ylabel         the mnemonic with (units) attached for plotting

    if isempty(DBDptr)
        calibData = data;
        y_label = instruments;
        d = errordlg('Unexpected calibration error. Data will remain uncalibrated.');
        uiwait(d)
        return
    end
    [coeffMat, y_label] = calcCoeffs(DBDptr, instruments); % # instruments long cell array containing coefficient column vecs 
    y_label = cellstr(y_label); % convert to cell array
    calibData_tmp = zeros(size(data));
    
    for k = 1:length(instruments)
        coeffI = coeffMat{k};
        di = data(:,k).^(0:length(coeffI)-1); % creates vector [1_ x^1 x^2 ...]
        calibData_tmp(:,k) = di * coeffI; % apply calibration curve for spceific instruments. vectorized for speed (n x #coefficients * #coefficients x 1 matrix mult)

    end
%     d = DBDptr(7200:7300,:)
%     cell2table(d)
%     y_label

    calibData = calibData_tmp;
    function [coeffMat, ylabel] = calcCoeffs(DBDptr, instruments)
    % calculate a 3D - p1 x p2 coefficient matrix, Where p1 is the number of 
    % variables being plotted, and p1 is the number of
    % coefficients in the calibration equation for the variable.
    % DBDptr   pointer to handles.DBDptr field. It's the database directive matrix for coefficient lookup  
    % instruments      char array of instrument names for calibration  
    % coeffMat -  a cell array containing column vectors of coefficients
    % for calibration -- i.e. [c0 c1 c2 c3]'. Cell array allows fo variable
    % size vector entries to account for different number of variables

        % TODO fix this for piecewise calibrations. Fix for discrete
        % calibrtions (i.e. 0=OFF 1=ON or whatever
        
        
        coeffMat_tmp = cell(length(instruments),1); 
        instrDB = char(DBDptr.mnemonic);
        
        i = 1;

        ylabel_tmp = '';
        
        uncalib = '';

        while i <= length(instruments) % loop through all the instruments chosen by the user
           
           tmp = instruments(i);
           ii = tmp{1}; % pull out cell array wrapper
         
           j = find(strcmp(strip(ii), strip(string(instrDB))), 1); % find the instrument in the database

           if isempty(j) || j > size(instrDB, 1) % if the instrument is not in the database, let the user know with uihelper function
   
                [coeffMat_tmp{i}, i] = uiHelper(i);
                ylabel_tmp = ylabelHelper(ii, ylabel_tmp);
                uncalib = uncalibHelper(uncalib, ylabel_tmp);
                continue
           end
           
           cellCoeff = DBDptr.conversion(j);  % c0=<num> c1=<num> ....

           if isempty(cellCoeff{1}) || ~strcmp(cellCoeff{1}(1),'c') % No conversion available. Calibration is impossible. Or there is piecewise calibration, which is unsupported
                [coeffMat_tmp{i}, i] = uiHelper(i);
                ylabel_tmp = ylabelHelper(ii, ylabel_tmp);
                uncalib = uncalibHelper(uncalib, ylabel_tmp);
                continue
           end
           
           coeff = extrCoeffFromStr(cellCoeff{1}); % get the vector of polynomial coefficients
           coeffMat_tmp{i} = coeff; % place the variable size vector in the cell array
           if i==1
               ylabel_tmp = char(strcat({ii}, {' ('}, DBDptr.units(j), {')'})); % rename the mnemonic with the units appended
           else
               ylabel_tmp = char(ylabel_tmp, char(strcat({ii}, {' ('}, DBDptr.units(j), {')'})));
           end
           
           i = i + 1;
        end
        
        if ~strcmp(uncalib, '') % If any data are left uncalibrated
            h = warndlg(strcat({char(uncalib)},{' are not available for calibration. Only raw counts are available. This instrument will be plotted in raw counts'}));
            uiwait(h)
        end
        
        ylabel = ylabel_tmp;
        coeffMat = coeffMat_tmp;
    end 


    function [M, i] = uiHelper(i)
        % displays dialog box and helps with loop variables in calcCoeffs. I used this so I didn't write the code twice 
        M = [0; 1]; % [c0=0; c1=1] cell in the coeffMat leaves the values the same
        i = i + 1;
    end 
    
    function ylab = ylabelHelper(ii, ylab_tmp)
        % another helper to avoid writing code twice
        if strcmp(ylab_tmp, '')
            ylab = char(ii);
        else
            ylab = char(ylab_tmp, char(ii));
        end
    end        
        
   function uncalib = uncalibHelper(uncalib, ylab)
       % fix uncalibrated ylabels
       
       if strcmp(uncalib, '')
            uncalib = strcat({ylab(end,:)});
       else
            uncalib = strcat({char(uncalib)},{', '}, {char(ylab(end,:))});
       end 
    
   end    
       
   function coeff = extrCoeffFromStr(str)
    % extract the coefficients from string in form 'c0=... c1=... c2=... ...'
    % str   input string
    % coeff the output array of coefficients in the same order.
        split1 = strsplit(str, {' ', '='}); % split based on spaces and '='
        i = 2:2:length(split1);
        coeff = str2num(char(split1(i))); % coerce into double array. ignore the warning. It crashes it with str2double
   end
end