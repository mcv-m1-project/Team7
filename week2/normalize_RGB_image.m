function normalize_RGB = normalize_RGB_image(image)
    % Split channels RBG
    red = double(image(:, :, 1));            
    green = double(image(:, :, 2));           
    blue = double(image(:, :, 3)); 

    
    % Normalize each channel
    normalize_red = max(0,red./(red + green + blue));
    normalized_green = max(0,green./(red + green + blue));
    normalize_blue = max(0,blue./(red + green + blue));

    % Merge channels again
    normalize_RGB(:,:,1) = normalize_red;
    normalize_RGB(:,:,2) = normalized_green;
    normalize_RGB(:,:,3) = normalize_blue;
end