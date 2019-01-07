%% Code for data generation and analysis in the main simulation study
% The code generates noisy ingestion rates from the true values of parameter coefficients,
% and performs simultaneous and sequential fitting to untransformed and log-transformed ingestion and clearance rates
% Note: data generation and fitting use non-rescaled temperature
clear
clc

%% True rescaled parameter values
a2_true = -2.5;
a1_true = 4;
a0_true = -0.35;
b2_true = 0;
b1_true = 0;
b0_true = 0.18;
h2_true = 3.75;
h1_true = -3.5;
h0_true = 0.65;

%Rescale the true coefficients back to 'normal' temperature scale
A_rescaled = [a2_true; a1_true; a0_true; b2_true; b1_true; b0_true; h2_true; h1_true; h0_true];
A = rescale_coefficients(A_rescaled, 5, 30, 0);
a2 = A(1);
a1 = A(2);
a0 = A(3);
b2 = A(4);
b1 = A(5);
b0 = A(6);
h2 = A(7);
h1 = A(8);
h0 = A(9);

%% Create a food density vector
R = [0.005; 0.005; 0.005; 0.01; 0.01; 0.01; 0.02; 0.02; 0.02; 0.04; 0.04; 0.04; 0.055; 0.055; 0.055; 0.07; 0.07; 0.07; 0.1; 0.1; 0.1; 0.125; 0.125; 0.125; 0.15; 0.15; 0.15; 0.3; 0.3; 0.3; 0.6; 0.6; 0.6; 0.85; 0.85; 0.85; 1.2; 1.2; 1.2; 1.8; 1.8; 1.8; 2.4; 2.4; 2.4];

R_270 = [R; R; R; R; R; R];

%% Create temperature vectors
T5  = 5*ones(45,1);
T10 = 10*ones(45,1);
T15 = 15*ones(45,1);
T20 = 20*ones(45,1);
T25 = 25*ones(45,1);
T30 = 30*ones(45,1);

T = [T5; T10; T15; T20; T25; T30];

%% Join R_270 and T into a sinlge matrix
X = [R_270 T];

%% Generate true ingestion rates at each temperature
IR_T5  = ((10.^(a2.*T5.^2 + a1.*T5 +a0)).*R.^(10.^(b2.*T5.^2 + b1.*T5 +b0)))./(1+(10.^(a2.*T5.^2 + a1.*T5 +a0)).*(10.^(h2.*T5.^2 + h1.*T5 +h0)).*R.^(10.^(b2.*T5.^2 + b1.*T5 +b0)));
IR_T10 = ((10.^(a2.*T10.^2 + a1.*T10 +a0)).*R.^(10.^(b2.*T10.^2 + b1.*T10 +b0)))./(1+(10.^(a2.*T10.^2 + a1.*T10 +a0)).*(10.^(h2.*T10.^2 + h1.*T10 +h0)).*R.^(10.^(b2.*T10.^2 + b1.*T10 +b0)));
IR_T15 = ((10.^(a2.*T15.^2 + a1.*T15 +a0)).*R.^(10.^(b2.*T15.^2 + b1.*T15 +b0)))./(1+(10.^(a2.*T15.^2 + a1.*T15 +a0)).*(10.^(h2.*T15.^2 + h1.*T15 +h0)).*R.^(10.^(b2.*T15.^2 + b1.*T15 +b0)));
IR_T20 = ((10.^(a2.*T20.^2 + a1.*T20 +a0)).*R.^(10.^(b2.*T20.^2 + b1.*T20 +b0)))./(1+(10.^(a2.*T20.^2 + a1.*T20 +a0)).*(10.^(h2.*T20.^2 + h1.*T20 +h0)).*R.^(10.^(b2.*T20.^2 + b1.*T20 +b0)));
IR_T25 = ((10.^(a2.*T25.^2 + a1.*T25 +a0)).*R.^(10.^(b2.*T25.^2 + b1.*T25 +b0)))./(1+(10.^(a2.*T25.^2 + a1.*T25 +a0)).*(10.^(h2.*T25.^2 + h1.*T25 +h0)).*R.^(10.^(b2.*T25.^2 + b1.*T25 +b0)));
IR_T30 = ((10.^(a2.*T30.^2 + a1.*T30 +a0)).*R.^(10.^(b2.*T30.^2 + b1.*T30 +b0)))./(1+(10.^(a2.*T30.^2 + a1.*T30 +a0)).*(10.^(h2.*T30.^2 + h1.*T30 +h0)).*R.^(10.^(b2.*T30.^2 + b1.*T30 +b0)));

