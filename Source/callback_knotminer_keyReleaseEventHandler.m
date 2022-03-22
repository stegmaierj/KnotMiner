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
function callback_knotminer_keyReleaseEventHandler(~,evt)
    global parameters; %#ok<GVMIS> 
    global parameter; %#ok<GVMIS> 
    global ind_auswahl; %#ok<NUSED> 
    global d_org;
    global dorgbez;

    parameters.xLim = get(gca, 'XLim');
    parameters.yLim = get(gca, 'YLim');
    parameters.mainFigure;
    %% switch between the images of the loaded series
    if (strcmp(evt.Key, 'rightarrow'))


    elseif (strcmp(evt.Key, 'leftarrow'))
        

    %% display raw image
    elseif(strcmp(evt.Character, '1'))
        parameters.visualizationMode = 1;
        parameters.currentParameter = 0;
        parameters.dirtyFlag = true;

    %% display mask image
    elseif(strcmp(evt.Character, '2'))
        parameters.visualizationMode = 2;
        parameters.currentParameter = 1;
        parameters.dirtyFlag = true;

    %% display raw+mask oevrlay image
    elseif(strcmp(evt.Character, '3'))
        parameters.visualizationMode = 3;
        parameters.dirtyFlag = true;

        parameters.showClassification = true;
        parameters.showDetections = false;
        
    %% display secondary channel image
    elseif(strcmp(evt.Character, '4'))
        parameters.visualizationMode = 4;

        parameters.currentParameter = 2;
        parameters.showClassification = false;
        parameters.showDetections = true;
        callback_knotminer_perform_clustering;

        parameters.dirtyFlag = true;
                
    %% display help dialog box
    elseif(strcmp(evt.Character, 'h'))
        callback_knotminer_showHelp;
    
	%% export the csv file and save the current workspace    
    elseif(strcmp(evt.Character, 'p'))
        parameters.currentParameter = mod(parameters.currentParameter+1, 4);
		parameters.dirtyFlag = true;

    %% toggle the color map
    elseif (strcmp(evt.Character, 'x'))
        parameters.axesEqual = ~parameters.axesEqual;
        parameters.dirtyFlag = true;

    %% toggle the color map
    elseif (strcmp(evt.Character, 'c'))
        parameters.showClassification = ~parameters.showClassification;
        parameters.dirtyFlag = true;

    elseif (strcmp(evt.Character, 'd'))
        parameters.showNoiseDetections = ~parameters.showNoiseDetections;
        parameters.dirtyFlag = true;

    elseif (strcmp(evt.Character, 'e'))
        callback_knotminer_export_results;

    %% toggle add/delete/deselect mode
    elseif (strcmp(evt.Character, 'f'))
        parameters.showDetections = ~parameters.showDetections;
        parameters.dirtyFlag = true;

    elseif (strcmp(evt.Character, 'i'))
        parameters.showInfo = ~parameters.showInfo;

    elseif (strcmp(evt.Character, '+') || strcmp(evt.Character, '-'))
        
        if (parameters.isInSelectionMode == true)
            disp('Region selection still ongoing, please finish current region, first!');
            return;
        end
        
        if (isfield(parameters, 'selectedRegion'))
            parameters.selectedRegion
            delete(parameters.selectedRegion);
        end
        parameters.isInSelectionMode = true;
        parameters.selectedRegion = imfreehand;

        if (~isempty(parameters.selectedRegion))

            selectionMask = parameters.selectedRegion.createMask;
            
            currentPositions = d_org(:, 3:5);
            selectedIndices = zeros(size(currentPositions,1), 1);
            for i=1:size(currentPositions,1)
    
                isInMask = selectionMask(round(currentPositions(i,2)), round(currentPositions(i,1))) > 0;
                isInZRange = (round(currentPositions(i,3)) >= (parameters.currentSlice - parameters.zSliceRange) && round(currentPositions(i,3)) <= (parameters.currentSlice + parameters.zSliceRange));
    
                if ((isInMask && parameters.maximumProjection == true) || ...
                    (isInMask && isInZRange && parameters.maximumProjection == false))
                    selectedIndices(i) = 1;
                end
            end
    
            if (strcmp(evt.Character, '+'))
                parameters.includeIndices = unique([parameters.includeIndices; find(selectedIndices)]);
                parameters.excludeIndices(ismember(parameters.excludeIndices, parameters.includeIndices)) = []; 
            else
                parameters.excludeIndices = unique([parameters.excludeIndices; find(selectedIndices)]);
                parameters.includeIndices(ismember(parameters.includeIndices, parameters.excludeIndices)) = [];
            end
    
            delete(parameters.selectedRegion);
            parameters.isInSelectionMode = false;
            
            callback_knotminer_perform_clustering;
            parameters.dirtyFlag = true;
        else
            disp('No region selected, skipping...');
        end

    %% toggle info text
    elseif (strcmp(evt.Character, 'a'))
        %% AUTO PARAMETERS TODO;
        parameters.useAutoClustering = ~parameters.useAutoClustering;
        callback_knotminer_perform_clustering;
        parameters.dirtyFlag = true;

    %% toggle info text
    elseif (strcmp(evt.Character, 'v'))
        if (parameters.visualizationMode == 1)
            parameter.gui.merkmale_und_klassen.ind_em = parameters.meanIntensityIndex;
            callback_knotminer_show_3D_scatter_plot;
        elseif (parameters.visualizationMode == 2)
            parameter.gui.merkmale_und_klassen.ind_em = parameters.densityIndex;
            callback_knotminer_show_3D_scatter_plot;
        elseif (parameters.visualizationMode == 4)
            parameter.gui.merkmale_und_klassen.ind_em = parameters.tempClusterIndex;
            callback_knotminer_show_3D_scatter_plot;
            colormap turbo;
        end

    elseif (strcmp(evt.Character, 'w'))
        parameters.useVolumeWeightedDensity = ~parameters.useVolumeWeightedDensity;

        if (parameters.useVolumeWeightedDensity)
            parameters.densityIndex = callback_knotminer_find_single_feature(dorgbez, 'vol-weighted-density-r=20');
        else
            parameters.densityIndex = callback_knotminer_find_single_feature(dorgbez, 'density-r=20');
        end
        parameters.dirtyFlag = true;

        %% toggle info text
    elseif (strcmp(evt.Character, 'q'))
        callback_knotminer_analyze_knots;
    
	%% set current cells as manually checked
	elseif (strcmp(evt.Key, 'uparrow'))

        parameters.intensityStep = parameter.gui.knotminer.parameterStepSize;
        parameters.densityStep = parameter.gui.knotminer.parameterStepSize;

        if (parameters.currentParameter == 0)
            parameters.intensityThreshold = max(0, min(parameters.intensityThreshold + parameters.intensityStep, 255));
        elseif (parameters.currentParameter == 1)
            parameters.densityThreshold = max(0, parameters.densityThreshold + parameters.densityStep);
        elseif (parameters.currentParameter == 2)
            parameters.epsilonDBSCAN = max(0, parameters.epsilonDBSCAN + 1);
            callback_knotminer_perform_clustering;
        else
            parameters.minPointsDBSCAN = max(1, parameters.minPointsDBSCAN + 1);
  

            callback_knotminer_perform_clustering;
        end

        parameters.dirtyFlag = true;

    elseif (strcmp(evt.Key, 'downarrow'))

        parameters.intensityStep = parameter.gui.knotminer.parameterStepSize;
        parameters.densityStep = parameter.gui.knotminer.parameterStepSize;

        if (parameters.currentParameter == 0)
            parameters.intensityThreshold = max(0, min(parameters.intensityThreshold - parameters.intensityStep, 255));
        elseif (parameters.currentParameter == 1)
            parameters.densityThreshold = max(0, parameters.densityThreshold - parameters.densityStep);
        elseif (parameters.currentParameter == 2)
            parameters.epsilonDBSCAN = max(0, parameters.epsilonDBSCAN - 1);
            callback_knotminer_perform_clustering;
        else            
            parameters.minPointsDBSCAN = max(1, parameters.minPointsDBSCAN - 1);
            callback_knotminer_perform_clustering;
        end
        parameters.dirtyFlag = true;

    %% set current cells as manually checked
	elseif (strcmp(evt.Character, 'm'))

        parameters.maximumProjection = ~parameters.maximumProjection;
        parameters.dirtyFlag = true;

    %% set current cells as manually checked
	elseif (strcmp(evt.Character, 's'))

        callback_knotminer_save_settings;
        
    %% set current cells as manually checked
	elseif (strcmp(evt.Character, 'l'))

        callback_knotminer_load_settings;

    %% set current cells as manually checked
	elseif (strcmp(evt.Character, '.'))
        parameters.zSliceRange = min(size(parameters.rawImage, 3), parameters.zSliceRange + 1);
        parameters.dirtyFlag = true;

    %% set current cells as manually checked
	elseif (strcmp(evt.Character, ','))
        parameters.zSliceRange = max(0, parameters.zSliceRange - 1);
        parameters.dirtyFlag = true;
    end

    %% update the visualization
    callback_knotminer_update_visualization;
end

