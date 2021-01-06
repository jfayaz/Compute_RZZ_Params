function [ARIAS,D5_95, D0_5, D0_30, t_mid] = Cal_Arias_tmid_Durations(acc_1_cell, dt_cell, percent_tmid, t0_rec)

% %     INPUTS
% %     ------
% %     acc_1:          GM history in dir 1 
% %     dt:             delat t of GM history
% %     percent_tmid:   percent of AI at which the GM is considered to have reached tmid
                        % 30% for near-fault GMs (Dabaghi 2014)
                        % 45% for far-field GMs  (Rezaeian 2010)
% %                     (used in calculating t_mid)

ARIAS = zeros(length(acc_1_cell),1);
D5_95 = zeros(length(acc_1_cell),1);
D0_5 = zeros(length(acc_1_cell),1);
D0_30 = zeros(length(acc_1_cell),1);
t_mid = zeros(length(acc_1_cell),1);


for i = 1:length(acc_1_cell)

       GM1 = acc_1_cell{i};
       time = dt_cell{i}:dt_cell{i}:length(GM1)*dt_cell{i};
       dt = dt_cell{i};

       % Calculating Arias Intensity and durations
       [t_5,~,ARIAS_val,~]  = arias(GM1,dt,5);
       [t_95,~,~,~]         = arias(GM1,dt,95);
       [t_30,~,~,~]         = arias(GM1,dt,30);
       ARIAS(i) = ARIAS_val * (9.81^2) * pi()/(2*9.81) * 100; %acc is in (g), Arias is in cm/s
       
       D5_95(i)   = t_95 - t_5;
       D0_5(i)    = t_5  - t0_rec; %assuming start of GM is at t0_rec
       D0_30(i)   = t_30 - t0_rec;
       
       % Calculating t_mid
       [t_mid_i,~,~,~]         = arias(GM1,dt,percent_tmid);
       t_mid(i)   = t_mid_i - t0_rec;
     
end

end

