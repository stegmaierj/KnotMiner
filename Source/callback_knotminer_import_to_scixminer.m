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

%% for automation, the new project shouldn't be directly loaded
if (exist('next_function_parameter', 'var') && ~isempty(next_function_parameter))
    loadNewProject = next_function_parameter;
    next_function_parameter = [];
else
    loadNewProject = true;
end

%% add functionality for tiff reading
addpath([parameter.allgemein.pfad_gaitcad filesep 'application_specials' filesep 'KnotMiner' filesep 'toolbox' filesep 'saveastiff_4.3' filesep]);

%% load the image files
[rawImageFile, rawImageFolder] = uigetfile({'*.tif;*.tiff;*.TIF;*.TIFF', 'Raw Image (*.tif;*.tiff;*.TIF;*.TIFF)'}, 'Please select the raw image (*.tif)!');
[labelImageFile, labelImageFolder] = uigetfile({'*.tif;*.tiff;*.TIF;*.TIFF', 'Segmentation Image (*.tif;*.tiff;*.TIF;*.TIFF)'}, 'Please select the segmentation mask image (*.tif)!');

if (sum(rawImageFile == 0) || sum(labelImageFile == 0))
    disp('No valid input files specified. Aborting import ...');
    return;
end

rawImage = double(loadtiff([rawImageFolder rawImageFile]));
labelImage = loadtiff([labelImageFolder labelImageFile]);

%% perform stack normalization
prompt = {'Perform Normalization? (0/1):','Normalization Quantile (default=0.003):'};
dlgtitle = 'Input Image Normalization';
dims = [1 35];
definput = {'1','0.003'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

performNormalization  = str2double(answer{1}) > 0;
normalizationQuantile = str2double(answer{2});

if (performNormalization == true)
    
    rawImageNormalized = zeros(size(rawImage));

    for i=1:size(rawImage,3)

        if (max(squeeze(labelImage(:,:,i)), [], 'all') > 0)
            lowerQuantile = quantile(rawImage(:,:,i), normalizationQuantile, [1,2]);
            upperQuantile = quantile(rawImage(:,:,i), 1-normalizationQuantile, [1,2]);
    
            rawImageNormalized(:,:,i) = (rawImage(:,:,i) - lowerQuantile) / (upperQuantile - lowerQuantile);
        end
    end

    rawImageNormalized(rawImageNormalized < 0) = 0;
    rawImageNormalized(rawImageNormalized > 1) = 1;
    rawImageNormalized = rawImageNormalized * 255;
    rawImage = rawImageNormalized;
end

%% extract the region props
regionProps = regionprops3(labelImage, rawImage, 'Centroid', 'EquivDiameter', 'Extent', 'Solidity', 'PrincipalAxisLength', 'SurfaceArea', 'Volume', 'Orientation', 'ConvexVolume', 'MeanIntensity', 'MaxIntensity', 'MinIntensity');

%% initialize scixminer variables
d_org = zeros(size(regionProps,1), 16);
d_org(:,1) = 1:size(regionProps,1);
d_org(:,2) = regionProps.Volume;
d_org(:,3:5) = regionProps.Centroid;
d_org(:,6:8) = regionProps.PrincipalAxisLength;
d_org(:,9:11) = regionProps.Orientation;
d_org(:,12) = regionProps.EquivDiameter;
d_org(:,13) = regionProps.Extent;
d_org(:,14) = regionProps.ConvexVolume;
d_org(:,15) = regionProps.Solidity;
d_org(:,16) = regionProps.SurfaceArea;
d_org(:,17) = regionProps.MinIntensity;
d_org(:,18) = regionProps.MaxIntensity;
d_org(:,19) = regionProps.MeanIntensity;

%% setup the variable specifiers
dorgbez = char('id', 'volume', 'xpos', 'ypos', 'zpos', 'PrincipalAxisLength1', 'PrincipalAxisLength2', 'PrincipalAxisLength3', 'Orientation1', 'Orientation2', 'Orientation3', 'EquivDiameter', 'Extent', 'ConvexVolume', 'Solidity', 'SurfaceArea', ...
    'MinIntensity', 'MaxIntensity', 'MeanIntensity');
code = ones(size(d_org,1), 1);
code_alle = code;
d_orgs = [];
var_bez = 'y';

%% save the project next to the label file
[folder, file, ~] = fileparts([labelImageFolder labelImageFile]);
projectFileName = [folder filesep file '_RegionProps.prjz'];
save(projectFileName, '-mat', 'd_org', 'dorgbez', 'code_alle', 'code');

%% load the created project
if (loadNewProject == true)
    next_function_parameter = projectFileName;
    ldprj_g;
end