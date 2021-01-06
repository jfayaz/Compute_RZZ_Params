function pulse_model = ModMavPap_PulseVel_v3(t,Vp, p)
%Mavroeidis and Papageorgiou velocity pulse given the 5 pulse parameters
%   The parameters are: pulse amplitude Vp, pulse period Tp, zero crossings gamma , phase angle
%   nu,and time of envelope's peak t0

% nu in rad!!!

%Vp     = p(1);
Tp     = p(1);
gamma  = p(2);
nu     = p(3);
t0     = p(4);


fp = 1/Tp;
resDisp = Vp/(4*pi*fp)*sin(nu+gamma*pi)/(1-gamma^2) - Vp/(4*pi*fp)*sin(nu-gamma*pi)/(1-gamma^2);

indx_t = (t > (t0 - (1/2)*gamma/fp)) & (t <= t0 + (1/2)*gamma/fp);
pulse_model = zeros(1,numel(t));
pulse_model(indx_t) = ((1/2)*Vp*cos(2*pi*fp*(t(indx_t)-t0)+nu)-resDisp*fp/gamma).*(1+cos(2*pi*fp*(t(indx_t)-t0)/gamma));
end
