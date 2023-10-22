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

figure;
imshow(im(:,:,:,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Calculs des superpixels                                 % 
% Conseil : afficher les germes + les régions             %
% à chaque étape / à chaque itération                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ........................................................%
%% Initialisation

im_1 = double(im(:,:,:,1));
K = 200;
[germ,S] = SLIC(im_1,K);
K = size(germ,1);
m = 1;
% coté du voisinage d'un germe
n = 3;

matrix_label = - ones(size(im_1(:,:,1)));
matrix_distance = zeros(size(im_1(:,:,1)));
matrix_distance(:,:) = realmax;
current_distance = zeros(size(matrix_distance));

[h,w] = size(current_distance);

%% Affinement de la grille

[Gx,Gy] = imgradient(rgb2gray(im(:,:,:,1)));
grad = (double(Gx)+double(Gy))/2;
for i = 1:size(germ,1)
    x_germ = germ(i,1);
    y_germ = germ(i,2);
    x_min = max(1,x_germ-1);
    x_max = min(h,x_germ+1);
    y_min = max(1,y_germ-1);
    y_max = min(w,y_germ+1);
    % Voisinage n du germe

    voisinage = grad(x_min:x_max,y_min:y_max);
    % Valeur minimale dans le voisinage

    [valeur,indice]=min(voisinage(:));
    [indX,indY] = ind2sub(size(voisinage),indice);
    x_newgerm = x_min+(indX-1);
    y_newgerm = y_min+(indY-1);
    % Mise à jour du germe

    germ(i,1) = x_newgerm;
    germ(i,2) = y_newgerm;
    germ(i,3) = im_1(x_newgerm,y_newgerm,1);
    germ(i,4) = im_1(x_newgerm,y_newgerm,2);
    germ(i,5) = im_1(x_newgerm,y_newgerm,3);

end

%% Kmeans
% Transformation de l'image au format des germes et attenuation
im_kmeans = zeros(h*w,5);
ligne=1;
for x=1:h
    for y=1:w
        im_kmeans(ligne,:)=[x*(m/S) y*(m/S) im_1(x,y,1) im_1(x,y,2) im_1(i,y,3)];
        ligne=ligne+1;
    end
end
for ligne=1:K
   germ(ligne,1)=germ(ligne,1)*(m/S);
   germ(ligne,2)=germ(ligne,2)*(m/S);
end
[res_kmeans, new_germ] = kmeans(im_kmeans,K,'Start',germ,'EmptyAction','drop');
for ligne=1:size(new_germ,1)
   new_germ(ligne,1)=new_germ(ligne,1)*(S/m);
   new_germ(ligne,2)=new_germ(ligne,2)*(S/m);
end
matrix_label = (reshape(res_kmeans,size(im_1,2),size(im_1,1)))';
figure;
matrix_segmentation = classe2segmentation(matrix_label);
imshow(matrix_segmentation);

%% Binarisation

% Initialisation
mat_binarisation = zeros(size(im_1(:,:,1)));
mat_cluster = zeros(size(new_germ,1));

mat_cluster = new_germ(:,3) > 170;

new_germ(:,6) = mat_cluster;

for i=1:h
    for j=1:w
        mat_binarisation(i,j) = new_germ(matrix_label(i,j),6);
    end
end

figure;
imshow(mat_binarisation)