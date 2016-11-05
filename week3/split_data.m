function split_data(data)
    % Load mask folder
    samples = dir('../datasets/train_set/train_split'); 
    samples = samples(arrayfun(@(x) x.name(1) == '0', samples));
    total_images = uint8(length(samples));

    disp('Spliting data...');
    for ii=1:total_images    
        [~, name_sample, ~] = fileparts(samples(ii).name);
        name_sample = strrep(name_sample,'.','');
        name = strcat('image_', name_sample);
        
        bb = data.(name);
        bb_1 = bb(bb~=0);
        bb_1 = bb_1';
        [n, m] = size(bb_1);
        windowCandidates = [];
        if m> 4 
            jump = m/4;
            pos_x = (1 * jump) - (jump-1);
            pos_y = (2 * jump) - (jump-1);
            pos_w = (3 * jump) - (jump-1);
            pos_h = (4 * jump) - (jump-1);
            bf = zeros((m/4), 4);
           
            
            for jj=1:(m/4)
               windowCandidates = [windowCandidates; ...
               struct('x',bb_1(1, pos_x), 'y',bb_1(1, pos_y), ...
                      'w',bb_1(1, pos_w), 'h',bb_1(1, pos_h));];
                pos_x = pos_x + 1;
                pos_y = pos_y + 1;
                pos_w = pos_w + 1;
            	pos_h = pos_h + 1;
                  
            end
            bb_1 = bf;
        else
           if m == 1
               bb_1 = bb_1'; 
           end
           
           if isempty(bb_1)
               windowCandidates = [windowCandidates ; struct('x',0,'y',0,'w',0,'h',0)];
           else
               windowCandidates = [windowCandidates ; struct('x',bb_1(1, 1),'y',bb_1(1, 2),...
               'w',bb_1(1, 3),'h',bb_1(1, 4))];
           end

        end

        name = name(7:length(name));
        a = name(1:2);
        b = name(3:length(name));
        name = strcat(a, '.', b);
        save_dir = strcat('split_data/', name, '.mat');
        save(save_dir, 'windowCandidates');
    end
end