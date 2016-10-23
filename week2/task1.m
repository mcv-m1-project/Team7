%% Task 1 -- Implement morphological operators Erosion/Dilation. Compose new operators from Dilation/Erosion:
%% Opening, Closing, TopHat and TopHat dual

function task1()
% Go to morphological operators folder
cd morphological_operators

% Show description on screen about task1
show_description_on_screen();

% Load example image to process. Images are logical (binaries)
image = im2bw(imread('../images/image3.jpg'));

% Structuring element: 5 by 5 square
% Getnhood: Get structuring element neighborhood. By this way, we can see
% value of variable on matlab workspace
se = getnhood(strel('square', 5));

%%------------------------------ EROSION -----------------------------%%

% Operations
image_er = imerode(image, se);
image_custom_er = myerode(image, se);
% show_images(image, image_er, image_custom_er, 'EROSION operation', 'ORIGINAL image', 'MATLAB image', ...
% 'CUSTOM image');

% Check that custom erosion operation was succesfull
disp('Check EROSION operation. Comparing matlab and custom operation ...');
check_images(image_er, image_custom_er);

%%----------------------------- DILATION -----------------------------%%

% Operations
image_di = imdilate(image, se);
image_custom_di = mydilate(image, se);
% show_images(image, image_di, image_custom_di, 'DILATION operation', 'ORIGINAL image', 'MATLAB image', ...
% 'CUSTOM image');

% Check that custom dilation operation was succesfull
disp('Check DILATION operation.Comparing matlab and custom operation ...');
check_images(image_di, image_custom_di);

%%------------------------------ OPENING -----------------------------%%

% Operations
image_op = imopen(image, se);
image_custom_op = myopen(image, se);
% show_images(image, image_op, image_custom_op, 'OPENING operation', 'ORIGINAL image', 'MATLAB image', ...
% 'CUSTOM image');

% Check that custom opening operation was succesfull
disp('Check OPENING operation. Comparing matlab and custom operation ...');
check_images(image_op, image_custom_op);


%%------------------------------ CLOSING -----------------------------%%

% Operations
image_cl = imclose(image, se);
image_custom_cl = myclose(image, se);
% show_images(image, image_cl, image_custom_cl, 'CLOSING operation', 'ORIGINAL image', 'MATLAB image', ...
% 'CUSTOM image');

% Check that custom closing operation was succesfull
disp('Check CLOSING operation. Comparing matlab and custom operation ...');
check_images(image_cl, image_custom_cl);

%%------------------------------ TOP HAT -----------------------------%%

% Operations
image_th = imtophat(image, se);
image_custom_th = mytophat(image, se);
% show_images(image, image_th, image_custom_th, 'TOP HAT operation', 'ORIGINAL image', 'MATLAB image', ...
% 'CUSTOM image');

% Check that custom top hat operation was succesfull
disp('Check TOP HAT operation. Comparing matlab and custom operation ...');
check_images(image_th, image_custom_th);

%%---------------------------- DUAL TOP HAT --------------------------%%

% Operations
image_th_dual = imbothat(image, se);
image_custom_th_dual = mybothat(image, se);
% show_images(image, image_th_dual, image_custom_th_dual, 'DUAL TOP HAT operation', 'ORIGINAL image', ...
% 'MATLAB image', 'CUSTOM image');

% Check that custom top hat operation was succesfull
disp('Check DUAL TOP HAT operation. Comparing matlab and custom operation ...');
check_images(image_th_dual, image_custom_th_dual);

cd ..   % Back to main directory
disp('task1(): done')
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------- TASK 1 DESCRIPTION -----------------------');
disp('Implement morphological operators Erosion/Dilation.');
disp('Compose new operators from Dilation/Erosion: Opening, Closing, ');
disp('TopHat and TopHat dual');
disp('------------------------------------------------------------------');
fprintf('\n');
end

% Function: check_images
% Description: compare images in order to know if are equals
% Input: image_1, image_2
% Output: None (show on screen result)
function check_images(image_1, image_2)
fprintf('Operation: ');
if image_1(:, :) == image_2(:, :)
    fprintf('successfull\n');
    fprintf('\n');
else
    difference = sum(sum(image_1)) - sum(sum(image_2));
    fprintf('error: %d pixels incorrect \n', difference);
    fprintf('\n');
end
end

% Function: show_images
% Description: show two images on screen
% Input: image_1, image_2, title_figure, title_1, title_2
% Output: None
function show_images(image_1, image_2, image_3, title_figure, title_1, title_2, title_3)
% Shows original image and dilated image
figure();
set(gcf,'name', title_figure,'numbertitle','off','Position', [300, 300, 1300, 400]);
subplot(1,3,1), imshow(image_1), title(title_1);
subplot(1,3,2), imshow(image_2), title(title_2);
subplot(1,3,3), imshow(image_3), title(title_3);
pause();
close all;
end