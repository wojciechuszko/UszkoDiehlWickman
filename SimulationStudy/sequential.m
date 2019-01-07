function F_seq = sequential(z, X)

%% Create ingestion and clearance rate vectors for fitting

IR_nonlog_T5  = z(1:45,1);
IR_nonlog_T10 = z(46:90,1);
IR_nonlog_T15 = z(91:135,1);
IR_nonlog_T20 = z(136:180,1);
IR_nonlog_T25 = z(181:225,1);
IR_nonlog_T30 = z(226:270,1);

IR_log_T5  = log10(z(1:45,1));
IR_log_T10 = log10(z(46:90,1));
IR_log_T15 = log10(z(91:135,1));
IR_log_T20 = log10(z(136:180,1));
IR_log_T25 = log10(z(181:225,1));
IR_log_T30 = log10(z(226:270,1));

CR_nonlog_T5  = z(1:45,1)./X(1:45,1);
CR_nonlog_T10 = z(46:90,1)./X(1:45,1);
CR_nonlog_T15 = z(91:135,1)./X(1:45,1);
CR_nonlog_T20 = z(136:180,1)./X(1:45,1);
CR_nonlog_T25 = z(181:225,1)./X(1:45,1);
CR_nonlog_T30 = z(226:270,1)./X(1:45,1);

CR_log_T5  = log10(z(1:45,1)./X(1:45,1));
CR_log_T10 = log10(z(46:90,1)./X(1:45,1));
CR_log_T15 = log10(z(91:135,1)./X(1:45,1));
CR_log_T20 = log10(z(136:180,1)./X(1:45,1));
CR_log_T25 = log10(z(181:225,1)./X(1:45,1));
CR_log_T30 = log10(z(226:270,1)./X(1:45,1));

T = [5; 10; 15; 20; 25; 30];
X_fit = X(1:45,1);

%% Fit to untransformed ingestion rate

