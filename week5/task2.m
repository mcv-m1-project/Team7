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
        mask = imread(directory);   
        
        % Compute Otsu to transform image into black and white (binary)
        threshold = graythresh(mask);
        mask = im2bw(mask, threshold);
        
        % Apply filter to reduce noise
        se = getnhood(strel('disk', 7));
        mask = imopen(mask, se);
        
        % Performs a flood-fill operation on background pixels 
        mask = imfill(mask,'holes');
        
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
                   
            % plot(features(jj).Centroid(1), features(jj).Centroid(2), 'green.', 'MarkerSize', 20);
            % rectangle('Position', features(jj).BoundingBox, 'EdgeColor','yellow', 'LineWidth', 2); 
                                  
            % Hough for detect squares and triangles 
            fprintf('Computing hough for squares and triangles... ');
            is_square_triangle = hough_for_squares_triangles(mask, windowCandidates);
            fprintf('done\n');
            
            % Hough for detect circles 
            fprintf('Computing hough for circles... ');
            is_circle = hough_for_circles(mask, windowCandidates);
            fprintf('done\n');
            
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
        pause();
        close all;
    end
end
disp('task2(): done');
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