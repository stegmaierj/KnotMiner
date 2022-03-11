# KnotMiner - A SciXMiner Toolbox to Analyse Knots in 3D Fluorescence Microscopy Images

This repository contains the SciXMiner extension KnotMiner that is targeted to provide tools for a qualitative and quantitaitve analysis of knots / density accumulations in 3D microscopy images. As a precondition, KnotMiner requires a raw 3D image containing cells that are fluorescently tagged with a nuclear marker and an assotiated segmentation image where each cell has a unique integer label. The segmented nuclei can be analyzed with KnotMiner and a graphical user interface allows to manually specify thresholds based on extracted single-cell features and to cluster remaining detections into isolated knots.

## 1. Prerequisites

The *KnotMiner* toolbox is an extension of the MATLAB toolbox SciXMiner [1] and assumes SciXMiner is properly installed on your system.

After having installed these requirements, download the *KnotMiner* toolbox from this repository and copy the contents of the `Source` folder into the folder `%SCIXMINERROOT/application_specials/knotminer/%` folder of SciXMiner (just create the subfolder if it does not exist yet). Open up MATLAB and start SciXMiner using the command `scixminer` and enable the toolbox using *Extras -> Choose application-specific extension packages...* . Restart SciXMiner and you should see a new menu entry called *KnotMiner*.

## 2. Typical Analysis Steps

### 2.1 Import a New Project
From the KnotMiner menu, call the command `KnotMiner -> Import -> Import New Image/Mask Pair` to import a new pair of raw image and segmentation. The input dialogs will first ask for the raw image file (3D tiff file) and then for the segmentation image (3D tiff file with a unique integer label per cell and label 0 as the background). Hint: on macOS the file open dialog does not directly mention which image to open. When pressing *Options* in the file open dialog, the requested image is listed in the file type selection dropdown. The import script will generate a `*.prjz` project file that can subsequently be loaded in SciXMiner using `File -> Load Project`.

### 2.2 Setup Project Parameters
As KnotMiner does not know in advance which physical spacing was used for the acquisition, make sure to provide this information. For this, use the dropdown menu in  the middle of the SciXMiner GUI and select *KnotMiner*. Use this dialog to enter the lateral and axial voxel size in micrometers. Moreover, you can specify the *Neighborhood Radius* parameter used for neighborhood computations, *e.g.*, for density computations.

### 2.3 Manual Threshold Specification and Clustering
You can now start with the manual specification of the thresholds. To do this, call the command `KnotMiner -> Show -> Annotation GUI`. The GUI will ask for the raw image associated with the project file. Select it and after that the raw image with superimposed detections should appear.

#### 2.3.1 Setup the Intensity Threshold
The first step is the intensity threshold. The parameter display on the top lefthand side shows which parameter is currently active. Use the *Up Arrow* and *Down Arrow* buttons to increase or decrease a value. The display should be immediately updated to show the effect of the threshold. Specify the threshold such that all bright cells that are potentially part of a knot remain green. Using the *C, D, F* keys, you can toggle the visualization. *C* shows the current classification (red detections are below the threshold, green detections above the threshold). *D* allows you to toggle the visibility of detections that are below the threshold. *F* shows a color-coded scatter plot of the current feature.

#### 2.3.2 Setup the Density Threshold
Once you're satisfied with the density threshold, hit the *2* key to switch to the density threshold adjustment. The controls are exactly as described in 3.1 but now the threshold operates on the density feature. Specify the density threshold such that all dense regions that are potentially knots remain green.

#### 2.3.3 Inspect the Combined Threshold Result
If you're also done with the density threshold, hit the *3* button to see the effect of both thresholds in combination. The now remaining green detections are the knot candidates and will be considered by the subsequent clustering. You can go back to steps 3.1 or 3.2 at any time to readjust the thresholds.

