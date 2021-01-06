function [acc_maj, acc_int, alfa_maj] = rotate_to_Maj_Int_AI(acc_1,acc_2,delta_t)

% This function rotates the GMs in orthogonal directions to the direction
% of the largest AI and the intermediate direction (which is orthogonal to
% the first)

% INPUT
% -----
% acc_1, acc_2: vector that contains the time series in orthogonal
%               directions
% delta_t:      is the time step of the GM time series

% OUTPUT
% ------
% acc_maj:  vector that contains the time series in the major direction
% acc_int:  vector that contains the time series in the intermediate
%           direction
% alfa_maj: the direction of the major direction with respect to acc_1's
%           direcion


% Get the AIs at all the orientations
% -----------------------------------
alfa_vector =(0:1:179)';
AI_vector = zeros(length(alfa_vector),1);

for i=1:length(alfa_vector)
    alfaX = alfa_vector(i);
    [GM_X] = rotate_v2(acc_1,0,acc_2,90,alfaX);
    [~,~,AI_vector(i,1),~] = arias(GM_X,delta_t,30); %I only need to calculate Ia
end

% Select the orientation that gives the higth AI
% ----------------------------------------------
alfa_maj = alfa_vector(AI_vector == max(AI_vector));

% Rotate the GMs to this orientation
% ----------------------------------
acc_maj = rotate_v2(acc_1,0,acc_2,90,alfa_maj);
acc_int = rotate_v2(acc_1,0,acc_2,90,alfa_maj+90);

end
