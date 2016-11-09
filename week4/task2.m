%% Task 2 -- Template matching using Distance Transform and chamfer distance

function task2()
% Show description on screen about task1
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_option_d] = choose_dataset;

% User menu to choose alternative 
[method, valid_option_m] = choose_method;

time_per_frame = [];
time = 0;

% Check if dataset is correct
if ((valid_option_d == 1) && (valid_option_m == 1))
    
    % Load improved masks
    sdir_masks = strcat('improved_masks_old/', dataset);
    samples = dir(sdir_masks); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));
    num_image = 0;
    
    % Load window candidates
    sdir_windows = strcat('windowCandidates_old/', dataset); 
    disp('Starting image processing...');
    
    for ii=1:total_images  
        % Load file name 
        [~, name_sample, ~] = fileparts(samples(ii).name);
        
        % Message to control iterations on screen
        num_image = num_image + 1;
        message = sprintf('\nImages processing: %d/%d. Image name: %s', num_image, total_images, ...
        name_sample);
        disp(message);
        
        % Load image depending on method selected
        if strcmp(method, 'gray')
            if strcmp(dataset, 'test')
                % Load original image
                directory = sprintf('../datasets/test_set/%s.jpg', name_sample);
                mask = imread(directory); 
                mask = rgb2gray(mask);
            else
                 % Load original image
                directory = sprintf('../datasets/train_set/%s_split/%s.jpg', dataset, name_sample);
                mask = imread(directory); 
                mask = rgb2gray(mask);
            end
        elseif strcmp(method, 'mask')
                % Load improved mask
                directory = sprintf('%s/%s.png', sdir_masks, name_sample);
                mask = logical(imread(directory));
        end
       
        % Load windowCandidate
        directory = sprintf('%s/%s.mat', sdir_windows, name_sample);
        windowCandidates = load(directory);
        windowCandidates = windowCandidates.windowCandidates;
        
        % List to save valid windowCandidates that match with templates
        windowCandidates_new = [];
        
        % Compute each windowCandidate
        [n, ~] = size(windowCandidates);
        num_window = 0;
        for jj=1:n
            % Message to display on screen
            num_window = num_window+1;
            message = sprintf('Running template maching on window candidate: %d/%d', ...
            num_window, n);
            disp(message);
            
            bounding_box = [windowCandidates(jj).x windowCandidates(jj).y ...
                            windowCandidates(jj).w windowCandidates(jj).h];
            if any(bounding_box)
                
                %figure, imshow(mask);
                %rectangle('Position', bounding_box, 'EdgeColor','red', 'LineWidth', 2); 
                %pause();
                %close all;
                
                tic
                is_valid = template_maching(mask, windowCandidates(jj));  
                time = time + toc;
                
                if is_valid
                   windowCandidates_new = [windowCandidates_new; ...
                   struct('x', windowCandidates(jj).x, 'y', windowCandidates(jj).y, ...
                          'w', windowCandidates(jj).w, 'h', windowCandidates(jj).h)];
                    
                end
            end
        end
        windowCandidates = windowCandidates_new;
        save_dir = strcat('windowCandidates/',method,'_image/',dataset,'/',name_sample,'.mat');
        save(save_dir, 'windowCandidates'); 
        
        time = time / n;
        time_per_frame = [time_per_frame, time];
        time = 0;
    end
    if strcmp(dataset, 'validation')
        time = mean(time_per_frame);
        message = sprintf('Mean time per frame: %d', time);
        disp(message);
    end
end

disp('task2(): done');
end

% Function: template_maching
% Description: template maching
% Input: mask, windowCandidate
% Output: None
function is_valid = template_maching(mask, windowCandidate)
% Control variable
is_valid = 0;

% Edges computed by Canny
mask = edge(mask, 'Canny');      

% Calculate size of template (must be square)
template_size = floor((windowCandidate.w + windowCandidate.h)/2);

% Mask located by windowCandidate
pos_mask = [windowCandidate.x+(windowCandidate.w/2), windowCandidate.y+(windowCandidate.h/2)];

%----------------------------- Process SQUARE template ---------------------------------------%
disp('Processing square template matching...');
t_square = get_square_template(template_size);             
pos_square = compute_chamfer_distance(mask, t_square);
vdistance_s = [pos_mask(1), pos_mask(2); pos_square(1), pos_square(2)];      
dist_square = pdist(vdistance_s, 'euclidean');

%----------------------------- Process TRIANGLE template -------------------------------------%
disp('Processing triangle template matching...');
t_triangle = get_triangle_template(template_size);         
pos_triangle = compute_chamfer_distance(mask, t_triangle);
vdistance_t = [pos_mask(1), pos_mask(2); pos_triangle(1), pos_triangle(2)];      
dist_triangle = pdist(vdistance_t, 'euclidean');

%----------------------------- Process INVERTED TRIANGLE template ----------------------------%
disp('Processing inverted triangle template matching...');
t_itriangle = imrotate(t_triangle, 180);      
pos_itriangle = compute_chamfer_distance(mask, t_itriangle);
vdistance_it = [pos_mask(1), pos_mask(2); pos_itriangle(1), pos_itriangle(2)];      
dist_itriangle = pdist(vdistance_it, 'euclidean');

%----------------------------- Process CIRCULAR template -------------------------------------%
disp('Processing circular template matching...');
t_circular = get_circular_template(template_size);      
pos_circular = compute_chamfer_distance(mask, t_circular);
vdistance_c = [pos_mask(1), pos_mask(2); pos_circular(1), pos_circular(2)];      
dist_circular = pdist(vdistance_c, 'euclidean');

