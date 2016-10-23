%% Task 3 Use operators to improve results in sign detection

function task3()

% Show description on screen about task3
show_description_on_screen();

% Load mask results images 
sdir = '../week1/mask_results';
samples = dir(sdir); 
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
total_images = uint8(length(samples));

% Flat morphological structuring element. Optimal structuring element
% depends on shapes of noise. See background noise and analyse wich shape
% to structuring element is the best to use. 
% Getnhood: Get structuring element neighborhood. By this way, we can see
% value of variable on matlab workspace
se = getnhood(strel('disk', 3));

disp('Starting image processing...');
num_image = 0;
for ii=1:total_images    
   [~, name_sample, ~] = fileparts(samples(ii).name);
   directory = sprintf('%s/%s.png', sdir, name_sample);
   image = imread(directory);
   image = imerode(image, se);

   mask_dir = sprintf('mask_results_task3/%s.png', name_sample);
   imwrite(image, mask_dir,'png');
   
   % Message to display on matlab
   num_image = num_image + 1;
   message = sprintf('Images processed: %d/%d', num_image, total_images);
   disp(message);
end

disp('Images saved on mask_results_task3 folder: done');
disp('task3(): done');
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------- TASK 3 DESCRIPTION -----------------------');
disp('Use operators to improve results in sign detection');
disp('------------------------------------------------------------------');
fprintf('\n');
end