%% Task 1 -- Analyse the dataset
%% Description: Determine the characteristics of the signals in the 
%% training set: max and min size, form factor, filling ratio of each type 
%% of signal, frequency of appearance (using text annotations and 
%% ground-truth masks). Group the signals according to their shape and color
%% NOTE: you must have folder train on your main directory to compute images

function task1()
disp('----------------------- TASK 1 DESCRIPTION -----------------------');
disp('Determine the characteristics of the signals in the training set');
disp('Create matlab_files/images_data.mat');
disp('------------------------------------------------------------------');
fprintf('\n');
% Clear screen
clear all;     
disp('List train directory: done');
samples = dir('../train');     

%% READ IMAGES IN THE TRAIN FOLDER
samples = samples(arrayfun(@(x) x.name(1) == '0', samples));

%% GROUP IMAGES BY TYPES IN MATRIX
% Initialize group of images in order to preallocate memory
% Format: (field, value) --> (type of signal, array of values)
n = 0;  % rows. Firstly, initialized to 0
m = 7;  % columns. 1: file name, 2: width, 3: height, 4: form factor, 
% 5: bbox area,  6: compute area, 7: filling ratio
images_data = struct('A', zeros(n, m),'B', zeros(n, m),'C', ...
zeros(n, m),'D', zeros(n, m), 'E', zeros(n, m),'F', zeros(n, m));

disp('Load dataset train: done');
for ii=1:length(samples)
[~, name_sample, ~] = fileparts(samples(ii).name);
file = fileread(['../train/gt/gt.' name_sample '.txt']);
lines= regexp(file, '\n', 'split');

    for jj=1:(length(lines)-1)
        text = regexp(lines(jj), ' ', 'split');

        % Get name. Delete character '.' from string name in order to 
        % save index of name image
        sname_sample = strrep(name_sample,'.','');
        value(1) = str2double(sname_sample);     % file name
        tly = str2double(text{1}{1});              
        tlx = str2double(text{1}{2});
        bry = str2double(text{1}{3});
        brx = str2double(text{1}{4});

        % Computed values
        value(2) = abs(tlx-brx);                % width
        value(3) = abs(tly-bry);                % height
        value(4) = value(2)/value(3);           % form factor
        value(5) = value(2)*value(3);           % bbox area

        % Read mask image
        directory = sprintf('../train/mask/mask.%s.png', name_sample);
        mask = imread(directory);
        % Compute area = count number of white pÃ­xels
        value(6) = sum(sum(mask));
        value(7) = value(6)/value(5);           % filling ratio

        % There are extra space after letter. So we get the letter of 
        % type image only from position (1,1). Note: position(1,2) space 
        % character
        image_type = char(text{1}{5});
        image_type = image_type(1,1);               
        [n, ~] = size(images_data().(image_type));
        images_data().(image_type)(n+1, :) = value(1, :);
    end
end

% Save struct of images_data
save matlab_files/images_data.mat images_data
disp('Saved matlab_files/images_data.mat: done');        
disp('task1(): done');
end