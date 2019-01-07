function precision = calc_precision( beta_primary , beta_bootstrap )

n = size( beta_bootstrap , 2 );

beta_primary_rep = repmat( beta_primary , 1 , n );

D2 = ( beta_primary_rep - beta_bootstrap ).^2;
D2_mean = 1/n * sum( D2 , 2 );

precision = sqrt( D2_mean );