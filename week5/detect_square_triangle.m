% Function: detect_square_triangle
% Description: compute hough to detect squares and triangles on binary mask
% Input: mask,  windowCandidates
% Output: candidate
function candidate = detect_square_triangle(mask, windowCandidate)
        % Extract the values from the window candidate
        x = windowCandidate.x;
        y = windowCandidate.y;
        w = windowCandidate.w;
        h = windowCandidate.h;
        exceptions = 0;
        candidate = 0;
        
        % Check if it's an empty window
        if x==0 && y==0 && w==0 && h==0
            candidate = 0;
        else
            if w > h
                dsize =(w-h)/2;
                try
                    bbox = mask(floor(y-dsize):floor(y+h+dsize), floor(x):floor(x+w));
                catch 
                    % warning('\nIndex exceeds matrix dimensions');
                    exceptions = 1;
                end
            elseif h>w
                try
                    dsize = (h-w)/2;
                    bbox = mask(floor(y):floor(y+h), floor(x-dsize):floor(x+w+dsize));
                catch 
                    % warning('Index exceeds matrix dimensions');
                    exceptions = 1;
                end
            else
                try
                    bbox = mask(floor(y):floor(y+h), floor(x):floor(x+w));
                catch 
                    % warning('Index exceeds matrix dimensions');
                    exceptions = 1;
                end

            end

            if exceptions == 0
                % Having the bbox we have to compute the edges or contours
                % Extend the bbox to ensure the detection
                s = size(bbox);
                bbox_ext = zeros(s(1)+40,s(2)+40);
                bbox_ext(20:20+s(1)-1,20:20+s(2)-1) = bbox;

                % Compute the gradient with erosion
                se = strel('square',3);
                contour = bbox_ext-imerode(bbox_ext,se);

                % Compute Hough
                [H, theta, ~]=hough(contour,'RhoResolution',1.5,'Theta',-90:1:89.5);

                % Extract the peaks in the Hough matrix
                peaks_square = houghpeaks(H,4); %An square has 4 lines
                peaks_triangle = houghpeaks(H,3); %A triangle has 3 lines

                candidate = 0;

                % Detect square: see the peaks and if the lines match with the
                % shape
                count_90 = 0;
                count_0 = 0;
                angles_square = (0);

                for pp=1:length(peaks_square)
                    try
                        angles_square(pp)=theta(peaks_square(pp,2));
                    catch 
                        % warning('Index exceeds matrix dimensions');
                        break
                    end

                    if ( abs(angles_square(pp))> 85 && abs(angles_square(pp))<=90 )
                        count_90=count_90+1;
                    elseif ( abs(angles_square(pp))>=0  && abs(angles_square(pp))< 5 )
                        count_0=count_0+1;
                    end
                end

                if count_90 == 2 && count_0 == 2
                    candidate = 1;
                end

                % Detect triangle: see the peaks and if the lines match with the
                % shape
                count_60 = 0;
                count_0 = 0;
                angles_triangle = (0);

                for mm=1:length(peaks_triangle)
                    try
                        angles_triangle(mm) = theta(peaks_triangle(mm,2));
                    catch 
                        % warning('Index exceeds matrix dimensions');
                        break
                    end
                    
                    if ( abs(angles_triangle(mm))> 20 && abs(angles_triangle(mm))<40 )
                        count_60 = count_60 + 1;
                    elseif ( abs(angles_triangle(mm))> 85  && abs(angles_triangle(mm))<=90 )
                        count_0 = count_0 + 1;
                    end
                end

                if count_60 == 2 && count_0 == 1
                    candidate=1;
                end
            end
        end
        % The Hough angle is referred to the normal line to the detected line.
end
