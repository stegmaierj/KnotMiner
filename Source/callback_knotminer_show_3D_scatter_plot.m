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
global dorgbez;
global d_org;
global ind_auswahl;

%% get the selected features and a suitable subplot layout
selectedFeatures = parameter.gui.merkmale_und_klassen.ind_em;
[numRows, numColumns] = callback_knotminer_compute_subplot_layout(length(selectedFeatures));

%% open new figure
figure;
colordef black;
set(gcf, 'units', 'normalized', 'color', 'black', 'OuterPosition', [0 0 1 1]);

%% plot individual features as scatter plots
for i=1:length(selectedFeatures)

    %% set current subplot
    subplot(numRows, numColumns, i);

    %% draw scatter plot of current feature
    scatter3(d_org(ind_auswahl,3), d_org(ind_auswahl,4), d_org(ind_auswahl,5), 36, d_org(ind_auswahl, parameter.gui.merkmale_und_klassen.ind_em(i)), 'filled');
    
    %% setup axes and labels
    axis equal;
    xlabel('Position X');
    ylabel('Position Y');
    zlabel('Position Z');
    title(kill_lz(dorgbez(parameter.gui.merkmale_und_klassen.ind_em(i), :)));
    
    %% show color map
    mycolorbar = colorbar;
    mycolorbar.Color = [1,1,1];
    colormap turbo;
end

%% reset the color def
colordef white;