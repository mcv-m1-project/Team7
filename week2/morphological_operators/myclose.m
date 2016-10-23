% Function: myclose
% Description: custom closing operation
% Input: image, se
% Output: image_closed
function image_closed = myclose(image, se)
% The definition of a morphological closing of an image is an dilation followed by a erosion, 
% using the same structuring element for both operations.
image_closed = mydilate(image, se);
image_closed = myerode(image_closed, se);
end