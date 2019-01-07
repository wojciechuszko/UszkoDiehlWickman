function [beta_fit, is_converged] = find_optimal_fit( experiment_data , fitting_options , beta_fit_initial )
% This function sets the initial conditions if no initial condition has
% been supplied, and chooses the simultaneous or sequential method based on
% the specified options in fitting_options. If any warnings or errors were detected
% issuing from matlab's numerical fitting algorithm, the fit is deemed to
% have not converged.

if nargin < 3
    beta_fit_initial = zeros(9,1);
end

if strcmp( fitting_options.sequence , 'simultaneous' )
    
    lastwarn('');
    
    try 
    
        beta_fit = find_optimal_fit_simultaneous( experiment_data , fitting_options , beta_fit_initial );

        if ~isempty(lastwarn)
            is_converged = false;
        else
            is_converged = true;
        end
        
    catch
        
        warning( 'Fit failed to converge, setting beta values to 0' )
        beta_fit = zeros(9,1);
        is_converged = false;
        
    end
    
elseif strcmp( fitting_options.sequence , 'sequential' )
    
    lastwarn('');
    
    try
    
        beta_fit = find_optimal_fit_sequential( experiment_data , fitting_options , beta_fit_initial );

        if ~isempty(lastwarn)
            is_converged = false;
        else
            is_converged = true;
        end
    
    catch
        
        warning( 'Fit failed to converge, setting beta values to 0' )
        beta_fit = zeros(9,1);
        is_converged = false;
        
    end
    
else
    
    error( 'fitting_options.sequence must be a string with value <siumltaneous> or <sequential>' )
    
end

