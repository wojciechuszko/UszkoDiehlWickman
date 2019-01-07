function B_rescaled = rescale_coefficients( B_unrescaled , T_min , T_max , p )

% B_untransformed is an 9 x N matrix where each column holds the parameters
% [a2,a1,a0,b2,b1,b0,h2,h1,h0]'

B_temp = B_unrescaled;
B_temp( [1,4,7] , : ) = B_unrescaled( [3,6,9] , : );
B_temp( [3,6,9] , : ) = B_unrescaled( [1,4,7] , : );
B_unrescaled = B_temp;


dT = T_max - T_min;

F_inv = [ 1, T_min,    T_min^2;
          0,    dT, 2*T_min*dT;
          0,     0,       dT^2];
      
if p == 0
    F_inv = inv(F_inv);
    a_t = F_inv*B_unrescaled(1:3,:);
    b_t = F_inv*B_unrescaled(4:6,:);
    h_t = F_inv*B_unrescaled(7:9,:);
    B_rescaled = [a_t;b_t;h_t];
    B_temp = B_rescaled;

    B_temp( [1,4,7] , : ) = B_rescaled( [3,6,9] , : );
    B_temp( [3,6,9] , : ) = B_rescaled( [1,4,7] , : );
    B_rescaled = B_temp;

else
    a_t = F_inv*B_unrescaled(1:3,:);
    b_t = F_inv*B_unrescaled(4:6,:);
    h_t = F_inv*B_unrescaled(7:9,:);
    B_rescaled = [a_t;b_t;h_t];
    B_temp = B_rescaled;

    B_temp( [1,4,7] , : ) = B_rescaled( [3,6,9] , : );
    B_temp( [3,6,9] , : ) = B_rescaled( [1,4,7] , : );
    B_rescaled = B_temp;
end
