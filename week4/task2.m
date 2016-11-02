%% Task 2 -- Template matching using Distance Transform and chamfer distance

function task2()
% Show description on screen about task1
show_description_on_screen();

% Load mask B.
% Edges computed by Canny
B = imread('00.000948.png');
B = edge(B, 'Canny');

%---------- Create circular template ------------%
radius_centered_location = 40;
total_size = 80;
circle_size = 20;
T = get_circular_template(radius_centered_location, total_size, circle_size);
T = edge(T, 'Canny');

% Computes the Euclidean distance transform of the image B
DT = bwdist(B, 'Euclidean');

% Find placement of T in D that minimizes the sum, M, of the DT multiplied by the
% pixel values in T. This operation can be implemented as find the minimum of the 
% convolution of the template and distance image
C = conv2(DT, double(T), 'valid');
[ColumnMin, Y] = min(C);
[~, X] = min(ColumnMin);
min_x = X;
min_y = Y(X);

% Plot location of detection
figure, imshow(B);
hold on;
plot(min_x, min_y, 'y.', 'MarkerSize', 30)
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
% Input: radius_centered_location, total_size, circle_size
% Output: template
function template = get_circular_template(radius_centered_location, total_size, ...
 circle_size)
[rr, cc] = meshgrid(1:total_size);
template = sqrt((rr-radius_centered_location).^2+(cc-radius_centered_location).^2) ...
<=circle_size;
end