function y=single_histogram(image,mask,nbinsr,nbinsg,nbinsb,method)

    s=size(image);
    image=double(image)/255;

    switch method
        case '2'
            image = normalize_RGB_image(image);
        case '3'
            cd ../colorspace
            image = colorspace('rgb->xyz',image);
            cd ../week2
    end
       
    histogram=zeros(nbinsr,nbinsg,nbinsb);
    for ii=1:s(1)
        for jj=1:s(2)
            if mask(ii,jj)==1
                r_bin=min(floor(nbinsr*image(ii,jj,1))+1,nbinsr);
                g_bin=min(floor(nbinsg*image(ii,jj,2))+1,nbinsg);
                b_bin=min(floor(nbinsb*image(ii,jj,3))+1,nbinsb);
                
                histogram(r_bin,g_bin,b_bin)=histogram(r_bin,g_bin,b_bin)+1;
            end
        end
    end
    y=histogram;
end