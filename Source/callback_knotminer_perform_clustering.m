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
global parameters; %#ok<GVMIS> 
global d_org; %#ok<GVMIS> 
global dorgbez; %#ok<GVMIS> 

%% perform automatic clustering using k-means or use the manual thresholds
if (parameters.useAutoClustering)

    %% perform clustering using k-means (k=2)
    idx = kmeans(zscore(d_org(:, [parameters.meanIntensityIndex, parameters.densityIndex]), 0, 1), 2);

    %% identify the less bright group and use it as the no-knot group
    meanIntensity1 = mean(d_org(idx == 1, parameters.meanIntensityIndex));
    meanIntensity2 = mean(d_org(idx == 2, parameters.meanIntensityIndex));

    %% set the cluster indices
    if (meanIntensity1 < meanIntensity2)
        parameters.indicesNoKnots = find(idx == 1);
        parameters.indicesKnots = find(idx == 2);
    else
        parameters.indicesNoKnots = find(idx == 2);
        parameters.indicesKnots = find(idx == 1);
    end
else

    %% in manual mode use intensity and density threshold for the separation
    parameters.indicesNoKnots = find((d_org(:,parameters.densityIndex) <= parameters.densityThreshold) | (d_org(:,parameters.meanIntensityIndex) <= parameters.intensityThreshold));
    parameters.indicesKnots = find((d_org(:,parameters.densityIndex) > parameters.densityThreshold) & (d_org(:,parameters.meanIntensityIndex) > parameters.intensityThreshold));
end

%% check if a valid selection of potential knot candidates exists
if (isempty(parameters.indicesKnots))
    disp('Please select knot candidates first using the manual thresholds or the auto threshold, before trying to cluster them!');
    return;
end

%% extract the positional features and scale with the current z-scale
positionFeatures = [callback_hccminer_find_single_feature(dorgbez, 'xpos'), callback_hccminer_find_single_feature(dorgbez, 'ypos'), callback_hccminer_find_single_feature(dorgbez, 'zpos')];
zscale = parameter.gui.knotminer.axialVoxelSize / parameter.gui.knotminer.lateralVoxelSize;
disp(['Lateral voxel size: ' num2str(parameter.gui.knotminer.lateralVoxelSize) ', Axial voxel size: ' num2str(parameter.gui.knotminer.axialVoxelSize) ', z-scale: ' num2str(zscale) '. Select KnotMiner from the dropdown menu and set physical spacing if needed ...']);

positions = squeeze(d_org(parameters.indicesKnots, positionFeatures));
positions(:,3) = positions(:,3) * zscale;

%% perform dbscan clustering using the current parameters
currentClustering = dbscan(d_org(parameters.indicesKnots, parameters.positionIndices), parameters.epsilonDBSCAN, parameters.minPointsDBSCAN);

%% save current clustering results to d_org
parameters.tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
if (isempty(parameters.tempClusterIndex) || parameters.tempClusterIndex == 0)
    d_org(:,end+1) = 0;
    dorgbez = char(dorgbez, 'tempClusterIndex');
    aktparawin;
    parameters.tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
else
    d_org(:, parameters.tempClusterIndex) = 0;
end
d_org(parameters.indicesKnots, parameters.tempClusterIndex) = currentClustering;