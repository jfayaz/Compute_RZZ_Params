function [ ] = save_pulse_info(GM_number, file_directory,pulseData, rot_angles, index_error, dt)

    %Save pulse index as given by Shahi and Baker's code
    Ipulse_SB = find_Ipulse(pulseData);

    % Save Tp value as given by Shahi and Baker's Code
    Tp_SB = find_Tp(pulseData);

    % Save Vp values for the extracted pulse of Shahi and Baker
    Vp_SB = find_Vp(pulseData);

    % Save angle of the GM where the pulse was identified as Shahi and
    % Baker
    rot_angle_SB = find_rot_angle(pulseData, rot_angles);

    % Save D0-max,p values for the extracted pulse of Shahi and Baker
    D0_maxp_SB = find_D0_maxp(pulseData);
    
    % Save the residual component of the time series in the largest pulse
    % direction
    residual_acc_SB = find_residual_acc(pulseData, dt); % in g
    
    % Save the extracted velocity pulse
    pulse_velocity_SB = find_pulse_velocity(pulseData); %in cm/s
    
    % Save the values to a file
    file_name = ['GM_',num2str(GM_number)];
    save(fullfile(file_directory,file_name),'Ipulse_SB','Tp_SB','Vp_SB','rot_angle_SB','D0_maxp_SB','residual_acc_SB','index_error','pulse_velocity_SB','pulseData');

end

