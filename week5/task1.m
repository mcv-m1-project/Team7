%% Task 1 -- Geometric Heuristics

function task1()
% Show description on screen
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_dataset] = choose_dataset;

% Check if dataset is correct
if valid_dataset
    
    % Load improved masks directory
    sdir_improved_masks = strcat('improved_masks/', dataset);
    
    % Load original images directory
    if strcmp(dataset, 'test')
        sdir_images = sprintf('../datasets/test_set/');
    else
        sdir_images = sprintf('../datasets/train_set/%s_split/', dataset);
    end
    samples = dir(sdir_images); 
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
        message = sprintf('\nImages processing: %d/%d. Image name: %s', num_image, ...
        total_images, name_sample);
        disp(message);
 
        % Load original image
        % directory = sprintf('%s/%s.jpg', sdir_images, name_sample);
        % original_image = imread(directory);
        
        % Load improved mask
        directory = sprintf('%s/%s.png', sdir_improved_masks, name_sample);
        improved_mask = imread(directory);
        
        % Load window candidate
        directory = sprintf('%s/%s.mat', sdir_windows, name_sample);
        windowCandidates = load(directory);
        windowCandidates = windowCandidates.windowCandidates;
        
        % Define new mask of match detections
        [sn, sm, ~] = size(improved_mask);
        mask_detections = zeros(sn, sm);
        
        % Counter of shape detections
        total_circles = 0;
        total_square_triangles = 0;
        
        % Compute each window candidate
        [n, ~] = size(windowCandidates);
        for jj=1:n
            msg = sprintf('Computing hough detections. Window candidate: %d/%d', jj, n);
            disp(msg);    
            bounding_box = [windowCandidates(jj).x windowCandidates(jj).y ...
                            windowCandidates(jj).w windowCandidates(jj).h];
                   
            % Hough for detect squares and triangles 
            fprintf('Computing hough for squares and triangles... ');
            is_square_triangle = detect_square_triangle(improved_mask, windowCandidates(jj));
            total_square_triangles = total_square_triangles + is_square_triangle;
            fprintf('done\n');
            
            % Hough for detect circles 
            fprintf('Computing hough for circles... ');     
            % gray_image = rgb2gray(original_image);  % Tranform image into gray scale
            % [Gx, Gy] = imgradientxy(gray_image);    % Find the directional gradients
            % [~, Gdir] = imgradient(Gx, Gy);         % Find the gradient magnitude and direction      
            is_circle = hough_for_circles(improved_mask, windowCandidates(jj));
            total_circles = total_circles + is_circle;
            fprintf('done\n');

            % If detected any shape on window, add detections as signal
            if is_circle || is_square_triangle 
                x1 = max(floor(bounding_box(2)), 1);
                x2 = max(floor(bounding_box(2)+bounding_box(4)), 1);
                y1 = max(floor(bounding_box(1)), 1);
                y2 = max(floor(bounding_box(1)+bounding_box(3)), 1);
                mask_detections(x1:x2, y1:y2) = improved_mask(x1:x2, y1:y2);
                
                fprintf('Squares or/and triangles detected: %d\n', total_square_triangles);
                fprintf('Circles detected: %d\n', total_circles);                 
            else
                disp('No found detections');
            end
        end
        simage = sprintf('improved_task1/%s/%s.png', dataset, name_sample);
        imwrite(mask_detections, simage, 'png');
        
        % figure();
        % set(gcf,'name','Improved masks','numbertitle','off','Position', ...
        % [150, 150, 1300, 400]);
        % subplot(1,2,1), imshow(improved_mask), title('old improved mask');
        % subplot(1,2,2), imshow(mask_detections), title('new improved mask');
        % pause();
        % close all;
    end
end
disp('task1(): done');
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------------- TASK 1 DESCRIPTION -----------------------------');
disp('Geometric Heuristics. Squares & Triangles: Hough for lines + heuristics');
disp('circles: Hough for circles. Object-based evaluation (MScProj-DB-System)');
disp('(precision, accuracy, specificity, sensitivity)');
disp('------------------------------------------------------------------------------');
fprintf('\n');
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