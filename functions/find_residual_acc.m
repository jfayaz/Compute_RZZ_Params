% Find the residual component of the velocity time series if the groud motion is pulse-like

function [residual_acc] = find_residual_acc(pulseData, dt)

residual_acc = -999;
for j = 1:5
    buff = pulseData{j};
    if(buff.is_pulse == 1)
        residual_vel = buff.resid_th;  % in cm/s
        residual_acc = [0, diff(residual_vel)/dt/981]; %in g
        break;
    end
end