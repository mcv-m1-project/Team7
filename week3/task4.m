%% Task 4 -- Region-based evaluation

function task4()

% Show description on screen about task1
show_description_on_screen();

% Number of image to display text on screen
num_image = 0;                    

% Load mask folder
sdir = 'mask_results';
samples = dir(sdir); 
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
total_images = uint8(length(samples));

bounding_boxes_list = load('matlab_files/bounding_boxes_list');
bounding_boxes_list = bounding_boxes_list.bounding_boxes_list;

disp('Starting image processing...');
for ii=1:total_images        
    
    % Message to display on matlab
    num_image = num_image + 1;
    message = sprintf('Images processed: %d/%d', num_image, total_images);
    disp(message);
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