%%% Generates the unmodulated simulations that are "not" post-processed yet
% w0: frequency at the begining (rad/sec = 2pi*Hz)
% wn: frequency at the end
% zeta: constant damping ratio
% n: length of acceleration vector
% dt: time steps

function [f,t]=simf(w0,wn,zeta,n,dt)
t=[0:dt:(n-1)*dt];
f=zeros(1,n);
C=zeros(1,n);

%% Find the scale parameter, C vector (see eqn 3 in the qual. report, C is the
%% denominator). And construct the Sj vectors to evaluate f vector (see
%% equations 2 and 3 in the report)
for j=1:n
    tj=t(j);
    uj=randn(1);
    omega=w0-(w0-wn)*tj/(t(n));
    omegaD=omega*sqrt(1-zeta^2);
    for i=1:n
        ti=t(i);
        if ti>=tj
            hf=(omega/sqrt(1-zeta^2))*exp(-zeta*omega*(ti-tj))*sin(omegaD*(ti-tj));
            Cj(i)=hf.^2;
            Sj(i)=hf;
        else
            Cj(i)=0;
            Sj(i)=0;
        end
    end 
    C = C + Cj;
    f = f + Sj*uj;
end
C=C.^(.5);
C(1)=.1;

%% Scale f to normalize its standard deviation
f=f./C;

%% correction 12/19/2009: minus sign removed from line 24, results are not
%% affected because of multiplication by stdnormal rvs ui