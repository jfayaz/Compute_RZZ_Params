function [ ] = mMP_Pulse_Parameters_Fitting(fullfile_name, target_pulse_velocity, dt_acc, Tp0, P_acc_res, P_acc_orth)


% This function takes the pulse classification results from Baker for
% pulse-like ground motion and fit the pulse model parameters (vp, Tp,
% gamma, nu and D0-maxp) of the mMP pulse model. This is done in order to
% get consistent parameters with the ones used in the site-based model for
% pulse-like GM

% Fit the pulse parameters
PulseParameters = fn_FitPulse_6m(target_pulse_velocity,dt_acc, Tp0);

% Determine the start time of the record set as the time at which 0.01% of AI is reached
% needed to calculate D0_maxp
[t_01_res,~,~,~]         = arias(P_acc_res,dt_acc,0.01);
[t_01_orth,~,~,~]        = arias(P_acc_orth,dt_acc,0.01);
t0_rec = min(t_01_res, t_01_orth);

% Get the fitted pulse parameters
Vp_mMP      = PulseParameters(1);
Tp_mMP      = PulseParameters(2);
gamma_mMP   = PulseParameters(3);
nu_mMP      = PulseParameters(4)/pi(); %rad (nu/pi)
D0_maxp_mMP = PulseParameters(5) - t0_rec;

% Save the variables
save(fullfile_name,'Vp_mMP','Tp_mMP','gamma_mMP','nu_mMP','D0_maxp_mMP','-append');

end