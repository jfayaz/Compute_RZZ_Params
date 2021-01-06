function [Sa_values] = Sa_Calculations(data1, dt1, T, damping )

% INPUT:
% data1: as recorded acceleration 1 in units of g
% dt1: time steps of data1 

% OUTPUT:
% Sa values will be in units of g


dy=100*ones(1,length(T));
alpha = 0; % strain hardening ratio - not used
g = 9.81; %m/s
Sa_values = zeros(1, length(T));
dt = 0.005;                 % Dt    = analyis time step

% Time step for analysis is taken here equal to 0.005s
[~,~,H1] = Bilinear_Newmark_v031218( T, damping, dy, alpha, g*data1, dt1, dt );

% should be the relative displacement time series (not spectrum)
RD1=H1.d'; % matrix [period by data points]

omega = 2*pi./T;


%% Sa Calculations
for per_index=1:length(T) % loop over periods
    RS1 = RD1(per_index,:);
    Sa_values(1, per_index) = max(abs(RS1))*omega(per_index)^2/g;
end

     
end

