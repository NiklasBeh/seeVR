% Copyright (C) Alex A. Bhogal, 2021, University Medical Center Utrecht,
% a.bhogal@umcutrecht.nl
% <filtRegressor: correlates a series of regressors with a reference signal >
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
% *************************************************************************
% This function correlates a series of nuisance regressors (typically 
% motion parameters derived from realignment) with the input probe. Based
% on the correlation threshold (opts.motioncorr, nuisance regressors are
% seperated.
%
% nuisance: an array of nuisance regressors (i.e. motion and derivatives,
% HR, respiratory etc.)
%
% probe: timeseries to which nuisance parameters are correlated
%
% opts: options structure containing required variables for this specific
% function; i.e. opts.motioncorr
%
% innuisance: regressors having a correlation lower than the threshold
%
% outnuisance: regressors having a correlation higher than the threshold
function [innuisance outnuisance] = filtRegressor(nuisance, probe, opts)


warning('off');
global opts
if isfield(opts,'motioncorr'); else; opts.motioncorr = 0.3; end

test1 = nuisance(1,:); test2 = nuisance(:,1);
if length(test1) > length(test2); nuisance = nuisance'; end; clear test1 test2
if iscolumn(probe)==0; probe = probe'; end

%remove nuisance correlating with probe
autoCorr = abs(corr(probe,nuisance)); 
autoCorr(autoCorr < opts.motioncorr) = 0; autoCorr(autoCorr > 0) = 1; %removes anything with more than weak correlation
%remove highly correlated nuisance regressors to preserve signal response
index = ([1:1:size(nuisance,2)]).*autoCorr; 
keep = index; keep(keep == 0) = [];
leave = index; leave = find(index == 0);

innuisance = nuisance; outnuisance = nuisance;

innuisance(:,keep) = [];
outnuisance(:,leave) = [];

% Plot
figure; 
subplot(4,1,1); plot(opts.xdata, probe); 
title('reference signal'); xlabel('time(s)'); 
xlim([0 length(motion)]);
set(gcf, 'Units', 'pixels', 'Position', [200, 500, 600, 800]);
subplot(4,1,2); plot(opts.xdata, nuisance); 
title('motion parameters & derivatives'); xlabel('time(s)'); 
xlim([0 length(motion)]);
subplot(4,1,3); plot(opts.xdata, keep); 
title('nuisance < r-threshold'); xlabel('time(s)');
xlim([0 length(motion)]);
subplot(4,1,4); plot(opts.xdata, leave); 
title('nuisance > r-threshold'); xlabel('time(s)');
xlim([0 length(motion)]);

end