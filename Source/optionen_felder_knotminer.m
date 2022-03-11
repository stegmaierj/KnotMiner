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

function felder = optionen_felder_knotminer

fc = 1;
felder(fc).name = 'KnotMiner';
felder(fc).subfeld = [];
felder(fc).subfeldbedingung = [];
felder(fc).visible = [];
felder(fc).in_auswahl = 1;

% BEGIN: DO NOT CHANGE THIS%PART%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Element: Optionen  
felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_Optionen';
felder(fc).visible(end).pos = [300 510];
felder(fc).visible(end).bez_pos_rel = [-280 -3];
% END: DO NOT CHANGE THIS%PART%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_knotminer_NeighborhoodRadius';
felder(fc).visible(end).pos = [300 480];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_knotminer_LateralVoxelSize';
felder(fc).visible(end).pos = [300 450];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_knotminer_AxialVoxelSize';
felder(fc).visible(end).pos = [300 420];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_knotminer_ParameterStepSize';
felder(fc).visible(end).pos = [300 390];
felder(fc).visible(end).bez_pos_rel = [-280 -3];
