function [germ,S] = SLIC(im,K)

    [x,y] = size(im(:,:,1));
   
    S = round(sqrt((x*y)/K));
    
    coord_x = (S/2:S:x);
    coord_y = (S/2:S:y);

    [X,Y] = meshgrid(coord_x,coord_y);
    
    germ = zeros(size(X,1)*size(X,2),5);

    germ(:,1) = X(:);
    germ(:,2) = Y(:);
    
    for i=1:length(germ(:,1))
        cx = germ(i,1);
        cy = germ(i,2);
        rgb = im(cx,cy,:);
        germ(i,3) = rgb(:,1);
        germ(i,4) = rgb(:,2);
        germ(i,5) = rgb(:,3);

       
    end

    

end
   
        