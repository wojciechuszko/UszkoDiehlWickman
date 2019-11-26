#Readme for the code used to perform parameter fits and bootstrapping for two experimental data sets in "Fitting functional response surfaces to data: a best practice guide". 

The files in this folder contain several matlab code files (.m-files), as well as two matlab data files (.mat-files) containing formatted data for two experimental series in which Daphnia fed on algae. 

The top-level file is "main.m", from which the code performing the parameter fitting and bootstrapping can be initiated. Here, one may set whether fits should be on untransformed or logtransformed data, whether the sequential or simultaneous fitting method should be used, and whether data resampling, stratified data resampling, or residual resampling should be used for the bootstrapping. One may also select the number of bootstraps that should be performed for the fit. Furthermore, one may select which of the two experimental series should be used in the fitting.

Running the file "main.m" without any alterations will perform a fit using logtransformed data with simultaneous fitting, and compute 10 bootstrap fits, using experimental series 2. Running the file with these parameters should not take more than a few seconds on most computers.

More detailed instructions and comments are available in the code-files themselves. 

#Additional notes on the code:

1) When running the code -- especially with untransformed data and/or sequential fits -- matlab may sometimes issue warnings. This is not a problem in and of it self, as our code will mark any fit where a warning was issued as not having converged, which can be seen in the results of the fitting procedure.

2) When we generated the data for the manuscript we used the ODE-solver routine 'ode15s', but after the data was already generated we discovred that the routine 'ode45' is actually faster in a majority of cases, and so we have changed the routine in the supplied code to 'ode45'.

3) As we use a numerical program for finding the optimal fit to each bootstrap data set, fits are not always perfect, and some rare outlier fits are sometimes returned by the code. It is therefore advisable to check the fitted bootstrap coefficients for anomalies before proceeding with any analysis. The fitting method we promote in the manuscript -- simultaneous fits to logtransformed data -- is much less prone to this kind of behavior.
