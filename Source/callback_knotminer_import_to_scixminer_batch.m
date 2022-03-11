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

loadNewProject = false;

%% add functionality for tiff reading
addpath([parameter.allgemein.pfad_gaitcad filesep 'application_specials' filesep 'KnotMiner' filesep 'toolbox' filesep 'saveastiff_4.3' filesep]);

%% Specify file names

rawImageFiles{1} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/92c11d/Images/Series_6.tif';
rawImageFiles{2} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/92c11d/Images/Series_16.tif';
rawImageFiles{3} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/92c11d/Images/series_T21808.tif';

% rawImageFiles{1} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe_2022-02-10_1450/LO-PE/P3_T21-0106_6-day_UEA-1_S13G.lif-Series012.tif';
% rawImageFiles{2} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/eo-pe-placenta_2022-02-03_1201/20X-P1_S13G_UEA1_PBS.lif - Series008_Nuclei_channel.tif';
% rawImageFiles{3} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/eo-pe-placenta_2022-02-03_1201/20X-P1_S13G_UEA1_PBS.lif - Series012_nuclei channel.tif';
% rawImageFiles{4} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/eo-pe-placenta_2022-02-03_1201/C2-20X-P1_S13G_UEA1_PBS.lif - Series019Nuclei_only.tif';
% rawImageFiles{5} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/iugr-0012199172_2022-02-10_1356/IUGR_0012199172/20X_0012199172_UEA-1-OV_S13G.lif - Series002.tif';
% rawImageFiles{6} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/iugr-0012199172_2022-02-10_1356/Term_control_0092140089/20X_0092140089_UEA-1-OV_S13G.lif-Series011.tif';
% rawImageFiles{7} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe_2022-02-10_1450/LO-PE/P3_T21-0106_6-day_UEA-1_S13G.lif-Series012.tif';
% rawImageFiles{8} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe-and-t21eo-pe_2022-02-03_1202/20X_T21-02775_UEA-1-OV_S13G_1h.lif - Series021_nuclei_only.tif';
% rawImageFiles{9} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe-and-t21eo-pe_2022-02-03_1202/20X-T21-0106-S13G+UEA-1-3-hours.lif - Series009_nuclei_channel.tif';
% rawImageFiles{10} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/t21786-14-04-2021-3-preterm-ideopatic_2022-02-10_1436/T21786_(14-04-2021)_3_preterm_ideopatic/25X-T21786_UEA1_overnight+S13G.lif-Series009.tif';
% rawImageFiles{11} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/t21786-14-04-2021-3-preterm-ideopatic_2022-02-10_1436/T21786_(14-04-2021)_3_preterm_ideopatic/25X-T21786_UEA1_overnight+S13G.lif-Series024.tif';
% rawImageFiles{12} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/t21786-14-04-2021-3-preterm-ideopatic_2022-02-10_1436/T21786_(14-04-2021)_3_preterm_ideopatic/25X-T21786_UEA1_overnight+S13G.lif-Series028.tif';
% rawImageFiles{13} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/20X_N1_UEA-1_OV+S13G.lif - Series003_nuclei_only.tif';
% rawImageFiles{14} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/C2-N2+UEA-1+SYT13G_585 460.lif - Series079_Nuclei_channel.tif';
% rawImageFiles{15} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/N2+UEA-1+SYT13G_585 460.lif - Series065_nuclei_channel.tif';
% rawImageFiles{16} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/N2+UEA-1+SYT13G_585 460.lif - Series070_nuclei_channel.tif';
% 

labelImageFiles{1} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/92c11d/instances_Series_6.tif';
labelImageFiles{2} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/92c11d/instances_Series_16.tif';
labelImageFiles{3} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/92c11d/instances_series_T21808.tif';

% labelImageFiles{1} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe_2022-02-10_1450/LO-PE/instances_P3_T21-0106_6-day_UEA-1_S13G.lif-Series012.tif';
% labelImageFiles{2} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/eo-pe-placenta_2022-02-03_1201/instances_20X-P1_S13G_UEA1_PBS.lif - Series008_Nuclei_channel.tif';
% labelImageFiles{3} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/eo-pe-placenta_2022-02-03_1201/instances_20X-P1_S13G_UEA1_PBS.lif - Series012_nuclei channel.tif';
% labelImageFiles{4} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/eo-pe-placenta_2022-02-03_1201/instances_C2-20X-P1_S13G_UEA1_PBS.lif - Series019Nuclei_only.tif';
% labelImageFiles{5} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/iugr-0012199172_2022-02-10_1356/IUGR_0012199172/instances_20X_0012199172_UEA-1-OV_S13G.lif - Series002.tif';
% labelImageFiles{6} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/iugr-0012199172_2022-02-10_1356/Term_control_0092140089/instances_20X_0092140089_UEA-1-OV_S13G.lif-Series011.tif';
% labelImageFiles{7} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe_2022-02-10_1450/LO-PE/instances_P3_T21-0106_6-day_UEA-1_S13G.lif-Series012.tif';
% labelImageFiles{8} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe-and-t21eo-pe_2022-02-03_1202/instances_20X_T21-02775_UEA-1-OV_S13G_1h.lif - Series021_nuclei_only.tif';
% labelImageFiles{9} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/lo-pe-and-t21eo-pe_2022-02-03_1202/instances_20X-T21-0106-S13G+UEA-1-3-hours.lif - Series009_nuclei_channel.tif';
% labelImageFiles{10} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/t21786-14-04-2021-3-preterm-ideopatic_2022-02-10_1436/T21786_(14-04-2021)_3_preterm_ideopatic/instances_25X-T21786_UEA1_overnight+S13G.lif-Series009.tif';
% labelImageFiles{11} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/t21786-14-04-2021-3-preterm-ideopatic_2022-02-10_1436/T21786_(14-04-2021)_3_preterm_ideopatic/instances_25X-T21786_UEA1_overnight+S13G.lif-Series024.tif';
% labelImageFiles{12} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/t21786-14-04-2021-3-preterm-ideopatic_2022-02-10_1436/T21786_(14-04-2021)_3_preterm_ideopatic/instances_25X-T21786_UEA1_overnight+S13G.lif-Series028.tif';
% labelImageFiles{13} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/instances_20X_N1_UEA-1_OV+S13G.lif - Series003_nuclei_only.tif';
% labelImageFiles{14} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/instances_C2-N2+UEA-1+SYT13G_585 460.lif - Series079_Nuclei_channel.tif';
% labelImageFiles{15} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/instances_N2+UEA-1+SYT13G_585 460.lif - Series065_nuclei_channel.tif';
% labelImageFiles{16} = '/Users/jstegmaier/ScieboDrive/Projects/2022/KapsokalyvasMU_NucleiSegmentation/Data/term-control-placenta_2022-02-03_1200/instances_N2+UEA-1+SYT13G_585 460.lif - Series070_nuclei_channel.tif';

for f=1:length(rawImageFiles)

    [rawImageFolder, file, ext] = fileparts(rawImageFiles{f});
    rawImageFolder = [rawImageFolder filesep];
    rawImageFile = [file ext];

    [labelImageFolder, file, ext] = fileparts(labelImageFiles{f});
    labelImageFolder = [labelImageFolder filesep];
    labelImageFile = [file ext];

    %% load the image files
    rawImage = loadtiff([rawImageFolder rawImageFile]);
    labelImage = loadtiff([labelImageFolder labelImageFile]);
    
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
end