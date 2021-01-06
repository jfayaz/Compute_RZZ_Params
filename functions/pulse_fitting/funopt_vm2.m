function error = funopt_vm2( Vp, p, target, ti )
%global PulseAmp
%% Define Theory
%theory=zeros(1,length(ti));
theory = ModMavPap_PulseVel_v3( ti, Vp, p);
   
%% Define the error
%[error error_norm] = errorcalc_1(target,theory); %error computed as absolute value of the difference
[error error_norm] = errorcalc_2(target,theory); %error computed as square of the difference

end

