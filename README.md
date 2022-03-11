# KnotMiner - A SciXMiner Toolbox to Analyse Knots in 3D Fluorescence Microscopy Images

This repository contains the SciXMiner extension KnotMiner that is targeted to provide tools for a qualitative and quantitaitve analysis of knots / density accumulations in 3D microscopy images. As a precondition, KnotMiner requires a raw 3D image containing cells that are fluorescently tagged with a nuclear marker and an assotiated segmentation image where each cell has a unique integer label. The segmented nuclei can be analyzed with KnotMiner and a graphical user interface allows to manually specify thresholds based on extracted single-cell features and to cluster remaining detections into isolated knots.

## Prerequisites

The *KnotMiner* toolbox is an extension of the MATLAB toolbox SciXMiner [1] and assumes SciXMiner is properly installed on your system.

After having installed these requirements, download the *KnotMiner* toolbox from this repository and copy the contents of the `Source` folder into the folder `%SCIXMINERROOT/application_specials/knotminer/%` folder of SciXMiner (just create the subfolder if it does not exist yet). Open up MATLAB and start SciXMiner using the command `scixminer` and enable the toolbox using *Extras -> Choose application-specific extension packages...* . Restart SciXMiner and you should see a new menu entry called *KnotMiner*.

## Typical Analysis Steps

1. 


## Keyboard Shortcuts

- 1;2;3: Toggles the visualization of intensity, density, int.+dens., clustering
- Up Arrow: Inrease current parameter value
- Down Arrow: Decrease current parameter value
- A: Perform automatic parameter identification
- C: Show current classification
- F: Show current feature values
- P: Toggle parameter
- Q: Show quantification of current clustering
- M: Toggle max. projection vs. slices
- V: Show scatter plot of the current clustering
- +/-: Increase/decrease the numer of z-slices to be displayed when in slice mode.
- H: Show this help dialog so you probably already know about this button :-)
- Wheel Up/Down: Scroll through stack (only effective in slice mode)

- Hint: In case key presses show no effect, left click once on the image and try hitting the button again. This only happens if the window loses the focus.
