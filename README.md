# Asynchrony and Inflationary Effect
## Purpose
This repository contains code used to produce the results and figures found in the manuscript "Metapopulations, the inflationary effect, and consequences for public health" submitted to The American Naturalist. The main purpose of this paper is to illustrate the central role that spatiotemporal variation plays in traditional metapopulation models of occupancy and how it relates to the inflationary effect phenomenon in patch models of population growth. The paper makes the connection and argues that spatiotemporal dynamics that might generate an inflationary effect should be common in systems of infectious disease given the dynamic nature of host behavior and movement and the relatively fast rates of pathogen reproduction in relation to host movement. This repository contains examples from different models. 

## Code Format
All the code and figures are produced in [Matlab 2023b] (https://www.mathworks.com/products/new_products/release2023b.html), but the code uses basic functions from Matlab that should be functional in many Matlab versions. Matlab requires a license, but a basic, free version is available at https://www.mathworks.com/products/matlab-online/matlab-online-versions.html that should be sufficient to run this code and make modifications, if interested.

## Repository Contents
The code is separated into four folders that represent the code to run different models and analyses used in the paper. Below is a brief description of each. Extra detail about each model and analysis can be found in the main text of the manuscript. 

### "Metapopulation Code" folder. 
Code to simulate the finite patch Levins metapopulation model can be found in the "Metapopulations" folder. There you will find the code to reproduce figures 2 and 3 of the main text and the code associated with the reaction norm approach described in the supplement. 

### "TwoPatch Model" folder.
Code to simulate the source-sink model can be found in the folder "TwoPatch Model". There you will find the code to reproduce figure 4.

### "SIR-Model" folder.
Code to simulate the SIR model for a respiratory disease, including the deterministic and stochastic forms, are in the folder titled "SIR-Model". 

### "Variance-Partitioning" folder
Code to recreate figure 1 and to do the variance partitioning are in the folder "Variance-Partitioning"
