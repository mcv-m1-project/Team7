% Task 4 Compute the histograms
% Histogram for A, B and C  -> Group 1: g1
% Histogram for D and F     -> Group 2: g2
% Histogram for E           -> Group 3: g3

function task4()

% Initialize environment variables
clear all; close all; clc;
load('matlab_files/images_data.mat');
% Path to the train split
path = '../week1/train'; 
nbinsr = 4; nbinsg = 4; nbinsb = 4;

prompt = 'Wich method would you like run? [1/2/3] : ';
method = input(prompt,'s');
if isempty(method)
        disp('Invalid option');
else
    switch method
        case '1'
            disp('Method 1 selected');
        case '2'
            disp('Method 2 selected');
        case '3'
            disp('Method 3 selected');
        otherwise
            disp('Unknow method');
    end

end

% Histograms
hist_g1 = zeros(nbinsr, nbinsg, nbinsb);
hist_g2 = zeros(nbinsr, nbinsg, nbinsb);
hist_g3 = zeros(nbinsr, nbinsg, nbinsb);
% Accumulate number of pixels
pixels_g1 = 0;
pixels_g2 = 0;
pixels_g3 = 0;
% Types of singla groups
types_abc = ['A', 'B', 'C'];
types_df = ['D', 'F'];

%% Compute A, B and C
disp('Compute A, B, C...');
total_images = length(images_data.(types_abc(1))) + ...
               length(images_data.(types_abc(2))) + ...
               length(images_data.(types_abc(3)));
num_image = 1;
for i=1:length(types_abc)
   for ll=1:length(images_data.(types_abc(i)))
        image_name=num2str(images_data.(types_abc(i))(ll,1)); %Uncomplete name
        full_name=make_file_name(image_name);
            if exist([path '/' full_name '.jpg'], 'file') == 2
                img=imread([path '/' full_name '.jpg']);
                mask=imread([path '/mask/mask.' full_name '.png']);
                sing_hist=single_histogram(img,mask,nbinsr,nbinsg,nbinsb,method);
                npixels = sum(sum(sum(sing_hist)));
                pixels_g1 = pixels_g1+npixels;
                hist_g1=hist_g1+sing_hist;
                fprintf('Image: %s.jpg FOUND, ', full_name);
                message = sprintf('processing: %d/%d', num_image, total_images);
            else
                fprintf('Image: %s.jpg NOT FOUND ', full_name);
                message = sprintf('cant process: %d/%d', num_image, total_images);
            end
            disp(message);
            num_image = num_image + 1;
   end    
end

%% Compute D and F
disp('Compute D, F...');
total_images = length(images_data.(types_df(1))) + ...
               length(images_data.(types_df(2)));
num_image = 1;
for i=1:length(types_df)
   for ll=1:length(images_data.(types_df(i)))
        image_name=num2str(images_data.(types_df(i))(ll,1)); %Uncomplete name
        full_name=make_file_name(image_name);
            if exist([path '/' full_name '.jpg'], 'file') == 2
                img=imread([path '/' full_name '.jpg']);
                mask=imread([path '/mask/mask.' full_name '.png']);
                sing_hist=single_histogram(img,mask,nbinsr,nbinsg,nbinsb,method);
                npixels=sum(sum(sum(sing_hist)));
                pixels_g2=pixels_g2+npixels;
                hist_g2=hist_g2+sing_hist;
                fprintf('Image: %s.jpg FOUND, ', full_name);
                message = sprintf('processing: %d/%d', num_image, total_images);
            else
                fprintf('Image: %s.jpg NOT FOUND ', full_name);
                message = sprintf('cant process: %d/%d', num_image, total_images);
            end
            disp(message);
            num_image = num_image + 1;
   end    
end

%% Compute E
disp('Compute E...');
total_images = length(images_data.E);
num_image = 1;
for ll=1:length(images_data.E)
    image_name=num2str(images_data.E(ll,1)); %Uncomplete name
    full_name=make_file_name(image_name);
    if exist([path '/' full_name '.jpg'], 'file') == 2
        img=imread([path '/' full_name '.jpg']);
        mask=imread([path '/mask/mask.' full_name '.png']);
        sing_hist=single_histogram(img,mask,nbinsr,nbinsg,nbinsb,method);
        npixels=sum(sum(sum(sing_hist)));
        pixels_g3=pixels_g3+npixels;
        hist_g3=hist_g3+sing_hist;
        fprintf('Image: %s.jpg FOUND, ', full_name);
        message = sprintf('processing: %d/%d', num_image, total_images);
    else
        fprintf('Image: %s.jpg NOT FOUND ', full_name);
        message = sprintf('cant process: %d/%d', num_image, total_images);
    end
    disp(message);
    num_image = num_image + 1;
end

%% Normalize the histograms and compute image probability
hist_g1 = hist_g1/pixels_g1;
hist_g2 = hist_g2/pixels_g2;
hist_g3 = hist_g3/pixels_g3;

%% Load mask results images 
sdir = '../week1/test';
samples = dir(sdir); 
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
total_images = uint8(length(samples));

