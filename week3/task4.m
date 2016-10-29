%% Task 4 -- Region-based evaluation

function task4()
% Show description on screen about task1
show_description_on_screen();
% User menu to choose dataset 
[dataset, valid_option_dataset] = choose_dataset();
% User menu to choose method 
[method, mat_file, valid_option_method] = choose_method();

if (valid_option_dataset == 1 && valid_option_method == 1) 

    % Number of image to display text on screen
    num_image = 0;                    

    % Load mask folder of improved mask, list of bounding boxes of 
    % improved mask selected and list of bounding boxes of ground truth
    % defined by dataset
    [total_images, bounding_boxes_list, sdir_gt, samples, sdir] = load_folders(...
    dataset, method, mat_file);

    disp('Starting image processing...');
    for ii=1:total_images        
        % Load image from improved masks
        [~, name_sample, ~] = fileparts(samples(ii).name);
        directory = sprintf('%s/%s.png', sdir, name_sample);
        image = logical(imread(directory));
        figure, imshow(image)
       
        % Load specific bounding box from improved mask
        sname_sample = strrep(name_sample,'.','');
        bb_name = 'image_';
        bb_name = strcat(bb_name, sname_sample);
        bb = bounding_boxes_list.(bb_name);   
        
        % Load specific bounding box from ground truth
        ldir_gt = strcat(sdir_gt, name_sample);
        ldir_gt = strcat(ldir_gt, '.txt');
        file = fileread(ldir_gt);
        text = regexp(file, ' ', 'split');        
        bb_gt = [str2double(text(2)), str2double(text(1)),...
        str2double(text(4))-str2double(text(2)), ...
        str2double(text(3))-str2double(text(1))];
        
        % Iterate all detections on improved masks
        [total_detections, ~] = size(bb);
        accept_detections = 0;
        discard_detections = 0;
        detections = 0;
        for jj=1:total_detections
            % Check if its a true detection 
            if(bb(jj,1) ~= 0 && bb(jj,2) ~= 0 && bb(jj,3) ~= 0 && ...
            bb(jj,4) ~= 0)
                detections = detections + 1;
                rectangle('Position', bb(jj,:), 'EdgeColor','y', 'LineWidth',2); 
                rectangle('Position', bb_gt, 'EdgeColor','g', 'LineWidth',2);
                
                detection_value = calculate_correct_detection_value(bb, ...
                bb_gt, jj, image);
                if detection_value > 0.5
                   accept_detections = accept_detections + 1;
                else
                   discard_detections = discard_detections + 1;
                end
                
            end                   
        end
        
        % Message to display on matlab
        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d', num_image, total_images);
        disp(message);
        
        % Message to print detections detected correctly
        if detections > 0
            fprintf('Accepted detections: %d/%d (%d%%)\n', accept_detections, ...
            detections, (accept_detections/detections)*100);
            fprintf('Discard detections: %d/%d (%d%%)\n', discard_detections, ...
            detections, (discard_detections/detections)*100);
        else
            disp('Non detections');
        end
        pause();
        close all;
    end
    
end
disp('task4(): done');
end

% Function: load_folders
% Description: Load mask folder of improved mask, list of bounding boxes of 
% improved mask selected and list of bounding boxes of ground truth 
% defined by dataset
% Input: dataset, method, mat_file
% Output: total_images, bounding_boxes_list, sdir_gt, samples, sdir
function [total_images, bounding_boxes_list, sdir_gt, samples, sdir] = ...
load_folders(dataset, method, mat_file)
sdir = 'improved_mask_';
sdir = strcat(sdir, dataset);
samples = dir(sdir); 
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
total_images = uint8(length(samples));

sdir_bb = strcat('matlab_files/', method, '/', mat_file);
sdir_bb = strcat(sdir_bb, dataset);
sdir_bb = strcat(sdir_bb, '.mat'); 
bounding_boxes_list = load(sdir_bb);
bounding_boxes_list = bounding_boxes_list.bounding_boxes_list;

sdir_gt = strcat('../datasets/train_set/', dataset, '_split');
sdir_gt = strcat(sdir_gt,'/gt/gt.'); 
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------- TASK 4 DESCRIPTION -----------------------');
disp('Region-based evaluation');
disp('------------------------------------------------------------------');
fprintf('\n');
end

% Function: choose_dataset
% Description: user menu to choose dataset
% Input: None
% Output: dataset
function [dataset, valid_option] = choose_dataset()
valid_option = 0;
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
end

% Function: choose_method
% Description: user menu to choose method
% Input: None
% Output: method, valid_option
function [method, mat_file, valid_option] = choose_method()
valid_option = 0;
disp('Method 1: connected component labeling [ccl]');
disp('Method 2: sliding window [sl]');
disp('Method 4: integral image [ii]');
prompt = 'Select method to use [ccl/sl/ii] : ';
method = input(prompt,'s');
switch method
    case 'ccl'
        disp('Method connected component labeling selected');
        method = 'connected_component_labeling';
        mat_file = 'ccl_bounding_boxes_';
        valid_option = 1;
    case 'sl'
        disp('Method sliding window selected');
        method = 'sliding_window';
        mat_file = 'sl_bounding_boxes_';
        valid_option = 1;
    case 'ii'
        disp('Method integral image selected');
        method = 'integral_image';
        mat_file = 'ii_bounding_boxes_';
    otherwise
        disp('Unknow split');
end  
end

% Function: test_image
% Description: generate image with numbers sorted
% Input: n, m
% Output: image
function image = test_image(n, m)
image = zeros(n, m);
min = 1;
max = m;
jump = m;
for i=1:n
    image(i,:) = (min:max);
    min = min + jump;
    max = max + jump;
end
end

% Function: calculate_correct_detection_value
% Description: generate image with numbers sorted
% Input: bb, bb_gt, jj, image
% Output: detection_value
function detection_value = calculate_correct_detection_value(bb, bb_gt, jj,...
image)
% ------- Correct detection ------- %
% Load bounding box from image
x1 = floor(bb(jj,2));
x2 = floor(bb(jj,2)+bb(jj,4));
y1 = floor(bb(jj,1));
y2 = floor(bb(jj,1)+bb(jj,3));
% Load bounding box of ground truth 
x1_gt = floor(bb_gt(1,2));
x2_gt = floor(bb_gt(1,2)+bb_gt(1,4));
y1_gt = floor(bb_gt(1,1));
y2_gt = floor(bb_gt(1,1)+bb_gt(1,3));

[n, m] = size(image);
image_test = test_image(n, m);
bb_detected_test = image_test(x1:x2, y1:y2);
bb_gt_test = image_test(x1_gt:x2_gt, y1_gt:y2_gt);
inter_data = intersect(bb_detected_test, bb_gt_test);
[elements_i, ~] = size(inter_data); 
union_data = union(bb_detected_test, bb_gt_test);
[elements_u, ~] = size(union_data); 
detection_value = elements_i / elements_u;
end