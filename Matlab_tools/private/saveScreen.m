function saveScreen(varargin)
% shared function for taking good quality pictures of the current figure
% screen. It is basically a shared callback function for all tool screens

    % all pictures saved to <PATH_TO>/Matlab_tools/SAVED_SCREENS
    

    if nargin > 0
        f = figure('name', 'Database Options');
        set(f, 'MenuBar', 'none')
        set(f, 'ToolBar', 'none')

        h = uibuttongroup('parent', f);

        uicontrol('Style', 'radio', 'String', ...
            'Save to PowerPoint Presentation (platform independent)',...
            'pos', [10 350 1000 20], 'tag', 'b1', 'parent', h);

        uicontrol('Style', 'radio', 'String', 'Save to PNG',...
            'pos',[10 250 1000 20], 'tag', 'b2', 'parent', h);

        b3 = uicontrol('Style', 'PushButton', 'String','Ok', ...
            'pos', [10 150 100 20], 'Callback' ,@b3Callback, 'parent', h);

        uiwait(f)
        if ~isvalid(f), return; end
        b = get(b3, 'UserData');
        close(f)
    end
    if nargin==0 || strcmp(b, 'b2') % nargin==0 for dwell_fft_tool, because there are not multiple files to sort through for that
        savename = inputdlg('Enter saved screen file name'); % popup box asking for filename
        if ~isempty(savename)

            if ~exist('Screenshots_and_PPTX', 'dir'), mkdir Screenshots_and_PPTX; end
            if ~exist('Screenshots_and_PPTX/Screenshots', 'dir'),  mkdir Screenshots_and_PPTX/Screenshots; end

            filename  = fullfile(pwd, 'Screenshots_and_PPTX/Screenshots', savename);
            export_fig.export_fig(filename{1}, '-png'); % use the open source export_fig function (located in export_fig directory)
        else
            warndlg('No name selected!')
        end
        
    else
        saveAsPPTX(varargin{:}) % {:} makes a comma separated list of the input vars
    end
        
    function b3Callback(src, event)
    % for use in proc_bin_button_Callback
        str = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        set(src, 'UserData', str)
        uiresume()
    end

end

