% YQMD retrievs the year, quarter, month, or day of a (vector of) serial dates.
% This is used for versions of Matlab prior to R2013a, before the 'year',
% 'quarter', 'month', and 'day' commands were introduced in Matlab.
%
% Usage: d = yqmd(d,type)
%
% type must be one of the following: 'year', 'quarter', 'month' or 'm',
% 'day', 'hour', 'minute', 'second', or abbreviations thereof.
%
% NOTE: This file is part of the X-13 toolbox.
%
% Author : Yvan Lengwiler
% Date   : 2015-07-20

function  d = yqmd(d,type)
    d = datevec(d);
    if strcmp(type,'m'); type = 'month'; end
    legal = {'year','month','day','hour','minute','second','quarter'};
    type = validatestring(type,legal);  % check for valid type
    type = find(ismember(legal,type));  % determine position
    if type == numel(legal);            % 'quarter' (last entry of legal)
        d = d(:,2);
        d = floor((d-1)/3) + 1;
    else                                % all other types
        d = d(:,type);
    end
end
