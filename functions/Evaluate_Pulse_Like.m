function [ ] = Evaluate_Pulse_Like(GM_number, Rrup, file_directory, res_acc, LP_acc, orth_acc, dt,  T, z, dy, alpha)

%% These are the GMs in the largest component and orthogonal
% ----------------------------------------------------------
%put it in a cell so it can be used in the other codes
P_acc_res{1}     = res_acc;     % residual component of the GM in the largest pulse direction
P_acc_orth{1}    = orth_acc;    % GM in the orthogonal direction
P_acc_LP{1}      = LP_acc;      % GM in the largest pulse direction
dt_GM{1} = dt;

%% Calculate the model parameters for PULSE-LIKE GMs in both directions
% ---------------------------------------------------------------------

% percent_tmid at which tmid is considered 
% applied in case we need to alterate this for far-field GMs
if Rrup <= 30
    percent_tmid = 30;
else
    percent_tmid = 45;
end

% Determine the start time of the record
% set as the time at which 0.01% of AI is reached
[t_01_res,~,~,~]         = arias(P_acc_res{1},dt_GM{1},0.01);
[t_01_orth,~,~,~]        = arias(P_acc_orth{1},dt_GM{1},0.01);
t0_rec = min(t_01_res, t_01_orth);


% ------- Calculating Arias Intensity and Durations ------- %%
[P_ARIAS_res,P_D5_95_res, P_D0_5_res, P_D0_30_res, P_tmid_res]          = Cal_Arias_tmid_Durations(P_acc_res, dt_GM, percent_tmid, t0_rec);
[P_ARIAS_orth,P_D5_95_orth, P_D0_5_orth, P_D0_30_orth, P_tmid_orth]     = Cal_Arias_tmid_Durations(P_acc_orth, dt_GM, percent_tmid, t0_rec);

% % ------- Calculating Mid-Frequency and Slope of Frequency ------- %%
% [P_fmid_res,P_fslp_res]     = Cal_Omega_and_Omega_Prime_Sanaz_mod(P_acc_res{1,1}, dt_GM{1,1},P_tmid_res);
% [P_fmid_orth,P_fslp_orth]   = Cal_Omega_and_Omega_Prime_Sanaz_mod(P_acc_orth{1,1}, dt_GM{1,1},P_tmid_orth);
% 
% % ------- Calculating Filter Damping Ratio ------- %%
% P_damping_res    = damping_z_sanaz_mod(P_acc_res{1,1},dt_GM{1,1},P_fmid_res,P_fslp_res,P_tmid_res,GM_number);
% P_damping_orth   = damping_z_sanaz_mod(P_acc_orth{1,1},dt_GM{1,1},P_fmid_orth,P_fslp_orth,P_tmid_orth,GM_number);

% ------- Calculating Mid-Frequency, Slope of Frequency and Damping ------- %%
[P_fmid_res,P_fslp_res,P_damping_res]     = Cal_Omega_and_Omega_Prime_Damping_with_dt_correction(P_acc_res{1,1}, dt_GM{1,1},P_tmid_res, GM_number);
[P_fmid_orth,P_fslp_orth,P_damping_orth]  = Cal_Omega_and_Omega_Prime_Damping_with_dt_correction(P_acc_orth{1,1}, dt_GM{1,1},P_tmid_res, GM_number);

%% Calculate Sa
% -------------
P_Sa_res    = Sa_Calculations(P_acc_res{1,1},dt_GM{1,1},T,z);
P_Sa_orth   = Sa_Calculations(P_acc_orth{1,1},dt_GM{1,1},T,z);
P_Sa_LP     = Sa_Calculations(P_acc_LP{1,1},dt_GM{1,1},T,z);

%% Save the info
clear acc_1 acc_2 dt_GM dt P_acc_res P_acc_orth P_acc_LP
file_name = ['GM_',num2str(GM_number)];
save(fullfile(file_directory,file_name));

end