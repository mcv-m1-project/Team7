function t=triangle(base) 
    %The bounding box that contain the triangle is squared of base size
    bbox=zeros(base,base);
    
    for ss=1:2:base
        bbox(base-ss:base-ss+1,1+floor(ss/2):base-floor(ss/2))=1;
    end
    
    t=bbox;
end