#### 2.3.4 Perform Clustering of Knot Candidates
Once the knot candidates are properly selected, you can apply a DBSCAN clustering algorithm. Hit the *4* button to enter the clustering visualization. The clustering is only performed on the detections that are above your manually specified thresholds. There are two parameters for the clustering `Epsilon` and `MinPoints`. In short, `Epsilon` specifies the radius arround each of the detections where the algorithm searches for neighbors. `MinPoints` specifies how many points should be present in the neighborhood of a point to be considered as a dense point. Points that have at least `MinPoints` neighbors within their `Epsilon`-sphere are considered core points and are part of a cluster. Points that have a dense point among their neighbors but have less than `MinPoints` neighbors are considered points on the boundary of a cluster. Points that do not have sufficient neighbors in their `Epsilon`-sphere and also don't contain any dense points in their neighborhood are considered noise points. See https://en.wikipedia.org/wiki/DBSCAN for all details of the algorithm. Again, the parameters can be increased/decreased with the *Up/Down Arrows* and the key *P* allows to switch between the parameters. The arrow keys only affect the currently selected parameter.

#### 2.3.5 Visual Analysis and Result Export
Finally, you can have a look at the quantifications for the current clustering. The key *Q* provides you with box plots and histograms of cluster sizes and the key *V* displays a 3D scatter plot of the current cluster results. Using the *E* button, you can export the current results to disk in form of a knot image (a segmentation image where the cells associated to a knot all have the same id) and a spreadsheet file where each row contains the quantifications of a knot. The following features are extracted:

| Feature      |  Description |
|:----------|:-------------|
| ClusterIndex | Unique index of a knot/cluster. This id corresponds to the id in the knot image. |
| NumCellsInCluster |  The number of cells in the respective cluster (use this, e.g., to reject small clusters).|
| Volume | The volume of the knot in number of voxels. To convert it to a volume in µm^3, multiply it with the physical spacing accordingly. |
|EquivDiameter | The diameter of a sphere of the same volume measuresd in voxels. To convert it to a length in µm, multiply it with the physical spacing accordingly. |
| Extent | Ratio of volume and bounding box volume. Maximum value of 1 obtained for box-like volumes and lower values indicate that the bounding box is not entirely filled by the object. |
| Solidity | Ratio of the volume and the convex volume. Maximum value of 1 obtained for convex objects. Lower values indicate more non-convex shapes. |
| ConvexVolume | Volume of the convex hull of the knot measured in voxels. To convert it to a volume in µm^3, multiply it with the physical spacing accordingly. |
| SurfaceArea | Surface area of the knot measured in voxels. To convert it to an area in µm^2, multiply it with the physical spacing accordingly. |
| PrincipalAxisLength1 | Length of the first principal component measured in voxels. To convert it to a length in µm, multiply it with the physical spacing accordingly. |
| PrincipalAxisLength2 | Length of the first principal component measured in voxels. To convert it to a length in µm, multiply it with the physical spacing accordingly. |
| PrincipalAxisLength3 | Length of the first principal component measured in voxels. To convert it to a length in µm, multiply it with the physical spacing accordingly. |



## 3. Keyboard Shortcuts

| Feature      |  Description |
|:----------|:-------------|
| 1;2;3:4 | Toggles the visualization of intensity, density, int.+dens., clustering|
| Up Arrow | Inrease current parameter value|
| Down Arrow | Decrease current parameter value|
| A | Perform automatic parameter identification|
| C | Show current classification|
| D | Show/hide detections below the threshold or noise clusters|
| E | Export results for the current parameters|
| F | Show current feature values|
| P | Toggle parameter|
| Q | Show quantification of current clustering|
| M | Toggle max. projection vs. slices|
| V | Show scatter plot of the current clustering|
| +/- | Increase/decrease the numer of z-slices to be displayed when in slice mode.|
| H | Show this help dialog so you probably already know about this button :-)|
| Wheel Up/Down | Scroll through stack (only effective in slice mode)|
| | |
| Hint | In case key presses show no effect, left click once on the image and try hitting the button again. This only happens if the window loses the focus.|
