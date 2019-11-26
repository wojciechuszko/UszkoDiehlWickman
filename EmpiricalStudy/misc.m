figure
plot3( experiment_data.initial_prey_density , experiment_data.temperature , ...
    experiment_data.consumed_density , 'ok' , 'markerfacecolor' , 'k' )
set( gca , 'xscale' , 'log' )
grid on
box on
title('Experiment data')

figure
plot3( bootstrap_data.initial_prey_density , bootstrap_data.temperature , ...
    bootstrap_data.consumed_density , 'ok' , 'markerfacecolor' , 'k' )
set( gca , 'xscale' , 'log' )
grid on
box on
title('bootstrap data')