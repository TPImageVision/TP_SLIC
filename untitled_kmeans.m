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
% Nombre de superpixels recherchés
K = 400;
for n = 1:4
    % Pour aller de 8 en 8 (1,9,17,25)
    n_calc = ((n-1) * 8)+1;
    
    %% Initialisation
    im_n = double(im(:,:,:,n_calc));
    % Initialisation des centres
    %[germ,S] = SLIC(im_1,K);
    [h,w] = size(im_n(:,:,1));
    
    S = sqrt((h*w)/K);
    
    [X,Y] = meshgrid(S/2:S:h,S/2:S:w);
    
    germ = zeros(size(X,1)*size(X,2),5);
    
    germ(:,1) = X(:);
    germ(:,2) = Y(:);
    
    for i=1:size(germ,1)
        cx = germ(i,1);
        cy = germ(i,2);
        rgb = im_n(round(cx),round(cy),:);
        germ(i,3) = rgb(:,1);
        germ(i,4) = rgb(:,2);
        germ(i,5) = rgb(:,3);
    end
    
    K = size(germ,1);
    % Gestion de la compacité (m = S par défaut)
    m = S;
    % coté du voisinage d'un germe
    n_voisin = 3;
    
    %% Affinement de la grille
    [Gx,Gy] = imgradient(rgb2gray(im(:,:,:,n)));
    grad = (double(Gx)+double(Gy))/2;
    
    for i = 1:size(germ,1)
        x_germ = germ(i,1);
        y_germ = germ(i,2);
        x_min = max(1,x_germ-1);
        x_max = min(h,x_germ+1);
        y_min = max(1,y_germ-1);
        y_max = min(w,y_germ+1);
        % Voisinage n du germe
        voisinage = Gy(x_min:x_max,y_min:y_max);
        % Valeur minimale dans le voisinage
        [valeur,indice]=min(voisinage(:));
        [indX,indY] = ind2sub(size(voisinage),indice);
        x_newgerm = floor(x_min+(indX-1));
        y_newgerm = floor(y_min+(indY-1));
        % Mise à jour du germe
        germ(i,1:2) = [x_newgerm y_newgerm];
        germ(i,3:5) = im_n(x_newgerm,y_newgerm,1:3);
    end
    
    %% Kmeans
    % Transformation de l'image au format des germes et compacité
    im_kmeans = zeros(h*w,5);
    ligne=1;
    for x=1:h
        for y=1:w
            im_kmeans(ligne,:)=[x*(m/S) y*(m/S) im_n(x,y,1) im_n(x,y,2) im_n(x,y,3)];
            ligne=ligne+1;
        end
    end
    % Compacité sur les germes
    for ligne=1:K
       germ(ligne,1)=germ(ligne,1)*(m/S);
       germ(ligne,2)=germ(ligne,2)*(m/S);
    end
    [res_kmeans, new_germ] = kmeans(im_kmeans,K,'Start',germ,'EmptyAction','drop');
    % Annulation de la compacité sur les germes résultants
    for ligne=1:size(new_germ,1)
       new_germ(ligne,1)=new_germ(ligne,1)*(S/m);
       new_germ(ligne,2)=new_germ(ligne,2)*(S/m);
    end
    matrix_label = (reshape(res_kmeans,size(im_n,2),size(im_n,1)))';
    mask = boundarymask(matrix_label);
    %% Amélioration de la connexité
    
    
    %% Binarisation
    mat_binarisation = zeros(size(im_n(:,:,1)));
    mat_cluster = new_germ(:,3) > new_germ(:,5)+3;
    new_germ(:,6) = mat_cluster;
    
    for i=1:h
        for j=1:w
            mat_binarisation(i,j) = new_germ(matrix_label(i,j),6);
        end
    end

    figure;
    imshow(labeloverlay(im(:,:,:,n_calc),mask,'Transparency',0));
    figure;
    imshow(mat_binarisation);
end