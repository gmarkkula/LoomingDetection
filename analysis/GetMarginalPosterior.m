
% Copyright 2020 Gustav Markkula
%
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
%%%%%% 
%
% See README.md in the root folder of the Github repository linked below 
% for more information on how to use this code, and a link to the paper 
% describing the study for which the code was developed. If you use this 
% code for your research, please cite that paper.
%
% Github repository: https://github.com/gmarkkula/LoomingDetectionStudy
% Open Science Framework repository: https://doi.org/10.17605/OSF.IO/KU3H4
%


function  [MMarginalPosterior, MXMeshGrid, varargout] = ...
  GetMarginalPosterior(SMeshGrids, ViMarginalParams)

if length(ViMarginalParams) == 1
  b2DMarginalPosterior = false;
elseif length(ViMarginalParams) == 2
  b2DMarginalPosterior = true;
else
  error('Marginalisation to 1 or 2 dimensions supported only.')
end

nFreeParameters = length(SMeshGrids.SParameter);
% ViMarginalParams = sort(ViMarginalParams);
ViOtherParams = setdiff(1:nFreeParameters, ViMarginalParams);

MXMeshGrid = SMeshGrids.SParameter(ViMarginalParams(1)).MGrid;
if b2DMarginalPosterior
  MYMeshGrid = SMeshGrids.SParameter(ViMarginalParams(2)).MGrid;
end

% start fromthe full posterior
MMarginalPosterior = SMeshGrids.MPosterior;

% remove non-marginal dimensions
for iOtherParam = ViOtherParams
  % mesh grid locations (identical across all not-plotted
  % dimensions so could just use any one element, but taking mean
  % across all of them is easier)
  MXMeshGrid = mean(MXMeshGrid, iOtherParam);
  if b2DMarginalPosterior
    MYMeshGrid = mean(MYMeshGrid, iOtherParam);
  end
  % sum posterior across not-plotted dimensions, to get marginal
  % posterior
  MMarginalPosterior = sum(MMarginalPosterior, iOtherParam);
end

if b2DMarginalPosterior
  varargout{1} = MYMeshGrid;
end