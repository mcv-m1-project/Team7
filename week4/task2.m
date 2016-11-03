%% Task 2 -- Template matching using Distance Transform and chamfer distance

function task2()
% Show description on screen about task1
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_option] = choose_dataset;

% Check if dataset is correct
if valid_option == 1
    
    % Load improved masks
    sdir_masks = strcat('improved_masks/', dataset);
    samples = dir(sdir_masks); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));
    num_image = 0;
    
    % Load window candidates
    sdir_windows = strcat('windowCandidates/', dataset); 
    disp('Starting image processing...');
    
    for ii=1:total_images  
        % Load file name 
        [~, name_sample, ~] = fileparts(samples(ii).name);
        
        % Message to control iterations on screen
        num_image = num_image + 1;
        message = sprintf('\nImages processing: %d/%d. Image name: %s', num_image, total_images, ...
        name_sample);
        disp(message);
        
        % Load improved mask
        directory = sprintf('%s/%s.png', sdir_masks, name_sample);
        mask = logical(imread(directory));

        % Load windowCandidate
        directory = sprintf('%s/%s.mat', sdir_windows, name_sample);
        windowCandidates = load(directory);
        windowCandidates = windowCandidates.windowCandidates;

        % Compute each windowCandidate
        [n, ~] = size(windowCandidates);
        num_window = 0;
        for jj=1:n
            num_window = num_window+1;
            message = sprintf('Running template maching on window candidate: %d/%d', ...
            num_window, n);
            disp(message);
            bounding_box = [windowCandidates.x windowCandidates.y windowCandidates.w ...
                            windowCandidates.h];
            if any(bounding_box)
                template_maching(mask, windowCandidates(jj));  
            end
        end
    end
end

disp('task2(): done');
end

% Function: template_maching
% Description: template maching
% Input: mask, windowCandidate
% Output: None
function template_maching(mask, windowCandidate)
% Edges computed by Canny
mask = edge(mask, 'Canny');      

% Calculate size of template (must be square)
template_size = floor((windowCandidate.w + windowCandidate.h)/2);

% Mask located by windowCandidate
pos_mask = [windowCandidate.x+(windowCandidate.w/2), windowCandidate.y+(windowCandidate.h/2)];

% Process square template
disp('Processing square template matching...');
t_square = get_square_template(template_size);             
pos_square = compute_chanfer_distance(mask, t_square, template_size);
vdistance_s = [pos_mask(1), pos_mask(2); pos_square(1), pos_square(2)];      
dist_square = pdist(vdistance_s, 'euclidean');

% Process triangle template
disp('Processing triangle template matching...');
t_triangle = get_triangle_template(template_size);         
pos_triangle = compute_chanfer_distance(mask, t_triangle, template_size);
vdistance_t = [pos_mask(1), pos_mask(2); pos_triangle(1), pos_triangle(2)];      
dist_triangle = pdist(vdistance_t, 'euclidean');

% Process inverted triangle template
disp('Processing inverted triangle template matching...');
t_itriangle = imrotate(t_triangle, 180);      
pos_itriangle = compute_chanfer_distance(mask, t_itriangle, template_size);
vdistance_it = [pos_mask(1), pos_mask(2); pos_itriangle(1), pos_itriangle(2)];      
dist_itriangle = pdist(vdistance_it, 'euclidean');

% Process circular template
disp('Processing circular template matching...');
t_circular = get_circular_template(template_size);      
pos_circular = compute_chanfer_distance(mask, t_circular, template_size);
vdistance_c = [pos_mask(1), pos_mask(2); pos_circular(1), pos_circular(2)];      
dist_circular = pdist(vdistance_c, 'euclidean');

[dmin, pos] = min([dist_square, dist_triangle, dist_itriangle, dist_circular]);
max_distance = 100;

% Check distance between mask and template 
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
else
    disp('No found templates');
end
    
% Plot location of detection
figure('Name', 'mask: location of detection'), imshow(mask);
hold on;
plot(pos_mask(1), pos_mask(2), 'm.', 'MarkerSize', 30)
plot(pos_square(1), pos_square(2), 'r.', 'MarkerSize', 30)
plot(pos_triangle(1), pos_triangle(2), 'g.', 'MarkerSize', 30)
plot(pos_itriangle(1), pos_itriangle(2), 'b.', 'MarkerSize', 30)
plot(pos_circular(1), pos_circular(2), 'y.', 'MarkerSize', 30)
pause();
close;
    
end

% Function: compute_chanfer_distance
% Description: compute chanfer distance
% Input: T1
% Output: None
function location = compute_chanfer_distance(mask, template, template_size)
template_2 = edge(template, 'Canny'); 

% Computes the Euclidean distance transform of the image B
DT = bwdist(mask, 'Euclidean');

% Find placement of T in D that minimizes the sum, M, of the DT multiplied by the
% pixel values in T. This operation can be implemented as find the minimum of the 
% 2D convolution of the template and distance image
C = conv2(DT, double(template_2), 'valid');

% Perform another convolution with a solid template to find location with displacement of
% matching position produced by false positives in background
C2 = conv2(DT, double(template),'valid');

% Compute threshold on second 2D convolution
thresold = (2 * template_size + 1)^2 * 3;
C(C2<thresold) = max(max(C));

% Calculate location of match position
[ColumnMin, Y] = min(C);
[~, X] = min(ColumnMin);
location = [X, Y(X)];
end

%figure('Name', '2D convolution computing threshold'), ...
%surf(double(C)), shading flat;
%pause();
%close;

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