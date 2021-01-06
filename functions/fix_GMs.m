function [acc_N,acc_E] = fix_GMs(acc_N,acc_E)

%%%% -------- Fixing Ground Motions --------- %%%%

for i = 1:length(acc_N)
    
    if isempty(acc_N{i,1})==0 && isempty(acc_E{i,1})==0
        
        GM1 = acc_N{i}';
        GM2 = acc_E{i}';
        length_diff = length(GM1)-length(GM2);
        if length_diff > 0
            for l = 1:abs(length_diff)
                GM1(end-l) = [];
            end
        else length_diff < 0;
            for l = 1:abs(length_diff)
                GM2(end-l) = [];
            end
        end
        acc_N{i} = GM1;
        acc_E{i} = GM2;
        
    end
end

end