function [fmid_f, fslp_f, damping_f] = Cal_Omega_and_Omega_Prime_Damping_with_dt_correction(acc_1,dt_GM,t_mid, GM_number)

% Iteration 0
factor = 1;
[fmid_0,fslp_0]     = Cal_Omega_and_Omega_Prime_Sanaz_mod(acc_1, dt_GM,t_mid, factor);
damping_0           = damping_z_sanaz_mod(acc_1,dt_GM,fmid_0,fslp_0,t_mid,GM_number);

% Iteration 1
fmax=0.5/dt_GM; %Nyquist frequency for dt_GM
r0=1-0.6771*(fmid_0/fmax)*damping_0;
factor = r0;
[fmid_i,~]     = Cal_Omega_and_Omega_Prime_Sanaz_mod(acc_1, dt_GM,t_mid, factor);

% Iteration 2
r1=1-0.6771*(fmid_i/fmax)*damping_0;
factor = r1;
[fmid_f,fslp_f]     = Cal_Omega_and_Omega_Prime_Sanaz_mod(acc_1, dt_GM,t_mid, factor);
damping_f           = damping_z_sanaz_mod(acc_1,dt_GM,fmid_f,fslp_f,t_mid,GM_number);

end

