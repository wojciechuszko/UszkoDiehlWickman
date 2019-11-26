clc
clear
close all
%% Series 2

transform_options = {'logtransformed', 'untransformed'};
sequence_options = {'simultaneous' , 'sequential' };
bootstrap_method = {'residual','data'};

for iii = 2:2
    for jjj = 2:2
        for kkk = 1:2
            
            fitting_options = struct;
            fitting_options.transform = transform_options{iii};
            fitting_options.sequence = sequence_options{jjj};
            fitting_options.bootstrap_method = bootstrap_method{kkk};
            fitting_options.number_of_bootstraps = 10000;
            fitting_options.display_progress = true;
            
            test_fitting_options( fitting_options );
            
            experiment_data = load_experiment_data( 'experimental_series_2_data.mat' );
            
            fit_results = perform_functional_response_fit( experiment_data , fitting_options );
            
            save_name = ['bootstrapresults_', transform_options{iii}, '_' ...
                         sequence_options{jjj} , '_' , bootstrap_method{kkk} , '.mat' ];
                     
            save( save_name , 'fit_results' , 'fitting_options' , 'experiment_data' )
            
        end
    end
end
%% Series 1
for iii = 1:2
    for jjj = 1:2
        for kkk = 1:2
            
            fitting_options = struct;
            fitting_options.transform = transform_options{iii};
            fitting_options.sequence = sequence_options{jjj};
            fitting_options.bootstrap_method = bootstrap_method{kkk};
            fitting_options.number_of_bootstraps = 10000;
            fitting_options.display_progress = true;
            
            test_fitting_options( fitting_options );
            
            experiment_data = load_experiment_data( 'experimental_series_1_data.mat' );
            
            fit_results = perform_functional_response_fit( experiment_data , fitting_options );
            
            save_name = ['Series1Results/bootstrapresults_', transform_options{iii}, '_' ...
                         sequence_options{jjj} , '_' , bootstrap_method{kkk} '_series1' , '.mat' ];
                     
            save( save_name , 'fit_results' , 'fitting_options' , 'experiment_data' )
            
        end
    end
end