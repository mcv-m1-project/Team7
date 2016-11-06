function candidate=template_matching(window, size)
    square_temp=ones(size, size);
    se=strel(ball, size/2, size/2);
    circle_temp=se.getnhood;
    trian_temp=triangle(size);
    inv_trian_temp=flipud(trian_temp);
    
    count_square=0;
    count_circle=0;
    count_tri=0;
    count_inv_tri=0;
    
    for ii=1:size
        for jj=1:size
                count_square=count_square+window(ii,jj)*square_temp(ii,jj);
                count_circle=count_circle+window(ii,jj)*circle_temp(ii,jj);
                count_tri=count_tri+window(ii,jj)*trian_temp(ii,jj);
                count_inv_tri=count_inv_tri+window(ii,jj)*inv_trian_temp(ii,jj);
        end
    end
    
    prob_square=count_square/sum(sum(square_temp));
    prob_circle=count_circle/sum(sum(circle_temp));
    prob_trian=count_tri/sum(sum(trian_temp));
    prob_inv_trian=count_inv_tri/sum(sum(inv_trian_temp));
    
    if prob_square<1 && prob_square>0.8
        candidate=1;
    elseif prob_circle<1 && prob_circle>0.8
        candidate=2;
    elseif prob_trian<1 && prob_trian>0.8
        candidate=3;
    elseif prob_inv_trian<1 && prob_inv_trian>0.8
        candidate=4;
    end
    
end