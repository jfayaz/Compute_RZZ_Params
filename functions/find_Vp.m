% Find the pulse amplitude Vp if the groud motion is pulse-like

function [Vp] = find_Vp(pulseData)

Vp = -999;
for j = 1:5
    buff = pulseData{j};
    if(buff.is_pulse == 1)
        pulse_th = buff.pulse_th;
        Vp = max(abs(pulse_th)); %cm/s   
        break;
    end
end