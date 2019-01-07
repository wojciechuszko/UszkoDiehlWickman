function dR_dt = functional_response_ode( t , R , p )
% This function calculates the right-hand-side of the ODE governing the
% depletion of the prey/resource due to predation/consumption, 
% dR(t)/dt = -aR^b/( 1 + ahR(t)^b )*G
%
% Input arguements: 
% t: The time elapsed in the simulated feeding trial
% R: The resource-density at time t in the feeding trial
% p: A struct containing information on parameters a, b, and h, as well as the
%    predator density G

% Computationally cheap method of avoiding problems with negative densities
R = max( R , 0 );

dR_dt = -p.a.*R.^p.b ./ ( 1 + p.a.*p.h.*R.^p.b ) .* p.G; 