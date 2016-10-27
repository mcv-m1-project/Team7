% Task 4: Evaluate the segmentation using ground truth

function task4()
show_description();
sdir = char('');
prompt = 'Do you want evaluate train or validation split? [train/validation] : ';
str = input(prompt,'s');
if isempty(str)
    disp('Invalid option')
else
    if strcmp(str, 'train')
        disp('Split train selected');
        sdir = '../datasets/train_set/train_split';
        samples = dir('../datasets/train_set/train_split'); 
    else
        if strcmp(str, 'validation')
            disp('Split validation selected');
            sdir = '../datasets/train_set/validation_split';
            samples = dir('../datasets/train_set/validation_split');         
        end  
        disp('Unknow option [?]');
        disp('Rerun task4 and choose a valid option [train/validation]')
    end
end

% List directory   
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
total_images = uint8(length(samples));

% Get time per frame from matlab file
time_per_frame_1 = load('matlab_files/time_per_frame_1.mat');
time_per_frame_1 = time_per_frame_1.time_per_frame_1;
time_per_frame_2 = load('matlab_files/time_per_frame_2.mat');
time_per_frame_2 = time_per_frame_2.time_per_frame_2;
time_per_frame_3 = load('matlab_files/time_per_frame_3.mat');
time_per_frame_3 = time_per_frame_3.time_per_frame_3;

% Define metrics struct to save partial results
metrics = struct('Precision', zeros(0,0),'Accuracy', zeros(0,0), ...
'Recall', zeros(0,0), 'TP', zeros(0,0), 'FP', zeros(0,0), 'FN', zeros(0,0), ...
'Time_per_frame', zeros(0,0));
results = struct('method1', metrics, 'method2', metrics, 'method3', metrics);

% Define metrics struct to save final results
median_metrics = struct('Precision', 0,'Accuracy', 0, 'Recall', 0, 'TP', 0, ...
'FP', 0, 'FN', 0, 'Time_per_frame', 0);
final_results = struct('method1', median_metrics, 'method2', median_metrics, ...
'method3', median_metrics);

% Get image from struct
for ii=1:total_images 
% Load image from segmentation method 1
message = sprintf('Loading image: %d/%d segmented 1', ii, total_images);
disp(message);
image_1 = matfile('matlab_files/images_segmented_1.mat');
image_1 = image_1.images_segmented_1(ii, :, :);   
image_1 = logical(squeeze(image_1(1,:,:)));

% Load image from segmentation method 2
message = sprintf('Loading image: %d/%d segmented 2', ii, total_images);
disp(message);
image_2 = matfile('matlab_files/images_segmented_2.mat') ;
image_2 = image_2.images_segmented_2(ii, :, :); 
image_2 = logical(squeeze(image_2(1,:,:)));

% Load image from segmentation method 3
message = sprintf('Loading image: %d/%d segmented 3', ii, total_images);
disp(message);
image_3 = matfile('matlab_files/images_segmented_3.mat') ;
image_3 = image_3.images_segmented_3(ii, :, :);   
image_3 = logical(squeeze(image_3(1,:,:)));

% Load mask of groundtruth
[~, name_sample, ~] = fileparts(samples(ii).name);
dir_mask = sprintf('%s/mask/mask.%s.png', sdir, name_sample);
mask = logical(imread(dir_mask));

% Get parameters of image using mask
[TP1, TN1, FP1, FN1, ACC1] = get_parameters(image_1, mask);
[TP2, TN2, FP2, FN2, ACC2] = get_parameters(image_2, mask);
[TP3, TN3, FP3, FN3, ACC3] = get_parameters(image_3, mask);

% Get metrics of image using mask
[R1, P1, AO1, FD1, F11] = get_metrics(TP1, TN1, FP1, FN1);
[R2, P2, AO2, FD2, F12] = get_metrics(TP2, TN2, FP2, FN2);
[R3, P3, AO3, FD3, F13] = get_metrics(TP3, TN3, FP3, FN3);

% % Save results on metric struct
results.method1 = save_metrics(results.method1, ii, P1, ACC1, R1, F11, TP1, ...
FP1, FN1, time_per_frame_1(ii));
results.method2 = save_metrics(results.method2, ii, P2, ACC2, R2, F12, TP2, ...
FP2, FN2, time_per_frame_2(ii));
results.method3 = save_metrics(results.method3, ii, P3, ACC3, R3, F13, TP3, ...
FP3, FN3, time_per_frame_3(ii));

% Load original image and plot with segmented images
% [~, name_sample, ~] = fileparts(samples(ii).name);
% dir_image = sprintf('datasets/train_set/validation_split/%s.jpg',...
% name_sample);
% original_image = imread(dir_image);
% plot_images(original_image, image_1, mask, 'METHOD 1');
% plot_images(original_image, image_2, mask, 'METHOD 2');
% plot_images(original_image, image_3, mask, 'METHOD 3');

end

final_results.method1 = get_results(results.method1, final_results.method1);
final_results.method2 = get_results(results.method2, final_results.method2);
final_results.method3 = get_results(results.method3, final_results.method3);

% Save struct of time per frame rate
results_method1 = final_results.method1;
results_method2 = final_results.method2;
results_method3 = final_results.method3;
save matlab_files/results_method1.mat results_method1
disp('Save results_method1.mat: done');
save matlab_files/results_method2.mat results_method2
disp('Save results_method2.mat: done');
save matlab_files/results_method3.mat results_method3
disp('Save results_method3.mat: done');
save('task4(): done');
end

% Function: plot_images
% Decription: plot images and masks with images of true positives, true
% negatives, false positives and false negatives
% Input: original_image, image, mask, method
% Output: None
function plot_images(original_image, image, mask, method)
figure();
set(gcf,'name','Segmentations','numbertitle','off','Position', ...
[150, 150, 1300, 600]);
subplot(2,3,1), imshow(original_image), title('Original image');
subplot(2,3,2), imshow(image), title(method);
subplot(2,3,3), imshow(image & mask), title('TRUE POSITIVES');
subplot(2,3,4), imshow((((~ image) & (~ mask)))),...
title('TRUE NEGATIVES');
subplot(2,3,5), imshow((~ image) & mask), title('FALSE POSITIVES');
subplot(2,3,6), imshow(image & (~ mask)), title('FALSE NEGATIVES');
pause();
close all;
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
[m, n] = size(image);
ACC = (TP+TN)/(m*n);
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
R = TP/(TP+FN);
% Calculate accepted outliers AO = FP / F = FP / (FP + TN)
AO = FP/(FP+TN);
% Calculate % false detections = FD = FP / P = 1 - precision
FD = 1 - (double(P)/100);
% Calcualte F1 measure  = 2 * ( (P * R) / (P + R) )
if P > 0 & R > 0
F1 = 2*((P*R)/(P+R));
else
F1 = 0;
end
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description()
disp('----------------------- TASK 4 DESCRIPTION -----------------------');
disp('Evaluate the segmentation using ground truth');
disp('Options to select: TRAIN and VALIDATION');
disp('- TRAIN SPLIT: evaluate train_split');
disp('- VALIDATION SPLIT: evaluate validation_split');
disp('Output files: results_method1, results_method2 and results_method3');
disp('------------------------------------------------------------------');
fprintf('\n');
end
