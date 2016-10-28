mask_size = size(mask);
k = 2;
optimum_k = 0;
while k<=15
    [idx,C]=kmeans(matrix_detection,k);
    rectangles=zeros(mask_size);
    for ll=1:length(C)
        rectangles(C(ll,1):C(ll,2),C(ll,3):C(ll,4))=rectangles ...
        (C(ll,1):C(ll,2),C(ll,3):C(ll,4))+1;
    end
    peak=max(max(rectangles));
    if peak==1
        k=k+1;
    else
        optimum_k=k-1;
        k=16;
    end
end