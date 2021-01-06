% Find the pulse amplitude Vp if the groud motion is pulse-like

function [rot_angle] = find_rot_angle(pulseData, rot_angles)

rot_angle = -999;
for j = 1:5
    buff = pulseData{j};
    if(buff.is_pulse == 1)
        rot_angle = rot_angles{j}*180/pi();   
        break;
    end
end