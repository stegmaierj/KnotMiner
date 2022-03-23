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

%% add functionality for tiff reading
addpath([parameter.allgemein.secondary_gaitcad_path filesep 'application_specials' filesep 'KnotMiner' filesep 'toolbox' filesep 'saveastiff_4.3' filesep]);

%% initialize the global settings variable
clear parameters;
global parameters; %#ok<GVMIS> 
global zgf_y_bez; %#ok<NUSED,GVMIS> 
global bez_code; %#ok<NUSED,GVMIS> 
global code_alle; %#ok<NUSED,GVMIS> 
global d_org; %#ok<GVMIS>
global ind_auswahl; %#ok<NUSED> 
global parameter; %#ok<GVMIS> 

%% load previous parameters/selection
knotMinerSettingsFile = [parameter.projekt.pfad filesep parameter.projekt.datei '_KnotMiner.mat'];
loadPreviousSettings = false;
if (isfile(knotMinerSettingsFile))
    
    %% ask if the user acqually wants to load a new project
    answer = questdlg('Load previous settings?',  'Load?', 'Yes','No', 'Yes');
    if (strcmp(answer, 'Yes'))
        callback_knotminer_load_settings;
        aktparawin;
        loadPreviousSettings = true;
    end
end

%% preload image files if not done yet
if (~isfield(parameters, 'rawImage') || isempty(parameters.rawImage))

    %% load the image files
    if (~isfield(parameters, 'rawImageFile') || ~isstring(parameters.rawImageFile) || ~isfile(parameters.rawImageFile))
        [rawImageFile, rawImageFolder] = uigetfile({'*.tif;*.tiff;*.TIF;*.TIFF', 'Raw Image (*.tif;*.tiff;*.TIF;*.TIFF)'}, 'Please select the raw image (*.tif)!');
        
        if (rawImageFile == 0)
            disp('No valid input file specified. Closing the annotation GUIs ...');
            return;
        end
        
        parameters.rawImageFile = [rawImageFolder rawImageFile];
    end
    
    parameters.rawImage = double(loadtiff(parameters.rawImageFile));

    minValue = min(parameters.rawImage(:));
    maxValue = max(parameters.rawImage(:));

    parameters.rawImage = (parameters.rawImage - minValue) / (maxValue - minValue);
    parameters.maximumProjectionRaw = max(parameters.rawImage, [], 3);
end

if (loadPreviousSettings == false)
    %% get indices of the required features
    parameters.positionIndices = [callback_knotminer_find_single_feature(dorgbez, 'xpos'), callback_knotminer_find_single_feature(dorgbez, 'ypos'), callback_knotminer_find_single_feature(dorgbez, 'zpos')];
    parameters.meanIntensityIndex = callback_knotminer_find_single_feature(dorgbez, 'MeanIntensity');
    parameters.densityIndex = callback_knotminer_find_single_feature(dorgbez, 'density-r=20');
    
    %% compute density if it doesn't exist yet
    if (isempty(parameters.densityIndex) || parameters.densityIndex == 0)
        callback_knotminer_compute_density_feature;
        parameters.densityIndex = callback_knotminer_find_single_feature(dorgbez, 'density-r=20');
    end
    
    %% use k-means to automatically identify good starting values for the two thresholds
    idxMeanIntensity = kmeans(zscore(d_org(:, [parameters.meanIntensityIndex]), 0, 1), 2);
    idxDensity = kmeans(zscore(d_org(:, [parameters.densityIndex]), 0, 1), 2);
    
    %% initialize new variable for the clustering
    parameters.tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
    if (isempty(parameters.tempClusterIndex) || parameters.tempClusterIndex == 0)
        d_org(:,end+1) = 0;
        dorgbez = char(dorgbez, 'tempClusterIndex');
        aktparawin;
        parameters.tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
    end
    
    %% initialize the settings
    parameters.visualizationMode = 1;
    parameters.colormapIndex = 1;
    parameters.markerSize = 30;
    parameters.gamma = 1;
    parameters.axesEqual = true;
    parameters.fontSize = 16;
    parameters.dirtyFlag = true;
    parameters.showInfo = false;
    parameters.maximumProjection = true;
    parameters.zSliceRange = 0;
    
    parameters.isInSelectionMode = false;
    parameters.currentSlice = 1;
    parameters.currentParameter = 0;
    parameters.densityThreshold = max(min(d_org(idxDensity == 1, parameters.densityIndex)), min(d_org(idxDensity == 2, parameters.densityIndex)));
    parameters.intensityThreshold = max(min(d_org(idxMeanIntensity == 1, parameters.meanIntensityIndex)), min(d_org(idxMeanIntensity == 2, parameters.meanIntensityIndex)));
    parameters.useAutoClustering = false;
    parameters.showClassification = true;
    parameters.showDetections = false;
    parameters.showNoiseDetections = true;
    parameters.intensityStep = 10;
    parameters.densityStep = 1;
    parameters.minPointsDBSCAN = 4;
    parameters.epsilonDBSCAN = 12;
    parameters.showParameterPanel = true;
    parameters.useVolumeWeightedDensity = false;
    parameters.infoLabel = [];
    parameters.showInfo = false;
    
    parameters.includeIndices =[];
    parameters.excludeIndices =[];
end

%% open the main figure
parameters.mainFigure = figure;
set(parameters.mainFigure, 'units', 'normalized', 'color', 'black', 'OuterPosition', [0 0 1 1]);

%% mouse, keyboard events and window title
set(parameters.mainFigure, 'WindowButtonDownFcn', @callback_knotminer_clickEventHandler);
set(parameters.mainFigure, 'WindowButtonMotionFcn', @callback_knotminer_moveEventHandler);
set(parameters.mainFigure, 'WindowScrollWheelFcn', @callback_knotminer_scrollEventHandler);
set(parameters.mainFigure, 'KeyReleaseFcn', @callback_knotminer_keyReleaseEventHandler);

%% updateVisualization
callback_knotminer_update_visualization;