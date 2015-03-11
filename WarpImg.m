% warp image
function  [NewImage] = WarpImg(T,Imgh1, Imgw1,Imgh2,Imgw2,Img1,Img2)
    %compute the show area
    %for (1 1)
    V1 = T*[1;1;1];
    %for (w2 1)
    V2 = T*[Imgw2;1;1];
    %for (1 h2)
    V3 = T*[1; Imgh2; 1];
    %for (w2, h2)
    V4 = T*[Imgw2; Imgh2; 1];
    
    NewPos = [V1 V2 V3 V4];
    
    Xmin = min(NewPos(1,:));
    Xmax = max(NewPos(1,:));
    Ymin = min(NewPos(2,:));
    Ymax = max(NewPos(2,:));
    Xwidth = [Xmin, Xmax];
    Yheight = [Ymin, Ymax];
    
    % the main idea is compute the second image in previous image
    % and copy the else part of the previous image
    
    % grid the new domain 
    [Xgrid, Ygrid] = ndgrid(Xwidth, Yheight);
    [NewX, NewY ] = size(Xgrid);
    
    %compute the inverse mapping of the second image
    %which means the (u, v) mapping to (x,y)
    %AX = B the solution is A \ B

    
    InverseImg = T \ [Xgrid(:) Ygrid(:) ones(NewX * NewY,1)]';
    clear NewImage;
    
    Xindex = reshape(InverseImg(1,:), NewX, NewY)';
    Yindex = reshape(InverseImg(2,:), NewX, NewY)';
    
    %we get RGB information, respectively
    NewImage(:,:,1) = interp2(Img2(:,:,1),Xindex, Yindex,'*bilinear');
    NewImage(:,:,2) = interp2(Img2(:,:,2),Xindex, Yindex, '*bilinear');
    NewImage(:,:,3) = interp2(Img2(:,:,3),Xindex, Yindex, '*bilinear');
    %compute the offset of the second images
    offset = -round( [  min( [NewPos(1,:),0] ), min( [NewPos(2,:),0] )]  )
    
    NewImage(1+offset(2): Imgh1+ offset(2),  1+ offset(1):Imgw1+offset(1), : ) = double(Img1(1:Imgh1,1:Imgw1,:));
    
    
    figure;
    image(NewImage/255);
    axis NewImage;
    title('Jason New Image');
end
