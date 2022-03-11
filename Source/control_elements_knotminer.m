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

function els = control_elements_knotminer(parameter)
% function els = control_elements_knotminer(parameter)
%
% 
% function els = control_elements_knotminer
% defines all control elements (checkboxes, listboxes, edit boxes for the package)
% the visualization is done later by optionen_felder_package
% 
% 
%
% The function control_elements_knotminer is part of the MATLAB toolbox SciXMiner. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 15-Aug-2016 11:31:19
% 
% This program is free software; you can redistribute it and/or modify,
% it under the terms of the GNU General Public License as published by 
% the Free Software Foundation; either version 2 of the License, or any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along with this program;
% if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
% You will find further information about SciXMiner in the manual or in the following conference paper:
% 
% 
% Please refer to this paper, if you use SciXMiner for your scientific work.

els = [];

%number of the handle - added as the last column for the handle matrix 
newcolumn = parameter.allgemein.uihd_column;


%%%%%%%%%%%%%%%%%%%%%%%
% knotminer for the second control element (here: a edit field for numbers)
ec = 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_knotminer_NeighborhoodRadius';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Neighborhood Radius';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.knotminer.neighborhoodRadius';
%default value at the start
els(ec).default = 20;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {1, Inf};
%help text in the context menu
els(ec).tooltext = 'Radius used for computing neighborhood-related measures like density and variance';
%callback for any action at the element, can be empty
%the function should be exist in the path of the knotminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% knotminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_knotminer_LateralVoxelSize';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Lateral Voxel Size';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.knotminer.lateralVoxelSize';
%default value at the start
els(ec).default = 1;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 0;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, Inf};
%help text in the context menu
els(ec).tooltext = 'Lateral voxel size in microns.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the knotminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% knotminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_knotminer_AxialVoxelSize';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Axial Voxel Size';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.knotminer.axialVoxelSize';
%default value at the start
els(ec).default = 1;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 0;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, Inf};
%help text in the context menu
els(ec).tooltext = 'Axial voxel size in microns.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the knotminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;
