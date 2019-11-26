function [beta_bootstrap, is_converged, total_strap_time ] = ...
    perform_bootstrapping( experiment_data , beta_primary , fitting_options )
% This function performs the bootstrapping of the functional-response fit
% by using data-resampling or residual resampling, depending on the options
% given. If fitting_options.display_progress is set to true, a waitbar
% showing how many bootstraps have been performed will be displayed.

beta_bootstrap = zeros( 9 , fitting_options.number_of_bootstraps );
is_converged = false( fitting_options.number_of_bootstraps , 1 );

if fitting_options.display_progress
    waitbar_handle = waitbar( 0 , 'Performing bootstrap...' );
end

strap_timer = tic;

for iii = 1:fitting_options.number_of_bootstraps
    
    bootstrap_data = contstruct_bootstrap_data( experiment_data , beta_primary , fitting_options );
    
    [beta_bootstrap(:,iii), is_converged(iii)] = ...
        find_optimal_fit( bootstrap_data , fitting_options , beta_primary );
    
    if fitting_options.display_progress
        waitbar_string = ['Performing bootstrap... ' , num2str(iii) , '/' , ...
                          num2str( fitting_options.number_of_bootstraps ) , ...
                          ', Time elapsed = ' , num2str( toc(strap_timer) ) ];
        waitbar( iii/fitting_options.number_of_bootstraps , waitbar_handle , waitbar_string )
    end
    
end

if fitting_options.display_progress
    close( waitbar_handle )
end

total_strap_time = toc( strap_timer );

end