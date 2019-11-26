%% Define fitting parameters
% Here, a Matlab struct called 'fitting_options' is defined, which governs
% the behavior of the fitting process. See the lines below for what values
% are allowed for each option.

fitting_options = struct;

% Legal options: 'logtransformed' or 'untransformed'
fitting_options.transform = 'logtransformed';

% Legal options: 'simultaneous' or 'sequential'
fitting_options.sequence = 'simultaneous';

% Legal options: 'data' or 'residual' or 'stratified'
fitting_options.bootstrap_method = 'stratified';

% Legal options: Nonnegative integer
fitting_options.number_of_bootstraps = 1000;

% Legal options: true or false
% If set to true, a waitbar willl be displyed showing the current progress
% with the bootstrapping. If set to false, nothing will be displayed.
fitting_options.display_progress = true;

% Test fitting options to make sure no illegal parameters have been passed
test_fitting_options( fitting_options );

%% Load one of the experimental series
% The experimental data is loaded into a Matlab struct, where each variable
% (e.g., temperature) is a field in the struct, and each field is a vector
% where each entry in a vector corresponds to the value in a single feeding
% trial

experiment_data = load_experiment_data( 'experimental_series_2_data.mat' );

%% Get fitted and bootstrapped parameter coefficients
% fit_results is struct with the results from the fitting procedure.
% fit_results has four fields.
% 1) beta_primary: the primary fit of the parameters, 
%    beta_primary = [a2 a1 a0 b2 b1 b0 h2 h1 h0]'
% 2) beta_bootstrap: A 9 x N matrix, where each column is a fitted set of
%    parameters for each bootstrapped data set, and N is the number of
%    bootstraps
% 3) is_converged_bootstrap: A vector of logicals indicating whether a
%    given bootstrap fit converged. 1 indicates convergence, and 0
%    indicates failure to converge for a given bootstrap data set.
% 4) total_elapsed_time: The wall time in seconds for the entire bootstrap procedure.
%
% fit_results_converged_only is a struct where all the fits that did not
% converge have been removed.

fit_results = perform_functional_response_fit( experiment_data , fitting_options );

fit_results_converged_only = remove_nonconverged_fits( fit_results );