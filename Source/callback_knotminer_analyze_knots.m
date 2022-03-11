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
global d_org;
global dorgbez;
global parameter;

%% get cluster index
tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
if (isempty(tempClusterIndex) || tempClusterIndex == 0)
    disp('Clustering not performed yet. Use KnotMiner -> Show -> Manual Annotation GUI to specify the parameters to use for clustering!');
    return;
end

%% extract cluster ids and number of clusters
clusterIndices = unique(d_org(:, parameters.tempClusterIndex));
numClusters = length(clusterIndices);

%% initalize knot features
knotFeatures = zeros(length(clusterIndices), 3);

%% extract knot features for all features
for i=1:numClusters
    
    %% skip background (0) and noise clusters (-1)
    c = clusterIndices(i);
    if (c <= 0)
        continue;
    end

    %% compute the 3D boundary
    currentIndices = find(d_org(:, tempClusterIndex) == c);
    currentPositions = d_org(currentIndices, 3:5);
    [currentBoundaryPoints, currentVolume] = boundary(currentPositions(:,1), currentPositions(:,2), currentPositions(:,3), 1);

    %% set the knot features
    knotFeatures(i, 1) = length(currentIndices);
    knotFeatures(i, 2) = currentVolume;
    knotFeatures(i, 3) = length(clusterIndices) - 2;
end

%% delete noise and background
knotFeatures = knotFeatures(3:end, :);

%% show quantification figure
fh = figure;
colordef white;
set(fh, 'units', 'normalized', 'color', 'white', 'OuterPosition', [0 0 1 1]);
subplot(2,2,1);
boxplot(knotFeatures(:,1));
ylabel('Cells per Knot');
title(strrep(parameter.projekt.datei, '_', '-'));

subplot(2,2,2);
boxplot(knotFeatures(:,2));

ylabel('Knot Volume');
title(strrep(parameter.projekt.datei, '_', '-'));

subplot(2,2,3);
histogram(knotFeatures(:,1), 'Normalization','probability');
xlabel('Cells per Knot');
ylabel('Frequency (%)');
title(strrep(parameter.projekt.datei, '_', '-'));

subplot(2,2,4);
histogram(knotFeatures(:,2), 'Normalization','probability');

xlabel('Knot Volume');
ylabel('Frequency (%)');
title(strrep(parameter.projekt.datei, '_', '-'));

%% TODO: WRITE RESULT TABLE AS CSV OR SIMILAR
