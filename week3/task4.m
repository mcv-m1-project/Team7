%% Task 4 -- Region-based evaluation

function task4()
% Show description on screen about task1
show_description_on_screen();
% User menu to choose dataset 
[dataset, valid_option_dataset, dir_gt] = choose_dataset();
% User menu to choose method 
[method, mat_file, valid_option_method] = choose_method();

% Define metrics struct to save partial results of evaluation
metrics = struct('Precision', zeros(0,0),'Accuracy', zeros(0,0), ...
'Recall', zeros(0,0), 'F1', zeros(0,0), 'TP', zeros(0,0), 'FP', zeros(0,0), ...
'FN', zeros(0,0), 'Time_per_frame', zeros(0,0));
results = struct('connected_component_labeling', metrics, ...
'sliding_window', metrics, 'integral_image', metrics);
% Define metrics struct to save final results
median_metrics = struct('Precision', 0,'Accuracy', 0, 'Recall', 0, 'F1', 0,...
'TP', 0, 'FP', 0, 'FN', 0, 'Time_per_frame', 0);
final_results = struct('connected_component_labeling', median_metrics, ...
'sliding_window', median_metrics, 'integral_image', median_metrics);

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
        % Image to show only detections of signals
        [image_n, image_m] = size(image);
        image_detections = zeros(image_n, image_m);
        %figure, imshow(image)
       
        % Load specific bounding box from improved mask
        sname_sample = strrep(name_sample,'.','');
        bb_name = 'image_';
        bb_name = strcat(bb_name, sname_sample);
        bb = bounding_boxes_list.(bb_name);   
        
        % Load specific bounding box from ground truth
        if strcmp(dataset, 'test') == 0
            ldir_gt = strcat(sdir_gt, name_sample);
            ldir_gt = strcat(ldir_gt, '.txt');
            file = fileread(ldir_gt);
            text = regexp(file, ' ', 'split');        
            bb_gt = [str2double(text(2)), str2double(text(1)),...
            str2double(text(4))-str2double(text(2)), ...
            str2double(text(3))-str2double(text(1))];
        end 
       
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
                %rectangle('Position', bb(jj,:), 'EdgeColor','y', 'LineWidth',2); 
                %rectangle('Position', bb_gt, 'EdgeColor','g', 'LineWidth',2);
                
                if strcmp(dataset, 'test') == 0
                    detection_value = calculate_correct_detection_value(bb, ...
                    bb_gt, jj, image);
                    if detection_value > 0.5
                       accept_detections = accept_detections + 1;
                    else
                       discard_detections = discard_detections + 1;
                    end
                end
                
                % Accumulate signals detected on image_detections
                x1 = max(floor(bb(jj,2)), 1);
                x2 = max(floor(bb(jj,2)+bb(jj,4)), 1);
                y1 = max(floor(bb(jj,1)), 1);
                y2 = max(floor(bb(jj,1)+bb(jj,3)), 1);
                image_detections(x1:x2, y1:y2) = image(x1:x2, y1:y2);
                
                if strcmp(dataset, 'test') == 1
                    simage = sprintf('mask_results_test/%s/%s.png', method, name_sample);
                    imwrite(image_detections, simage,'png');
                end
            end                   
        end
        
        if ((strcmp(dataset, 'test') == 1) && (detections == 0))
        	simage = sprintf('mask_results_test/%s/%s.png', method, name_sample);
            imwrite(image_detections, simage,'png');
        end
        
        % Message to display on matlab
        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d', num_image, total_images);
        disp(message);
        
        if strcmp(dataset, 'test') == 0
            % Message to print detections detected correctly
            if detections > 0
                fprintf('Accepted detections: %d/%d (%d%%)\n', accept_detections, ...
                detections, floor((accept_detections/detections)*100));
                fprintf('Discard detections: %d/%d (%d%%)\n', discard_detections, ...
                detections, floor((discard_detections/detections)*100));
            else
                disp('Non detections');
            end
            % pause();
            % close all;        

            % Calculate metrics of image_dections and image
            [TP, TN, FP, FN, ACC] = get_parameters(image_detections, mask_gt);
            [R, P, AO, FD, F1] = get_metrics(TP, TN, FP, FN);
            results.(method) = save_metrics(results.(method), ii, P, ACC, R, F1, TP, ...
            FP, FN, 0); 
        end
    end
    
    if strcmp(dataset, 'test') == 0
        final_results.(method) = get_results(results.(method),final_results.(method));
        results = final_results.(method);
        sdir = sprintf('matlab_files/evaluation/results_%s_%s.mat', method, dataset);
        save(sdir, 'results');
        fprintf('Save %s: done', sdir);
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
function [dataset, valid_option,dir_gt] = choose_dataset()
valid_option = 0;
disp('If you choose test, will create mask_results on directory: mask_results_test');
prompt = 'Do you want mork on train, validation or test? [train/validation/test] : ';
dataset = input(prompt,'s');
switch dataset
    case 'train'
        disp('Dataset train split selected');
        valid_option = 1;
        dir_gt = '../datasets/train_set/train_split/mask';
    case 'validation'
        disp('Dataset validation split selected');
        valid_option = 1;
        dir_gt = '../datasets/train_set/validation_split/mask';
    case 'test'
        disp('Dataset test selected');
        valid_option = 1;
        dir_gt = '../datasets/test_set/';
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
        valid_option = 1;
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
x1 = max(floor(bb(jj,2)), 1);
x2 = max(floor(bb(jj,2)+bb(jj,4)), 1);
y1 = max(floor(bb(jj,1)), 1);
y2 = max(floor(bb(jj,1)+bb(jj,3)), 1);
% Load bounding box of ground truth 
x1_gt = max(floor(bb_gt(1,2)), 1);
x2_gt = max(floor(bb_gt(1,2)+bb_gt(1,4)), 1);
y1_gt = max(floor(bb_gt(1,1)), 1);
y2_gt = max(floor(bb_gt(1,1)+bb_gt(1,3)), 1);

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

