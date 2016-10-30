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
        if m> 4 
            min = 1;
            max = 4;
            bf = zeros((m/4), 4);
            for jj=1:(m/4)
                bf(jj, 1:4) =  bb_1(1, min:max);
                min = min + 4;
                max = max + 4;
            end
            bb_1 = bf;
        end
        if m == 1
           bb_1 = bb_1'; 
        end
        
        name = name(7:length(name));
        a = name(1:2);
        b = name(3:length(name));
        name = strcat(a, '.', b);
        save_dir = strcat('split_data/', name, '.mat');
        save(save_dir, 'bb_1', '-v7.3');
    end
end