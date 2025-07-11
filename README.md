**Repository for the paper "Investigating the Robustness of Extreme Precipitation Super-Resolution Across Climates"**

This GitHub repository contains the code and data necessary to reproduce the results presented in the article _"Investigating the Robustness of Extreme Precipitation Super-Resolution Across Climates"_. The workflows implemented here focus on analyzing extreme precipitation events using COSMO model data in the context of super-resolution: learning to increase the spatial resolution of extreme value distributions (GEV) for precipitation, with a particular focus on model robustness under climate change.

**Overview of the dev Directory**

The dev directory includes the main components of the data processing and modeling pipeline, structured as follows:

- _InitialData_ : Extracts extreme precipitation maxima from the high-resolution COSMO model output and generates corresponding datasets at lower spatial resolutions through mean pooling.
- _gev_modeling_ : Estimates the parameters of the Generalized Extreme Value (GEV) distributions for precipitation extremes at different spatial scales, providing statistical modeling of the extremes.
- _Peek&Prepare_ : Performs data cleaning, transformation, and preparation steps to organize and format the datasets for subsequent modeling.
- _Correlations_ : Computes spatial autocorrelation of precipitation data to understand spatial dependencies and analyzes cross-correlation with altitude to assess topographic influences on precipitation extremes.
- _JustModels_ : Implements a variety of statistical models based on the VGAM (Vector Generalized Additive Models) and VGLM (Vector Generalized Linear Models) frameworks to perform super-resolution of extreme value distributions. 
- _Performance_analysis_ : Contains scripts to visualize model outputs and evaluate their performance quantitatively using metrics such as the Cramér–von Mises statistic.
- _ClimateChange_ : Investigates the robustness gap, i.e., differences in model projections under climate change scenarios, to assess uncertainties and model reliability.
