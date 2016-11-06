% %% Task 1
% 
% %Create the grey level models
% 
% load('images_data.mat');
% train_dir='/Users/marccarneherrera/Desktop/M1_project/week1/datasets/train_set/train_split/';
% 
% %% Type A
% %We have to compute the average signal
% 
% model_A=zeros(300,300,3);
% numA=0;
% for aa=1:length(images_data.A)
%     
%     %Read the image
%     name=images_data.A(aa,1);
%     name=make_file_name(name);
%     if exist([train_dir name '.jpg'], 'file') == 2
%         color_image=imread([train_dir name '.jpg']);
%         mask=imread([train_dir 'mask/mask.' name '.png']);
%         
%         color_mask(:,:,1)=mask(:,:);
%         color_mask(:,:,2)=mask(:,:);
%         color_mask(:,:,3)=mask(:,:);
%         
%         gt=fileread([train_dir 'gt/gt.' name '.txt']);
%         text=regexp(gt, ' ', 'split');
%     
%         value(1)=str2num(text{1});
%         value(2)=str2num(text{2});
%         value(3)=str2num(text{3});
%         value(4)=str2num(text{4});
%         
%         masked_image=color_mask.*color_image;
%         
%         bbox_masked_image=masked_image(value(1):value(3),value(2):value(4),:);
%         
%         signal=imresize(bbox_masked_image,[300,300]);
%         
%         model_A(:,:,1)=model_A(:,:,1)+double(signal(:,:,1));
%         model_A(:,:,2)=model_A(:,:,2)+double(signal(:,:,2));
%         model_A(:,:,3)=model_A(:,:,3)+double(signal(:,:,3));
%         numA=numA+1;
%         
%     end
%     
% end
% 
% model_A=uint8(round(model_A/numA));
% 
% %% Type B
% %We have to compute the average signal
% 
% model_B=zeros(300,300,3);
% numB=0;
% for bb=1:length(images_data.B)
%     
%     %Read the image
%     name=images_data.B(bb,1);
%     name=make_file_name(name);
%     if exist([train_dir name '.jpg'], 'file') == 2
%         color_image=imread([train_dir name '.jpg']);
%         
%         mask=imread([train_dir 'mask/mask.' name '.png']);
%         color_mask(:,:,1)=mask(:,:);
%         color_mask(:,:,2)=mask(:,:);
%         color_mask(:,:,3)=mask(:,:);
%         gt=fileread([train_dir 'gt/gt.' name '.txt']);
%         text=regexp(gt, ' ', 'split');
%     
%         value(1)=str2num(text{1});
%         value(2)=str2num(text{2});
%         value(3)=str2num(text{3});
%         value(4)=str2num(text{4});
%         
%         masked_image=color_mask.*color_image;
%         
%         bbox_masked_image=masked_image(value(1):value(3),value(2):value(4),:);
%         
%         signal=imresize(bbox_masked_image,[300,300]);
%         
%         model_B(:,:,1)=model_B(:,:,1)+double(signal(:,:,1));
%         model_B(:,:,2)=model_B(:,:,2)+double(signal(:,:,2));
%         model_B(:,:,3)=model_B(:,:,3)+double(signal(:,:,3));
%         numB=numB+1;
%         
%     end
%     
% end
% 
% model_B=uint8(round(model_B/numB));
% 
% %% Type C
% %We have to compute the average signal
% 
% model_C=zeros(300,300,3);
% numC=0;
% for cc=1:length(images_data.C)
%     
%     %Read the image
%     name=images_data.C(cc,1);
%     name=make_file_name(name);
%     if exist([train_dir name '.jpg'], 'file') == 2
%         color_image=imread([train_dir name '.jpg']);
%         
%         mask=imread([train_dir 'mask/mask.' name '.png']);
%         color_mask(:,:,1)=mask(:,:);
%         color_mask(:,:,2)=mask(:,:);
%         color_mask(:,:,3)=mask(:,:);
%         gt=fileread([train_dir 'gt/gt.' name '.txt']);
%         text=regexp(gt, ' ', 'split');
%     
%         value(1)=str2num(text{1});
%         value(2)=str2num(text{2});
%         value(3)=str2num(text{3});
%         value(4)=str2num(text{4});
%         
%         masked_image=color_mask.*color_image;
%         
%         bbox_masked_image=masked_image(value(1):value(3),value(2):value(4),:);
%         
%         signal=imresize(bbox_masked_image,[300,300]);
%         
%         model_C(:,:,1)=model_C(:,:,1)+double(signal(:,:,1));
%         model_C(:,:,2)=model_C(:,:,2)+double(signal(:,:,2));
%         model_C(:,:,3)=model_C(:,:,3)+double(signal(:,:,3));
%         numC=numC+1;
%         
%     end
%     
% end
% 
% model_C=uint8(round(model_C/numC));
% 
% %% Type D
% %We have to compute the average signal
% 
% model_D=zeros(300,300,3);
% numD=0;
% for dd=1:length(images_data.D)
%     
%     %Read the image
%     name=images_data.D(dd,1);
%     name=make_file_name(name);
%     if exist([train_dir name '.jpg'], 'file') == 2
%         color_image=imread([train_dir name '.jpg']);
%         
%         mask=imread([train_dir 'mask/mask.' name '.png']);
%         color_mask(:,:,1)=mask(:,:);
%         color_mask(:,:,2)=mask(:,:);
%         color_mask(:,:,3)=mask(:,:);
%         gt=fileread([train_dir 'gt/gt.' name '.txt']);
%         text=regexp(gt, ' ', 'split');
%     
%         value(1)=str2num(text{1});
%         value(2)=str2num(text{2});
%         value(3)=str2num(text{3});
%         value(4)=str2num(text{4});
%         
%         masked_image=color_mask.*color_image;
%         
%         bbox_masked_image=masked_image(value(1):value(3),value(2):value(4),:);
%         
%         signal=imresize(bbox_masked_image,[300,300]);
%         
%         model_D(:,:,1)=model_D(:,:,1)+double(signal(:,:,1));
%         model_D(:,:,2)=model_D(:,:,2)+double(signal(:,:,2));
%         model_D(:,:,3)=model_D(:,:,3)+double(signal(:,:,3));
%         numD=numD+1;
%         
%     end
%     
% end
% 
% model_D=uint8(round(model_D/numD));
% 
% 
% %% Type E
% %We have to compute the average signal
% 
% model_E=zeros(300,300,3);
% numE=0;
% for ee=1:length(images_data.E)
%     
%     %Read the image
%     name=images_data.E(ee,1);
%     name=make_file_name(name);
%     if exist([train_dir name '.jpg'], 'file') == 2
%         color_image=imread([train_dir name '.jpg']);
%         
%         mask=imread([train_dir 'mask/mask.' name '.png']);
%         color_mask(:,:,1)=mask(:,:);
%         color_mask(:,:,2)=mask(:,:);
%         color_mask(:,:,3)=mask(:,:);
%         gt=fileread([train_dir 'gt/gt.' name '.txt']);
%         text=regexp(gt, ' ', 'split');
%     
%         value(1)=str2num(text{1});
%         value(2)=str2num(text{2});
%         value(3)=str2num(text{3});
%         value(4)=str2num(text{4});
%         
%         masked_image=color_mask.*color_image;
%         
%         bbox_masked_image=masked_image(value(1):value(3),value(2):value(4),:);
%         
%         signal=imresize(bbox_masked_image,[300,300]);
%         
%         model_E(:,:,1)=model_E(:,:,1)+double(signal(:,:,1));
%         model_E(:,:,2)=model_E(:,:,2)+double(signal(:,:,2));
%         model_E(:,:,3)=model_E(:,:,3)+double(signal(:,:,3));
%         numE=numE+1;
%         
%     end
%     
% end
% 
% model_E=uint8(round(model_E/numE));
% 
% %% Type F
% %We have to compute the average signal
% 
% model_F=zeros(300,300,3);
% numF=0;
% for ff=1:length(images_data.F)
%     
%     %Read the image
%     name=images_data.F(ff,1);
%     name=make_file_name(name);
%     if exist([train_dir name '.jpg'], 'file') == 2
%         color_image=imread([train_dir name '.jpg']);
%         
%         mask=imread([train_dir 'mask/mask.' name '.png']);
%         color_mask(:,:,1)=mask(:,:);
%         color_mask(:,:,2)=mask(:,:);
%         color_mask(:,:,3)=mask(:,:);
%         gt=fileread([train_dir 'gt/gt.' name '.txt']);
%         text=regexp(gt, ' ', 'split');
%     
%         value(1)=str2num(text{1});
%         value(2)=str2num(text{2});
%         value(3)=str2num(text{3});
%         value(4)=str2num(text{4});
%         
%         masked_image=color_mask.*color_image;
%         
%         bbox_masked_image=masked_image(value(1):value(3),value(2):value(4),:);
%         
%         signal=imresize(bbox_masked_image,[300,300]);
%         
%         model_F(:,:,1)=model_F(:,:,1)+double(signal(:,:,1));
%         model_F(:,:,2)=model_F(:,:,2)+double(signal(:,:,2));
%         model_F(:,:,3)=model_F(:,:,3)+double(signal(:,:,3));
%         numF=numF+1;
%        
%     end
%     
% end
% 
% model_F=uint8(round(model_F/numF));

