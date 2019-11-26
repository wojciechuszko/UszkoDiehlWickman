function bootstrap_data = contstruct_bootstrap_data( experiment_data , beta_primary , fitting_options )

%% Perform data bootstrap
if strcmp( fitting_options.bootstrap_method , 'data' )
    
    n = experiment_data.number_of_trials;
    
    % Randomly and uniformly pick n feeding trial indices with replacement
    random_indices = randi( n , [n,1] );
    
    bootstrap_data = experiment_data;
    field_names = fields( experiment_data );
    
    % Construct the bootstrapped data set by replacing the original feeding
    % trial with the randomly chosen one.
    for jjj = 1:length( field_names )
        if strcmp( field_names{jjj} , 'number_of_trials' ), continue, end
        
        bootstrap_data.(field_names{jjj}) = ...
            experiment_data.(field_names{jjj})( random_indices );
    end
    
%% Perform residual bootstrap
elseif strcmp( fitting_options.bootstrap_method , 'residual' )
    
    predicted_consumed_densities = calc_predicted_consumed_densities( experiment_data , beta_primary );
    
    R0 = experiment_data.initial_prey_density;
    y = experiment_data.consumed_density;
    y_hat = predicted_consumed_densities;
    
    % Measured and predicted proportions of consumed prey
    rho = y./R0;
    rho_hat = y_hat./R0;
    
    % Logit transforms of proportion of consumed prey
    q = log( rho./( 1 - rho ) );
    q_hat = log( rho_hat./( 1 - rho_hat ) );
    
    % Residuals on logit scale
    delta = q - q_hat;
    
    n = experiment_data.number_of_trials;
    % Randomly and uniformly pick n residual indices with replacement 
    random_indices = randi( n , [n,1] );
    
    % Construct the random residuals on the logit scale
    delta_random = delta( random_indices );
    
    % Calculate the logit proportion of consumed prey in bootstrap data
    q_star = q_hat + delta_random;
    
    % Back-transform to get the bootstrapped amount of consumed prey in the
    % bootstrap data
    rho_star = exp( q_star )./( 1 + exp( q_star ) );
    y_star = rho_star.*R0;
    
    bootstrap_data = experiment_data;
    bootstrap_data.consumed_density = y_star;
    
elseif strcmp( fitting_options.bootstrap_method , 'stratified' )
    
    bootstrap_data = get_stratified_bootstrap_sample( experiment_data );
    
else
    error( 'fitting_options.bootstrap_method must be a string with value <data> or <residual>' )
    
end
