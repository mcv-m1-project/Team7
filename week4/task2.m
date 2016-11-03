%% Task 2 -- Template matching using Distance Transform and chamfer distance

function task2()
% Show description on screen about task1
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_option] = choose_dataset;
% Check if dataset is correct
if valid_option == 1
    print_windowCandidates_on_mask(dataset);
end

% Load mask B.
% Edges computed by Canny
B = imread('00.000948.png');
B = edge(B, 'Canny');

%---------- Create circular template ------------%
radius_centered_location = 40;
total_size = 80;
circle_size = 20;
T = get_circular_template(radius_centered_location, total_size, circle_size);
T = edge(T, 'Canny');

% Computes the Euclidean distance transform of the image B
DT = bwdist(B, 'Euclidean');

% Find placement of T in D that minimizes the sum, M, of the DT multiplied by the
% pixel values in T. This operation can be implemented as find the minimum of the 
% convolution of the template and distance image
C = conv2(DT, double(T), 'valid');
[ColumnMin, Y] = min(C);
[~, X] = min(ColumnMin);
min_x = X;
min_y = Y(X);

% Plot location of detection
figure, imshow(B);
hold on;
plot(min_x, min_y, 'y.', 'MarkerSize', 30)
pause();
close all;
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
% Input: radius_centered_location, total_size, circle_size
% Output: template
function template = get_circular_template(radius_centered_location, total_size, ...
 circle_size)
[rr, cc] = meshgrid(1:total_size);
template = sqrt((rr-radius_centered_location).^2+(cc-radius_centered_location).^2) ...
<=circle_size;
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

% Function: print_windowCandidates_on_mask
% Description: print window candidates on mask
% Input: None
% Output: None
function print_windowCandidates_on_mask(dataset)
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
        % Load improved mask
        [~, name_sample, ~] = fileparts(samples(ii).name);
        directory = sprintf('%s/%s.png', sdir_masks, name_sample);
        mask = logical(imread(directory));
        figure, imshow(mask)
       
        % Load windowCandidate
        directory = sprintf('%s/%s.mat', sdir_windows, name_sample);
        windowCandidates = load(directory);
        windowCandidates = windowCandidates.windowCandidates;
        
        [n, ~] = size(windowCandidates);
        for jj=1:n
            bounding_box = [windowCandidates(jj).x windowCandidates(jj).y ...
                            windowCandidates(jj).w windowCandidates(jj).h];
            if any(bounding_box)
                rectangle('Position', bounding_box, 'EdgeColor','green', 'LineWidth', 2); 
            end
        end
        pause();
        close all;
        
        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d. Image name: %s', num_image, total_images, ...
        name_sample);
        disp(message);
    end
end