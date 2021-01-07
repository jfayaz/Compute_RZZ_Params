function [fre_mid,slope_mid] = Cal_Omega_and_Omega_Prime_Sanaz_mod(acc_1,dt_GM,t_mid, factor)

% %     INPUTS
% %     ------
% %     acc_1:      GM time series in dir 1 
% %     dt_GM:      delat t of the GM
% %     tmid:       t_mid of the GMs
% %     factor:     correction factor that accounts for the undercounting of
%                   the number of zero crossings depending on dt

GM = acc_1;
time=0:dt_GM:((length(GM)-1)*dt_GM);
Integzero = zeros(size(time));

% Count the number of zero crossings
no_of_crosses_N = 0;
for k = 2:length(GM)
   if GM(k-1)*GM(k) < 0 && GM(k-1)<GM(k)
       no_of_crosses_N = no_of_crosses_N+1;
   end
   Integzero(k) = no_of_crosses_N;   
end

% Apply the correction factor
Integzero = Integzero/factor;

% 
[tesf,~,~,Indexf]=arias(GM,dt_GM,1);    % time when 1%AI is reached
[tesl,~,~,Indexl]=arias(GM,dt_GM,99);   % time when 99%AI is reached
nuf=Integzero(Indexf);
nul=Integzero(Indexl);

tes2=tesf+(tesl-tesf)/8;   Index2=find(tes2>time,1,'last'); nu2=Integzero(Index2);
tes3=tesf+2*(tesl-tesf)/8; Index3=find(tes3>time,1,'last'); nu3=Integzero(Index3);
tes4=tesf+3*(tesl-tesf)/8; Index4=find(tes4>time,1,'last'); nu4=Integzero(Index4);
tes5=tesf+4*(tesl-tesf)/8; Index5=find(tes5>time,1,'last'); nu5=Integzero(Index5);
tes6=tesf+5*(tesl-tesf)/8; Index6=find(tes6>time,1,'last'); nu6=Integzero(Index6);
tes7=tesf+6*(tesl-tesf)/8; Index7=find(tes7>time,1,'last'); nu7=Integzero(Index7);
tes8=tesf+7*(tesl-tesf)/8; Index8=find(tes8>time,1,'last'); nu8=Integzero(Index8);

p=polyfit([tesf,tes2,tes3,tes4,tes5,tes6,tes7,tes8,tesl],[nuf,nu2,nu3,nu4,nu5,nu6,nu7,nu8,nul],2);
% Desired data for this record:
fre_mid=2*p(1)*t_mid+p(2); %x_MidFreq%frequency at the time of the middle of strong shaking
slope_mid=2*p(1);  %x_SlopeFreq%

end


