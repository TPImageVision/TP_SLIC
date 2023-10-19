function  showGermes(germ,im)
    for i=1:length(germ(:,1))
        cx=germ(i,1);
        cy=germ(i,2);
        im(cx,cy,1) = 57;
        im(cx,cy,2) = 255;
        im(cx,cy,3) = 20;
    end
    figure;
    imshow(im);