function saveAsPPTX(prevPath, plotfun, readRange, fig)
%% Save multiple files to PPT (platform independent)
% PrevPath - the starting path for file selection, fed in from plotting
% tool function

% plotfun - function handle to main plotting function

% readRange - range of new files to read in [startRow startCol endRow endCol]

% fig - current figure. Could use gcf, but this is more robust

    %% select files to export
    
    [fname, fpath] = uigetfile(fullfile(prevPath, '*.txt'), ...
        'Select files to be placed into PPT with the current plot timeframe. Note that the plots will be placed in the Main/Science plot window', ...
        'Multiselect', 'on'); % Usually will be multiple channel files. Must be in same directory (i.e. same timeframe)
    
    if ~fpath, return; end % user decided to exit instead of continue
    
    fname = string(fname); % get a consistent length reading (to get number of files selected)


    %% Open existing presentation
    isOpen  = exportToPPTX();
    if ~isempty(isOpen)
        % If PowerPoint already started, then close first and then open a new one
        exportToPPTX('close');
    end

    
    exportToPPTX('open','.PPTX_Templates/JPSS_PPT_Template.pptx'); % Do not delete this template!!!


    % All available layout templates:
    % 	1. Custom Layout
    % 	2. Title and Content
    % 	3. Title Slide

    %% Add title slide

    default = {'Instrument Anomaly Findings', 'JPPS Team'};

    title = inputdlg({'Title of your presentation:', ...
        'Preparer:'}, 'PPT Title and Preparer', 1, ...
        default);

    if isempty(title), title = default; end

    exportToPPTX('addslide','Master',1,'Layout','Title Slide'); % create first slide 
    exportToPPTX('addtext',title{1},'Position','Title'); % add the title
    exportToPPTX('addtext',title{2},'Position','Subtitle');
 
    
    range = [nn2an(readRange(1), readRange(2)) ':' nn2an(readRange(3), readRange(4))]; % get the Excel-style range for readtable
    

    %% Add content slides

    for i = 1:length(fname)
        
        exportToPPTX('addslide','Layout','Title and Content');
        exportToPPTX('addtext','Channel 1','Position','Title');

        exportToPPTX('addpicture',gcf,'Position','Content Placeholder','Scale','max');

        if ~exist('Screenshots_and_PPTX', 'dir'), mkdir Screenshots_and_PPTX; end

        if ~exist('Screenshots_and_PPTX/PPTX', 'dir'),  mkdir Screenshots_and_PPTX/PPTX; end
        
    end
    %% Save As this presentation
    newFile = exportToPPTX('save',['Screenshots_and_PPTX/PPTX' title{1}]);


    %% Close presentation (and clear all temporary files)
    exportToPPTX('close');

    fprintf('New file has been saved: <a href="matlab:open(''%s'')">%s</a>\n',newFile,newFile);
    
    
    function cr = nn2an(r, c)
    % convert number, number format to alpha, number format
        t = [floor((c - 1)/26) + 64 rem(c - 1, 26) + 65];
        if(t(1)<65), t(1) = []; end
        cr = [char(t) num2str(r)];    
    end
end