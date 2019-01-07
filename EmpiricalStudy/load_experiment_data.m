function experiment_data = load_experiment_data( file_name )
% This function loads a pre-formatted data file containing the results from
% a functional-response experiment, and calculates the number of feeding
% trials, as well as the scaled temperature for each trial

experiment_data = load( file_name );
experiment_data.number_of_trials = length( experiment_data.duration );
experiment_data.scaled_temperature = calc_scaled_temperatures( experiment_data );