% Compute minimum position
[dmin, pos] = min([dist_square, dist_triangle, dist_itriangle, dist_circular]);
message = sprintf('Minimum distance: %d', dmin);
disp(message);

% Check distance between mask and template 
max_distance = 1140;
if dmin < max_distance
    switch pos
        case 1
            disp('Found square');
        case 2
            disp('Found triangle');
        case 3
            disp('Found inverted triangle');
        case 4
            disp('Found circle');
    end
    is_valid = 1;
else
    disp('No found templates');
end
    
%tPlot location of detection
% figure('Name', 'mask: location of detection'), imshow(mask);
% hold on;
% plot(pos_mask(1), pos_mask(2), 'm.', 'MarkerSize', 20)
% plot(pos_square(1), pos_square(2), 'r.', 'MarkerSize', 20)
% plot(pos_triangle(1), pos_triangle(2), 'g.', 'MarkerSize', 20)
% plot(pos_itriangle(1), pos_itriangle(2), 'b.', 'MarkerSize', 20)
% plot(pos_circular(1), pos_circular(2), 'y.', 'MarkerSize', 20)
% pause();
% close;
end

% Function: compute_chanfer_distance
% Description: compute chanfer distance
% Input: mask, template, template_size
% Output: location
function location = compute_chamfer_distance(mask, template)
% Edges computed by canny on template to get contour
template_2 = edge(template, 'Canny'); 

% Computes the Euclidean distance transform of the image B
DT = bwdist(mask, 'Euclidean');

% Find placement of T in D that minimizes the sum, M, of the DT multiplied by the
% pixel values in T. This operation can be implemented as find the minimum of the 
% 2D convolution of the template and distance image
C = conv2(DT, double(template_2), 'valid');

% Calculate location of match position
[ColumnMin, Y] = min(C);
[~, X] = min(ColumnMin);
location = [X, Y(X)];

% figure('Name', '2D convolution computing threshold'), ...
% surf(double(C)), shading flat;
% pause();
% close;
end

% Function: choose_method
% Description: user menu to choose method
% Input: None
% Output: method, valid_option
function [method, valid_option] = choose_method()
valid_option = 0;
disp('Alternative 1: distance transform and chamfer distance: original gray level image [gray]');
disp('Alternative 2: distance transform and chamfer distance: contours from binary mask [mask]');
prompt = 'Select method to use [gray/mask] : ';
method = input(prompt,'s');
switch method
    case 'gray'
        disp('Distance transform and chamfer distance (original gray level image) selected');
        method = 'gray';
        valid_option = 1;
    case 'mask'
        disp('Distance transform and chamfer distance (contours from binary mask) selected');
        method = 'mask';
        valid_option = 1;
    otherwise
        disp('Unknow split');
end  
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------------- TASK 2 DESCRIPTION -----------------------------');
disp('Template matching using Distance Transform and chamfer distance');
disp('Chamfer distance model of each shape: ');
disp('   •  Edges computed by canny, gradient magnitude or others ');
disp ('      edges(im,’canny’) on gray level image or contours from binary mask');
disp('   •  Model learning of edges (hand crafted, average or other');
disp('   •  Distance transform of test image and chamfer distance to classify');
disp('------------------------------------------------------------------------------');
fprintf('\n');
end

% Function: get_circular_template
% Description: create circular template
% Input: template_size
% Output: circular template
function template = get_circular_template(template_size)
radius_centered_location = template_size/2;
circle_size = radius_centered_location-5;
[rr, cc] = meshgrid(1:template_size);
template = sqrt((rr-radius_centered_location).^2+(cc-radius_centered_location).^2) ...
<=circle_size;
end

% Function: get_triangle_template
% Description: create triangle template
% Input: template_size
% Output: triangle template
function template = get_triangle_template(template_size)
radius_centered_location = floor(template_size/2);
template = zeros(template_size, template_size);

% Define points of triangle. point = [y, x]
p1 = [template_size-10, 10];
p2 = [template_size-10, template_size-10];
p3 = [10, radius_centered_location];

% Set points on background
template(p1(1), p1(2)) = 1;
template(p2(1), p2(2)) = 1;
template(p3(1), p3(2)) = 1;

% Draw first line
array_x = p1(1):p2(1);
array_y = p1(2):p2(2);
template(array_x, array_y) = 1;

% Draw second line
[~, my] = size(array_y);
a = floor(linspace(p1(1), p3(1), (my-1)));
b = floor(linspace(p1(2), p3(2), (my-1)));
[~, ma] = size(a);
for ii=1:ma
    template(a(ii), b(ii)) = 1;
end
template(p1(1)-1, p1(2)) = 1;

% Draw third line
a = floor(linspace(p2(1), p3(1), (my-1)));
b = floor(linspace(p2(2), p3(2), (my-1)));
for ii=1:ma
    template(a(ii), b(ii)) = 1;
end
template(p2(1)-1, p2(2)) = 1;

% Fill triangle
template = imfill(template,'holes');
end

% Function: get_square_template
% Description: create square template
% Input: template_size
% Output: triangle template
function template = get_square_template(template_size)
template = zeros(template_size, template_size);

% Define points of square. point = [y, x]
p1 = [template_size-10, template_size-10];
p2 = [template_size-10, 10];
p3 = [10, template_size-10];
p4 = [10, 10];

% Set points on background
template(p1(1), p1(2)) = 1;
template(p2(1), p2(2)) = 1;
template(p3(1), p3(2)) = 1;
template(p4(1), p4(2)) = 1;

% Draw horizontal lines
array = p2(2):p1(2);
template(10, array) = 1;
template(template_size-10, array) = 1;
template(array, 10) = 1;
template(array, template_size-10) = 1;

% Fill square
template = imfill(template,'holes');
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