% Function: get_parameters
% Decription: calculate true positives, true negatives, false positives,
% false negatives and accuracy from image and mask.
% Input: image, mask
% Output: TP, TN, FP, FN, ACC
function [TP, TN, FP, FN, ACC] = get_parameters(image, mask)
% Calculate True Positives (TP): correctly detected
TP = sum(sum(image & mask));
% Galculate True Negatives (TN): non-detected false samples
TN = sum(sum((((~ image) & (~ mask)))));
% Calculate False Positives (FP): non-detected true samples
FP = sum(sum((~ image) & mask));
% Calculate False Negatives (FN): false detected samples
FN = sum(sum(image & (~ mask)));
% Calculate Accuracy (ACC) : (TP + TN) / total pixels
ACC = (TP+TN)/(TP+TN+FP+FN);
end

% Function: get_metrics
% Decription: calculate precision, recall, accepted outliers and % of false
% detections from true positives, true negatives, false positives and false
% negatives values
% Input: TP, TN, FP, FN
% Output: R, P, AO, FD, F1
function [R, P, AO, FD, F1] = get_metrics(TP, TN, FP, FN)
% Calculate precision: P = TP / P = TP / (TP + FP)
P = TP/(TP+FP);
% Calculate recall: R = TP / T
if TP == 0 && FN == 0
    R = 0;
else
    R = TP/(TP+FN);
end
% Calculate accepted outliers AO = FP / F = FP / (FP + TN)
AO = FP/(FP+TN);
% Calculate % false detections = FD = FP / P = 1 - precision
FD = 1 - (double(P)/100);
% Calcualte F1 measure  = 2 * ( (P * R) / (P + R) )
if P > 0 && R > 0
F1 = 2*((P*R)/(P+R));
else
F1 = 0;
end
end

% Function: get_results
% Decription: get metrics from matlab struct
% Input: results, final_results
% Output: final_results
function final_results = get_results(results, final_results)
final_results.Precision = median(results.Precision);
final_results.Accuracy = median(results.Accuracy);
final_results.Recall = median(results.Recall);
final_results.F1 = median(results.F1);
final_results.TP = median(results.TP);
final_results.FP = median(results.FP);
final_results.FN = median(results.FN);
final_results.Time_per_frame = median(results.Time_per_frame);
end

% Function: save_metrics
% Decription: save metrics on matlab strcut
% Input: metrics, ii, P, ACC, R, F1, TP, FP, FN, Time
% Output: metrics
function metrics = save_metrics(metrics, ii, P, ACC, R, F1, TP, FP, FN, Time)
metrics.Precision(ii) = P;
metrics.Accuracy(ii) = ACC;
metrics.Recall(ii) = R;
metrics.F1(ii) = F1;
metrics.TP(ii) = TP;
metrics.FP(ii) = FP;
metrics.FN(ii) = FN;
metrics.Time_per_frame(ii) = Time;
end