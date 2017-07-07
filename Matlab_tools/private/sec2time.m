function elapsedSec = sec2time( seconds, days, epoch )
%   Converts a vector of seconds to a vector of total elapsed seconds
%   Works especially well for time vectors in seconds where new days begin
%   (at zero seconds)
%   seconds is the vector of seconds 
%   days is vector of days since 01-01-58 epoch
%   epoch (days) - days since 01-01-1958 converted to matlab's epoch of 00-00-0000


epochedSecs = seconds + (days + epoch)*86400; % now seconds is seconds since the year 00-00-0000
elapsedSec = epochedSecs - epochedSecs(1); % now elapsed secs

