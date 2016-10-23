% Task 4 Compute the histograms
% Histogram for A, B and C  -> Group 1: g1
% Histogram for D and F     -> Group 2: g2
% Histogram for E           -> Group 3: g3

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
sdir = '../week1/datasets/train_set/validation_split';
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
    mask_dir = sprintf('mask_results_task4_m%s/%s.png', method, name_sample);
    imwrite(mask, mask_dir,'png');
    
    % Message to display on matlab
    num_image = num_image + 1;
    message = sprintf('Images processed: %d/%d', num_image, total_images);
    disp(message);
end
disp('task4(): done');