%Fit the Holling model to ingestion rates at each temperature
%b1=a (attack rate), b2=b (Hill exponent), b3=h (handling time)
X = X_fit;
formula_nonlog_IR_T5 = @(b,x) ((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
beta0 = [5, 1.5, 10];
model_nonlog_IR_T5 = fitnlm(X,IR_nonlog_T5,formula_nonlog_IR_T5,beta0);
F_nonlog_IR_T5 = model_nonlog_IR_T5.Coefficients.Estimate;

formula_nonlog_IR_T10 = @(b,x) ((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_IR_T10 = fitnlm(X,IR_nonlog_T10,formula_nonlog_IR_T10,beta0);
F_nonlog_IR_T10 = model_nonlog_IR_T10.Coefficients.Estimate;

formula_nonlog_IR_T15 = @(b,x) ((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_IR_T15 = fitnlm(X,IR_nonlog_T15,formula_nonlog_IR_T15,beta0);
F_nonlog_IR_T15 = model_nonlog_IR_T15.Coefficients.Estimate;

formula_nonlog_IR_T20 = @(b,x) ((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_IR_T20 = fitnlm(X,IR_nonlog_T20,formula_nonlog_IR_T20,beta0);
F_nonlog_IR_T20 = model_nonlog_IR_T20.Coefficients.Estimate;

formula_nonlog_IR_T25 = @(b,x) ((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_IR_T25 = fitnlm(X,IR_nonlog_T25,formula_nonlog_IR_T25,beta0);
F_nonlog_IR_T25 = model_nonlog_IR_T25.Coefficients.Estimate;

formula_nonlog_IR_T30 = @(b,x) ((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_IR_T30 = fitnlm(X,IR_nonlog_T30,formula_nonlog_IR_T30,beta0);
F_nonlog_IR_T30 = model_nonlog_IR_T30.Coefficients.Estimate;

%Fit the second polynomial to fitted log10s of a, b and h
a_nonlog_IR = log10([F_nonlog_IR_T5(1); F_nonlog_IR_T10(1); F_nonlog_IR_T15(1); F_nonlog_IR_T20(1); F_nonlog_IR_T25(1); F_nonlog_IR_T30(1)]);
b_nonlog_IR = log10([F_nonlog_IR_T5(2); F_nonlog_IR_T10(2); F_nonlog_IR_T15(2); F_nonlog_IR_T20(2); F_nonlog_IR_T25(2); F_nonlog_IR_T30(2)]);
h_nonlog_IR = log10([F_nonlog_IR_T5(3); F_nonlog_IR_T10(3); F_nonlog_IR_T15(3); F_nonlog_IR_T20(3); F_nonlog_IR_T25(3); F_nonlog_IR_T30(3)]);

X = T;

formula_a = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [-0.001, 0.1, -1];
y = a_nonlog_IR;
model_a_temp = fitnlm(X,y,formula_a,beta0);
a_temp_nonlog_IR = model_a_temp.Coefficients.Estimate;

formula_b = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0, 0, 0.1];
y = b_nonlog_IR;
model_b_temp = fitnlm(X,y,formula_b,beta0);
b_temp_nonlog_IR = model_b_temp.Coefficients.Estimate;

formula_h = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0.01, -0.1, 1];
y = h_nonlog_IR;
model_h_temp = fitnlm(X,y,formula_h,beta0);
h_temp_nonlog_IR = model_h_temp.Coefficients.Estimate;

F_nonlog_IR = [a_temp_nonlog_IR; b_temp_nonlog_IR; h_temp_nonlog_IR];

%% Fit to log-transformed ingestion rate

%Fit the Holling model to ingestion rates at each temperature
%b1=a (attack rate), b2=b (Hill exponent), b3=h (handling time)
X = X_fit;
formula_log_IR_T5 = @(b,x) log10((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
beta0 = [5, 1.5, 10];
model_log_IR_T5 = fitnlm(X,IR_log_T5,formula_log_IR_T5,beta0);
F_log_IR_T5 = model_log_IR_T5.Coefficients.Estimate;

formula_log_IR_T10 = @(b,x) log10((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_log_IR_T10 = fitnlm(X,IR_log_T10,formula_log_IR_T10,beta0);
F_log_IR_T10 = model_log_IR_T10.Coefficients.Estimate;

formula_log_IR_T15 = @(b,x) log10((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_log_IR_T15 = fitnlm(X,IR_log_T15,formula_log_IR_T15,beta0);
F_log_IR_T15 = model_log_IR_T15.Coefficients.Estimate;

formula_log_IR_T20 = @(b,x) log10((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_log_IR_T20 = fitnlm(X,IR_log_T20,formula_log_IR_T20,beta0);
F_log_IR_T20 = model_log_IR_T20.Coefficients.Estimate;

formula_log_IR_T25 = @(b,x) log10((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_log_IR_T25 = fitnlm(X,IR_log_T25,formula_log_IR_T25,beta0);
F_log_IR_T25 = model_log_IR_T25.Coefficients.Estimate;

formula_log_IR_T30 = @(b,x) log10((b(1)*x.^b(2))./(1+b(1)*b(3)*x.^b(2)));
model_log_IR_T30 = fitnlm(X,IR_log_T30,formula_log_IR_T30,beta0);
F_log_IR_T30 = model_log_IR_T30.Coefficients.Estimate;

%Fit the second polynomial to fitted log10s of a, b and h
a_log_IR = log10([F_log_IR_T5(1); F_log_IR_T10(1); F_log_IR_T15(1); F_log_IR_T20(1); F_log_IR_T25(1); F_log_IR_T30(1)]);
b_log_IR = log10([F_log_IR_T5(2); F_log_IR_T10(2); F_log_IR_T15(2); F_log_IR_T20(2); F_log_IR_T25(2); F_log_IR_T30(2)]);
h_log_IR = log10([F_log_IR_T5(3); F_log_IR_T10(3); F_log_IR_T15(3); F_log_IR_T20(3); F_log_IR_T25(3); F_log_IR_T30(3)]);

X = T;

formula_a = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [-0.001, 0.1, -1];
y = a_log_IR;
model_a_temp = fitnlm(X,y,formula_a,beta0);
a_temp_log_IR = model_a_temp.Coefficients.Estimate;

formula_b = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0, 0, 0.1];
y = b_log_IR;
model_b_temp = fitnlm(X,y,formula_b,beta0);
b_temp_log_IR = model_b_temp.Coefficients.Estimate;

formula_h = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0.01, -0.1, 1];
y = h_log_IR;
model_h_temp = fitnlm(X,y,formula_h,beta0);
h_temp_log_IR = model_h_temp.Coefficients.Estimate;

F_log_IR = [a_temp_log_IR; b_temp_log_IR; h_temp_log_IR];

%% Fit to untransformed clearance rate

%Fit the Holling model to ingestion rates at each temperature
%b1=a (attack rate), b2=b (Hill exponent), b3=h (handling time)
X = X_fit;
formula_nonlog_CR_T5 = @(b,x) ((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
beta0 = [5, 1.5, 10];
model_nonlog_CR_T5 = fitnlm(X,CR_nonlog_T5,formula_nonlog_CR_T5,beta0);
F_nonlog_CR_T5 = model_nonlog_CR_T5.Coefficients.Estimate;

formula_nonlog_CR_T10 = @(b,x) ((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_CR_T10 = fitnlm(X,CR_nonlog_T10,formula_nonlog_CR_T10,beta0);
F_nonlog_CR_T10 = model_nonlog_CR_T10.Coefficients.Estimate;

formula_nonlog_CR_T15 = @(b,x) ((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_CR_T15 = fitnlm(X,CR_nonlog_T15,formula_nonlog_CR_T15,beta0);
F_nonlog_CR_T15 = model_nonlog_CR_T15.Coefficients.Estimate;

formula_nonlog_CR_T20 = @(b,x) ((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_CR_T20 = fitnlm(X,CR_nonlog_T20,formula_nonlog_CR_T20,beta0);
F_nonlog_CR_T20 = model_nonlog_CR_T20.Coefficients.Estimate;

formula_nonlog_CR_T25 = @(b,x) ((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_CR_T25 = fitnlm(X,CR_nonlog_T25,formula_nonlog_CR_T25,beta0);
F_nonlog_CR_T25 = model_nonlog_CR_T25.Coefficients.Estimate;

formula_nonlog_CR_T30 = @(b,x) ((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_nonlog_CR_T30 = fitnlm(X,CR_nonlog_T30,formula_nonlog_CR_T30,beta0);
F_nonlog_CR_T30 = model_nonlog_CR_T30.Coefficients.Estimate;

%Fit the second polynomial to fitted log10s of a, b and h
a_nonlog_CR = log10([F_nonlog_CR_T5(1); F_nonlog_CR_T10(1); F_nonlog_CR_T15(1); F_nonlog_CR_T20(1); F_nonlog_CR_T25(1); F_nonlog_CR_T30(1)]);
b_nonlog_CR = log10([F_nonlog_CR_T5(2); F_nonlog_CR_T10(2); F_nonlog_CR_T15(2); F_nonlog_CR_T20(2); F_nonlog_CR_T25(2); F_nonlog_CR_T30(2)]);
h_nonlog_CR = log10([F_nonlog_CR_T5(3); F_nonlog_CR_T10(3); F_nonlog_CR_T15(3); F_nonlog_CR_T20(3); F_nonlog_CR_T25(3); F_nonlog_CR_T30(3)]);

X = T;

formula_a = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [-0.001, 0.1, -1];
y = a_nonlog_CR;
model_a_temp = fitnlm(X,y,formula_a,beta0);
a_temp_nonlog_CR = model_a_temp.Coefficients.Estimate;

formula_b = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0, 0, 0.1];
y = b_nonlog_CR;
model_b_temp = fitnlm(X,y,formula_b,beta0);
b_temp_nonlog_CR = model_b_temp.Coefficients.Estimate;

formula_h = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0.01, -0.1, 1];
y = h_nonlog_CR;
model_h_temp = fitnlm(X,y,formula_h,beta0);
h_temp_nonlog_CR = model_h_temp.Coefficients.Estimate;

F_nonlog_CR = [a_temp_nonlog_CR; b_temp_nonlog_CR; h_temp_nonlog_CR];

%% Fit to log-transformed clearance rate

%Fit the Holling model to ingestion rates at each temperature
%b1=a (attack rate), b2=b (Hill exponent), b3=h (handling time)
X = X_fit;
formula_log_CR_T5 = @(b,x) log10((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
beta0 = [5, 1.5, 10];
model_log_CR_T5 = fitnlm(X,CR_log_T5,formula_log_CR_T5,beta0);
F_log_CR_T5 = model_log_CR_T5.Coefficients.Estimate;

formula_log_CR_T10 = @(b,x) log10((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_log_CR_T10 = fitnlm(X,CR_log_T10,formula_log_CR_T10,beta0);
F_log_CR_T10 = model_log_CR_T10.Coefficients.Estimate;

formula_log_CR_T15 = @(b,x) log10((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_log_CR_T15 = fitnlm(X,CR_log_T15,formula_log_CR_T15,beta0);
F_log_CR_T15 = model_log_CR_T15.Coefficients.Estimate;

formula_log_CR_T20 = @(b,x) log10((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_log_CR_T20 = fitnlm(X,CR_log_T20,formula_log_CR_T20,beta0);
F_log_CR_T20 = model_log_CR_T20.Coefficients.Estimate;

formula_log_CR_T25 = @(b,x) log10((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_log_CR_T25 = fitnlm(X,CR_log_T25,formula_log_CR_T25,beta0);
F_log_CR_T25 = model_log_CR_T25.Coefficients.Estimate;

formula_log_CR_T30 = @(b,x) log10((b(1)*x.^(b(2)-1))./(1+b(1)*b(3)*x.^b(2)));
model_log_CR_T30 = fitnlm(X,CR_log_T30,formula_log_CR_T30,beta0);
F_log_CR_T30 = model_log_CR_T30.Coefficients.Estimate;

%Fit the second polynomial to fitted log10s of a, b and h
a_log_CR = log10([F_log_CR_T5(1); F_log_CR_T10(1); F_log_CR_T15(1); F_log_CR_T20(1); F_log_CR_T25(1); F_log_CR_T30(1)]);
b_log_CR = log10([F_log_CR_T5(2); F_log_CR_T10(2); F_log_CR_T15(2); F_log_CR_T20(2); F_log_CR_T25(2); F_log_CR_T30(2)]);
h_log_CR = log10([F_log_CR_T5(3); F_log_CR_T10(3); F_log_CR_T15(3); F_log_CR_T20(3); F_log_CR_T25(3); F_log_CR_T30(3)]);

X = T;

formula_a = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [-0.001, 0.1, -1];
y = a_log_CR;
model_a_temp = fitnlm(X,y,formula_a,beta0);
a_temp_log_CR = model_a_temp.Coefficients.Estimate;

formula_b = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0, 0, 0.1];
y = b_log_CR;
model_b_temp = fitnlm(X,y,formula_b,beta0);
b_temp_log_CR = model_b_temp.Coefficients.Estimate;

formula_h = @(b,x) b(1)*x.^2 + b(2)*x + b(3);
beta0 = [0.01, -0.1, 1];
y = h_log_CR;
model_h_temp = fitnlm(X,y,formula_h,beta0);
h_temp_log_CR = model_h_temp.Coefficients.Estimate;

F_log_CR = [a_temp_log_CR; b_temp_log_CR; h_temp_log_CR];

%% Create a single matrix with all fitted coefficients
F_seq = [F_nonlog_IR F_log_IR F_nonlog_CR F_log_CR];

end
