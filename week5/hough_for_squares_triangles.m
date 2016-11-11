% Function: hough_for_squares_triangles
% Description: compute hough to detect squares and triangles on binary mask
% Input: mask,  windowCandidates
% Output: is_valid
function is_valid = hough_for_squares_triangles(mask, windowCandidate)
% Variable to detect squares or triangles
is_valid = 0;

% Compute standard hough transform
[H, ~, ~] = hough(mask);
%[H, THETA, RHO] = hough(mask);
% imshow(H, [], 'XData', THETA, 'YData', RHO, 'InitialMagnification', 'fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;

nmax = max(max(H));
data = zeros(1, nmax);
for ii = 1:nmax
    data(ii) = sum(sum(H == ii));
end

[maxval,maxind] = max(data);
medval = median(data);
[p] = polyfit(1:maxind-5,data(1:maxind-5),2);

if maxval<3*medval
    %disp('Found triangle');
    is_valid = 1;
elseif  p(3)>(windowCandidate.w-80)
    %disp('Found square');
    is_valid = 1;
end
end