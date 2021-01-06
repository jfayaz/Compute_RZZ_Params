function [RZZ_PARAMS] = Merge_RZZ_Params(current_path,No_of_GMs)
direc         = [current_path];
files         = struct2cell(dir([direc,'/Non_Pulse_Like_GMs/*.mat']))';
Non_Pulse_GMs = str2double(regexprep(files(:,1),'[_.GMmat]',''));
Pulse_GMs     = setdiff([1:No_of_GMs]',Non_Pulse_GMs);

for i = 1:No_of_GMs
    fprintf('Extracting RZZ for GM #%d...\n',i)
    if ismember(i,Non_Pulse_GMs)==1
        load([direc,'/Non_Pulse_Like_GMs/GM_',num2str(i),'.mat']);
        RZZ_DATA(i,1) = NP_ARIAS_maj;
        RZZ_DATA(i,2) = NP_ARIAS_int;
        RZZ_DATA(i,3) = NP_D5_95_maj;
        RZZ_DATA(i,4) = NP_D5_95_int;
        RZZ_DATA(i,5) = NP_D0_30_maj;
        RZZ_DATA(i,6) = NP_D0_30_int;
        RZZ_DATA(i,7) = NP_D0_5_maj;
        RZZ_DATA(i,8) = NP_D0_5_int;
        RZZ_DATA(i,9) = NP_fmid_maj;
        RZZ_DATA(i,10)= NP_fmid_int;
        RZZ_DATA(i,11)= NP_fslp_maj;
        RZZ_DATA(i,12)= NP_fslp_int;
        RZZ_DATA(i,13)= NP_tmid_maj;
        RZZ_DATA(i,14)= NP_tmid_int;
        RZZ_DATA(i,15)= NP_damping_maj;
        RZZ_DATA(i,16)= NP_damping_int;
        
        RZZ_DATA(i,17)= nan;
        RZZ_DATA(i,18)= nan;
        RZZ_DATA(i,19)= nan;
        RZZ_DATA(i,20)= nan;
        RZZ_DATA(i,21)= 0;
        
        clearvars -except direc Non_Pulse_GMs Pulse_GMs RZZ_DATA i GM_SPECTRA
    else
        load([direc,'/Pulse_Like_GMs/GM_',num2str(i),'.mat']);
        RZZ_DATA(i,1) = P_ARIAS_res;
        RZZ_DATA(i,2) = P_ARIAS_orth;
        RZZ_DATA(i,3) = P_D5_95_res;
        RZZ_DATA(i,4) = P_D5_95_orth;
        RZZ_DATA(i,5) = P_D0_30_res;
        RZZ_DATA(i,6) = P_D0_30_orth;
        RZZ_DATA(i,7) = P_D0_5_res;
        RZZ_DATA(i,8) = P_D0_5_orth;
        RZZ_DATA(i,9) = P_fmid_res;
        RZZ_DATA(i,10)= P_fmid_orth;
        RZZ_DATA(i,11)= P_fslp_res;
        RZZ_DATA(i,12)= P_fslp_orth;
        RZZ_DATA(i,13)= P_tmid_res;
        RZZ_DATA(i,14)= P_tmid_orth;
        RZZ_DATA(i,15)= P_damping_res;
        RZZ_DATA(i,16)= P_damping_orth;
        
        clearvars -except direc Non_Pulse_GMs Pulse_GMs RZZ_DATA i GM_SPECTRA Rrup
        
        load([direc,'/Pulse_Classification/GM_',num2str(i),'.mat']);
        RZZ_DATA(i,17) = Tp_SB;
        RZZ_DATA(i,18) = Tp_mMP;
        RZZ_DATA(i,19) = Vp_SB;
        RZZ_DATA(i,20) = Vp_mMP;
        RZZ_DATA(i,21) = 1;       
        
        clearvars -except direc Non_Pulse_GMs Pulse_GMs RZZ_DATA i GM_SPECTRA  
    end
    
end

RZZ_PARAMS = cell2struct(num2cell(RZZ_DATA),{'Ia_maj','Ia_min','D5_95_maj','D5_95_min','D0_30_maj','D0_30_min','D0_5_maj','D0_5_min','fmid_maj','fmid_min','fprime_maj','fprime_min','tmid_maj','tmid_min','Damp_maj','Damp_min','Tp_SB','Tp_nMP','Vp_SB','Vp_nMP','Is_Pulse'},2);
save ([direc,'/RZZ_Params.mat'],'RZZ_PARAMS')


