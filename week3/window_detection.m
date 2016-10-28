function matrix_detection=window_detection(mask)
    detect = 1;
    s = size(mask);
    
    % Criteria: square windows. In each proposal evaluate the area of white
    % region and see if correspond to a form.
    % Also grid the window and apply a restriction to each subwindow to
    % detect a specific distribution of the white area.
    
    n_sizes = 10;
    max = 300;
    step = max/n_sizes;
    initial_size = 30;
    
    for ss=1:n_sizes
        message = sprintf('Analysing window: %d/%d', ss, n_sizes);
        disp(message);
        
        % Define the window
        % Move on the image
        ii = 2;
        while ii<(s(1)-(initial_size+step*ss-1))-2
            jj = 2;
            if ii~=2
                if sum(sum(mask(r1:r2,:)))==0 && ...
                   r2+1<(s(1)-(initial_size+step*ss-1))-2
                    ii=r2+1;
                end
            end
            
            while jj<(s(2)-(initial_size+step*ss-1))-2
                r1 = ii;
                r2 = ii+initial_size+step*ss-1;
                c1 = jj;
                c2 = jj+initial_size+step*ss-1;
                window=mask(r1:r2,c1:c2);
                if (sum(mask(r1:r2,c1-1))+sum(mask(r1:r2,c2+1))+ ...
                    sum(mask(r1-1,c1:c2))+sum(mask(r2+1,c1:c2)))==0
                    if sum(sum(window))==0 || sum(sum(window))<...
                       (0.25*(r2-r1)*(r2-r1))
                        jj = c2+1;
                    else
                        % disp('Compute candidate...');
                        candidate = compute_candidate(window);
                        if candidate ~= 0
                            matrix_detection(detect,1) = r1;
                            matrix_detection(detect,2) = r2;
                            matrix_detection(detect,3) = c1;
                            matrix_detection(detect,4) = c2;
                            detect = detect+1;
                        end
                        jj = jj+1;
                    end
                else
                    jj = jj+1;
                end
            end
            ii = ii+1;
        end
        if detect == 1
            matrix_detection = zeros(1,4);
        end
    end 
end