

fh = figure; clf;
set(gcf, 'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
set(gcf, 'Color', 'k');
colordef black;
colormap turbo;


%% apply step selection to avoid displaying all cells if performance matters
selectedIndices = ind_auswahl;
selectedFeature = parameter.gui.merkmale_und_klassen.ind_em(1);
markerSize = 10;

currentThreshold = 15;

subplot(1,2,1);

%% show scatter plot
scatter3(d_org(selectedIndices,3), d_org(selectedIndices,4), d_org(selectedIndices,5), markerSize, d_org(selectedIndices, selectedFeature), 'filled');
axis equal;
box on;
set(gca, 'YDir', 'reverse');

title(kill_lz(dorgbez(selectedFeature,:)));
xlabel('PositionX');
ylabel('PositionY');
colorbar;

view(0, 90);

subplot(1,2,2);

currentImage = imread([parameter.projekt.pfad filesep strrep(parameter.projekt.datei, '_RegionProps', '_MaxProj.png')]);
imagesc(cat(3, currentImage, currentImage, currentImage)); hold on;

idx = kmeans(d_org(selectedIndices, selectedFeature), 2);

scatter(d_org(selectedIndices,3), d_org(selectedIndices,4), markerSize, idx, 'filled');

title('k-Means Clustering');
xlabel('PositionX');
ylabel('PositionY');

axis equal; axis tight; colorbar;
colordef white;