disp('Starting image processing...');
num_image = 0;
for ii=1:total_images  
    [~, name_sample, ~] = fileparts(samples(ii).name);
    directory = sprintf('%s/%s.jpg', sdir, name_sample);
    image = imread(directory);
    % Compute masks
    mask_g3 = compute_probability(image,hist_g3,nbinsr,nbinsg,nbinsb,method);
    mask_g1 = compute_probability(image,hist_g1,nbinsr,nbinsg,nbinsb,method);
    mask_g1 = mask_g1/(max(max(mask_g1)));
    mask_g2 = compute_probability(image,hist_g2,nbinsr,nbinsg,nbinsb,method);
    mask_g2 = mask_g2/(max(max(mask_g2)));
    %for g3
    s=size(mask_g3);
    maxr=max(max(max(hist_g3)));
    for ii=1:s(1)
        for jj=1:s(2)
            if mask_g3(ii,jj)>0.1 && mask_g3(ii,jj)<0.3
                mask_g3(ii,jj)=1;
            else
                mask_g3(ii,jj)=0;
            end
        end
    end
    % for g1
    s=size(mask_g1);
    maxr=max(max(max(hist_g1)));
    for ii=1:s(1)
        for jj=1:s(2)
            if mask_g1(ii,jj)>0.7 %&& mask_g1(ii,jj)<0.3
                mask_g1(ii,jj)=1;
            else
                mask_g1(ii,jj)=0;
            end
        end
    end
    % for g2
    s=size(mask_g2);
    maxr=max(max(max(hist_g3)));
    for ii=1:s(1)
        for jj=1:s(2)
            if mask_g2(ii,jj)>0.2 && mask_g2(ii,jj)<0.3
                mask_g2(ii,jj)=1;
            else
                mask_g2(ii,jj)=0;
            end
        end
    end
    %Total mask
    mask=min(1,(mask_g1+mask_g2+mask_g3));
    mask = imfill(mask,'holes');
    %mask_dir = sprintf('mask_results_task4_m%s/%s.png', method, name_sample);
    mask_dir = sprintf('mask_results_task4_test_m3/%s.png', name_sample);
    imwrite(mask, mask_dir,'png');
    
    % Message to display on matlab
    num_image = num_image + 1;
    message = sprintf('Images processed: %d/%d', num_image, total_images);
    disp(message);
end

%% Evaluate masks_results

% Get time per frame from matlab file
% time_per_frame_1 = load('matlab_files/time_per_frame_1.mat');
% time_per_frame_1 = time_per_frame_1.time_per_frame_1;
% time_per_frame_2 = load('matlab_files/time_per_frame_2.mat');
% time_per_frame_2 = time_per_frame_2.time_per_frame_2;
% time_per_frame_3 = load('matlab_files/time_per_frame_3.mat');
% time_per_frame_3 = time_per_frame_3.time_per_frame_3;

% % Define metrics struct to save partial results
% metrics = struct('Precision', zeros(0,0),'Accuracy', zeros(0,0), ...
% 'Recall', zeros(0,0), 'TP', zeros(0,0), 'FP', zeros(0,0), 'FN', zeros(0,0), ...
% 'Time_per_frame', zeros(0,0));
% results = struct('method', metrics);
% 
% % Define metrics struct to save final results
% median_metrics = struct('Precision', 0,'Accuracy', 0, 'Recall', 0, 'TP', 0, ...
% 'FP', 0, 'FN', 0, 'Time_per_frame', 0);
% final_results = struct('method', median_metrics);
% 
% % List directory   
% sdir_m = sprintf('mask_results_task4_m%d', method);
% sdir = '../week1/datasets/train_set/validation_split';
% samples = dir(sdir_m);
% samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
% total_images = uint8(length(samples));
% 
% % Get image from struct
% for ii=1:total_images 
% 
% % Load our mask
% [~, name_sample, ~] = fileparts(samples(ii).name);
% image = sprintf('%s/%s.png', sdir_m, name_sample);
% image = imread(image);
% 
% % Load mask of groundtruth
% [~, name_sample, ~] = fileparts(samples(ii).name);
% dir_mask = sprintf('%s/mask/mask.%s.png', sdir, name_sample);
% mask = logical(imread(dir_mask));
% 
% % Get parameters of image using mask
% [TP1, TN1, FP1, FN1, ACC1] = get_parameters(image, mask);
% 
% % Get metrics of image using mask
% [R1, P1, AO1, FD1, F11] = get_metrics(TP1, TN1, FP1, FN1);
% 
% % % Save results on metric struct
% results.method = save_metrics(results.method, ii, P1, ACC1, R1, F11, TP1, ...
% FP1, FN1, 0);
% 
% end
% 
% final_results.method = get_results(results.method, final_results.method);
% 
% % Save struct of time per frame rate
% results_method = final_results.method;
% save matlab_files/results_method results_method
% disp('Save results_method.mat: done');
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
%metrics.Time_per_frame(ii) = Time;
metrics.Time_per_frame(ii) = 0;
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