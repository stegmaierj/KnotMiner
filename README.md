# KnotMiner - A SciXMiner Toolbox to Analyse Knots in 3D Fluorescence Microscopy Images

This repository contains the SciXMiner extension KnotMiner that is targeted to provide tools for a qualitative and quantitaitve analysis of knots / density accumulations in 3D microscopy images. As a precondition, KnotMiner requires a raw 3D image containing cells that are fluorescently tagged with a nuclear marker and an assotiated segmentation image where each cell has a unique integer label. The segmented nuclei can be analyzed with KnotMiner and a graphical user interface allows to manually specify thresholds based on extracted single-cell features and to cluster remaining detections into isolated knots.

## Prerequisites

The *KnotMiner* toolbox is an extension of the MATLAB toolbox SciXMiner [1] and assumes SciXMiner is properly installed on your system.

After having installed these requirements, download the *KnotMiner* toolbox from this repository and copy the contents of the `Source` folder into the folder `%SCIXMINERROOT/application_specials/knotminer/%` folder of SciXMiner (just create the subfolder if it does not exist yet). Open up MATLAB and start SciXMiner using the command `scixminer` and enable the toolbox using *Extras -> Choose application-specific extension packages...* . Restart SciXMiner and you should see a new menu entry called *KnotMiner*.

## Typical Analysis Steps

1. 


## Keyboard Shortcuts
