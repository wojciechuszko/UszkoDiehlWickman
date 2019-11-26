function bootstrap_data = get_stratified_bootstrap_sample( experiment_data )

%% Split data by temperature
experiment_data_by_temperature = struct;

T_unique = unique( experiment_data.temperature );
field_names = fields( experiment_data );

for iii = 1:length( T_unique )
   
    for jjj = 1:length( field_names )
        
        if length( experiment_data.(field_names{jjj}) ) <= 1, continue, end
        
        experiment_data_by_temperature(iii).(field_names{jjj}) = ...
            experiment_data.(field_names{jjj})( experiment_data.temperature == T_unique(iii) );
        
    end
    
end

%% For each temperature, sort samples by initial prey density
    
for iii = 1:length( T_unique )
   
    [~, sorting_index] = sort( experiment_data_by_temperature(iii).initial_prey_density );
    
    for jjj = 1:length( field_names )
        
        if length( experiment_data.(field_names{jjj}) ) <= 1, continue, end
        
        experiment_data_by_temperature(iii).(field_names{jjj}) = ...
            experiment_data_by_temperature(iii).(field_names{jjj})( sorting_index );
        
    end
end

%% Find all replicates taken at the same initial prey density
 % and draw random samples from the replicates into the bootstrap sample 

density_threshold = 1e-5;

bootstrap_data_by_temperature = experiment_data_by_temperature;

for iii = 1:length( T_unique )
   
    initial_density = experiment_data_by_temperature(iii).initial_prey_density;
    
    finished_loop = false;
    www = 1;
    while ~finished_loop
        
       inds = find( initial_density(www) + density_threshold > initial_density( www:end ) );
       inds = inds + www - 1;
       
       randomized_inds = randi( [min(inds),max(inds)] , length(inds) , 1 );
       
       for jjj = 1:length( field_names )
        
        if length( experiment_data.(field_names{jjj}) ) <= 1, continue, end
        
        bootstrap_data_by_temperature(iii).(field_names{jjj})(inds) = ...
            experiment_data_by_temperature(iii).(field_names{jjj})( randomized_inds );
        
       end
        
       www = max(inds) + 1;
       
       if www > length( initial_density ), finished_loop = true; end
        
    end
    
end

%% Merge temperature-split data into single dataset

bootstrap_data = bootstrap_data_by_temperature(1);

for iii = 2:length( T_unique )
   
    for jjj = 1:length( field_names )
        
        if length( experiment_data.(field_names{jjj}) ) <= 1, continue, end
        
        bootstrap_data.(field_names{jjj}) = ...
            [bootstrap_data.(field_names{jjj}); bootstrap_data_by_temperature(iii).(field_names{jjj})];
        
    end
       
end

bootstrap_data.number_of_trials = experiment_data.number_of_trials;

