%% Task 4 -- Region-based evaluation

function task4()
% Show description on screen about task1
show_description_on_screen();
% User menu to choose dataset 
[dataset, valid_option] = choose_dataset();

if valid_option == 1

    % Number of image to display text on screen
    num_image = 0;                    

    % Load mask folder of IMPROVED MASK
    sdir = 'improved_mask_';
    sdir = strcat(sdir, dataset);
    samples = dir(sdir); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));

    % Load bounding boxes of IMPROVED MASK
    sdir_bb = 'matlab_files/bounding_boxes_';
    sdir_bb = strcat(sdir_bb, dataset);
    sdir_bb = strcat(sdir_bb, '.mat'); 
    bounding_boxes_list = load(sdir_bb);
    bounding_boxes_list = bounding_boxes_list.bounding_boxes_list;
    
    % Load bounding boxes of GROUND TRUTH
    sdir_gt = '../datasets/train_set/';
    sdir_gt = strcat(sdir_gt, dataset);
    sdir_gt = strcat(sdir_gt, '_split/gt/gt.'); 

    disp('Starting image processing...');
    for ii=1:total_images        
        % Load image from improved masks
        [~, name_sample, ~] = fileparts(samples(ii).name);
        directory = sprintf('%s/%s.png', sdir, name_sample);
        image = logical(imread(directory));
        figure, imshow(image)
       
        % LOAD bounding box from improved mask
        sname_sample = strrep(name_sample,'.','');
        bb_name = 'image_';
        bb_name = strcat(bb_name, sname_sample);
        bb = bounding_boxes_list.(bb_name);   
        
        [total_detections, ~] = size(bb);
        
        for jj=1:total_detections
            % PRINT bounding box from improved mask
            if(bb(jj,1) ~= 0 && bb(jj,2) ~= 0 && bb(jj,3) ~= 0 && ...
            bb(jj,4) ~= 0)
                rectangle('Position', bb(jj,:), 'EdgeColor','y', 'LineWidth',2); 

            end
            
            % LOAD bounding box from ground truth
            ldir_gt = strcat(sdir_gt, name_sample);
            ldir_gt = strcat(ldir_gt, '.txt');
            file = fileread(ldir_gt);
            text = regexp(file, ' ', 'split');

            bb_gt = [str2double(text(2)), str2double(text(1)),...
                    str2double(text(4))-str2double(text(2)), ...
                    str2double(text(3))-str2double(text(1))];
            % PRINT bounding box from improved mask
            rectangle('Position', bb_gt, 'EdgeColor','g', 'LineWidth',2); 
            
        end

        pause();
        close all;
        
        % Message to display on matlab
        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d', num_image, total_images);
        disp(message);
    end
    
end
disp('task4(): done');
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