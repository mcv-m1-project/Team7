% Function: mytophat
% Description: custom top hat operation
% Input: image, se
% Output: image_tpohat
function image_tophat = mytophat(image, se)
% Top-hat filtering computes the morphological opening of the image (using imopen) and then 
% subtracts the result from the original image
image_tophat = myopen(image, se);
image_tophat = image - image_tophat; 
end