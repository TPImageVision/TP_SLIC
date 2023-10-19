function [x_min,x_max,y_min,y_max] = getVoisinagePixelIJ(im,S,x,y)
    [sizeX,sizeY] = size(im(:,:,1));
    x_min = max([1,x-S]);
    x_max = min([sizeX,x+S]);
    y_min = max([1,y-S]);
    y_max = min([sizeY,y+S]);

