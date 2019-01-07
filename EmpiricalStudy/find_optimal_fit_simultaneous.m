function beta_fit = find_optimal_fit_simultaneous( experiment_data , fitting_options , beta_fit_initial )
% This function performs the simultaneous fit of the parameters beta to the
% experimental data using the matlab function 'nlinfit'. The logtransformed
% or untransformed fit is used based on the option selected. 

B0 = beta_fit_initial;
X = experiment_data;

if strcmp( fitting_options.transform , 'logtransformed' )
    minimization_target = log( experiment_data.consumed_density );

elseif strcmp( fitting_options.transform , 'untransformed' )
    minimization_target = experiment_data.consumed_density;

else
    error( 'fitting_options.transform must be a string with value <logtransformed> or <untransformed>' )

end

Y = minimization_target;
matlab_minimizer_options = statset( 'TolX' , 1e-5  , 'TolFun' , 1e-5 );

beta_fit = nlinfit( X , Y , @(B,X) calc_minimization_predictor( B , X , fitting_options ) , ...
           B0 , matlab_minimizer_options );