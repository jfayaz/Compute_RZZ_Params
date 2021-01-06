function zhat=damping_z_sanaz_mod(tF,deltat,wmid,wslope,tmid, GM_number)

% Cut the target at 5% and 95% Arias Intensity --> new accel time history
% Work with "Fcut" and "tcut" as the target after this point
[t5,~,~,Index5]=arias(tF,deltat,5); % time when 5%AI is reached
[t95,~,~,Index95]=arias(tF,deltat,95); % time when 95%AI is reached
tFcut=tF(Index5:Index95);
tcut=t5:deltat:t95;
    
% Estimate the frequency at the begining and the end of the new cut-motion
% having the slope and a point (t45,MidFreq), get the equation of the line and calculate the freq at t5 and t95
w0=wmid+wslope*(t5-tmid); %freq (Hz.) at the beginning of the motion to be simulated
wn=wmid+wslope*(t95-tmid); %freq (Hz.) at the end of the motion to be simulated

% Having freq, generate 20 simulations for each of z=0.1, 0.2,..., 0.9 
    for k=1:9
        for j=1:20
            display (['now simulating for z=0.',num2str(k),' , j=',num2str(j),' for GM ',num2str(GM_number)]) 
            % unmodulated simulation for the cut (5-95) motion: 
            SIM_F(:,j,k)=simf(w0*2*pi,wn*2*pi,k*0.1,length(tFcut),deltat);
            % cumulative nmax+pmin: (Local Peaks)
            SIM_LP(:,j,k)=nmax_pmin(SIM_F(:,j,k));
            % 3D matrix : (row,col,page)
        end
    end 
    
    % Take average of every 20 set of simulations 
    %(average columns of each page of the 3D matrix SIM_LP, store in columns avg_LP).
    for k=1:9 
        avg_LP(:,k)=(sum((SIM_LP(:,:,k))'))'/20;
    end
    
    % Calculate errors (to see which column of avg_LP is closer to the target nmax+pmin)
    for k=1:9
        tLP=nmax_pmin(tFcut); %target
        zetadiff(k)=sum(tLP'-avg_LP(:,k));%record i in row i
    end
    
    % Find which two z's give the smallest positive and the smallest negative errors 
    % Interpolate and find zhat that gives zetadiff=0 { z-zp=[(zp-zn)/(ep-en)](e-ep)  zhat is the value of z when e=0}
    % If z<0.1, interpolate by assuming zetadiff=sum(target) at z=0; implying that when damping is 0, motion is harmonic
    zhat=zhatcalc_MD(zetadiff,tLP);
    
    