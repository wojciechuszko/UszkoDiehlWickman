function F_sim = simultaneous(z, X)

%% Create ingestion and clearance rate vectors for fitting

IR_nonlog = z;
IR_log = log10(z);
CR_nonlog = z./X(:,1);
CR_log = log10(z./X(:,1));

%% Model formulas; coefficients: b1=a2, b2=a1, b3=a0, b4=b2 , b5=b1, b6=b0, b7=h2, b8=h1, b9=h0

%Log-transformed ingestion rate
formula_log_IR = @(b,x) log10(((10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*x(:,1).^(10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6))))./ ... 
    (1+(10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*(10.^(b(7).*x(:,2).^2 + b(8).*x(:,2) + b(9))).*x(:,1).^(10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6)))));

%Log-transformed clearance rate
formula_log_CR = @(b,x) log10(((10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*x(:,1).^((10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6)))-1))./ ... 
        (1+(10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*(10.^(b(7).*x(:,2).^2 + b(8).*x(:,2) + b(9))).*x(:,1).^(10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6)))));

%Untransformed ingestion rate
formula_nonlog_IR = @(b,x) ((10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*x(:,1).^(10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6))))./ ... 
    (1+(10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*(10.^(b(7).*x(:,2).^2 + b(8).*x(:,2) + b(9))).*x(:,1).^(10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6))));

%Untransformed clearance rate
formula_nonlog_CR = @(b,x) ((10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*x(:,1).^((10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6)))-1))./ ... 
        (1+(10.^(b(1).*x(:,2).^2 + b(2).*x(:,2) + b(3))).*(10.^(b(7).*x(:,2).^2 + b(8).*x(:,2) + b(9))).*x(:,1).^(10.^(b(4).*x(:,2).^2 + b(5).*x(:,2) + b(6))));

%% Fit models

%Initial parameter values
beta0 = [-0.001, 0.1, -1, 0, 0, 0.1, 0.01, -0.1, 1];

%Log-transformed ingestion rate
model_log_IR = fitnlm(X,IR_log,formula_log_IR,beta0);
F_log_IR = model_log_IR.Coefficients.Estimate;

%Log-transformed clearance rate
model_log_CR = fitnlm(X,CR_log,formula_log_CR,beta0);
F_log_CR = model_log_CR.Coefficients.Estimate;

%Untransformed ingestion rate
model_nonlog_IR = fitnlm(X,IR_nonlog,formula_nonlog_IR,beta0);
F_nonlog_IR = model_nonlog_IR.Coefficients.Estimate;

%Untransformed clearance rate
model_nonlog_CR = fitnlm(X,CR_nonlog,formula_nonlog_CR,beta0);
F_nonlog_CR = model_nonlog_CR.Coefficients.Estimate;

%% Create a single matrix with all fitted coefficients
F_sim = [F_log_IR F_log_CR F_nonlog_IR F_nonlog_CR];

end
