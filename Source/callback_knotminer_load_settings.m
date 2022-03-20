%%
% KnotMiner.
% Copyright (C) 2022 D. Eschweiler, S. Hermans, D. Kapsokalyvas, J. Stegmaier
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the Liceense at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% Please refer to the documentation for more information about the software
% as well as for installation instructions.
%
% If you use this application for your work, please cite the repository and one
% of the following publications:
%
% TBA
%
%%

global parameters;
global parameter;

%% set default settings path
loadFile = [parameter.projekt.pfad filesep parameter.projekt.datei '_KnotMiner.mat'];

%% load the file
load(loadFile, 'parametersSaved', 'parametersSciXMiner');

%% copy parameters
parametersOld = parameters;
parameters = parametersSaved;
parameters.dirtyFlag = true;

if (~isempty(parametersOld))
    parameters.rawImage = parametersOld.rawImage;
    parameters.mainFigure = parametersOld.mainFigure;
    clear parametersOld;
end
parameter.gui.knotminer = parametersSciXMiner;

%% display success message
disp(['Current settings successfully loaded from ' loadFile]);