%% Set the number of iterations and create result matrices
iter = 5;

results_simultaneous_log_IR = ones(9,iter);
results_simultaneous_log_CR = ones(9,iter);
results_simultaneous_nonlog_IR = ones(9,iter);
results_simultaneous_nonlog_CR = ones(9,iter);

results_sequential_log_IR = ones(9,iter);
results_sequential_log_CR = ones(9,iter);
results_sequential_nonlog_IR = ones(9,iter);
results_sequential_nonlog_CR = ones(9,iter);

%% Add variability to generated ingestion rates and perform fits
for i = 1:iter
    
    %Add random noise to true ingestion rates at each temperature
    %the function 'abs' changes the sign of all (rare) negative ingestion rates
    z_T5  = abs(norminv(rand([45 1]),IR_T5,0.31*IR_T5));
    z_T10 = abs(norminv(rand([45 1]),IR_T10,0.31*IR_T10));
    z_T15 = abs(norminv(rand([45 1]),IR_T15,0.31*IR_T15));
    z_T20 = abs(norminv(rand([45 1]),IR_T20,0.31*IR_T20));
    z_T25 = abs(norminv(rand([45 1]),IR_T25,0.31*IR_T25));
    z_T30 = abs(norminv(rand([45 1]),IR_T30,0.31*IR_T30));
    
    %Create a single vector with all noisy ingestion rates
    z = [z_T5; z_T10; z_T15; z_T20; z_T25; z_T30];
    
    %Perform simultaneous fits and save results
    F_sim = simultaneous(z, X);
    
    results_simultaneous_log_IR(:,i) = F_sim(:,1);
    results_simultaneous_log_CR(:,i) = F_sim(:,2);
    results_simultaneous_nonlog_IR(:,i) = F_sim(:,3);
    results_simultaneous_nonlog_CR(:,i) = F_sim(:,4);
    
    %Perform sequential fits and save results
    F_seq = sequential(z, X);
    
    results_sequential_log_IR(:,i) = F_seq(:,1);
    results_sequential_log_CR(:,i) = F_seq(:,2);
    results_sequential_nonlog_IR(:,i) = F_seq(:,3);
    results_sequential_nonlog_CR(:,i) = F_seq(:,4);
    
end

%% Rescale the fitted coefficients back to unitless temperature scale and save the results as .mat files
%Rows are fitted coefficients in order a2, a1, a0, b2, b1, b0, h2, h1, h0
%Columns are different fits, so that the number of columns = iter
results_simultaneous_log_IR = rescale_coefficients(results_simultaneous_log_IR, 5, 30, 1);
results_simultaneous_log_CR = rescale_coefficients(results_simultaneous_log_CR, 5, 30, 1);
results_simultaneous_nonlog_IR = rescale_coefficients(results_simultaneous_nonlog_IR, 5, 30, 1);
results_simultaneous_nonlog_CR = rescale_coefficients(results_simultaneous_nonlog_CR, 5, 30, 1);

results_sequential_log_IR = rescale_coefficients(results_sequential_log_IR, 5, 30, 1);
results_sequential_log_CR = rescale_coefficients(results_sequential_log_CR, 5, 30, 1);
results_sequential_nonlog_IR = rescale_coefficients(results_sequential_nonlog_IR, 5, 30, 1);
results_sequential_nonlog_CR = rescale_coefficients(results_sequential_nonlog_CR, 5, 30, 1);

save('results_simultaneous_log_IR.mat', 'results_simultaneous_log_IR');
save('results_simultaneous_log_CR.mat', 'results_simultaneous_log_CR');
save('results_simultaneous_nonlog_IR.mat', 'results_simultaneous_nonlog_IR');
save('results_simultaneous_nonlog_CR.mat', 'results_simultaneous_nonlog_CR');

save('results_sequential_log_IR.mat', 'results_sequential_log_IR');
save('results_sequential_log_CR.mat', 'results_sequential_log_CR');
save('results_sequential_nonlog_IR.mat', 'results_sequential_nonlog_IR');
save('results_sequential_nonlog_CR.mat', 'results_sequential_nonlog_CR');
