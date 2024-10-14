# Asynchrony and Inflationary Effect
## Purpose
This repository contains code used to produce the results and figures found in the manuscript "Metapopulations, the inflationary effect, and consequences for public health" submitted to The American Naturalist. The main purpose of this paper is to illustrate the central role that spatiotemporal variation plays in traditional metapopulation models of occupancy and how it relates to the inflationary effect phenomenon in patch models of population growth. The paper makes the connection and argues that spatiotemporal dynamics that might generate an inflationary effect should be common in systems of infectious disease given the dynamic nature of host behavior and movement and the relatively fast rates of pathogen reproduction in relation to host movement. This repository contains examples from different models. 

## Code Format
All the code and figures are produced in [Matlab 2023b](https://www.mathworks.com/products/new_products/release2023b.html), but the code uses basic functions from Matlab that should be functional in many Matlab versions. Matlab requires a license, but a basic, free version is available at https://www.mathworks.com/products/matlab-online/matlab-online-versions.html that should be sufficient to run this code and make modifications, if interested.

## Repository Contents
The repository has two main folders, `src` and `fig`, that contain, respectively, source code to run models and generate figures in the manuscript, and the produced figures. Within each of these main folders are four folders that organize source code and figures according to the model (or analysis) used in the paper. Below is a brief description of each sub-folder contents. Extra detail about each model and analysis can be found in the main text of the manuscript as well as the supplement. 

### "Metapopulation Code" folder. 
This folder contains the code used to produce figures 2 and 3 of the main text, and the code associated with the reaction norm approach described in the supplement. This code relates to a finite-patch version of the Levins metapopulation model where extinction events have some correlation, which we call \rho<sub>E</sub>. The files found in the src folder are:

1. **LevinsMetaPop.m**. 
Description: This is a function that simulates the stochastic, finite patch version of the Levins model illustrated in the main text and detailed in the supplementary material, section S2. The goal of this model is to illustrate the importance of correlated patch extinctions on model behavior. This function takes correlations, simulation length, number of patches, and average extinction and colonization rates as inputs. The output is a matrix of occupancy of the different patches across the specified time inputs. 
Dependencies: None

2. **LevinsMetaPopSim.m**
Description: Code to simulate the stochastic, finite-patch model in two situations. The first is one to illustrate dynamics of the model in the case of uncorrelated extinctions and compare that with the case of correlated extinctions. This comparison is made across two different patch numbers. The output is given by figure 2 of the main text. The second part of the code simulates the model across multiple correlations in extinction rates. It then calculates extinction times and conditional mean occupancy. This is to illustrate that the main effect of spatiotemporal heterogeneity in the model is to stabilize dynamics and increase persistence, rather than enhance population size, on average. The code also plots the results. The results are in figure 3 of the main text. Simulation details are in supplement S2. 
Dependencies: LevinsMetaPop.m and viridis.m

3. **PathReactionNorm.m**
Description: A script that illustrates the reaction norm copula approach to creating correlated extinction events in multiple patches. The approach relies on correlating normal random variables, transforming them to uniform random variables, and then transforming them to random variables with the support of interest. The stochastic Levins model used in the manuscript requires correlated Bernoulli events (extinction/persistence) across many patches. The approach outlined here illustrates how these correlated Bernoulli variables are produced. The mathematical details are outlined in the supplementary material S2 and the code produces Figures S1 and S2. 
Dependencies: viridis.m

4. **viridis.m**
Description: A colormap.
Dependencies: None 

### "TwoPatch Model" folder.
Code to simulate the source-sink model can be found in the folder "TwoPatch Model". In the src folder, you will find two code files:

1. **VarianceEffect.m**
Description: A simulation of the source-sink model for difference variability in growth rates. This model has the same environmental process and illustrates how variation in the sink can boost population sizes on average. It also calculates and plots the geometric and arithmetic mean population sizes for each environmental variance. It produces figure 4 of the main text.
Dependencies: viridis.m

2. **viridis.m**
Description: A colormap.
Dependencies: None 


### "SIR-Model" folder.
Code to simulate the two-patch SIR model for a respiratory disease, including the deterministic and stochastic forms. The model includes two patches with constant rates of movement. 

In the "src" folder, you will find the following scripts, with short descriptions and dependencies.

1. **Cycle_Growth_Rate.m**
Description: Simulates over movement rates and intervention overlap to calculate metapopulation growth rates in the deterministic version of the model. 
Dependencies: TwoPatch_Global_r.m and viridis.m

2. **ISink_Sink.m**
Description: Script to encode the ode for the SIR model. Note that this only models the infectious compartment, which is relevant for understanding the average growth rate when the population is completely susceptible.
Dependencies: None

3. **Stochastic_Two_Patch_Model.m**
Description: This code simulates the stochastic version of the two-patch SIR model. To do so, it discretizes continuous-time and adds Gaussian noise to the transmission rate. 
Dependencies: viridis.m

4. **supplement_figures.m**
Description: Code that calculates the metapopulation growth rate across different parameter values of the two-patch SIR model. The code here reproduces figures S4 and S5 of the supplement. 
Dependencies: TwoPatch_Global_r.m and viridis.m

5. **Transmission_Figure.m**
Description: Code that produces a diagram showing how the transmission rate of the SIR model changes over time in the two patches. No simulations here. This just produces a conceptual figure. The figure it produces is Figure S3 of the supplement. 
Dependencies: None

6. **TwoPatch_Global_r.m**
Description: This code is a function that two values (high and low per-capita growth rates) to calculate a metapopulation growth rate for a two patch metapopulation with periodic growth rates. The SIR model is a specific instance of this more general model. The growth rate calculated here is a regional, low-density growth rate. It gives the metapopulation scale growth rate assuming no density-dependence. 
Dependencies: ISink_Sink

7. **viridis.m**
Description: the viridis colormap function.
Dependecies: None


### "Variance-Partitioning" folder
This src folder here includes code that produces a fake spatiotemporally varying data set, decomposes the variation according to the equations in box 1, and then plots the variation and its components as in Figure 1. This is to illustrate the decomposition. The spatiotemporal variability generated in this code has a sine wave  over time that is phase shifted slightly across spatial locations with some random noise added. The two files are:

1. **ST_Decomposition.m**
Description: Code to produce the fake dataset, run the decomposition, and plot results. 
Dependencies: viridis.m

2. **viridis.m**
Description: a colormap. Dependencies: None 

## Citation
This material has been archived at Zenodo. If you use any of the material here, please use the following DOI to attribute the work. 
[![DOI](https://zenodo.org/badge/651155359.svg)](https://doi.org/10.5281/zenodo.13928923)
