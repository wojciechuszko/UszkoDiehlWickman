function test_fitting_options( fitting_options )
% This function checks that no illegal option has been passed to the
% struct fitting_options, and that all options have been defined

if ~isfield( fitting_options , 'transform' )
    error( 'field <transform> not defined for fitting options' )
elseif ~strcmp( fitting_options.transform , 'logtransformed' ) && ...
       ~strcmp( fitting_options.transform , 'untransformed' )
   error( 'field <transform> must be a string of value <logtransformed> or <untransformed>' )
end

if ~isfield( fitting_options , 'sequence' )
    error( 'field <sequence> not defined for fitting options' )
elseif ~strcmp( fitting_options.sequence , 'simultaneous' ) && ...
       ~strcmp( fitting_options.sequence , 'sequential' )
   error( 'field <sequence> must be a string of value <simultaneous> or <sequential>' )
end

if ~isfield( fitting_options , 'bootstrap_method' )
    error( 'field <bootstrap_method> not defined for fitting options' )
elseif ~strcmp( fitting_options.bootstrap_method , 'data' ) && ...
       ~strcmp( fitting_options.bootstrap_method , 'residual' )
   error( 'field <bootstrap_method> must be a string of value <data> or <residual>' )
end

if ~isfield( fitting_options , 'display_progress' )
    error( 'field <display_progress> not defined for fitting options' )
elseif ~islogical( fitting_options.display_progress )
   error( 'field <display_progress> must be a logical of value true or false' )
end

if ~isfield( fitting_options , 'number_of_bootstraps' )
    error( 'field <number_of_bootstraps> not defined for fitting options' )
elseif ~( round( fitting_options.number_of_bootstraps ) == fitting_options.number_of_bootstraps ) || ...
       fitting_options.number_of_bootstraps < 0 
   error( 'field <number_of_bootstraps> must be a nonnegative integer' )
end