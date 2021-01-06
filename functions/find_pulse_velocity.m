% Find the extracted velocity time series of the pulse if the groud motion is pulse-like

function [pulse_velocity] = find_pulse_velocity(pulseData)

pulse_velocity = -999;
for j = 1:5
    buff = pulseData{j};
    if(buff.is_pulse == 1)
        pulse_velocity = buff.pulse_th;  % in cm/s
        break;
    end
end