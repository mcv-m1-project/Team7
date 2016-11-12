% Function: hough_for_circles
% Description: compute hough to detect circles on binary mask
% Input: mask,  windowCandidates
% Output: is_valid
function is_valid = hough_for_circles(mask, windowCandidates)
% Variable to detect circles
is_valid = 0;

% Define 5-by-5 filter to smooth out the small scale irregularities
fltr4img = [1 1 1 1 1; 1 2 2 2 1; 1 2 4 2 1; 1 2 2 2 1; 1 1 1 1 1];
fltr4img = fltr4img / sum(fltr4img(:));
imgfltrd = filter2( fltr4img , mask );

% Galculate center of cercle
center_x = windowCandidates.x+(windowCandidates.w/2);
center_y = windowCandidates.y+(windowCandidates.h/2);
center = [center_x center_y];

% Get radius of cercle
radius = floor(windowCandidates.w/2);
Rmin = radius - 10;
Rmax = radius + 10;
radrange = [Rmin Rmax];

% Define inputs to function CircularHough_Grd.
% Based on example #3 provided on file CircularHough_Grd.m
fltr4LM_R = 8;
multirad = 10;
fltr4accum = 0.7;

% Compute circular hough
[~, circen, ~] = CircularHough_Grd(imgfltrd, radrange, ...
fltr4LM_R, multirad, fltr4accum);

% figure, imshow(mask), hold on;
% plot(circen(:,1), circen(:,2), 'r+');
% for k = 1 : size(circen, 1),
    % DrawCircle(circen(k,1), circen(k,2), cirrad(k), 32, 'b-');
% end

% Check if exists any location that match with center of window candidate.
% In this case, it means that within of window candidate there are one circle.
[n, ~] = size(circen);
for zz=1:n
    locations = [center(1), center(2); circen(zz,1),circen(zz,2)];
    dist = pdist(locations, 'euclidean');  
    if dist <= 5        
        % message = sprintf('Found circle. Distance: %d', dist);
        % disp(message);
        % plot( circen(zz,1),  circen(zz,2), 'g.', 'MarkerSize', 20)
        is_valid = 1;
    end     
end
% pause();
% close all;
end