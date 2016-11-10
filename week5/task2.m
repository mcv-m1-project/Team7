%% Task 2 -- Improve segmentation

function task2()
% User menu to choose dataset 
[dataset, valid_dataset] = choose_dataset;

% Check if dataset is correct
if valid_dataset
    
    % Load mean shift images
    sdir_masks = strcat('mean_shift_images/', dataset);
    samples = dir(sdir_masks); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));
    num_image = 0;
    
    disp('Starting image processing...');
    for ii=1:total_images
        % Load file name 
        [~, name_sample, ~] = fileparts(samples(ii).name);
        
        % Message to control iterations on screen
        num_image = num_image + 1;
        message = sprintf('\nImages processing: %d/%d. Image name: %s', num_image, ...
        total_images, name_sample);
        disp(message);
 
        % Load mean shift image
        directory = sprintf('%s/%s.jpg', sdir_masks, name_sample);
        image_ms = imread(directory); 
        
        % Transform mean shift image to binary image
        level = graythresh(image_ms);
        mask = im2bw(image_ms, level);
               
        se = getnhood(strel('disk', 5));
        mask = imopen(mask, se);
        
        % Get features of regions detected
        features  = regionprops(mask, 'centroid', 'BoundingBox');
        
        % Define new mask of match detections
        [sn, sm] = size(mask);
        mask_detections = zeros(sn, sm);
        
        % Compute each window candidate
        [n, ~] = size(features);
        figure, imshow(mask), hold on;
        for jj=1:n
            msg = sprintf('Computing hough detections. Window candidate: %d/%d', jj, n);
            disp(msg);    
            
            bounding_box = features(jj).BoundingBox;
            windowCandidates = struct('x', bounding_box(1), 'y', bounding_box(2), ...
                                      'w', bounding_box(3), 'h', bounding_box(4));
                   
            plot(features(jj).Centroid(1), features(jj).Centroid(2), 'green.', 'MarkerSize', 20);
            rectangle('Position', features(jj).BoundingBox, 'EdgeColor','yellow', 'LineWidth', 2); 
                                  
            % Hough for detect squares and triangles 
            disp('Computing hough for squares and triangles...');
            is_square_triangle = hough_for_squares_triangles(mask, windowCandidates);
            
            % Hough for detect circles 
            disp('Computing hough for circles...');
            is_circle = hough_for_circles(mask, windowCandidates);
            
            % If detected any shape on window, add detections as signal
            if is_circle || is_square_triangle 
                x1 = max(floor(bounding_box(2)), 1);
                x2 = max(floor(bounding_box(2)+bounding_box(4)), 1);
                y1 = max(floor(bounding_box(1)), 1);
                y2 = max(floor(bounding_box(1)+bounding_box(3)), 1);
                mask_detections(x1:x2, y1:y2) = mask(x1:x2, y1:y2);
                
                simage = sprintf('improved_task2/%s/%s.png', dataset, name_sample);
                imwrite(mask_detections, simage,'png');
            end
        end      
    end
end
disp('task2(): done');
end

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
    disp('Found triangle');
    is_valid = 1;
elseif  p(3)>(windowCandidate.w-80)
    disp('Found square');
    is_valid = 1;
end
end

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

% Check if exists any location that match with center of window candidate.
% In this case, it means that within of window candidate there are one circle.
[n, ~] = size(circen);
for zz=1:n
    locations = [center(1), center(2); circen(zz,1),circen(zz,2)];
    dist = pdist(locations, 'euclidean');  
    if dist <= 1 
        message = sprintf('Found circle. Distance: %d', dist);
        disp(message);
        is_valid = 1;
    end     
end
end

% Function: choose_dataset
% Description: user menu to choose dataset
% Input: None
% Output: dataset
function [dataset, valid_option] = choose_dataset()
valid_option = 0;
prompt = 'Do you want mork on train or dataset? [train/test] : ';
dataset = input(prompt,'s');
switch dataset
    case 'train'
        disp('Dataset train selected');
        prompt = 'Do you want mork on train or validation split? [train/validation] : ';
        dataset = input(prompt,'s');
        switch dataset
            case 'train'
                disp('Dataset train split');
                valid_option = 1;
            case 'validation'
                disp('Dataset validation split');
                valid_option = 1;
            otherwise
                disp('Unknow split');
        end   
    case 'test'
        disp('Dataset test selected');
        valid_option = 1;
    otherwise
        disp('Unknow option');
end
end