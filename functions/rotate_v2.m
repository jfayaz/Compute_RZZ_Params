function [GM_X] = rotate_v2(GM1,alfa1,GM2,alfa2,alfaX)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Input %%%%
% GM1   =   Ground-motion in direction alfa1
% alfa1 =   Angle of GM1 measured clockwise from North (in degrees)
% GM2   =   Ground-motion in direction alfa2
% alfa2 =   Angle of GM2 measured clockwise from North (in degrees)
%           alfa2 is +90° or -90° from alfa1
% alfaX =   Angle at which the ground motion is to be determined measured
%           clockwise from North (in degrees)

%GM1 and GM2 are Nx1 or 1xN matrices where N is the time length:
% First Column: intensity value

%%%% Output %%%%
% GM_X  =   Ground-motion rotated to alfaX
% column vector
%% Input Verification

% Orthogonality of directions
if alfa2 ~= alfa1+90 && alfa2~=alfa1-90
    error('The input ground motions must be in orthogonal directions');
end

% Matching length
if length(GM1) ~= length(GM2)
    error('The input ground motions must have the same time length');
end


%% Projection of GM1 and GM2 on two orthogonal directions N and W

%Determine angles from the North direction to directions 1 and 2 - counterclockwise
a1 = -alfa1;
a2 = -alfa2;

%Direction N is in the North direction
%Direction W is 90° away from the North - counterclockwise

% GM1_NW contains the projection of GM1 on the N and W directions
GM1_N = GM1 * cosd(a1); %projection of GM1 on N %NW(:,1)
GM1_W = GM1 * sind(a1); %projection of GM1 on W %NW(:,2)

% GM2_NW contains the projection of GM2 on the N and W directions
GM2_N = GM2 * cosd(a2); %projection of GM2 on N %NW(:,1)
GM2_W = GM2 * sind(a2); %projection of GM2 on W %NW(:,2)

% Sum the projections from the 2 GMs
GM_N = GM1_N + GM2_N;
GM_W = GM1_W + GM2_W;
%GM_NW = GM1_NW + GM2_NW;


%% Projection of GM_NW on the alfaX direction

% Determine angles measured from the alfaX direction to the North diretion - counterclockwise
aX = alfaX;

% GM_X contains the projection of GM1 on the N and W directions
%GM_X = zeros (size(GM1));

GM_X = GM_N*cosd(aX) + GM_W*cosd(aX+90); %Add projections from N and W direction to the X direction

end

