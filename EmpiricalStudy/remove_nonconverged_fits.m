function fit_results_converged_only = remove_nonconverged_fits( fit_results )
% This function removes all bootstrap coefficent from the results where the
% fits did not converge, as well as the indicator for which fits converged

fit_results_converged_only = fit_results;
fit_results_converged_only.beta_bootstrap = ...
    fit_results.beta_bootstrap( : , fit_results.is_converged_bootstrap );

fit_results_converged_only = rmfield( fit_results_converged_only , 'is_converged_bootstrap' );