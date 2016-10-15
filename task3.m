%% Task 3 Color segmentation to generate a mask

function task3()
% Data images to load segmented images
images_segmented_1 = zeros(0, 0, 0);
images_segmented_2 = zeros(0, 0, 0);
images_segmented_3 = zeros(0, 0, 0);

time_per_frame_1 = zeros(0);
time_per_frame_2 = zeros(0);
time_per_frame_3 = zeros(0);

% List directory
samples = dir('datasets/train_set/train_split');        
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));

num_image = 0;
total_images = uint8(length(samples));

for ii=1:total_images    
    % Load image
    [~, name_sample, ~] = fileparts(samples(ii).name);
    directory = sprintf('datasets/train_set/train_split/%s.jpg',...
    name_sample);
    image = imread(directory);

    %---------------------------- METHOD #1 ---------------------------%
    % Apply equation in order to identify color on images. 
    % (RGB color space)
    tic;
    image_segmented = segmentation_by_equation(image);
    time_per_frame_1(ii) = toc;

    [n, ~] = size(images_segmented_1);
    images_segmented_1(n+1, :, :) = image_segmented(:, :);

    %---------------------------- METHOD #2 ---------------------------%
    % Converting an RGB image into normalized RGB removes the effect of 
    % anyintensity variations. Normalizing can provide exactly what you
    % need to compare two images taken under variations of illumination
    % PROVIDING the colour temperature of the light source doesn't
    % change as the illumination output varies

    % LINK Reference to convert RGB into normalized RGB: 
    % https://es.mathworks.com/matlabcentral/newsreader ...
    % /view_thread/171190
    tic
    image_normalized = normalize_RGB_image(image);
    image_segmented = segmentation_by_equation(image_normalized);
    time_per_frame_2(ii) = toc;

    [n, ~] = size(images_segmented_2);
    images_segmented_2(n+1, :, :) = image_segmented(:, :);

    %---------------------------- METHOD #3 ---------------------------%
    
    % Converting an RGB image into XYZ color space
    cd colorspace
    tic
    image_hsv = colorspace('rgb->xyz',image);
    cd ..
    image_segmented = segmentation_by_equation(image_hsv);
    time_per_frame_3(ii) = toc;
    
    [n, ~] = size(images_segmented_3);
    images_segmented_3(n+1, :, :) = image_segmented(:, :);
    
    %------------------------------------------------------------------%
    
    % Message to display on matlab
    num_image = num_image + 1;
    message = sprintf('Images processed: %d/%d', num_image, total_images);
    disp(message);
end 

% Save struct of segmented images
save('images_segmented_1.mat', 'images_segmented_1', '-v7.3');
save('images_segmented_2.mat', 'images_segmented_3', '-v7.3');
save('images_segmented_3.mat', 'images_segmented_3', '-v7.3');
% Save struct of time per frame rate
save time_per_frame_1.mat time_per_frame_1
save time_per_frame_2.mat time_per_frame_2
save time_per_frame_3.mat time_per_frame_3
end    
    
% Function: normalize_RGB_image
% Description: convert an RGB image into normalized RGB
% Input: image in RGB color space
% Output: image in normalize RGB color space
function normalize_RGB = normalize_RGB_image(image)
% Split channels RBG
red = double(image(:, :, 1));            
green = double(image(:, :, 2));           
blue = double(image(:, :, 3)); 

% Normalize each channel
normalize_red = red./sqrt(power(red,2) + power(green,2) + power(blue,2));
normalized_green = green./sqrt(power(red,2) + power(green,2) + ...
power(blue,2));
normalize_blue = blue./sqrt(power(red,2)+ power(green,2) + power(blue,2));

% Merge channels again
normalize_RGB = cat(3,normalize_red, normalized_green, ...
normalize_blue);
end

% Function: segmentation_by_equation
% Decription:
% Input: image to process, title of figure to show and title of processed
% image in order to identify segmentation method applied
% Output: image segmented
function segmentation = segmentation_by_equation(image)
% Split channels
red_channel = image(:, :, 1);            
green_channel = image(:, :, 2);           
blue_channel = image(:, :, 3); 

% Apply equation depending on color segmentation
% RED color segmentation
segmentation_red = max(0,double(red_channel) - ...
0.65*(double(green_channel) + double(blue_channel)));
% BLUE color segmentation
segmentation_blue = max(0, double(blue_channel) - ...
0.65*(double(red_channel) + double(green_channel)));

% Merge channels RED and BLUE
segmentation = min(1, (segmentation_red + segmentation_blue));
segmentation=(segmentation/max(max(segmentation)));
segmentation = segmentation(:,:)>0.15;

% Fill holes of image in order to identify signals
segmentation = imfill(segmentation, 'holes');
end

% Function: show_channels_histograms
% Description: show channels and histograms of each channel component
% Input: image and color space to process
% Output: None
function show_channels_histograms(image, color_space)
switch color_space
    case 'rgb'
        % Shows red, green and blue channels with histograms
        figure();
        set(gcf,'name','RGB channels','numbertitle','off','Position', ...
        [150, 150, 1300, 400]);
        subplot(2,3,1), imshow(image(:,:,1)), title('RED channel ');
        subplot(2,3,2), imshow(image(:,:,2)), title('BLUE channel');
        subplot(2,3,3), imshow(image(:,:,3)), title('GREEN channel');
        subplot(2,3,4), imhist(image(:,:,1)), title('RED histogram');
        subplot(2,3,5), imhist(image(:,:,2)), title('GREEN histogram');
        subplot(2,3,6), imhist(image(:,:,3)), title('BLUE histogram');
    case 'hsv'
        image = rgb2hsv(image);
        figure();
        set(gcf,'name','HSV channels','numbertitle','off','Position', ...
        [150, 150, 1300, 400]);
        subplot(2,3,1), imshow(image(:,:,1)), title('HUE channel ');
        subplot(2,3,2), imshow(image(:,:,2)), title('SATURATION channel');
        subplot(2,3,3), imshow(image(:,:,3)), title('BRIGHTNESS channel');
        subplot(2,3,4), imhist(image(:,:,1)), title('HUE histogram');
        subplot(2,3,5), imhist(image(:,:,2)), title('SATURATION histogram');
        subplot(2,3,6), imhist(image(:,:,3)), title('BRIGHTNESS histogram');
    otherwise
        disp('invalid color space')
end

pause();
close all;
end