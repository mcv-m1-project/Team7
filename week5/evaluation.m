%% Evaluation

function evaluation()

% Show description on screen about evaluation
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_option_dataset] = choose_dataset();

% User menu to choose method 
[method, valid_option_method] = choose_method();

% Define metrics struct to save partial results of evaluation
metrics = struct('Precision', zeros(0,0),'Accuracy', zeros(0,0), ...
'Recall', zeros(0,0), 'F1', zeros(0,0), 'TP', zeros(0,0), 'FP', zeros(0,0), ...
'FN', zeros(0,0), 'Time_per_frame', zeros(0,0));
results = struct('task1', metrics, 'task2', metrics);

% Define metrics struct to save final results
median_metrics = struct('Precision', 0,'Accuracy', 0, 'Recall', 0, 'F1', 0,...
'TP', 0, 'FP', 0, 'FN', 0, 'Time_per_frame', 0);
final_results = struct('task1', median_metrics, 'task2', median_metrics);


if (valid_option_dataset == 1 && valid_option_method == 1) 

    % Number of image to display text on screen
    num_image = 0;                    

    % Load partial old improved mask directory
    sdir = strcat('improved_masks/', dataset);
    samples = dir(sdir); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));
    
    disp('Starting image processing...');
    for ii=1:total_images     
        
        % Load old improved masks
        [~, name_sample, ~] = fileparts(samples(ii).name);
        directory = sprintf('%s/%s.png', sdir, name_sample);
        old_mask = logical(imread(directory));
       
        % Load mask
        sdir_mask = strcat('improved_',method,'/',dataset,'/',name_sample,'.png');
        new_mask = logical(imread(sdir_mask));

        % Calculate metrics of image_dections and image
        [TP, TN, FP, FN, ACC] = get_parameters(new_mask, old_mask);
        [R, P, ~, ~, F1] = get_metrics(TP, TN, FP, FN);
        results.(method) = save_metrics(results.(method), ii, P, ACC, R, F1, TP, ...
        FP, FN, 0); 

        % Message to display on matlab
        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d. Image name: %s', ...
        num_image, total_images, name_sample);
        disp(message);
    end
        
    final_results.(method) = get_results(results.(method),final_results.(method));
    results = final_results.(method);
    sdir = sprintf('evaluations_%s/results_%s.mat', method, dataset);
    save(sdir, 'results');
    fprintf('Save %s: done', sdir);
    
end
disp('evaluation(): done');
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('--------------------------- EVALUATION ---------------------------');
disp('Evaluate train or validation split');
disp('------------------------------------------------------------------');
fprintf('\n');
end

% Function: choose_dataset
% Description: user menu to choose dataset
% Input: None
% Output: dataset
function [dataset, valid_option] = choose_dataset()
valid_option = 0;
prompt = 'Do you want evaluate test or train or validation split? [train/validation/test] : ';
dataset = input(prompt,'s');
switch dataset
    case 'train'
        disp('Dataset train split selected');
        valid_option = 1;
    case 'validation'
        disp('Dataset validation split selected');
        valid_option = 1;
    case 'test'
        disp('Dataset test selected');
        valid_option = 1;
    otherwise
        disp('Unknow split');
end   
end

% Function: choose_method
% Description: user menu to choose method
% Input: None
% Output: method, valid_option
function [method, valid_option] = choose_method()
valid_option = 0;
disp('Method 1: Geometric heuristics on last improved masks         [task1]');
disp('Method 2: Geometric heuristics on mean shift segmentation     [task2]');
prompt = 'Select method to use [task1/task2] : ';
method = input(prompt,'s');
switch method
    case 'task1'
        disp('Geometric heuristics on last improved masks on selected');
        method = 'task1';
        valid_option = 1;
    case 'task2'
        disp('Geometric heuristics on mean shift segmentation');
        method = 'task2';
        valid_option = 1;
    otherwise
        disp('Unknow split');
end  
end

% Function: get_parameters
% Decription: calculate true positives, true negatives, false positives,
% false negatives and accuracy from image and mask.
% Input: image, mask
% Output: TP, TN, FP, FN, ACC
function [TP, TN, FP, FN, ACC] = get_parameters(mask, mask_gt)
% Calculate True Positives (TP): correctly detected
TP = sum(sum(mask>0 & mask_gt>0));
% Galculate True Negatives (TN): non-detected false samples
TN = sum(sum(mask==0 & mask_gt==0));
% Calculate False Positives (FP): non-detected true samples
FP = sum(sum(mask>0 & mask_gt==0));
% Calculate False Negatives (FN): false detected samples
FN = sum(sum(mask==0 & mask_gt>0));
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
if isnan(P)
   P = 0; 
end
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
final_results.Precision = mean(results.Precision);
final_results.Accuracy = mean(results.Accuracy);
final_results.Recall = mean(results.Recall);
final_results.F1 = mean(results.F1);
final_results.TP = mean(results.TP);
final_results.FP = mean(results.FP);
final_results.FN = mean(results.FN);
final_results.Time_per_frame = mean(results.Time_per_frame);
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
