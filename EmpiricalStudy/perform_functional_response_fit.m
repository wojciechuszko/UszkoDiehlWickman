function fit_results = perform_functional_response_fit( experiment_data , fitting_options )
% The top-level function performing a fit of a functional response to
% experimental feeding data. The program fits temperature-dependent attack
% rates a(T) = exp( a0 + a1*T + a2*T^2 ), Hill exponents b(T) = exp( b0 +
% b1*T + b2*T^2 ), and handling times h(T) = exp( h + h1*T + h2*T^2 ). The
% parameters are stored in the vector beta = [a0 a1 a2 b0 b1 b2 h0 h1 h2]'.
% The initial guess is beta_0 = [0 0 0 0 0 0 0 0 0]' for the primary fit, and
% the primary fit is used as the initial guess for each bootstrap.

%% Get the primary fit of the data

beta_primary = find_optimal_fit( experiment_data , fitting_options );

%% Perform the bootstrapping

[beta_bootstrap, is_converged_bootstrap, total_strap_time ] = ...
    perform_bootstrapping( experiment_data , beta_primary , fitting_options );

%% Convert fitted coefficients to the same order and base as in the paper

% Change order of parameters from beta = [a0 a1 a2 b0 b1 b2 h0 h1 h2]' to
% beta = [a2 a1 a0 b2 b1 b0 h2 h1 h0]'
new_order = [3 2 1 6 5 4 9 8 7]';
beta_primary = beta_primary( new_order );
beta_bootstrap = beta_bootstrap( new_order , : );

% Change base from base e to base 10
conversion_factor = log10( exp(1) );
beta_primary = beta_primary * conversion_factor;
beta_bootstrap = beta_bootstrap * conversion_factor;

%% Store results in fit_results

fit_results = struct;

fit_results.beta_primary = beta_primary;
fit_results.beta_bootstrap = beta_bootstrap;
fit_results.is_converged_bootstrap = is_converged_bootstrap;
fit_results.total_elapsed_time = total_strap_time;