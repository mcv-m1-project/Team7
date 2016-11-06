%% Task 1

%Create the grey level models

load('images_data.mat');
train_dir='datasets/train_set/train_split/';

% Type A
%We have to compute the average signal

model_A=zeros(300,300);
numA=0;
for aa=1:length(images_data.A)
    
    %Read the image
    name=images_data.A(aa,1);
    name=make_file_name(name);
    if exist([train_dir name '.jpg'], 'file') == 2
        color_image=imread([train_dir name '.jpg']);
        grey_image=rgb2gray(color_image);
        mask=imread([train_dir 'mask/mask.' name '.png']);
        gt=fileread([train_dir 'gt/gt.' name '.txt']);
        text=regexp(gt, ' ', 'split');
    
        value(1)=str2num(text{1});
        value(2)=str2num(text{2});
        value(3)=str2num(text{3});
        value(4)=str2num(text{4});
        
        masked_image=mask.*grey_image;
        
        bbox_masked_image=masked_image(value(1):value(3),value(2):value(4));
        
        signal=imresize(bbox_masked_image,[300,300]);
        
        model_A=model_A+double(signal);
        numA=numA+1;
        
    end
    
end

model_A=uint8(round(model_A/numA));

% Type B
%We have to compute the average signal

model_B=zeros(300,300);
numB=0;
for bb=1:length(images_data.B)
    
    %Read the image
    name=images_data.B(bb,1);
    name=make_file_name(name);
    if exist([train_dir name '.jpg'], 'file') == 2
        color_image=imread([train_dir name '.jpg']);
        grey_image=rgb2gray(color_image);
        mask=imread([train_dir 'mask/mask.' name '.png']);
        gt=fileread([train_dir 'gt/gt.' name '.txt']);
        text=regexp(gt, ' ', 'split');
    
        value(1)=str2num(text{1});
        value(2)=str2num(text{2});
        value(3)=str2num(text{3});
        value(4)=str2num(text{4});
        
        masked_image=mask.*grey_image;
        
        bbox_masked_image=masked_image(value(1):value(3),value(2):value(4));
        
        signal=imresize(bbox_masked_image,[300,300]);
        
        model_B=model_B+double(signal);
        numB=numB+1;
        
    end
    
end

model_B=uint8(round(model_B/numB));

% Type C
%We have to compute the average signal

model_C=zeros(300,300);
numC=0;
for cc=1:length(images_data.C)
    
    %Read the image
    name=images_data.C(cc,1);
    name=make_file_name(name);
    if exist([train_dir name '.jpg'], 'file') == 2
        color_image=imread([train_dir name '.jpg']);
        grey_image=rgb2gray(color_image);
        mask=imread([train_dir 'mask/mask.' name '.png']);
        gt=fileread([train_dir 'gt/gt.' name '.txt']);
        text=regexp(gt, ' ', 'split');
    
        value(1)=str2num(text{1});
        value(2)=str2num(text{2});
        value(3)=str2num(text{3});
        value(4)=str2num(text{4});
        
        masked_image=mask.*grey_image;
        
        bbox_masked_image=masked_image(value(1):value(3),value(2):value(4));
        
        signal=imresize(bbox_masked_image,[300,300]);
        
        model_C=model_C+double(signal);
        numC=numC+1;
        
    end
    
end

model_C=uint8(round(model_C/numC));

% Type D
%We have to compute the average signal

model_D=zeros(300,300);
numD=0;
for dd=1:length(images_data.D)
    
    %Read the image
    name=images_data.D(dd,1);
    name=make_file_name(name);
    if exist([train_dir name '.jpg'], 'file') == 2
        color_image=imread([train_dir name '.jpg']);
        grey_image=rgb2gray(color_image);
        mask=imread([train_dir 'mask/mask.' name '.png']);
        gt=fileread([train_dir 'gt/gt.' name '.txt']);
        text=regexp(gt, ' ', 'split');
    
        value(1)=str2num(text{1});
        value(2)=str2num(text{2});
        value(3)=str2num(text{3});
        value(4)=str2num(text{4});
        
        masked_image=mask.*grey_image;
        
        bbox_masked_image=masked_image(value(1):value(3),value(2):value(4));
        
        signal=imresize(bbox_masked_image,[300,300]);
        
        model_D=model_D+double(signal);
        numD=numD+1;
        
    end
    
end

model_D=uint8(round(model_D/numD));


% Type E
%We have to compute the average signal

