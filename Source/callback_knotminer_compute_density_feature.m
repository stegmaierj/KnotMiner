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

%% setup parameters
radius = parameter.gui.knotminer.neighborhoodRadius;
zscale = parameter.gui.knotminer.axialVoxelSize / parameter.gui.knotminer.lateralVoxelSize;
positionFeatures = [callback_hccminer_find_single_feature(dorgbez, 'xpos'), callback_hccminer_find_single_feature(dorgbez, 'ypos'), callback_hccminer_find_single_feature(dorgbez, 'zpos')];

disp(['Lateral voxel size: ' num2str(parameter.gui.knotminer.lateralVoxelSize) ', Axial voxel size: ' num2str(parameter.gui.knotminer.axialVoxelSize) ', z-scale: ' num2str(zscale) '. Select KnotMiner from the dropdown menu and set physical spacing if needed ...']);

%% compute the neighbor indices
disp(['Computing neighbor indices within a radius of r=' num2str(radius) ' ...']);

validIndices = find(d_org(:,1) ~= 0);
positions = squeeze(d_org(validIndices, positionFeatures));
positions(:,3) = positions(:,3) * zscale;

currentKDTree = KDTreeSearcher(positions);
idx = rangesearch(currentKDTree, positions, radius);

%% add new entry to d_org
d_org(:,end+1) = 0;
newFeatureIndex = size(d_org,2);
dorgbez = char(dorgbez(1:end,:), ['density-r=' num2str(radius)]);
aktparawin;

%% set the density based on the number of neighbors within the given radius
disp('Computing density ...');
for j=generate_rowvector(validIndices)
    d_org(j,newFeatureIndex) = length(idx{j});
end
disp('Done.');
