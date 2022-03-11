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

%% the key event handler
function callback_knotminer_scrollEventHandler(~,evt)

    %% include global variables
    global parameters; %#ok<GVMIS> 
    global d_org; %#ok<GVMIS> 

    %% set the current slice
    parameters.currentSlice = max(1, min(size(parameters.rawImage,3), parameters.currentSlice - (evt.VerticalScrollCount)));
    
    %% update the visualization
    parameters.dirtyFlag = true;
    callback_knotminer_update_visualization;
end