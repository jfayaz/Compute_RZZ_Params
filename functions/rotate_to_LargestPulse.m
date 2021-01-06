function [acc_LargestPulse, acc_Orthogonal] = rotate_to_LargestPulse(acc_1,acc_2,alfa_pulse)

% This function rotates the pulse-like GMs in orthogonal directions 
% to the direction of the largest pulse and the orthogonal direction
% This is done after extracting the pulse from the Shahi and Baker (2014)
% classification algorithm.

% INPUT
% -----
% acc_1, acc_2: vector that contains the time series in orthogonal
%               directions
% alfa_pulse:   is the orientation in which the pulse was extracted (as Shahi
%               and Baker's algorithm)

% OUTPUT
% ------
% acc_LargestPulse: vector that contains the time series in the largest
%                   pulse direction
% acc_Orthogonal:   vector that contains the time series in the orthogonal
%                   direction

acc_LargestPulse = rotate_v2(acc_1,0,acc_2,90,alfa_pulse);
acc_Orthogonal = rotate_v2(acc_1,0,acc_2,90,alfa_pulse+90);

end
