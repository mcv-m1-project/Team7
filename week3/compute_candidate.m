function candidate = compute_candidate(window)
    % 4 subwindow
    len_window = size(window);
    len = len_window(1);
    
    if sum(sum(window))/(len*len)<0.3
        candidate = 0;
    else
        win_1 = window(1:len/2,1:len/2);
        win_2 = window(1:len/2,len/2+1:len);
        win_3 = window(len/2+1:len,1:len/2);
        win_4 = window(len/2+1:len,len/2+1:len);

        win_1_rel = (sum(sum(win_1)))/((len/2)*(len/2));
        win_2_rel = (sum(sum(win_2)))/((len/2)*(len/2));
        win_3_rel = (sum(sum(win_3)))/((len/2)*(len/2));
        win_4_rel = (sum(sum(win_4)))/((len/2)*(len/2));

        area_sup_tri = (len/4)*(len/2);
        area_tol = 1.2;
        area_tol_2 = 0.5;

        % Square detected
        if win_1_rel<=1 && win_1_rel>=0.9 && win_2_rel<=1 && win_2_rel>=0.9 ...
           && win_3_rel<=1 && win_3_rel>=0.9 && win_4_rel<=1 && win_4_rel>=0.9
            candidate=1;
            % disp('Square detected!')
        % Circle detected
        elseif win_1_rel<=0.9 && win_1_rel>=0.6 && win_2_rel<=0.9 && ...
               win_2_rel>=0.6 && win_3_rel<=0.9 && win_3_rel>=0.6 && ...
               win_4_rel<=0.9 && win_4_rel>=0.6
            candidate=2;
            % disp('Circle detected!')
        % Triangle detected
        elseif win_1_rel<=area_sup_tri+area_sup_tri*area_tol && ....
               win_1_rel>=area_sup_tri-area_sup_tri*area_tol && ...
               win_2_rel<=area_sup_tri+area_sup_tri*area_tol && ...
               win_2_rel>=area_sup_tri-area_sup_tri*area_tol && ...
               win_3_rel>=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2 && ...
               win_4_rel>=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2
            candidate=3;
            % disp('Triangle detected!')
        elseif win_3_rel<=area_sup_tri+area_sup_tri*area_tol && ...
               win_3_rel>=area_sup_tri-area_sup_tri*area_tol && ...
               win_4_rel<=area_sup_tri+area_sup_tri*area_tol && ...
               win_4_rel>=area_sup_tri-area_sup_tri*area_tol && ...
               win_1_rel<=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2 && ...
               win_2_rel<=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2 
            candidate=4;
            % disp('Detection!')
        else
            candidate = 0;
        end
    end
end