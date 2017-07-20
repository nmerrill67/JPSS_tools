function txt = dcUpdateDwellFFT(~, event_obj)
% customizes data cursor object to show times instead of seond from epoch.
% This implementation allows for seeing either time, or frequency in the
% cursor based on the values in the axis

   pos = get(event_obj,'Position');
   
   % check if it is a day value or frequency. Days are going to be over
   % days since 01-01-1958, so that is how I am implementing this
   
   epoch = datenum('01-01-1958', 'mm-dd-yyyy'); % in days
   
   if any(pos(1) > epoch) % we have days 
       txt = {['time: ',datestr(pos(1), 'dd-mmm-yyyy HH:MM:SS.FFF')],['amplitude: ',num2str(pos(2))]};
   else % we have frequency
       txt = {['Frequency: ', num2str(pos(1)), ' (Hz)']; ['T: ', num2str(1/pos(1)), ' (sec) = ', num2str(1/pos(1)/60),...
           ' (min) = ', num2str(1/pos(1)/3600), ' (hr)']; ['amplitude: ',num2str(pos(2))]};
   end
   
end
