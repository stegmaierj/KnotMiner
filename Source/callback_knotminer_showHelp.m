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

helpText = {'1;2;3;4: Toggles the visualization of intensity, density, int.+dens., clustering'; ...
            'Up Arrow: Inrease current parameter value'; ...
            'Down Arrow: Decrease current parameter value'; ...
            'A: Perform automatic parameter identification';...
            'C: Show current classification';...
            'D: Show/hide detections below the threshold or noise clusters'; ...
            'E: Export results for the current parameters'; ...
            'F: Show current feature values';...
            'I: Show/hide info for detection closest to the mouse cursor';...
            'L: Load previous parameter settings and manual selection';...
            'M: Toggle max. projection vs. slices';...
            'O: Open previous parameter settings and manual selection';...
            'P: Toggle parameter';...
            'Q: Show quantification of current clustering';...
            'S: Save current parameter settings and manual selection';...
            'V: Show scatter plot of the current clustering';...
            'W: Toggle using volume-weighted or normal density';...
            'X: Toggle the aspect ratio of the aXes'; ...   
            '+/-: Include/exclude cells via freehand selection tool (e.g., helpful if not all cells can be selected via threshold).'; ...
            ',/.: Increase/decrease the numer of z-slices to be displayed when in slice mode.'; ...
            'H: Show this help dialog so you probably already know about this button :-)'; ...
            'Wheel Up/Down: Scroll through stack (only effective in slice mode)'; ...
            '';...
            'Hint: In case key presses show no effect, left click once on the image and try hitting the button again. This only happens if the window loses the focus.'};

helpdlg(helpText);