clear;
close all;
% Nombre d'images utilisees
nb_images = 36; 

% chargement des images
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end
    % im est une matrice de dimension 4 qui contient 
    % l'ensemble des images couleur de taille : nb_lignes x nb_colonnes x nb_canaux 
    % im est donc de dimension nb_lignes x nb_colonnes x nb_canaux x nb_images
    im(:,:,:,i) = imread(nom); 
end

% Affichage d'exemples d'images
figure; 
subplot(2,2,1); imshow(im(:,:,:,1)); title('Image 1');
subplot(2,2,2); imshow(im(:,:,:,9)); title('Image 9');
subplot(2,2,3); imshow(im(:,:,:,17)); title('Image 17');
subplot(2,2,4); imshow(im(:,:,:,25)); title('Image 25');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Calculs des superpixels                                 % 
% Conseil : afficher les germes + les régions             %
% à chaque étape / à chaque itération                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ........................................................%
%% Initialisation

im_1 = double(im(:,:,:,1));
figure;
[germ,S] = SLIC(im_1,100);
m = 1;
% coté du voisinage d'un germe
n = 3;

matrix_label = - ones(size(im_1(:,:,1)));
matrix_distance = zeros(size(im_1(:,:,1)));
matrix_distance(:,:) = realmax;
current_distance = zeros(size(matrix_distance));

[h,w] = size(current_distance);

matrix_condition = zeros(size(matrix_label));

n_step = 0;

%% Test
[L1,Numlabel] = superpixels3(im_1,120);

%% Algorithme

%% Affinement de la grille
[Gx,Gy] = imgradient(rgb2gray(im_1));
    
grad = (double(Gx)+double(Gy))/2;


%% Partie itérative 

while (n_step<1)
    for i=1:size(germ,1)
        x_germ = germ(i,1);
        y_germ = germ(i,2);
       
        current_distance(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)) = sqrt((double(im_1(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S),3))-double(germ(i,3))).^2 + (double(im(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S),4))-double(germ(i,4))).^2 + (double(im(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S),5))-double(germ(i,5))).^2) + (m/S)*sqrt(double(im_1(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S),1).^2)  + double(im_1(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S),2)).^2);        
        
        matrix_condition(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)) = current_distance(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)) < matrix_distance(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S));

        matrix_distance(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)) = matrix_distance(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)).*abs(matrix_condition(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S))-1) + matrix_condition(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)).*current_distance(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S));
        matrix_label(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)) = matrix_label(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S)).*abs(matrix_condition(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S))-1) + matrix_condition(max(1,x_germ-S):min(h,x_germ+S),max(1,y_germ-S):min(w,y_germ+S))*i;

    end
    fprintf("n = %d \n",n_step)
    n_step = n_step + 1;
end


matrix_segmentation = classe2segmentation(matrix_label);

imshow(matrix_segmentation);







