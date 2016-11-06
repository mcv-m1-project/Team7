function ngray=normalize_gray(grayImage)
    originalMinValue = double(min(min(grayImage)));
    originalMaxValue = double(max(max(grayImage)));
    originalRange = originalMaxValue - originalMinValue;

    % Get a double image in the range 0 to +255
    desiredMin = 0;
    desiredMax = 255;
    desiredRange = desiredMax - desiredMin;
    s=size(grayImage);
    ngray=zeros(s);
    
    for ii=1:s(1)
        for jj=1:s(2)
            ngray(ii,jj) = desiredRange * (double(grayImage(ii,jj)) - originalMinValue) / originalRange + desiredMin;
        end
    end
    
end