function PulseParameters = fn_FitPulse_6m(target,dt,Tp0)
%% Important ! 
% This file optimize Tp gamma nu and t_max, V_p is given by the max of the
% velocity
%


%% Define extracted pulse as target
ti=dt*(0:length(target)-1);             %time vector
[Vp, index] = max(abs(target)); %velocity pulse amplitude and location
Tmax        = index*dt;
repeat = 1;

%% Set Initial Iteration Point

    t00 = Tmax;             % initial point is time of max of Baker velocity pulse
    clear gamma0 nu0
    %gamma0 = input('Enter initial gamma: ');
    peak_max_t = findpeaks(smooth(target,10));
    peak_max = peak_max_t(peak_max_t>max(peak_max_t)/10);
    peak_min_t = findpeaks(-smooth(target,10));
    peak_min = peak_min_t(peak_min_t>max(peak_min_t)/10);
    gamma0 = floor((numel(peak_max) + numel(peak_min))/2);
    if gamma0 < 2
        gamma0 = 2;
    end
    %
    %
    nu0 = pi;
    %
    p0 = [Tp0,  gamma0, nu0, t00];
    %% Optimize Parameters
    %
    [p, ~ ,~ ,~] = fminsearch(@(p) funopt_vm2(Vp,p , target, ti ), p0);
    if p(3)<0
       p(3) = p(3)+2*pi; 
    end
 

PulseParameters = [Vp p];

end
