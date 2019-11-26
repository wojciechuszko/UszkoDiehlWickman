function plot_parameter_fits( beta_primary , beta_bootstrap , experiment_data )

T_min = min( experiment_data.temperature );
T_max = max( experiment_data.temperature );
n_temp = 100;

temperature_range = linspace( T_min , T_max , n_temp )';
scaled_temperature_range = linspace( 0 , 1 , n_temp )';
T_s = scaled_temperature_range;

a_prim = 10.^( beta_primary(1)*T_s.^2 + beta_primary(2)*T_s + beta_primary(3) );
b_prim = 10.^( beta_primary(4)*T_s.^2 + beta_primary(5)*T_s + beta_primary(6) );
h_prim = 10.^( beta_primary(7)*T_s.^2 + beta_primary(8)*T_s + beta_primary(9) );

a_boot = 10.^( T_s.^2*beta_bootstrap(1,:) + T_s*beta_bootstrap(2,:) + ones(n_temp,1)*beta_bootstrap(3,:) );
b_boot = 10.^( T_s.^2*beta_bootstrap(4,:) + T_s*beta_bootstrap(5,:) + ones(n_temp,1)*beta_bootstrap(6,:) );
h_boot = 10.^( T_s.^2*beta_bootstrap(7,:) + T_s*beta_bootstrap(8,:) + ones(n_temp,1)*beta_bootstrap(9,:) );

percentile_values = [0.025, 0.975];
a_perc = calc_percentile_curves( a_boot , percentile_values );
b_perc = calc_percentile_curves( b_boot , percentile_values );
h_perc = calc_percentile_curves( h_boot , percentile_values );

line_alpha = 0.01;
figure
hold on

ax1 = subplot( 1 , 3 , 1 );
hold on
co = get(gca, 'ColorOrder');
plot( temperature_range , a_boot , 'color' , [co(1,:),line_alpha] )
plot( temperature_range , a_prim , 'k' )
plot( temperature_range , a_perc , 'k--' )
set( ax1 , 'yscale' , 'log' )
xlim( [T_min T_max] )
ylim( [1e-1, 1e4] )
box on

ax2 = subplot( 1 , 3 , 2 );
hold on
co = get(gca, 'ColorOrder');
plot( temperature_range , b_boot , 'color' , [co(1,:),line_alpha] )
plot( temperature_range , b_prim , 'k' )
plot( temperature_range , b_perc , 'k--' )
set( ax2 , 'yscale' , 'log' )
xlim( [T_min T_max] )
ylim( [1e-1, 1e1] )
box on

ax3 = subplot( 1 , 3 , 3 );
hold on
co = get(gca, 'ColorOrder');
plot( temperature_range , h_boot , 'color' , [co(1,:),line_alpha] )
plot( temperature_range , h_prim , 'k' )
plot( temperature_range , h_perc , 'k--' )
set( ax3 , 'yscale' , 'log' )
xlim( [T_min T_max] )
ylim( [1e-1, 1e1] )
box on

%% Ratio curves
figure
hold on

ax1 = subplot( 1 , 3 , 1 );
hold on
co = get(gca, 'ColorOrder');
plot( temperature_range , diag( 1./a_prim )*a_boot , 'color' , [co(1,:),line_alpha] )
plot( temperature_range , ones( size(temperature_range) ) , 'k' )
plot( temperature_range , diag( 1./a_prim )*a_perc , 'k--' )
set( ax1 , 'yscale' , 'log' )
xlim( [T_min T_max] )
ylim( [1e-1, 1e1] )
box on

ax2 = subplot( 1 , 3 , 2 );
hold on
co = get(gca, 'ColorOrder');
plot( temperature_range , diag( 1./b_prim )*b_boot , 'color' , [co(1,:),line_alpha] )
plot( temperature_range , ones( size(temperature_range) ) , 'k' )
plot( temperature_range , diag( 1./b_prim )*b_perc , 'k--' )
set( ax2 , 'yscale' , 'log' )
xlim( [T_min T_max] )
ylim( [1e-1, 1e1] )
box on

ax3 = subplot( 1 , 3 , 3 );
hold on
co = get(gca, 'ColorOrder');
plot( temperature_range , diag( 1./h_prim )*h_boot , 'color' , [co(1,:),line_alpha] )
plot( temperature_range , ones( size(temperature_range) ) , 'k' )
plot( temperature_range , diag( 1./h_prim )*h_perc , 'k--' )
set( ax3 , 'yscale' , 'log' )
xlim( [T_min T_max] )
ylim( [1e-1, 1e1] )
box on

end

function percentile_curves = calc_percentile_curves( curves_matrix , percentile_values )

    CM = sort( curves_matrix , 2 );
    S = size( CM , 2 );
    
    percentile_curves = zeros( size( CM , 1 ) , length( percentile_values ) );
    
    for iii = 1:length( percentile_values )
        
        ind = max( min( round( percentile_values(iii)*S ) , S ) , 1 );
        
        percentile_curves(:,iii) = CM(:,ind);
        
    end
    


end

