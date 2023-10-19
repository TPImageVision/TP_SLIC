function index = findIndex(x_germ,y_germ,germ_matrix)
% Cette fonction permet de retouver l'index du germe à partir de ses
% coordonnées, pour libeller les pixels.
    index = 1;
    %fprintf("valeur de _xgerm = %d et y_germ = %d \n",x_germ,y_germ);
    while((germ_matrix(index,1) ~= x_germ) && (germ_matrix(index,2) ~= y_germ))
        index = index+1;
    end
end