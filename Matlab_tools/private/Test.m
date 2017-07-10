function makePPT()

    %% Open existing presentation
    isOpen  = exportToPPTX();
    if ~isempty(isOpen)
        % If PowerPoint already started, then close first and then open a new one
        exportToPPTX('close');
    end

    exportToPPTX('open','PPTX_Templates/JPSS_PPT_Template.pptx');


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


    %% Add content slides

    exportToPPTX('addslide','Layout','Title and Content');
    exportToPPTX('addtext','Channel 1','Position','Title');

    exportToPPTX('addpicture',gcf,'Position','Content Placeholder','Scale','max');

    if ~exist('Screenshots_and_PPTX/PPTX', 'dir'),  mkdir Screenshots_and_PPTX/PPTX; end

    %% Save As this presentation
    newFile = exportToPPTX('save',['Screenshots_and_PPTX/PPTX' title{1}]);


    %% Close presentation (and clear all temporary files)
    exportToPPTX('close');

    fprintf('New file has been saved: <a href="matlab:open(''%s'')">%s</a>\n',newFile,newFile);

end