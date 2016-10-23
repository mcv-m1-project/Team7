function y=compute_probability(image,hist,nbinsr,nbinsg,nbinsb)

    s=size(image);
    %image=normalize_RGB_image(image);
    image=double(image)/255;
    %image=colorspace('rgb->xyz',image);
    prob=zeros(s(1),s(2));
    
    for ii=1:s(1)
        for jj=1:s(2)
            
                r_bin=min(floor(nbinsr*image(ii,jj,1))+1,nbinsr);
                g_bin=min(floor(nbinsg*image(ii,jj,2))+1,nbinsg);
                b_bin=min(floor(nbinsb*image(ii,jj,3))+1,nbinsb);
                
                prob(ii,jj)=hist(r_bin,g_bin,b_bin);
           
        end
    end
    
    y=prob;
    
end