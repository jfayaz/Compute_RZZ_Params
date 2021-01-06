% Find the duration between the start of the GM and the max. pulse arrival

function [D0_maxp] = find_D0_maxp(pulseData)

D0_maxp = -999;
for j = 1:5
    buff = pulseData{j};
    if(buff.is_pulse == 1)
        pulse_th = buff.pulse_th;
        record_dt = buff.dt;
        
        Ind_max_pulse = find(pulse_th == max(abs(pulse_th)));
        if isempty(Ind_max_pulse)==1 %if ==1, it means the maximum velocity is negative
            Ind_max_pulse = find(pulse_th == - max(abs(pulse_th)));
        end
        D0_maxp = (Ind_max_pulse -1 ) * record_dt;
        
        break;
    end
end