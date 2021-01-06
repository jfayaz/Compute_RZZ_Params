function [T,I,Ia,index]=arias(F1,delta_t,percent,F2)
%%%%  ----- ARIAS INTENSITY FUNCTION -----------
% %     Given a motion, this function will give the time at which a given
% %     percentage of arias intensity is reached (if time starts at 0 sec)
% % 
% %     INPUTS
% %     F1: Ground motion history 1
% %     F2: Ground motion history 2
% %     delta_t: discretization of 'F' (sec)
% %     percent: % age level of arias intensity that has been reached by time T 
% %
% %     OUTPUTS
% %     T : Time at which percent % arias intensity is reached 
% %     I : cummulative arias intensity is reached 
% %     Ia : Arias intensity vector 

    n=size(F1,2);
    
    if nargin == 4
        I=cumsum((F1(2:n-1).^2)+(F2(2:n-1).^2))*delta_t;
        Ia=((F1(1)^2)+(F2(1)^2))*delta_t/2 + I(n-2) + ((F1(n)^2)+(F2(n)^2))*delta_t/2;      % Arias Intensity
    elseif nargin == 3
        I=cumsum(F1(2:n-1).^2)*delta_t;
        Ia=(F1(1)^2)*delta_t/2 + I(n-2) + (F1(n)^2)*delta_t/2;                              % Arias Intensity
    else
        disp('Not enough input arguments. Please check inputs. \n')
    end
    
    It=(percent/100)*Ia;
    
    if I(1)<It
        index=find(I<It, 1, 'last' );
    else
        index=0;
    end
    
    T=index*delta_t;
end
