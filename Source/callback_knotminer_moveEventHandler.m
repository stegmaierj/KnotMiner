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
function callback_knotminer_moveEventHandler(~,evt)

    %% include global variables
    global parameters; %#ok<GVMIS> 
    global d_org; %#ok<GVMIS> 

    C = get(gca, 'CurrentPoint');

    if (ishandle(parameters.infoLabel))

        if (~parameters.showInfo)
            parameters.infoLabel.Visible = 0;
            parameters.infoPoint.Visible = 0;
            return;
        end

        parameters.infoLabel.Visible = 1;
        set(parameters.infoLabel, 'Units', 'data', 'Position', C(1,:) + [20, 20, 0]);

        if (parameters.maximumProjection == false)
            validIndices = find(abs(round(d_org(:,parameters.positionIndices(3)) - parameters.currentSlice)) < max(1, parameters.zSliceRange));
            currentPositions = d_org(validIndices,parameters.positionIndices);
            currentFeatures = d_org(validIndices, [parameters.meanIntensityIndex, parameters.densityIndex, parameters.tempClusterIndex]);
        else
            currentPositions = d_org(:,parameters.positionIndices);
            currentFeatures = d_org(:, [parameters.meanIntensityIndex, parameters.densityIndex, parameters.tempClusterIndex]);
        end


        distances = sqrt((currentPositions(:,1) - C(1,1)).^2 + (currentPositions(:,2) - C(1,2)).^2);
        [~, minIndex] = min(distances);


        parameters.infoPoint.XData = currentPositions(minIndex, 1);
        parameters.infoPoint.YData = currentPositions(minIndex, 2);
        parameters.infoPoint.Visible = 1;


        set(parameters.infoLabel, 'String', sprintf('Int: %.1f, Den: %.1f, Cl: %i', currentFeatures(minIndex, 1), currentFeatures(minIndex, 2), currentFeatures(minIndex, 3)));
    end
end