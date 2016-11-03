%% Task 2 -- Template matching using Distance Transform and chamfer distance

function task2()
% Show description on screen about task1
show_description_on_screen();

B = imread('improved_masks/train/00.000978.png');   % Load mask B
B = edge(B, 'Canny');                               % Edges computed by Canny

template_size = 300;

%T1 = get_square_template(template_size);       % Square template
T1 = get_triangle_template(template_size);      % Triangle template
T1 = imrotate(T1, 180);                         % Inverted triangle template
%T1 = get_circular_template(template_size);     % Circular template

T2 = edge(T1, 'Canny'); 

% Computes the Euclidean distance transform of the image B
DT = bwdist(B, 'Euclidean');

% Find placement of T in D that minimizes the sum, M, of the DT multiplied by the
% pixel values in T. This operation can be implemented as find the minimum of the 
% 2D convolution of the template and distance image
C = conv2(DT, double(T2), 'valid');

% Get minimum values of 2D convolution
[ColumnMin_x, ColumnMin_y] = min(C);
[~, min_x1] = min(ColumnMin_x);
[min_y1, ~] = min(ColumnMin_y);

% Perform another convolution with a solid template to find displacement of
% matching position
C2 = conv2(DT, double(T1),'valid');

% Compute threshold on 2D convolution
thresold = (2 * template_size + 1)^2 * 3;
C(C2<thresold) = max(max(C));
%figure('Name', '2D convolution computing threshold'), ...
%surf(double(C)), shading flat;
%pause();
%close;

% Calculate displacement of match position
[ColumnMin_x, ColumnMin_y] = min(C);
[~, min_x2] = min(ColumnMin_x);
[min_y2, ~] = min(ColumnMin_y);

% Calculate positions of matching
x = min_x1+(min_x1-min_x2);
y = min_y1+(min_y1-min_y2);

% Plot location of detection
figure('Name', 'B image: location of detection'), imshow(B);
hold on;
plot(x+(template_size/2), y+(template_size/2), 'g.', 'MarkerSize', 30)
pause();
close all;
end

% Function: show_description
% Description: show description on screen
% Input: None
% Output: None
function show_description_on_screen()
disp('----------------------------- TASK 2 DESCRIPTION -----------------------------');
disp('Template matching using Distance Transform and chamfer distance');
disp('Chamfer distance model of each shape: ');
disp('   •  Edges computed by canny, gradient magnitude or others ');
disp ('      edges(im,’canny’) on gray level image or contours from binary mask');
disp('   •  Model learning of edges (hand crafted, average or other');
disp('   •  Distance transform of test image and chamfer distance to classify');
disp('------------------------------------------------------------------------------');
fprintf('\n');
end

% Function: get_circular_template
% Description: create circular template
% Input: template_size
% Output: circular template
function template = get_circular_template(template_size)
radius_centered_location = template_size/2;
circle_size = radius_centered_location-5;
[rr, cc] = meshgrid(1:template_size);
template = sqrt((rr-radius_centered_location).^2+(cc-radius_centered_location).^2) ...
<=circle_size;
end

% Function: get_triangle_template
% Description: create triangle template
% Input: template_size
% Output: triangle template
function template = get_triangle_template(template_size)
radius_centered_location = template_size/2;
template = zeros(template_size, template_size);

% Define points of triangle. point = [y, x]
p1 = [template_size-10, 10];
p2 = [template_size-10, template_size-10];
p3 = [10, radius_centered_location];

% Set points on background
template(p1(1), p1(2)) = 1;
template(p2(1), p2(2)) = 1;
template(p3(1), p3(2)) = 1;

% Draw first line
array_x = p1(1):p2(1);
array_y = p1(2):p2(2);
template(array_x, array_y) = 1;

% Draw second line
[~, my] = size(array_y);
a = floor(linspace(p1(1), p3(1), (my-1)));
b = floor(linspace(p1(2), p3(2), (my-1)));
[~, ma] = size(a);
for ii=1:ma
    template(a(ii), b(ii)) = 1;
end
template(p1(1)-1, p1(2)) = 1;

% Draw third line
a = floor(linspace(p2(1), p3(1), (my-1)));
b = floor(linspace(p2(2), p3(2), (my-1)));
for ii=1:ma
    template(a(ii), b(ii)) = 1;
end
template(p2(1)-1, p2(2)) = 1;

% Fill triangle
template = imfill(template,'holes');
end

% Function: get_square_template
% Description: create square template
% Input: template_size
% Output: triangle template
function template = get_square_template(template_size)
template = zeros(template_size, template_size);

% Define points of square. point = [y, x]
p1 = [template_size-10, template_size-10];
p2 = [template_size-10, 10];
p3 = [10, template_size-10];
p4 = [10, 10];

% Set points on background
template(p1(1), p1(2)) = 1;
template(p2(1), p2(2)) = 1;
template(p3(1), p3(2)) = 1;
template(p4(1), p4(2)) = 1;

% Draw horizontal lines
array = p2(2):p1(2);
template(10, array) = 1;
template(template_size-10, array) = 1;
template(array, 10) = 1;
template(array, template_size-10) = 1;

% Fill square
template = imfill(template,'holes');
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