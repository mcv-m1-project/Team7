% Function: mybothat
% Description: custom top hat operation
% Input: image, se
% Output: image_dual_tophat
function image_dual_tophat = mybothat(image, se)
% Top-hat filtering computes the morphological closing of the image (using imopen) and then 
% subtracts the original image from the result
image_dual_tophat = myclose(image, se);
image_dual_tophat = image_dual_tophat - image; 
end