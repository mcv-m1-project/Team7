function split_data(data)
    % Load mask folder
    samples = dir('../datasets/test_set'); 
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
        final_s = [];
        if m> 4 
            min = 1;
            max = 4;
            bf = zeros((m/4), 4);
            for jj=1:(m/4)
                ss = struc('x',0,'y',0,'w',0,'h',0);
                bf(jj, 1:4) =  bb_1(1, min:max);
                min = min + 4;
                max = max + 4;
                
                ss.x = bf(jj, 1);
                ss.y = bf(jj, 2);
                ss.w = bf(jj, 3);
                ss.h = bf(jj, 4);
                
                final_s = [final_s , ss];
            end
            bb_1 = bf;
        else
           if m == 1
               bb_1 = bb_1'; 
           end
           
           if isempty(bb_1)
                ss = struc('x',0,'y',0,'w',0,'h',0);
           else
               ss = struc('x',0,'y',0,'w',0,'h',0);
               ss.x = bb_1(1, 1);
               ss.y = bb_1(1, 2);
               ss.w = bb_1(1, 3);
               ss.h = bb_1(1, 4);
           end


           final_s = [final_s , ss];
        end

        
        name = name(7:length(name));
        a = name(1:2);
        b = name(3:length(name));
        name = strcat(a, '.', b);
        save_dir = strcat('split_data/', name, '.mat');
        save(save_dir, 'final_s', '-v7.3');
    end
end