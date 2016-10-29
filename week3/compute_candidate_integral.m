function candidate = compute_candidate_integral(mask, r1, r2, c1, c2)
    % 4 subwindow
    len = r2-r1;
    
    % Use of integral image
    img_integral = cumsum(cumsum(mask),2);
    white_sum = img_integral()-img_integral()-img_integral+img_integral();
    
    if (img_integral(r2,c2)-img_integral(r1,c2)-img_integral(r2,c1)+ ...
        img_integral(r1,c1))/(len*len)<0.3
        candidate=0;
    else
        win_1_rel=(img_integral(ceil((r1+r2)/2),ceil((c1+c2)/2)) ...
        -img_integral(ceil((r1+r2)/2),c1)-img_integral(r1,ceil((c1+c2)/2))...
        +img_integral(r1,c1))/((len/2)*(len/2));
        win_2_rel=(img_integral(ceil((r1+r2)/2),c2)-img_integral(ceil(...
        (r1+r2)/2),ceil((c1+c2)/2))-img_integral(r1,c2)+img_integral(r1,ceil(...
        (c1+c2)/2)))/((len/2)*(len/2));
        win_3_rel=(img_integral(r2,ceil((c1+c2)/2))-img_integral(r2,c1)-...
        img_integral(ceil((r1+r2)/2),ceil((c1+c2)/2))+img_integral(ceil...
        ((r1+r2)/2),c1))/((len/2)*(len/2));
        win_4_rel=(img_integral(r2,c2)-img_integral(r2,ceil((c1+c2)/2))-...
        img_integral(ceil((r1+r2)/2),c2)+img_integral(ceil((r1+r2)/2),ceil...
        ((c1+c2)/2)))/((len/2)*(len/2));

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
        elseif win_1_rel<=area_sup_tri+area_sup_tri*area_tol && ...
               win_1_rel>=area_sup_tri-area_sup_tri*area_tol && ...
               win_2_rel<=area_sup_tri+area_sup_tri*area_tol && ...
               win_2_rel>=area_sup_tri-area_sup_tri*area_tol && ....
               win_3_rel>=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2 ...
               && win_4_rel>=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2
            candidate=3;
            % disp('Triangle detected!');
        elseif win_3_rel<=area_sup_tri+area_sup_tri*area_tol && ...
                win_3_rel>=area_sup_tri-area_sup_tri*area_tol && ...
                win_4_rel<=area_sup_tri+area_sup_tri*area_tol && ...
                win_4_rel>=area_sup_tri-area_sup_tri*area_tol && ...
                win_1_rel<=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2 ...
                && win_2_rel<=(1-area_sup_tri)-(1-area_sup_tri)*area_tol_2 
            candidate=4;
            % disp('Detection!');
        else
            candidate = 0;
        end
    end
end