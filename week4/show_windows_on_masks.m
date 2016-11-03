% Function: print_windowCandidates_on_mask
% Description: print window candidates on mask
% Input: None
% Output: None
function show_windows_on_masks()
% User menu to choose dataset 
[dataset, valid_option] = choose_dataset;
% Check if dataset is correct
if valid_option == 1
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
        % Load improved mask
        [~, name_sample, ~] = fileparts(samples(ii).name);
        directory = sprintf('%s/%s.png', sdir_masks, name_sample);
        mask = logical(imread(directory));
        figure, imshow(mask)

        % Load windowCandidate
        directory = sprintf('%s/%s.mat', sdir_windows, name_sample);
        windowCandidates = load(directory);
        windowCandidates = windowCandidates.windowCandidates;

        [n, ~] = size(windowCandidates);
        for jj=1:n
            bounding_box = [windowCandidates(jj).x windowCandidates(jj).y ...
                            windowCandidates(jj).w windowCandidates(jj).h];
            if any(bounding_box)
                rectangle('Position', bounding_box, 'EdgeColor','green', 'LineWidth', 2); 
            end
        end
        pause();
        close all;

        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d. Image name: %s', num_image, total_images, ...
        name_sample);
        disp(message);
    end
end
disp('show_windows_on_masks(): done');
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