%% Task 1 -- Geometric Heuristics

function task1()
% Show description on screen
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_dataset] = choose_dataset;

% Check if dataset is correct
if valid_dataset
    
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
        message = sprintf('\nImages processing: %d/%d. Image name: %s', num_image, ...
        total_images, name_sample);
        disp(message);
 
        % Load improved mask
        directory = sprintf('%s/%s.png', sdir_masks, name_sample);
        mask = imread(directory); 
       
        % Load window candidate
        directory = sprintf('%s/%s.mat', sdir_windows, name_sample);
        windowCandidates = load(directory);
        windowCandidates = windowCandidates.windowCandidates;
        
        % Define new mask of match detections
        [sn, sm] = size(mask);
        mask_detections = zeros(sn, sm);
        
        % Compute each window candidate
        [n, ~] = size(windowCandidates);
        for jj=1:n
            msg = sprintf('Computing hough detections. Window candidate: %d/%d', jj, n);
            disp(msg);    
            bounding_box = [windowCandidates(jj).x windowCandidates(jj).y ...
                            windowCandidates(jj).w windowCandidates(jj).h];
            % if any(bounding_box)
                % rectangle('Position', bounding_box, 'EdgeColor','green', 'LineWidth', 2);                 
            % end
                   
            % Hough for detect squares and triangles 
            disp('Computing hough for squares and triangles...');
            is_square_triangle = hough_for_squares_triangles(mask, windowCandidates(jj));
            
            % Hough for detect circles 
            disp('Computing hough for circles...');
            is_circle = hough_for_circles(mask, windowCandidates(jj));
            
            % If detected any shape on window, add detections as signal
            if is_circle || is_square_triangle 
                x1 = max(floor(bounding_box(2)), 1);
                x2 = max(floor(bounding_box(2)+bounding_box(4)), 1);
                y1 = max(floor(bounding_box(1)), 1);
                y2 = max(floor(bounding_box(1)+bounding_box(3)), 1);
                mask_detections(x1:x2, y1:y2) = mask(x1:x2, y1:y2);
                
                simage = sprintf('improved_task1/%s/%s.png', dataset, name_sample);
                imwrite(mask_detections, simage,'png');
            end
        end
        
        % figure();
        % set(gcf,'name','RGB channels','numbertitle','off','Position', ...
        % [150, 150, 1300, 400]);
        % subplot(1,2,1), imshow(mask), title('mask');
        % subplot(1,2,2), imshow(mask_detections), title('mask_detections');
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