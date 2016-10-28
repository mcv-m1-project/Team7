%% Task 1 -- Implement a function for CCL that labels all connected components
%% in a binary image and returns a list of the bounding boxes. To discard false
%% positives, simple geometric constraints can be used (aspect ratio / filling
%% ratio / ...)

function task1()
% Show description on screen about task1
show_description_on_screen();
% User menu to choose dataset 
[dataset, valid_option] = choose_dataset;
% Check if dataset is correct
if valid_option == 1

    % Define parameters
    bounding_boxes_list = struct();     % List of bounding boxes
    area_min = 300;                     % Minimum area to recognize signal
    ratio_min = 0.6;                    % Minimum ratio to recongnize signal
    num_image = 0;                      % Number of image to display text

    % Load mask folder
    sdir = 'improved_mask_';
    sdir = strcat(sdir, dataset);
    samples = dir(sdir); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));

    disp('Starting image processing...');
    for ii=1:total_images    
        [~, name_sample, ~] = fileparts(samples(ii).name);
        directory = sprintf('%s/%s.png', sdir, name_sample);
        image = logical(imread(directory));

        % Find connected_components in binary image
        connected_components = bwconncomp(image);
        % Measure properties of image regions.  
        % Shape Measurements:
        %  - BoundingBox: returns the smallest rectangle containing the region
        %  - Area: returns a scalar that specifies the actual number of pixels 
        %    in the region
        shape_mesarurements = regionprops(connected_components,'BoundingBox',...
        'Area');

        % Uncoment to show images
        % figure, imshow(image);
        
        % Discard objects that are not belongs to signal
        for i=1:length(shape_mesarurements)
          boundingBox = shape_mesarurements(i).BoundingBox;
          area = shape_mesarurements(i).Area;
          ratio = min(boundingBox(4),boundingBox(3))/...
          max(boundingBox(4),boundingBox(3));

          % Check if regions detected are candidates to be signal
          if((area > area_min) && ((ratio) > ratio_min))
              % Get bounding box values
              boundingBox = [boundingBox(1),boundingBox(2),boundingBox(3),...
              boundingBox(4)];
          
              % Show bounding box on image
              % show_bounding_boxes(image, boundingBox, area, ratio);

          else
                boundingBox = [0, 0, 0, 0];
          end
              
          % Save bounding box values on struct list
          name_sample = strrep(name_sample,'.','');
          name = strcat('image_', name_sample);
          if isfield(bounding_boxes_list, name)
                [n, ~] = size(bounding_boxes_list.(name));
                bounding_boxes_list.(name)(n+1, :, :) = boundingBox;
          else
                bounding_boxes_list.(name) = boundingBox;    
          end
          
        end
        
        if(length(shape_mesarurements)==0)
          [~, name_sample, ~] = fileparts(samples(ii).name);
          % Save bounding box values on struct list
          name_sample = strrep(name_sample,'.','');
          name = strcat('image_', name_sample);
          if isfield(bounding_boxes_list, name)
                [n, ~] = size(bounding_boxes_list.(name));
                bounding_boxes_list.(name)(n+1, :, :) = boundingBox;
          else
                bounding_boxes_list.(name) = boundingBox;    
          end
        end

        % Uncoment to show images
        % pause;
        % close all;
        
        % Message to display on matlab
        num_image = num_image + 1;
        message = sprintf('Images processed: %d/%d', num_image, total_images);
        disp(message);
    end

save_dir = strcat('matlab_files/connected_component_labeling/ccl_bounding_boxes_', dataset);
save(save_dir, 'bounding_boxes_list', '-v7.3');
disp('Save bounding_boxes_list.mat: done');
end
disp('task1(): done');
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------- TASK 1 DESCRIPTION -----------------------');
disp('Implement a function for CCL that labels all connected components');
disp('in a binary image and returns a list of the bounding boxes. To discard');
disp('false positives, simple geometric constraints can be used ');
disp('(aspect ratio / filling ratio / ...)');
disp('------------------------------------------------------------------');
fprintf('\n');
end

% Function: show_bounding_boxes
% Description: show bounding boxes on image
% Input: image, bounding box, area and ratio
% Output: None
function show_bounding_boxes(image, boundingBox, area, ratio)
    % Compute area of each shape
    square_area = abs(area - (boundingBox(4)*boundingBox(3)));
    triangle_area = abs(area - ((boundingBox(4)*boundingBox(3))/2));
    cercle_area = abs((((boundingBox(4)*boundingBox(3))*pi/(4*ratio)))-area);
    % Get min area
    [~, shape] = min([square_area, triangle_area, cercle_area]);
    % Print bounding box on image
    switch shape
      case 1 % square 
          rectangle('Position', boundingBox, 'EdgeColor','r', 'LineWidth', 2); 
      case 2 % triangle
          rectangle('Position', boundingBox, 'EdgeColor','g', 'LineWidth', 2);    
      case 3 % cercle
          rectangle('Position', boundingBox, 'EdgeColor','b', 'LineWidth', 2);          
    end    
end

% Function: choose_dataset
% Description: user menu to choose dataset
% Input: None
% Output: dataset
function [dataset, valid_option] = choose_dataset()
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
end