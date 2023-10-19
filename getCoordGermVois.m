function germ_voisin = getCoordGermVois(x_min,x_max,y_min,y_max,germ)  

    L = ((germ(:,1) >= x_min & germ(:,1)  <= x_max) &  (germ(:,2) >= y_min & germ(:,2) <= y_max));

    %L=data(:,1)<25 & data(:,2)>30
    germ_voisin=germ(L,:);
    

        

  