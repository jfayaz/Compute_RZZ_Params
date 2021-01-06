function [error error_norm]=errorcalc_2(target,theory)
%function error_norm=errorcalc(target,theory)
%'errorcalc' approximates the relative error difference between energies 
%(integral of squared values) of two given vectors 'target' and 'theory'. 


%%% Define the error
diff=(target-theory).^2;    %square of the difference
diff_integ=cumsum(diff);
n=length(diff_integ);
error=diff_integ(n);

%%% Define the area underneath the target for normalization of error
target_integ=cumsum(abs(target.^2));   %### ask ADK!
area=target_integ(n);

%%% Define the normalized error measure
error_norm=error/area;

%Note: the integrals are estimated without multiplication by deltat, this is ok
%if the value of deltat remains constant through out the process.

end


