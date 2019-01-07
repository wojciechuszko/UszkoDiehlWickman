function ode_parameters = calc_ode_parameters( beta_fit , scaled_temperature , ...
                          predator_density )
% This function calculates the temperature-dependent attack rates a, Hill exponents b, 
% and handling times h for given temperatures and given fitting parameters beta_fit,
% and stores them in a struct.
% The predator densities are stored in the same struct as G, for ease of
% use in the function describing the ODE system.

ode_parameters = struct;                      
                      
B = beta_fit;
T = scaled_temperature;

ode_parameters.a = exp( B(1) + B(2)*T + B(3)*T.^2 );
ode_parameters.b = exp( B(4) + B(5)*T + B(6)*T.^2 );
ode_parameters.h = exp( B(7) + B(8)*T + B(9)*T.^2 );

ode_parameters.G = predator_density;