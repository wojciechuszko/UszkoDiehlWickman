function beta_fit = find_optimal_fit_sequential( experiment_data , fitting_options , beta_fit_initial )
% This function performs the sequential fit of the parameters beta to the
% experimental data using the matlab function 'nlinfit'. The logtransformed
% or untransformed fit is used based on the option selected.
%
% The procedure proceeds in three steps: First, the experiment data is
% divided into subsets, where all feeding trials in each subset had the
% same temperature. Second, the parameters a, b, and h that best fit the
% data at each temperature is calculated. To avoid negative numbers, what
% is actually fit to the data is log(a), log(b) and log(h). Third, a
% second-degree polynomial in scaled temperature is fit to the fitted
% parameters, and the coefficients for these polynomials are then stored in beta_fit. 


%% Isolate unique temperatures and sort experiment data by temperature

unique_temperatures = unique( experiment_data.temperature );

experiment_data_by_temperature = cell( length( unique_temperatures ) , 1 );

for iii = 1:length( unique_temperatures )
    
    temperature_indices = experiment_data.temperature == unique_temperatures(iii);
    field_names = fields( experiment_data );
    experiment_data_at_temperature = experiment_data;
    for jjj = 1:length( field_names )
        if strcmp( field_names{jjj} , 'number_of_trials' ), continue, end
        
        experiment_data_at_temperature.(field_names{jjj}) = ...
            experiment_data.(field_names{jjj})( temperature_indices );
    end
    
    experiment_data_at_temperature.number_of_trials = sum( temperature_indices );
    
    experiment_data_by_temperature{iii} = experiment_data_at_temperature;
    
end

%% Perform fit at each unique temperature

% Set up matrix of fitted parameters. First row is a, second b, and third
% h, and each column is a specific temperature.
parameter_fits_by_temperature = zeros( 3 , length( unique_temperatures ) );

for iii = 1:length( unique_temperatures )
    
    experiment_data_at_temperature = experiment_data_by_temperature{iii};
    scaled_temperature = experiment_data_at_temperature.scaled_temperature(1);
    
    [a_log,b_log,h_log] = calc_functional_response_parameters_for_temperature( beta_fit_initial , ...
        scaled_temperature );
    
    B0 = [a_log; b_log; h_log];
    X = experiment_data_at_temperature;
    
    if strcmp( fitting_options.transform , 'logtransformed' )
        minimization_target = log( experiment_data_at_temperature.consumed_density );
        
    elseif strcmp( fitting_options.transform , 'untransformed' )
        minimization_target = experiment_data_at_temperature.consumed_density;
        
    else
        error( 'fitting_options.transform must be a string with value <logtransformed> or <untransformed>' )
        
    end
    
    Y = minimization_target;
    matlab_minimizer_options = statset( 'TolX' , 1e-5  , 'TolFun' , 1e-5 );
    
    % We use the same code as for the simultaneous case, and fit log(a),
    % log(b) and log(h), by fitting a0, b0, and h0 in the simultaneous
    % model and fixing all other parameters to 0.
    parameter_fit_at_temperature = nlinfit( X , Y , ...
        @(B,X) calc_minimization_predictor( [B(1);0;0;B(2);0;0;B(3);0;0] , X , fitting_options ) , ...
        B0 , matlab_minimizer_options );
    
    parameter_fits_by_temperature(:,iii) = parameter_fit_at_temperature;
    
end

%% Fit a second degree polynomial to the fitted parameters at each temperature

unique_scaled_temperatures = unique( experiment_data.scaled_temperature );
poly_degree = 2;

a_coeffs = polyfit( unique_scaled_temperatures , parameter_fits_by_temperature(1,:)' , poly_degree );
a_coeffs = fliplr( a_coeffs )';

b_coeffs = polyfit( unique_scaled_temperatures , parameter_fits_by_temperature(2,:)' , poly_degree );
b_coeffs = fliplr( b_coeffs )';

h_coeffs = polyfit( unique_scaled_temperatures , parameter_fits_by_temperature(3,:)' , poly_degree );
h_coeffs = fliplr( h_coeffs )';

beta_fit = [a_coeffs; b_coeffs; h_coeffs];

end

%% Helper function for calculating parameters
function [a_log,b_log,h_log] = calc_functional_response_parameters_for_temperature( B , T )

a_log = B(1) + B(2)*T + B(3)*T^2;
b_log = B(4) + B(5)*T + B(6)*T^2;
h_log = B(7) + B(8)*T + B(9)*T^2;

end





