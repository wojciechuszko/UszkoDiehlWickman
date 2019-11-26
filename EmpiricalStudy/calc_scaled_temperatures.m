function scaled_temperature = calc_scaled_temperatures( experiment_data )
% This function calculates the scaled temperature, which is between 0 and 1
% in each feeding trial in the experiment data set

T = experiment_data.temperature;
T_max = max(T);
T_min = min(T);

T_s = (T-T_min)./(T_max-T_min);

scaled_temperature = T_s;