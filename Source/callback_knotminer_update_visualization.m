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

%% include global variables
global parameter; %#ok<GVMIS> 
global parameters; %#ok<GVMIS> 
global d_org; %#ok<GVMIS> 
global dorgbez; %#ok<GVMIS> 
global d_orgs; %#ok<GVMIS> 
global zgf_y_bez; %#ok<GVMIS> 
global bez_code; %#ok<GVMIS>

%% only update if anything changed
if (parameters.dirtyFlag == true)
    
    %% open figure or set to focus
    figure(parameters.mainFigure); clf; hold on;
    set(gca, 'Units', 'normalized', 'Position', [0,0,1,1]);
    set(gca, 'YDir', 'reverse');
    set(gca, 'Color', 'k')

    %% get the current raw image either as projection or as slice
    if (parameters.maximumProjection == true)
        currentImage = parameters.maximumProjectionRaw;
    else
        if (parameters.zSliceRange == 0)
            currentImage = parameters.rawImage(:,:,parameters.currentSlice);
        else
            sliceRange = max(1, parameters.currentSlice - parameters.zSliceRange):(min(size(parameters.rawImage, 3), parameters.currentSlice + parameters.zSliceRange));
            currentImage = max(parameters.rawImage(:,:,sliceRange), [], 3);
        end
    end
    imagesc(cat(3, currentImage, currentImage, currentImage));

    %% copy the current in/exclude indices
    currentIncludeIndices = parameters.includeIndices;
    currentExcludeIndices = parameters.excludeIndices;

    %% find the current indices
    validIndices = 1:size(d_org,1);
    if (parameters.maximumProjection == false)
        validIndices = find(abs(round(d_org(:,parameters.positionIndices(3))) - parameters.currentSlice) <= parameters.zSliceRange);

        currentIncludeIndices((abs(round(d_org(currentIncludeIndices,parameters.positionIndices(3))) - parameters.currentSlice) > parameters.zSliceRange)) = [];
        currentExcludeIndices((abs(round(d_org(currentExcludeIndices,parameters.positionIndices(3))) - parameters.currentSlice) > parameters.zSliceRange)) = [];
    end

    %% visualize detections and raw data depending on the mode    
    if (parameters.visualizationMode == 1)
        
        %% mode 1: show mean intensity
        visualizationModeString = 'Mean Intensity';
        featureValues = d_org(validIndices,parameters.meanIntensityIndex);
        caxis([0, max(d_org(:,parameters.meanIntensityIndex))]);

        %% perform knot classification only using mean intensity feature
        if (parameters.showClassification)
            indicesNoKnots = intersect(validIndices, find(d_org(:,parameters.meanIntensityIndex) <= parameters.intensityThreshold));
            indicesKnots = intersect(validIndices, find(d_org(:,parameters.meanIntensityIndex) > parameters.intensityThreshold));

            %% add manually (de)selected knot candidates
            indicesKnots(ismember(indicesKnots, currentExcludeIndices)) = [];
            indicesNoKnots(ismember(indicesNoKnots, currentIncludeIndices)) = [];
            indicesKnots = unique([indicesKnots; currentIncludeIndices]);
            indicesNoKnots = unique([indicesNoKnots; currentExcludeIndices]);
        end
        caxis([0, max(d_org(:,parameters.meanIntensityIndex))]);
        colormap turbo;

    elseif (parameters.visualizationMode == 2)

        %% mode 2: show density intensity
        if (parameters.useVolumeWeightedDensity == false)
            visualizationModeString = 'Density';
        else
            visualizationModeString = 'Density (Vol. Weighted)';
        end

        %% get the feature values
        featureValues = d_org(validIndices,parameters.densityIndex);

        %% perform knot classification only using density feature
        if (parameters.showClassification)
            indicesNoKnots = intersect(validIndices, find(d_org(:,parameters.densityIndex) <= parameters.densityThreshold));
            indicesKnots = intersect(validIndices, find(d_org(:,parameters.densityIndex) > parameters.densityThreshold));

            %% add manually (de)selected knot candidates
            indicesKnots(ismember(indicesKnots, currentExcludeIndices)) = [];
            indicesNoKnots(ismember(indicesNoKnots, currentIncludeIndices)) = [];
            indicesKnots = unique([indicesKnots; currentIncludeIndices]);
            indicesNoKnots = unique([indicesNoKnots; currentExcludeIndices]);
        end
        caxis([0, max(d_org(:,parameters.densityIndex))]);
        colormap turbo;

    elseif (parameters.visualizationMode == 3)

        %% mode 3: show knot classification
        visualizationModeString = 'Knot Candidate Classification (Manual)';
        indicesNoKnots = intersect(validIndices, find((d_org(:,parameters.densityIndex) <= parameters.densityThreshold) | (d_org(:,parameters.meanIntensityIndex) <= parameters.intensityThreshold)));
        indicesKnots = intersect(validIndices, find((d_org(:,parameters.densityIndex) > parameters.densityThreshold) & (d_org(:,parameters.meanIntensityIndex) > parameters.intensityThreshold)));

        %% add manually (de)selected knot candidates    
        indicesKnots(ismember(indicesKnots, currentExcludeIndices)) = [];
        indicesNoKnots(ismember(indicesNoKnots, currentIncludeIndices)) = [];
        indicesKnots = unique([indicesKnots; currentIncludeIndices]);
        indicesNoKnots = unique([indicesNoKnots; currentExcludeIndices]);

    else
        %% mode 3: show knot classification
        visualizationModeString = 'Knot Clustering';
        parameters.tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
        if (isempty(parameters.tempClusterIndex) || parameters.tempClusterIndex == 0)
            callback_knotminer_perform_clustering;
        end

        %% perform knot classification only using both features
        indicesNoKnots = intersect(validIndices, find(d_org(:, parameters.tempClusterIndex) <= 0));
        indicesKnots = intersect(validIndices, find(d_org(:, parameters.tempClusterIndex) > 0));

        %% add manually (de)selected knot candidates
        indicesKnots(ismember(indicesKnots, currentExcludeIndices)) = [];
        indicesNoKnots(ismember(indicesNoKnots, currentIncludeIndices)) = [];
        indicesKnots = unique([indicesKnots; currentIncludeIndices]);
        indicesNoKnots = unique([indicesNoKnots; currentExcludeIndices]);

        featureValuesKnots = d_org(indicesKnots, parameters.tempClusterIndex);
        featureValuesNoKnots = d_org(indicesNoKnots, parameters.tempClusterIndex);
        if (max(d_org(:,parameters.tempClusterIndex)) ~= 0)
            caxis([0, max(d_org(:,parameters.tempClusterIndex))]);
        end
        colormap lines;
    end

    %% show current classification
    if (parameters.showClassification)
        plot(d_org(indicesKnots, parameters.positionIndices(1)), d_org(indicesKnots, parameters.positionIndices(2)), 'og');
            
        if (parameters.showNoiseDetections == true)
            plot(d_org(indicesNoKnots, parameters.positionIndices(1)), d_org(indicesNoKnots, parameters.positionIndices(2)), 'or');
        end
    end

    %% show current detections
    if (parameters.showDetections && parameters.visualizationMode ~= 3)
        if (parameters.visualizationMode < 3)
            scatter(d_org(validIndices,parameters.positionIndices(1)), d_org(validIndices,parameters.positionIndices(2)), parameters.markerSize, featureValues, 'filled');
        else
            if (parameters.showNoiseDetections)
                scatter(d_org(indicesNoKnots,parameters.positionIndices(1)), d_org(indicesNoKnots,parameters.positionIndices(2)), parameters.markerSize, featureValuesNoKnots, 'filled');
            end
            scatter(d_org(indicesKnots,parameters.positionIndices(1)), d_org(indicesKnots,parameters.positionIndices(2)), parameters.markerSize, featureValuesKnots, 'filled');
        end
    end

    %% reset the axis
    imageSize = size(parameters.rawImage);
    axis([0, imageSize(1), 0, imageSize(2)]);

    if (parameters.axesEqual)
        axis equal;
    end

    %% show the group ids and counts
    if (parameters.showParameterPanel == true)

        %% parameters
        textColors = {'white', 'red'};
        text('String', ['Intensity Thresh.: ' num2str(parameters.intensityThreshold)], 'FontSize', parameters.fontSize, 'Color', textColors{(parameters.currentParameter == 0)+1}, 'Units', 'normalized', 'Position', [0.01 0.98], 'Background', 'black');
        text('String', ['Density Thresh.: ' num2str(parameters.densityThreshold)], 'FontSize', parameters.fontSize, 'Color', textColors{(parameters.currentParameter == 1)+1}, 'Units', 'normalized', 'Position', [0.01 0.94], 'Background', 'black');
        text('String', ['Epsilon: ' num2str(parameters.epsilonDBSCAN)], 'FontSize', parameters.fontSize, 'Color', textColors{(parameters.currentParameter == 2)+1}, 'Units', 'normalized', 'Position', [0.01 0.90], 'Background', 'black');
        text('String', ['MinPoints: ' num2str(parameters.minPointsDBSCAN)], 'FontSize', parameters.fontSize, 'Color', textColors{(parameters.currentParameter == 3)+1}, 'Units', 'normalized', 'Position', [0.01 0.86], 'Background', 'black');

        %% visualization mode and current slice
        currentSliceString = 'Max. Projection';
        if (parameters.maximumProjection == false)
            currentSliceString = sprintf('%i / %i (+/- %i Slices)', parameters.currentSlice, size(parameters.rawImage, 3), parameters.zSliceRange);
        end
        text('String', ['Slice: ' currentSliceString], 'FontSize', parameters.fontSize, 'Color', textColors{1}, 'Units', 'normalized', 'Position', [0.01 0.04], 'Background', 'black');
        text('String', ['Vis. Mode: ' visualizationModeString], 'FontSize', parameters.fontSize, 'Color', textColors{1}, 'Units', 'normalized', 'Position', [0.01 0.12], 'Background', 'black');

        if (parameters.useAutoClustering == true)
            text('String', 'Clustering Mode: Auto (k-Means)', 'FontSize', parameters.fontSize, 'Color', textColors{1}, 'Units', 'normalized', 'Position', [0.01 0.08], 'Background', 'black');
        else
            text('String', 'Clustering Mode: Manual (Mean Int. / Density)', 'FontSize', parameters.fontSize, 'Color', textColors{1}, 'Units', 'normalized', 'Position', [0.01 0.08], 'Background', 'black');
        end
    end

    parameters.infoLabel = text('String', 'Info Label', 'FontSize', parameters.fontSize, 'Color', textColors{1}, 'Background', 'black');
    parameters.infoPoint = plot(0,0, '*r');

    %% set dirty flag to false
    parameters.dirtyFlag = false;
end