%% Detect signals

model_A=imread('model_A_color.png');
model_B=imread('model_B_color.png');
model_C=imread('model_C_color.png');
model_D=imread('model_D_color.png');
model_E=imread('model_E_color.png');
model_F=imread('model_F_color.png');

%bbox_dir='windowCandidates/test/';%Result from window
%images_dir='datasets/test_set/';%Original image
%mask_dir='improved_masks/test/';%From color component segmentation

%bbox_dir='windowCandidates/validation/';%Result from window
%images_dir='datasets/train_set/validation_split/';%Original image
%mask_dir='improved_masks/validation/';%From color component segmentation

time_per_frame = [];
time = 0;

list=dir(images_dir);
list=list(arrayfun(@(x) x.name(1)=='0',list));

for jj=1:length(list)
    name=list(jj).name;
    image_name=name(1:end-4);
    color_image=imread([images_dir name]);
    
    mask=imread([mask_dir image_name '.png']);
    color_mask(:,:,1)=mask(:,:);
    color_mask(:,:,2)=mask(:,:);
    color_mask(:,:,3)=mask(:,:);
    window = load([bbox_dir image_name '.mat']); %genera variable bounding_boxes
    window = window.windowCandidates;
    
    masked_image=(color_mask/255).*color_image;
    detect=0;
    windowCandidates=[];
    %Charge bounding boxes
    for bb=1:length(window)
        %Refine the bounding box
        x=window(bb).x;
        y=window(bb).y;
        w=window(bb).w;
        h=window(bb).h;
        
        control_error = 0;
        
        if x==0 && y==0 && w==0 && h==0
            windowCandidates=[windowCandidates;struct('x',x,'y',y,'w',w,'h',h)];
        else
            if w>h
                try
                    dsize=(w-h)/2;
                    bbox=masked_image(y-dsize:y+h+dsize,x:x+w,:);
                catch
                    warning('Index exceeds matrix dimensions');
                    control_error = 1;
                end

            elseif h>w
                try
                    dsize=(h-w)/2;
                    bbox=masked_image(y:y+h,x-dsize:x+w+dsize,:);
                catch
                    warning('Index exceeds matrix dimensions');
                    control_error = 1;
                end
                
            else
                try
                    bbox=masked_image(y:y+h,x:x+w,:);
                catch
                    warning('Index exceeds matrix dimensions');
                    control_error = 1;
                end
                
            end

            if control_error == 0
                bbox_resized=imresize(bbox,[300, 300]);

                tic
                %Compare with the models using the correlation
                corr(1,1)=corr2(model_A(:,:,1),bbox_resized(:,:,1));
                corr(1,2)=corr2(model_A(:,:,2),bbox_resized(:,:,2));
                corr(1,3)=corr2(model_A(:,:,3),bbox_resized(:,:,3));
                corr(2,1)=corr2(model_B(:,:,1),bbox_resized(:,:,1));
                corr(2,2)=corr2(model_B(:,:,2),bbox_resized(:,:,2));
                corr(2,3)=corr2(model_B(:,:,3),bbox_resized(:,:,3));
                corr(3,1)=corr2(model_C(:,:,1),bbox_resized(:,:,1));
                corr(3,2)=corr2(model_C(:,:,2),bbox_resized(:,:,2));
                corr(3,3)=corr2(model_C(:,:,3),bbox_resized(:,:,3));
                corr(4,1)=corr2(model_D(:,:,1),bbox_resized(:,:,1));
                corr(4,2)=corr2(model_D(:,:,2),bbox_resized(:,:,2));
                corr(4,3)=corr2(model_D(:,:,3),bbox_resized(:,:,3));
                corr(5,1)=corr2(model_E(:,:,1),bbox_resized(:,:,1));
                corr(5,2)=corr2(model_E(:,:,2),bbox_resized(:,:,2));
                corr(5,3)=corr2(model_E(:,:,3),bbox_resized(:,:,3));
                corr(6,1)=corr2(model_F(:,:,1),bbox_resized(:,:,1));
                corr(6,2)=corr2(model_F(:,:,2),bbox_resized(:,:,2));
                corr(6,3)=corr2(model_F(:,:,3),bbox_resized(:,:,3));

                for cc=1:6
                    c(cc)=(corr(cc,1)+corr(cc,3))/2;
                end

                %apply a threshold to find a maxima
                [maxprob,pos]=max(c);

                time=toc;
                
                if maxprob>0.5
                    candidate=1;
                    detect=detect+1;
                    windowCandidates=[windowCandidates;struct('x',x,'y',y,'w',w,'h',h)];
                else
                    candidate=0;
                end
            else
                 windowCandidates=[windowCandidates;struct('x',0,'y',0,'w',0,'h',0)];
            end
        end
    end
    time = time / (length(window));
    time_per_frame = [time_per_frame, time];
    sdir = strcat('windowCandidates_test_task1/',image_name,'.mat');
    save(sdir, 'windowCandidates');
    
end
time = mean(time_per_frame);
message = sprintf('Mean time per frame: %d', time);
disp(message);

%% Differences
% npixels=300*300;
% d_a=sum(sum(diff_A))/npixels;
% d_b=sum(sum(diff_B))/npixels;
% d_c=sum(sum(diff_C))/npixels;
% d_d=sum(sum(diff_D))/npixels;
% d_e=sum(sum(diff_E))/npixels;
% d_f=sum(sum(diff_F))/npixels;
