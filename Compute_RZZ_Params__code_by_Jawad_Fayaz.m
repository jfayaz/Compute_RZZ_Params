%%-------------------------- Code to compute RZZ parameters-------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% authors : Jawad Fayaz and Sarah Azar
% visit: (https://jfayaz.github.io)
%
%
% Citation Reference:
% Jawad Fayaz, Sarah Azar, Mayssa Dabaghi, and Farzin Zareian (2020). 
%    "Methodology for Validation of Simulated Ground Motions for Seismic Response Assessment: 
%         Application to Cybershake Source-Based Ground Motions". Bulletin of Seismological Society of America
%   https://doi.org/10.1785/0120200240
% 
%
% ------------------------------ Instructions ------------------------------------- 
% This code computes the RZZ parameters for the GMs provided by the user.
% The user is required to provide GM input file that contains 4 variables
%      'ACC1'   --> n x 1 Cell Structure containing GM history in Direction 1 (units of g) 
%      'ACC2'   --> n x 1 Cell Structure containing GM history in Direction 2 (units of g)
%      'DT'     --> n x 1 array containing dts for the GM histories
%      'RRUP'   --> n x 1 array containing Rrups of the GM histories (units of KM)
% 
%
% INPUT:
% The following inputs within the code are required:
%     'GM_Input_File'    --> GM Input File containing the time-histories, DT and RRUP (as mentioned above)  
%     'Results_Folder'   --> Folder that will contain the output RZZ parameters
%     'Damping_Ratio'    --> Damping Rato of SDOF  
%     'Periods_for_Sa'   --> Periods for computing Sa for both components (after rotations as per the provided reference) of GMs
%     
%
% OUTPUT:
% The code will create 3 sub-folders inside 'Results_Folder' which include:
%     'Non_Pulse_Like_GMs'    -->  contains RZZ parameters and Component Sa of GMs classified as Non-Pulse-Like
%     'Pulse_Like_GMs'        -->  contains RZZ parameters and Component Sa of GMs classified as Pulse-Like
%     'Pulse_Classification'  -->  contains Pulse Classification parameters                
%
% The indices of the results are in the same order as the provided GMs
% 
% The code will also create 'RZZ_Params' .mat and .xlsx files that contain the important 
% RZZs that are useful for engineering analysis. These results are also present in the workspace
% variable named 'RZZ_PARAMS'.
% Also, the Sa of the rotated components will be provided as 'SA_SPECTRA' variable and saved as 'SA_SPECTRA.mat'
%
% NOTE:
% To be efficient and prevent re-computations, before computing the RZZ parameters, the code performs
% a check in the 'Results_Folder' to see if RZZs of any GMs are already computed using the indices of 
% the GMs. If the results are present, the code will NOT recompute the RZZ parameters for those GMs. 
% Hence, to start fresh computations of RZZ parameters either delete the already created 'Results_Folder' 
% or provide a different name for the 'Results_Folder' to save the results
%
%%--------------------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; fclose all; close all; delete(gcp('nocreate')); current_path = pwd; warning('off','all');
addpath('./functions');addpath('./functions/Pulse_Classification');addpath('./functions/pulse_fitting');
%% ======================== USER INPUTS =============================== %%
GM_Input_File  = 'Example_Data.mat';
Results_Folder = 'Results_RZZ';
Damping_Ratio  = 0.05;
Periods_for_Sa = [0.1 0.2 0.5 0.75 1 2 5 10];

%%===== PSUEDO INPUTS (do not change anything if you are not sure) ======%%
load (GM_Input_File);
% Limit GMs from m to n (dont change untill you want to compute RZZ
% parameters only for subset of GMS among the provide vector of GMs)
m = 1; n = length(DT); 
accX     = ACC1(m:n); accY = ACC2(m:n); dt = num2cell(DT(m:n));
Rrup_vec = [[1:n]' RRUP(m:n)];

%%%%%%================= END OF USER INPUT ========================%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ======== Fixing GMs to have same length (if they dont) ================
[acc_1,acc_2] = fix_GMs(accX,accY);
clear acc_E acc_N;

%% ======== Classify the GMs as Pulse or Non-Pulse ================
% by applying Shahi and Baker(2014) classification algorithm
pulse_direct = [current_path,'/',Results_Folder,'/Pulse_Classification/'];
mkdir(pulse_direct)
Apply_Shahi_Baker(m, acc_1, acc_2, dt, pulse_direct);

%% ======== Calculate RZZ Parameters ================
% Create saving directories
pulse_direct = [current_path,'/',Results_Folder,'/Pulse_Like_GMs'];
non_pulse_direct = [current_path,'/',Results_Folder,'/Non_Pulse_Like_GMs'];
mkdir(pulse_direct)
mkdir(non_pulse_direct)

% Specify Sa calculations parameters
z  = Damping_Ratio*ones(1,length(Periods_for_Sa));                     
dy = 100*ones(1,length(Periods_for_Sa));            
alpha = 0;                             

numcores = feature('numcores')-2;
if numcores < 1
    numcores = 1;
else
    numcores = numcores;
end
parpool(numcores);
pctRunOnAll warning('off','all');

parfor i=1:length(acc_1)
 
    if isempty(acc_1{i,1})==0 && isempty(acc_2{i,1})==0
       
        GM_numb    = i+m-1;
        file_name  = ['GM_',num2str(GM_numb),'.mat'];
        ffile_name = fullfile(current_path,'/',Results_Folder,'/Pulse_Classification',file_name);
        S          = load(ffile_name);
        dt_acc     = dt{i,1};
        Rrup       = Rrup_vec(Rrup_vec(:,1)==GM_numb,2);

        switch S.index_error
            
            case 0
                
                switch S.Ipulse_SB
                    
                    case 1 %Pulse-like GM
      
                        if isfile(fullfile(pulse_direct,file_name))==0
                            
                            %rotate to the LP direction
                            rot_angle   = S.rot_angle_SB;
                            LP_acc_GM   = acc_1{i,1} * (cos(rot_angle)) + acc_2{i,1} * sind(rot_angle);
                            orth_acc_GM = acc_1{i,1} * (-sind(rot_angle)) + acc_2{i,1} * cosd(rot_angle); %orthogonal component to the LP direction

                            % Extract the residual component of the GM after removing the pulse
                            res_acc_GM  = S.residual_acc_SB;  %residual component of the pulse-like LP component

                            % Calculate the model parameters of the residual and orthogonal components
                            Evaluate_Pulse_Like(GM_numb, Rrup, pulse_direct,res_acc_GM, LP_acc_GM, orth_acc_GM, dt_acc, Periods_for_Sa, z, dy, alpha);

                            % Fit the mMP pulse parameters to the pulse extracted by SB
                            mMP_Pulse_Parameters_Fitting(ffile_name, S.pulse_velocity_SB, dt_acc, S.Tp_SB, res_acc_GM, orth_acc_GM);

                        end

                    case 0 %Non-Pulse-like GM

                        if isfile(fullfile(non_pulse_direct,file_name))==0
                            Evaluate_NonPulse_Like(GM_numb, Rrup, non_pulse_direct,acc_1{i,1}, acc_2{i,1}, dt_acc, Periods_for_Sa, z, dy, alpha);
                        end

                end
        end

    end

end

[RZZ_PARAMS,SA_SPECTRA] = Merge_RZZ_Sa_Params([current_path,'/',Results_Folder],length(acc_1));
struc2xls([current_path,'/',Results_Folder,'/RZZ_Params.xlsx'],RZZ_PARAMS,'Sheet','RZZ')
fprintf('\n\tPlease check the RZZ results in "%s" folder\n',Results_Folder)
