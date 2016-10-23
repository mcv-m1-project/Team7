function y=mydilate(image, SE)
    
    %Compute the size of the element (2D element)
    SE=SE.getnhood(); %Transform the SE to a logical matrix 
    S=size(SE);
    Lx=S(1);
    Ly=S(2);
    
    %Compute the size of the image
    SS=size(image);
    i_x=SS(1);
    i_y=SS(2);
    
    %Extend image using mirroring
    ext_image=zeros(i_x+Lx-1,i_y+Ly-1);
    y=zeros(i_x+Lx-1,i_y+Ly-1);
    
    %Copy the image
    ext_image(floor(Lx/2)+1:end-floor(Lx/2),floor(Ly/2)+1:end-floor(Ly/2))=image;
    
    %Mirror the image
    ext_image(1:floor(Lx/2),:)=ext_image(2*floor(Lx/2):-1:floor(Lx/2)+1,:); %North side
    ext_image(end-floor(Lx/2):end,:)=ext_image(end-floor(Lx/2)-1:-1:end-2*floor(Lx/2)-1,:); %South side
    ext_image(:,1:floor(Ly/2))=ext_image(:,2*floor(Lx/2):-1:floor(Lx/2)+1); 
    ext_image(:,end-floor(Ly/2):end)=ext_image(:,end-floor(Ly/2)-1:-1:end-2*floor(Ly/2)-1);
    
    for ii=floor(Lx/2)+1:i_x+Lx-2-floor(Lx/2)
        for jj=floor(Ly/2)+1:i_y+Ly-2-floor(Ly/2)
            view=SE.*ext_image(ii-floor(Lx/2):ii+floor(Lx/2),jj-floor(Ly/2):jj+floor(Ly/2));
            val=max(max(view));
            y(ii,jj)=val;
        end
    end    
    y=y(floor(Lx/2)+1:i_x+Lx-1-floor(Lx/2),floor(Ly/2)+1:i_y+Ly-1-floor(Ly/2));
end