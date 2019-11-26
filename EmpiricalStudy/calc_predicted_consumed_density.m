function predicted_consumed_density = calc_predicted_consumed_density( ode_parameters , ...
                                      initial_prey_density , duration )
                                  
matlab_ode_options = odeset( 'reltol' , 1e-6 , 'abstol' , 1e-6 );

t_0 = 0;
t_end = duration;
R0 = initial_prey_density;

[t, R] = ode15s( @(t,R) functional_response_ode( t , R , ode_parameters ) , ...
       [t_0, t_end] , R0 , matlab_ode_options );
   
predicted_consumed_density = R0 - R(end);