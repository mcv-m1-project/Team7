% Function: myopen
% Description: custom opening operation
% Input: image, se
% Output: image_opened
function image_opened = myopen(image, se)
% The definition of a morphological opening of an image is an erosion followed by a dilation, 
% using the same structuring element for both operations.
image_opened = myerode(image, se);
image_opened = mydilate(image_opened, se);
end