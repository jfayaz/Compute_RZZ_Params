function [ ] = Evaluate_NonPulse_Like(GM_number, Rrup, file_directory, acc_1, acc_2, dt, T, z, dy, alpha)

%% Rotate pulse-like GMs to largest pulse and orthogonal directions
% -----------------------------------------------------------------
[NP_acc_maj{1}, NP_acc_int{1}, ~] = rotate_to_Maj_Int_AI(acc_1,acc_2,dt);
dt_GM{1} = dt; %put it in a cell so it can be used in the other codes

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
[t_01_maj,~,~,~]         = arias(NP_acc_maj{1},dt_GM{1},0.01);
[t_01_int,~,~,~]         = arias(NP_acc_int{1},dt_GM{1},0.01);
t0_rec = min(t_01_maj, t_01_int);


% ------- Calculating Arias Intensity and Durations ------- %%
[NP_ARIAS_maj,NP_D5_95_maj, NP_D0_5_maj, NP_D0_30_maj, NP_tmid_maj] = Cal_Arias_tmid_Durations(NP_acc_maj, dt_GM, percent_tmid, t0_rec);
[NP_ARIAS_int,NP_D5_95_int, NP_D0_5_int, NP_D0_30_int, NP_tmid_int] = Cal_Arias_tmid_Durations(NP_acc_int, dt_GM, percent_tmid, t0_rec);

% % ------- Calculating Mid-Frequency and Slope of Frequency ------- %%
% [NP_fmid_maj,NP_fslp_maj] = Cal_Omega_and_Omega_Prime_Sanaz_mod(NP_acc_maj{1,1}, dt_GM{1,1},NP_tmid_maj);
% [NP_fmid_int,NP_fslp_int] = Cal_Omega_and_Omega_Prime_Sanaz_mod(NP_acc_int{1,1}, dt_GM{1,1},NP_tmid_int);
% 
% % ------- Calculating Filter Damping Ratio ------- %%
% NP_damping_maj = damping_z_sanaz_mod(NP_acc_maj{1,1},dt_GM{1,1},NP_fmid_maj,NP_fslp_maj,NP_tmid_maj, GM_number);
% NP_damping_int = damping_z_sanaz_mod(NP_acc_int{1,1},dt_GM{1,1},NP_fmid_int,NP_fslp_int,NP_tmid_maj, GM_number);

% ------- Calculating Mid-Frequency, Slope of Frequency and Damping ------- %%
[NP_fmid_maj,NP_fslp_maj,NP_damping_maj]     = Cal_Omega_and_Omega_Prime_Damping_with_dt_correction(NP_acc_maj{1,1}, dt_GM{1,1},NP_tmid_maj, GM_number);
[NP_fmid_int,NP_fslp_int,NP_damping_int]     = Cal_Omega_and_Omega_Prime_Damping_with_dt_correction(NP_acc_int{1,1}, dt_GM{1,1},NP_tmid_int, GM_number);

%% Calculate Sa
% -------------
NP_Sa_maj = Sa_Calculations(NP_acc_maj{1,1},dt_GM{1,1},T,z);
NP_Sa_int = Sa_Calculations(NP_acc_int{1,1},dt_GM{1,1},T,z);

%% Save the info
clear acc_1 acc_2 dt_GM dt NP_acc_maj NP_acc_int
file_name = ['GM_',num2str(GM_number)];
save(fullfile(file_directory,file_name));

end