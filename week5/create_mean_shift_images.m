%% Create mean shift images 

function create_mean_shift_images()
% Show description on screen
show_description_on_screen();

% User menu to choose dataset 
[dataset, valid_dataset] = choose_dataset;

% Check if dataset is correct
if valid_dataset
    
    % Load directory of dataset selected
    if strcmp(dataset, 'test')
        sdir =  sprintf('../datasets/test_set/');
    else
        sdir = sprintf('../datasets/train_set/%s_split/', dataset);
    end
   
    % Load improved masks
    samples = dir(sdir); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));
    num_image = 0;
    
    for ii=1:total_images
        % Load file name 
        [~, name_sample, ~] = fileparts(samples(ii).name);
        
        % Message to control iterations on screen
        num_image = num_image + 1;
        message = sprintf('\nImages processing: %d/%d. Image name: %s', num_image, ...
        total_images, name_sample);
        disp(message);
        
        % Load original image
        directory = sprintf('%s/%s.jpg', sdir, name_sample);
        image = imread(directory);         
        
        % Define mean shift bandwidth
        ms_bandwidth = 0.1;                  
        % Compute mean shift (color)
        [image_ms, ~]  = Ms(image, ms_bandwidth);    
        
        % Save mean shift image on dataset directory
        sdir_ms = sprintf('mean_shift_images/%s/%s.jpg', dataset, name_sample); 
        imwrite(image_ms, sdir_ms, 'jpg');
    end
    
end

disp('create_mean_shift_images(): done');
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------------- TASK 2 DESCRIPTION --------------');
disp('Compute mean shift algorithms on dataset selected');
disp('---------------------------------------------------------------');
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