% Function: custom_imerode
% Description: custom erosion operation
% Input: image, se
% Output: image_eroded
function image_eroded = myerode(image, se)
% Get integer sizes of structuring element
[m, n] = size(se);
% Divided by 2 in order to adjust local window into image
m = floor(m/2);
n = floor(n/2);

% Add value 1 on borders of images
image = padarray(image, [m n], 1);
% Initialize to 0 dilated image
image_eroded = false(size(image));
% Get sizes of dilated image
[max_i, max_j] = size(image);

% Set max_i and max_j iterations to iterate inside of image
max_i = max_i-(2*m);
max_j = max_j-(2*n);

% Iterate pixel by pixel of image
for i=1:max_i
    for j=1:max_j
        window = image(i:i+(2*m),j:j+(2*n));   % Get window
        min_value = min(min(window-se));       % Get local MINIMUM
        image_eroded(i,j) = min_value;         % Assing pixel value to image
    end
end
% Resize image eroded
image_eroded = ~image_eroded(1:max_i, 1:max_j);
end