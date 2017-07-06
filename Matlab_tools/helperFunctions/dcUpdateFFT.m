function txt = dcUpdateFFT(~, event_obj)
% customizes data cursor object to show times instead of seond from epoch
   pos = get(event_obj,'Position');
   txt = {['Frequency: ', num2str(pos(1)), ' (Hz)']; ['T: ', num2str(1/pos(1)), ' (sec) = ', num2str(1/pos(1)/60),...
       ' (min) = ', num2str(1/pos(1)/3600), ' (hr)']; ['amplitude: ',num2str(pos(2))]};

end

