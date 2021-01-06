% This function takes the simulated ground motion in orthogonal directions
% and classifies them as pulse or non-pulse according to Shahi and Baker's
% (2014) code. It also reports the Tp, Vp and D0maxp of the extracted pulse
% (pulse period, pulse amplitude and time to the pulse) by saving them in
% the 'save_directory'

function [] = Apply_Shahi_Baker(m, acc_1_cell, acc_2_cell, dt_cell, save_directory)

N = length(acc_1_cell);

for i=1:N
    
    if isempty(acc_1_cell{i,1})==0 && isempty(acc_2_cell{i,1})==0
        
        
        GM_numb = i+m-1;
        file_name = ['GM_',num2str(GM_numb),'.mat'];
        if isfile(fullfile(save_directory,file_name))==0
            
            try
                A1 = acc_1_cell{i,1}';
                A2 = acc_2_cell{i,1}';
                dt = dt_cell{i,1};
                dt2 = dt_cell{i,1};
                
                disp(['Starting Pulse Classification for GM #',num2str(GM_numb)]);
                signal1 = cumsum(A1)' .* dt .* 981; % convert acc (in g) to velocity (in cm/s)
                signal2 = cumsum(A2)' .* dt2 .* 981; % convert acc (in g) to velocity (in cm/s)
                
                % Run Shahi and Baker's Code
                [pulseData, rot_angles,~,~] = classification_algo(signal1,signal2,dt);
                index_error = 0;
            catch
                disp(['Error in GM #',num2str(GM_numb)]);  %sometimes the code is giving error, so ignore the GM is we find one
                index_error = 1;
            end
            
            save_pulse_info(GM_numb, save_directory, pulseData, rot_angles, index_error, dt);
        end
        
    end
    
end
end
