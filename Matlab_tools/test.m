        f = figure('name', 'Spacecraft Database Options');
        set(f, 'MenuBar', 'none')
        set(f, 'ToolBar', 'none')
        
        h = uibuttongroup('parent', f);
        
        uicontrol('Style', 'radio', 'String', ... % use current SC DB
            'Use current SC database: ' ,...
            'pos', [10 350 1000 20], 'tag', 'b1', 'parent', h);
        
        uicontrol('Style', 'radio', 'String', 'Get new SC database',... % choose new SC DB
            'pos',[10 300 1000 20], 'tag', 'b2', 'parent', h);
        
        uicontrol('Style', 'checkbox', 'String', 'Get new Sci database', ... % choose new Sci DB (optional, hence its a check box instead of radio button)
            'pos', [10 250 1000 20], 'tag', 'b3', 'parent', h)
        
        b4 = uicontrol('Style', 'PushButton', 'String','Ok', ... % also choose/not choose Sci DB
            'pos', [10 200 100 20], 'Callback' ,@b4Callback, 'parent', h);
        
        uiwait(f)
        if ~isvalid(f), return; end
        bStruct = get(b4, 'UserData');
        bStruct.b3Val
        bStruct.sel
        close(f)



    
    
    function b4Callback(src, event)
        % for use in proc_bin_button_Callback
        sel = get(get(get(src, 'Parent'), 'SelectedObject'), 'tag');
        
        children = get(get(src, 'Parent'), 'Children'); % need this to access b3 value. Can only access all children, not just b3. This creates an array of uicontrol types
        b3 = children(2); % the array is ordered from newest to oldest in creation. b3 was created second to last, so it is second.
        
        toReturn = struct('sel', sel, 'b3Val', get(b3, 'value') ); % create struct for User Data field of b4, so it can bve accessed after this function returns.
        
        set(src, 'UserData', toReturn)

        
        uiresume()
    end
    
   