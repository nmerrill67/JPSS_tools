function data = dataCorrection(data, sortFlag, dupFlag)
% shared function file for the data correction options in plot windows
% data - matrix: old data that may need correcting
% sortFlag - bool: sort rows?
% dupFlag - bool: delete duplicate entries and timestamps?


    if sortFlag   % if data sort requested
        data = sortrows(data,[1,2]);
    end

    if dupFlag % if Delete Dups requested
        data = unique(data,'rows');
        [~, unqInds, ~] = unique(data(:,1) + data(:,2)/86400000 + ...
            data(:,3)/(8.6400e+10), 'rows'); 
        % get indices of unique timestamps wrt mission epoch to avoid misconveived duplicates
        
        data = data(unqInds, :);
    end


end