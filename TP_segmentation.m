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
    end;
    % im est une matrice de dimension 4 qui contient 
    % l'ensemble des images couleur de taille : nb_lignes x nb_colonnes x nb_canaux 
    % im est donc de dimension nb_lignes x nb_colonnes x nb_canaux x nb_images
    im(:,:,:,i) = imread(nom); 
end;

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
im_1 = im(:,:,:,1);
im(:,:,:,1) = double(im(:,:,:,1));
figure;
[germ,S] = SLIC(im_1,100);
m = 1;
% coté du voisinage d'un germe
n = 3;

germ = double(germ);


matrix_label = zeros(size(im_1(:,:,1)));


%% Algorithme

%% Affinement de la grille
% [gradx,grady] = imgradient(rgb2gray(im(:,:,:,1)));
% 
% %imshow(grady);
% 
% grad = (gradx +grady)/2 ;
% 
% for i=1:size(germ,1)
%     newGerm(grad,germ,n,i);
% end    




%% Evolution des centres de chaque super pixel

for x=1:size(im_1(:,:,1),1)
    for y=1:size(im_1(:,:,1),2)
        [x_min,x_max,y_min,y_max] = getVoisinagePixelIJ(im,S,x,y);
        germ_voisin = getCoordGermVois(x_min,x_max,y_min,y_max,germ);
        distance_germ = zeros(size(germ_voisin,1),3);

        for i=1:size(distance_germ,1)
            distance_germ(i,1:2) = germ_voisin(i,1:2);
            distance_germ(i,3) = sqrt((double(im(x,y,1,1))-double(germ_voisin(i,3)))^2 + (double(im(x,y,2,1))-double(germ_voisin(i,4)))^2 + (double(im(x,y,3,1))-double(germ_voisin(i,5)))^2)  + (m/S)*sqrt((x-double(germ_voisin(i,1)))^2 + (y-double(germ_voisin(i,2)))^2);        
        end
        %fprintf("pixel actuel fini : %d, ce pixel possède des distances de taille : %d \n",x+y,size(distance_germ));
        [useless ,index_min] = min(distance_germ(:,3));
        germ_coord_min = distance_germ(index_min,1:2);
        classe_pixel = findIndex(germ_coord_min(1),germ_coord_min(2),germ);
        matrix_label(x,y) = classe_pixel;
    end
    
   
end  

matrx_segmentation = classe2segmentation(matrix_label);


imshow(matrx_segmentation);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Binarisation de l'image à partir des superpixels        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ........................................................%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET COMPLETER                              %
% quand vous aurez les images segmentées                  %
% Affichage des masques associes                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% subplot(2,2,1); ... ; title('Masque image 1');
% subplot(2,2,2); ... ; title('Masque image 9');
% subplot(2,2,3); ... ; title('Masque image 17');
% subplot(2,2,4); ... ; title('Masque image 25');

