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

%% start counter
tic;

outputPath = [parameter.projekt.pfad filesep 'Results' filesep];
if (~isfolder(outputPath)); mkdir(outputPath); end

%% preload image files if not done yet
if (~isfield(parameters, 'segImage') || isempty(parameters.segImage))
    %% load the image files
    [segImageFile, segImageFolder] = uigetfile({'*.tif;*.tiff;*.TIF;*.TIFF', 'Segmentation Image (*.tif;*.tiff;*.TIF;*.TIFF)'}, 'Please select the segmented image (*.tif)!');
    parameters.segImage = loadtiff([segImageFolder segImageFile]);
end

%% get the position features
positionFeatures = [callback_knotminer_find_single_feature(dorgbez, 'xpos'), callback_knotminer_find_single_feature(dorgbez, 'ypos'), callback_knotminer_find_single_feature(dorgbez, 'zpos')];
parameters.tempClusterIndex = callback_knotminer_find_single_feature(dorgbez, 'tempClusterIndex');
if (isempty(parameters.tempClusterIndex) || parameters.tempClusterIndex == 0)
    callback_knotminer_perform_clustering;
end

%% create knot image
imageSize = size(parameters.segImage);
knotImage = zeros(imageSize);
knotIndices = find(d_org(:, parameters.tempClusterIndex) > 0);
regionProps = regionprops(parameters.segImage, 'PixelIdxList');

%% add nuclei belonging to knots to the knot image
for i=knotIndices'
    currentPosition = round(d_org(i, positionFeatures));
    currentLabel = parameters.segImage(currentPosition(2), currentPosition(1), currentPosition(3));
    knotImage(regionProps(i).PixelIdxList) = d_org(i, parameters.tempClusterIndex);
end

%% number of cells per cluster
clusterIndices = unique(d_org(knotIndices, parameters.tempClusterIndex));
clusterCounts = zeros(length(clusterIndices), 1);
for i=clusterIndices'
    clusterCounts(i) = sum(d_org(knotIndices, parameters.tempClusterIndex) == i);
end

%% write the knot image to disk
clear options;
options.compress = 'lzw';
options.overwrite = true;
saveastiff(uint16(knotImage), [outputPath parameter.projekt.datei '_KnotImage.tif'], options);

%% resample the image using the zspacing to have faithful measures
zscale = parameter.gui.knotminer.axialVoxelSize / parameter.gui.knotminer.lateralVoxelSize;
disp(['Using lateral voxel size: ' num2str(parameter.gui.knotminer.lateralVoxelSize) ', axial voxel size: ' num2str(parameter.gui.knotminer.axialVoxelSize) ', z-scale: ' num2str(zscale) '. Select KnotMiner from the dropdown menu and set physical spacing if needed ...']);
knotImage = imresize3(knotImage, [imageSize(1), imageSize(2), round(imageSize(3) * zscale)], 'nearest');

%% compute regionprops of the knot image
regionPropsKnots = regionprops3(knotImage, 'EquivDiameter', 'Volume', 'Extent', 'PrincipalAxisLength', 'ConvexVolume', 'Solidity', 'SurfaceArea');

%% write the result file with measures in voxel
specifiers = 'ClusterIndex;NumCellsInCluster;Volume;EquivDiameter;Extent;Solidity;ConvexVolume;SurfaceArea;PrincipalAxisLength1;PrincipalAxisLength2;PrincipalAxisLength3;';
resultMatrix = [clusterIndices, ...
                clusterCounts, ...
                regionPropsKnots.Volume, ...
                regionPropsKnots.EquivDiameter, ...
                regionPropsKnots.Extent, ...
                regionPropsKnots.Solidity, ...
                regionPropsKnots.ConvexVolume, ...
                regionPropsKnots.SurfaceArea, ...
                sortrows(regionPropsKnots.PrincipalAxisLength', 'descend')'];

quantificationFile = [outputPath parameter.projekt.datei '_QuanificationsVoxelsIsotropic.csv'];
dlmwrite(quantificationFile, resultMatrix, ';');
prepend2file(specifiers, quantificationFile, true);

%% write the result file with measures physically scaled
lengthFactor = parameter.gui.knotminer.lateralVoxelSize;
areaFactor = parameter.gui.knotminer.lateralVoxelSize^2;
volumeFactor = parameter.gui.knotminer.lateralVoxelSize^3;
resultMatrixPhysical = [clusterIndices, ...
                        clusterCounts, ...
                        regionPropsKnots.Volume * volumeFactor, ...
                        regionPropsKnots.EquivDiameter * lengthFactor, ...
                        regionPropsKnots.Extent, ...
                        regionPropsKnots.Solidity, ...
                        regionPropsKnots.ConvexVolume * volumeFactor, ...
                        regionPropsKnots.SurfaceArea * areaFactor, ...
                        sortrows(regionPropsKnots.PrincipalAxisLength', 'descend')' * lengthFactor];

quantificationFilePhysical = [outputPath parameter.projekt.datei '_QuanificationsMicronsIsotropic.csv'];
dlmwrite(quantificationFilePhysical, resultMatrixPhysical, ';');
prepend2file(specifiers, quantificationFilePhysical, true);

disp(['Results were successfully saved to ' outputPath]);
toc