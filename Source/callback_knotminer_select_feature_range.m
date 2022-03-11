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

currentFeature = parameter.gui.merkmale_und_klassen.ind_em(1);
prompt = {'Minimum Value:','Maximum Value:'};
dlgtitle = [kill_lz(dorgbez(currentFeature, :)) ' Feature Range Selection'];
dims = [1 35];
definput = {num2str(min(d_org(:,currentFeature))), num2str(max(d_org(:,currentFeature)))};
answer = inputdlg(prompt,dlgtitle,dims,definput);

ind_auswahl = find(d_org(:,currentFeature) >= str2double(answer{1}) & d_org(:,currentFeature) <= str2double(answer{2}));

if (isempty(ind_auswahl))
    ind_auswahl = 1:size(d_org, 1);
    disp('No data point matches the selection. Selecting all data points instead ...');
end

aktparawin;
