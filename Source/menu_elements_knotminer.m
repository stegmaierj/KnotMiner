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

function elements = menu_elements_knotminer(parameter)

newcolumn = parameter.allgemein.uihd_column;
mc = 1;

%main element in the menu
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
%the tag must be unique
elements(mc).tag = 'MI_knotminer';
%name in the menu
elements(mc).name = 'KnotMiner';
%list of the functions in the menu, -1 is a separator
elements(mc).menu_items = {'MI_KnotMiner_Import', 'MI_KnotMiner_Show', 'MI_KnotMiner_Process'};
%is always enabled if a project exists
%further useful option: elements(mc).freischalt = {'1'}; %is always enabled
elements(mc).freischalt = {'1'}; 

%%%%%%%% IMPORT %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Import';
elements(mc).tag = 'MI_KnotMiner_Import';
elements(mc).menu_items = {'MI_KnotMiner_Import_Project'};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Import New Image/Mask Pair';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_knotminer_import_to_scixminer;';
elements(mc).tag = 'MI_KnotMiner_Import_Project';
%is enabled if at least one time series exist
elements(mc).freischalt = {};


%%%%%%%%%% SHOW %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Show';
elements(mc).tag = 'MI_KnotMiner_Show';
elements(mc).menu_items = {'MI_KnotMiner_ShowScatterPlots', 'MI_KnotMiner_AnalyzeKnots', 'MI_KnotMiner_ShowAnnotationGUI'};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = '3D Scatter Plot';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_knotminer_show_3D_scatter_plot;';
elements(mc).tag = 'MI_KnotMiner_ShowScatterPlots';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Knot Analysis';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_knotminer_analyze_knots;';
elements(mc).tag = 'MI_KnotMiner_AnalyzeKnots';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Annotation GUI';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_knotminer_show_annotation_gui;';
elements(mc).tag = 'MI_KnotMiner_ShowAnnotationGUI';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};



%%%%%%% PROCESS %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Process';
elements(mc).tag = 'MI_KnotMiner_Process';
elements(mc).menu_items = {'MI_KnotMiner_ComputeDensity', 'MI_KnotMiner_SelectFeatureRange'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Compute Density Feature';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_knotminer_compute_density_feature;';
elements(mc).tag = 'MI_KnotMiner_ComputeDensity';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Select Feature Range';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_knotminer_select_feature_range;';
elements(mc).tag = 'MI_KnotMiner_SelectFeatureRange';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};
