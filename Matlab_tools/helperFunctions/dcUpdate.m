function txt = dcUpdate(~, event_obj)
% customizes data cursor object to show times instead of seond from epoch
   pos = get(event_obj,'Position');
   txt = {['time: ',datestr(pos(1), 'dd-mmm-yyyy HH:MM:SS.FFF')],['amplitude: ',num2str(pos(2))]};

end

