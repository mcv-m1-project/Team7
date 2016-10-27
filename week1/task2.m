%% Task 2 - Split the dataset into training and validation
%% Desription: Create train/validation split using provided training images

% It's important to have execute the task 1 to have all data
% This algorithm select a number of samples for each type taking the N 
% first samples. It's possible to add a new criteria for example, randomly 
% sorting the matrix.

function task2()
show_description();
% Select dataset
prompt = 'Do you want mork on train or test dataset? [train/test] : ';
str = input(prompt,'s');
if isempty(str)
    disp('Invalid option');
else
    if strcmp(str, 'train')
        disp('Dataset train selected');
        % Load images_data from task1
        if exist('matlab_files/images_data.mat', 'file') == 2
            images_data = load('matlab_files/images_data.mat');
            images_data = images_data.images_data;
            % Create new directories
            if ~exist('../datasets/train_set', 'dir')
                % Train split directories
                mkdir('../datasets/train_set/train_split');
                mkdir('../datasets/train_set/train_split/gt');
                mkdir('../datasets/train_set/train_split/mask');
                % Validations split directories
                mkdir('../datasets/train_set/validation_split');
                mkdir('../datasets/train_set/validation_split/gt');
                mkdir('../datasets/train_set/validation_split/mask');
            end
            %% Split types
            array_types = {'A','B','C','D','E','F'};
            num_types_singals = length(fieldnames(images_data));
            fprintf('Creating train and validation split...');
            for tp=1:num_types_singals  
                % Get type of signal
                type_signal = char(array_types(tp));
                [m, ~] = size(images_data().(type_signal));
                train_partition = 0.7;
                num_training = round(m * train_partition);       
                for pp=1:m
                    % Make file name
                    name_file = num2str(images_data().(type_signal)(pp,1));
                    name_file = make_file_name(name_file);
                    % Put image on train or validation split, depending on value of
                    % num_training calculated before
                    if pp <= num_training     
                        image_directory = '../datasets/train_set/train_split';
                        gt_directory = '../datasets/train_set/train_split/gt';
                        mask_direcotry = '../datasets/train_set/train_split/mask';
                    else
                        image_directory = '../datasets/train_set/validation_split';
                        gt_directory = '../datasets/train_set/validation_split/gt';
                        mask_direcotry = '../datasets/train_set/validation_split/mask';
                    end
                    % Copy image
                    copyfile(['../train/' name_file '.jpg'], image_directory);
                    % Copy gt file
                    copyfile(['../train/gt/gt.' name_file '.txt'], gt_directory);
                    % Copy mask
                    copyfile(['../train/mask/mask.' name_file '.png'], mask_direcotry);
                end
            end
            fprintf('done\n');
            disp('Directory datasets/train_set and datasets/validation_set created');
        else
        disp('Error to load images_data.mat variable.');
        disp('Rerun task1() and select train dataset to create images_data.mat');
        end
        
    else
        if strcmp(str, 'test')
            disp('Dataset test selected');
            % Create new directory
            if ~exist('../datasets/test_set', 'dir')
                % Train split directories
                mkdir('../datasets/test_set');
            end    
            % Load image directory
            image_directory = '../datasets/test_set';
            samples = dir('../test');  
            samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
            for ii=1:length(samples)
                % Get name file
                [~, name_sample, ~] = fileparts(samples(ii).name);
                % Copy image into dataset
                copyfile(['../test/' name_sample '.jpg'], image_directory);
            end  
            disp('Directory datasets/test_set created');
        else
            disp('Unknow option [?]');
            disp('Rerun task2() and choose a valid option [train/test]')
        end
    end
end
disp('task2(): done');
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description()
disp('----------------------- TASK 2 DESCRIPTION -----------------------');
disp('Create train/validation split using provided training images');
disp('Options to select: TRAIN and TEST');
disp('- TRAIN: split the dataset into training and validation');
disp('  Dataset are splitted on folder datasets/train_set' );
disp('- TEST: copy images from test folder on datsasets');
disp('  Dataset are splitted on folder datasets/test_set' );
disp('------------------------------------------------------------------');
fprintf('\n');
end