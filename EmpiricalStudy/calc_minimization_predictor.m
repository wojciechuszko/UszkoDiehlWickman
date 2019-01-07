function minimization_predictor = calc_minimization_predictor( beta_fit , experiment_data , fitting_options )
% Calculates the predicted consumed densities, or predicted log of consumed
% densities based on the options set.

predicted_consumed_densities = calc_predicted_consumed_densities( experiment_data , beta_fit );

if strcmp( fitting_options.transform , 'logtransformed' )
    minimization_predictor = log( predicted_consumed_densities );
    
    %Fix for parameter-combinations that yield zero consumed density
    minimization_predictor( predicted_consumed_densities <= 0 ) = -30;

elseif strcmp( fitting_options.transform , 'untransformed' )
    minimization_predictor = predicted_consumed_densities;

else
    error( 'fitting_options.transform must be a string with value <logtransformed> or <untransformed>' )
    
end