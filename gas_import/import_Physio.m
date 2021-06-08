function [MRTimes2, ID, FRCmL, VdmL, TissuestoreO2mL, TissuestoreCO2mL, VO2mLmin, VCO2mLmin, QmLmin, hBconcentrationgdLBlood, Restingmetabolicscalefactor, ResponseReason] = import_Physio(filename, dataLines)
%IMPORTFILE Import data from a text file
%  [MRTIMES2, ID, FRCML, VDML, TISSUESTOREO2ML, TISSUESTORECO2ML,
%  VO2MLMIN, VCO2MLMIN, QMLMIN, HBCONCENTRATIONGDLBLOOD,
%  RESTINGMETABOLICSCALEFACTOR, RESPONSEREASON] = IMPORTFILE(FILENAME)
%  reads data from text file FILENAME for the default selection.
%  Returns the data as column vectors.
%
%  [MRTIMES2, ID, FRCML, VDML, TISSUESTOREO2ML, TISSUESTORECO2ML,
%  VO2MLMIN, VCO2MLMIN, QMLMIN, HBCONCENTRATIONGDLBLOOD,
%  RESTINGMETABOLICSCALEFACTOR, RESPONSEREASON] = IMPORTFILE(FILE,
%  DATALINES) reads data for the specified row interval(s) of text file
%  FILENAME. Specify DATALINES as a positive scalar integer or a N-by-2
%  array of positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  [MRTimes2, ID, FRCmL, VdmL, TissuestoreO2mL, TissuestoreCO2mL, VO2mLmin, VCO2mLmin, QmLmin, hBconcentrationgdLBlood, Restingmetabolicscalefactor, ResponseReason] = importfile("C:\Users\abhogal\Documents\DATA\MRI_data\APRICOT\APC006\2020-01-21 03;04;07 (APC006)\PhysioParams.txt", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 11-Mar-2020 15:48:45

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 12);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["MRTimes2", "ID", "FRCmL", "VdmL", "TissuestoreO2mL", "TissuestoreCO2mL", "VO2mLmin", "VCO2mLmin", "QmLmin", "hBconcentrationgdLBlood", "Restingmetabolicscalefactor", "ResponseReason"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "ResponseReason", "TrimNonNumeric", true);
opts = setvaropts(opts, "ResponseReason", "ThousandsSeparator", ",");

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
MRTimes2 = tbl.MRTimes2;
ID = tbl.ID;
FRCmL = tbl.FRCmL;
VdmL = tbl.VdmL;
TissuestoreO2mL = tbl.TissuestoreO2mL;
TissuestoreCO2mL = tbl.TissuestoreCO2mL;
VO2mLmin = tbl.VO2mLmin;
VCO2mLmin = tbl.VCO2mLmin;
QmLmin = tbl.QmLmin;
hBconcentrationgdLBlood = tbl.hBconcentrationgdLBlood;
Restingmetabolicscalefactor = tbl.Restingmetabolicscalefactor;
ResponseReason = tbl.ResponseReason;
end