model_E=zeros(300,300);
numE=0;
for ee=1:length(images_data.E)
    
    %Read the image
    name=images_data.E(ee,1);
    name=make_file_name(name);
    if exist([train_dir name '.jpg'], 'file') == 2
        color_image=imread([train_dir name '.jpg']);
        grey_image=rgb2gray(color_image);
        mask=imread([train_dir 'mask/mask.' name '.png']);
        gt=fileread([train_dir 'gt/gt.' name '.txt']);
        text=regexp(gt, ' ', 'split');
    
        value(1)=str2num(text{1});
        value(2)=str2num(text{2});
        value(3)=str2num(text{3});
        value(4)=str2num(text{4});
        
        masked_image=mask.*grey_image;
        
        bbox_masked_image=masked_image(value(1):value(3),value(2):value(4));
        
        signal=imresize(bbox_masked_image,[300,300]);
        
        model_E=model_E+double(signal);
        numE=numE+1;
        
    end
    
end

model_E=uint8(round(model_E/numE));

% Type F
%We have to compute the average signal

model_F=zeros(300,300);
numF=0;
for ff=1:length(images_data.F)
    
    %Read the image
    name=images_data.F(ff,1);
    name=make_file_name(name);
    if exist([train_dir name '.jpg'], 'file') == 2
        color_image=imread([train_dir name '.jpg']);
        grey_image=rgb2gray(color_image);
        mask=imread([train_dir 'mask/mask.' name '.png']);
        gt=fileread([train_dir 'gt/gt.' name '.txt']);
        text=regexp(gt, ' ', 'split');
    
        value(1)=str2num(text{1});
        value(2)=str2num(text{2});
        value(3)=str2num(text{3});
        value(4)=str2num(text{4});
        
        masked_image=mask.*grey_image;
        
        bbox_masked_image=masked_image(value(1):value(3),value(2):value(4));
        
        signal=imresize(bbox_masked_image,[300,300]);
        
        model_F=model_F+double(signal);
        numF=numF+1;
       
    end
    
end

model_F=uint8(round(model_F/numF));

% Detect signals

model_A=imread('model_A.jpg');
model_B=imread('model_B.jpg');
model_C=imread('model_C.jpg');
model_D=imread('model_D.jpg');
model_E=imread('model_E.jpg');
model_F=imread('model_F.jpg');

bbox_dir='/Users/marccarneherrera/Desktop/M1_project/week4/windowCandidates/validation/';%Result from window
images_dir='/Users/marccarneherrera/Desktop/M1_project/week4/datasets/train_set/validation_split/';%Original image
mask_dir='/Users/marccarneherrera/Desktop/M1_project/week4/improved_masks/validation/';%From color component segmentation

list=dir(images_dir);
list=list(arrayfun(@(x) x.name(1)=='0',list));

for jj=14:14 %1:length(list)
    name=list(jj).name;
    image_name=name(1:end-4);
    color_image=imread([images_dir name]);
    grey_image=rgb2gray(color_image);
    mask=imread([mask_dir image_name '.png']);
    load([bbox_dir image_name '.mat']); %genera variable bounding_boxes
    
    masked_image=(mask/255).*grey_image;
    
    %Charge bounding boxes
    for bb=1:length(windowCandidates)
        %Refine the bounding box
        x=windowCandidates(bb).x;
        y=windowCandidates(bb).y;
        w=windowCandidates(bb).w;
        h=windowCandidates(bb).h;
        
        if w>h
            dsize=(w-h)/2;
            bbox=masked_image(y-dsize:y+h+dsize,x:x+w);
        elseif h>w
            dsize=(h-w)/2;
            bbox=masked_image(y:y+h,x-dsize:x+w+dsize);
        else
            bbox=masked_image(y:y+h,x:x+w);
        end
        
        bbox_resized=imresize(bbox,[300, 300]);
        
        %Compare with the models using the correlation
        corr(1)=corr2(model_A,bbox_resized);
        corr(2)=corr2(model_B,bbox_resized);
        corr(3)=corr2(model_C,bbox_resized);
        corr(4)=corr2(model_D,bbox_resized);
        corr(5)=corr2(model_E,bbox_resized);
        corr(6)=corr2(model_F,bbox_resized);
        
        %apply a threshold to find a maxima
        [maxprob,pos]=max(corr);
        
        otherprob=0;
        otherprob=(sum(corr)-corr(pos))/5;
        
        if 1.4*otherprob<=corr(pos)
            candidate=1;
        else
            candidate=0;
        end
        
        
    end
    
    
    
    
end


%% Differences
% npixels=300*300;
% d_a=sum(sum(diff_A))/npixels;
% d_b=sum(sum(diff_B))/npixels;
% d_c=sum(sum(diff_C))/npixels;
% d_d=sum(sum(diff_D))/npixels;
% d_e=sum(sum(diff_E))/npixels;
% d_f=sum(sum(diff_F))/npixels;
