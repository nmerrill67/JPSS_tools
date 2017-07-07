function saveScreen()
% shared function for taking good quality pictures of the current figure
% screen. It is basically a shared callback function for all tool screens

    % all pictures saved to .../Matlab_tools/SAVED_SCREENS
    
    % this function is in the helperFunctions dir, but it is called in the
    % Matlab_tools root, so that is the working directory for this
    % function, hence referencing helperFunctions as a sub directory
    
    savename = inputdlg('Enter saved screen file name'); % popup box asking for filename
    if ~isempty(savename)
        filename  = fullfile(pwd, 'SAVED_SCREENS', savename);
        export_fig.export_fig(filename{1}, '-png'); % use the open source export_fig function (located in export_fig directory)
    else
        warndlg('No name selected!')
    end

end

