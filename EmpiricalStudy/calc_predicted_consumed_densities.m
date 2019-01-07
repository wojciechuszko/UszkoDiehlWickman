function predicted_consumed_densities = calc_predicted_consumed_densities( experiment_data , beta_fit )
% Caluculates the predicted consumed densities for the given experiment
% data, and a given set of parameters beta.

predicted_consumed_densities = zeros( experiment_data.number_of_trials , 1 );

%% Linear loop over experiments
% for iii = 1:experiment_data.number_of_trials
%    
%     
%     ode_parameters = calc_ode_parameters( beta_fit , experiment_data.scaled_temperature(iii) , ...
%                      experiment_data.predator_density(iii) );
%     
%     predicted_consumed_densities(iii) = calc_predicted_consumed_density( ode_parameters , ...
%                                         experiment_data.initial_prey_density(iii) ,  ...
%                                         experiment_data.duration(iii) );
%     
% end

%% Solve all ODEs with the same duration simultaneously
% For performance reasons, the ODEs for all feeding trials with the same
% duration are solved simultaneously as a single ODE-system. This does not
% affect the results, but yields a factor ~10 improvement in speed. Regrettably it
% makes the code somewhat harder to read. 

unique_durations = unique( experiment_data.duration );

for iii = 1:length( unique_durations )
   
    duration_iii = unique_durations( iii );
    duration_indices = experiment_data.duration == duration_iii;
    
    scaled_temperatures_for_duration = experiment_data.scaled_temperature( duration_indices );
    predator_densities_for_duration = experiment_data.predator_density( duration_indices );
    initial_prey_densities_for_duration = experiment_data.initial_prey_density( duration_indices );
    
    ode_parameters = calc_ode_parameters( beta_fit , scaled_temperatures_for_duration , ...
                     predator_densities_for_duration );
                 
    matlab_ode_options = odeset( 'reltol' , 1e-6 , 'abstol' , 1e-6 );

    t_0 = 0;
    t_end = duration_iii;
    R0 = initial_prey_densities_for_duration;

    [t, R] = ode45( @(t,R) functional_response_ode( t , R , ode_parameters ) , ...
             [t_0, t_end] , R0 , matlab_ode_options );

    predicted_consumed_densities( duration_indices ) = R0 - R(end,:)';
    
end

1 == 1;