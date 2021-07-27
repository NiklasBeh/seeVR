% Copyright (C) Alex A. Bhogal, 2021, University Medical Center Utrecht,
% a.bhogal@umcutrecht.nl
% <basicCVR: generates a basic CVR map using baseline and stimulus indices >
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

function [delta] = basicCVR(data, mask, base_idx, stim_idx, savefile, opts)
% Using a defined baseline period and stimulus period, this function
% returns a map of the signal change at each voxel between those epochs.
%
% data: absolute timeseries data (i.e. 4D BOLD MRI dataset that is not 
% expressed in %signal change)
%
% mask: binary mask defining voxels of interest
%
% base_idx: start and end indices defining the baseline period
%
% base_stim: start and end indices defining the stimulus period
%
% opts: options structure containing required variables for this specific
% function; i.e. opts.smoothmap (if input data is not smoothed,
% opts.headers.map, opts.resultsdir
%
% delta: a map of calculated signal changes from baseline

warning('off')
global opts

if isfield(opts,'smoothmap'); else; opts.smoothmap = 1; end

disp('Normalizing to baseline')
data = normTimeseries(data,mask,base_idx);
sBOLD = data; sBOLD(isnan(sBOLD)) = 0;

sBOLD( sBOLD == 0) = NaN;
data = sBOLD; clear sBOLD;

base = nanmean(data(:,:,:,base_idx(1):base_idx(2)),4);
stim = nanmean(data(:,:,:,stim_idx(1):stim_idx(2)),4);
delta = stim - base; delta(~mask) = NaN;

%spatially smooth map (only done if timeseries is not smoothed already)
if opts.smoothmap
delta = smthData(delta , mask, opts);
end
delta(delta > 15) = 0; delta(delta < -15) = 0; %remove large BOLD
delta(isnan(delta)) = 0;
disp('Saving CVR map')
saveImageData(delta,opts.headers.map,opts.resultsdir,savefile, 64);
end

