%% Task 2 -> Region based detection
%% Task 3 -> Computing the integral image

function task23()
% User menu to choose dataset 
[dataset, valid_option, processing] = choose_dataset;

% Read pixel candidates, mask generated in the other weeks
mask_dir = 'improved_mask_';
mask_dir = strcat(mask_dir, dataset);
mask_dir = strcat(mask_dir, '/');
files = dir(mask_dir);
files = files(arrayfun(@(x) x.name(1)=='0',files));
num_image = 0;
total_images = length(files);
bounding_boxes_list = struct();

disp('Starting image processing...');
for ii=1:total_images
    % Message to display on screen
    num_image = num_image + 1;
    message = sprintf('Images processed: %d/%d', num_image, total_images);
    disp(message);
    
    mask = imread([mask_dir num2str(files(ii).name)]);
    matrix_detection = window_detection(mask, processing);
        
    if sum(matrix_detection(1,:))~=0
    
        % find the number of clusters to select a single detection per object
        mask_size = size(mask);
        k = 2;
        optimum_k = 0;
        while k<=1000
            [idx,C] = kmeans(matrix_detection,k);
            rectangles = zeros(mask_size);
            for ll=1:size(C,1)
                rectangles(C(ll,1):C(ll,2),C(ll,3):C(ll,4)) = ...
                rectangles(C(ll,1):C(ll,2),C(ll,3):C(ll,4))+1;
            end
            peak=max(max(rectangles));

            if peak==1
                k=k+1;
            else
                optimum_k=k-1;
                k=100000;
            end
        end

        % Select centroids
        [idx, C] = kmeans(matrix_detection,optimum_k);
        
        % Prepare data
        for kk=1:size(C,1)
            bounding_boxes(kk,1) = C(kk,3);
            bounding_boxes(kk,2) = C(kk,1);
            bounding_boxes(kk,3) = C(kk,4)-C(kk,3);
            bounding_boxes(kk,4) = C(kk,2)-C(kk,1);
        end
    else
        bounding_boxes(1,1) = matrix_detection(1,3);
        bounding_boxes(1,2) = matrix_detection(1,1);
        bounding_boxes(1,3) = matrix_detection(1,4)-matrix_detection(1,3);
        bounding_boxes(1,4) = matrix_detection(1,2)-matrix_detection(1,1);
    end
    
     name_sample = strrep(files(ii).name,'.','');
     name_sample = name_sample(1:length(name_sample)-3);
     name_sample = strcat('image_', name_sample);
     bounding_boxes_list.(name_sample) = bounding_boxes;
     
end

save_dir = strcat('matlab_files/sliding_window/sl_bounding_boxes_', dataset);
save(save_dir, 'bounding_boxes_list', '-v7.3');

% %% Plot the bounding box
% figure,imshow(mask*255)
% hold on
% for ii=1:length(matrix_detection)
%     rectangle('Position',[matrix_detection(ii,3), matrix_detection(ii,1), ...
%     matrix_detection(ii,2)-matrix_detection(ii,1), matrix_detection(ii,4) ...
%     -matrix_detection(ii,3)],'Edgecolor','r')
% end
% hold off

%% Clustering of window
% mask_size = size(mask);
% k = 2;
% optimum_k = 0;
% while k<=1000
%     [idx, C] = kmeans(matrix_detection,k);
%     rectangles = zeros(mask_size);
%     for ll=1:size(C,1)
%         rectangles(C(ll,1):C(ll,2),C(ll,3):C(ll,4))=rectangles(C(ll,1):...
%         C(ll,2),C(ll,3):C(ll,4))+1;
%     end
%     peak = max(max(rectangles));
%     
%     if peak == 1
%         k = k+1;
%     else
%         optimum_k = k-1;
%         k = 100000;
%     end
% end

%% Plot the centroids
% [idx,C] = kmeans(matrix_detection,optimum_k);
% figure,imshow(mask*255)
% hold on
% for ii=1:size(C,1)
%     rectangle('Position',[C(ii,3), C(ii,1), C(ii,2)-C(ii,1), ...
%     C(ii,4)-C(ii,3)],'Edgecolor','r')
% end
% hold off

end

% Function: choose_dataset
% Description: user menu to choose dataset
% Input: None
% Output: dataset
function [dataset, valid_option, processing] = choose_dataset()
valid_option = 0;
prompt = 'Do you want mork on train or test dataset? [train/test] : ';
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

prompt = 'Do you want use siliding windows or integral image? [s/i] : ';
processing = input(prompt,'s');
switch dataset
    case 's'
        disp('Method: sliding window selected');
    case 'i'
        disp('Method: integral image selected');
    otherwise    
        disp('Unknow option');
end

end
