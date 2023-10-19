function newgerm_mat = newGerm(grad,germ,n,i)
    % grad : matrix gradient de l'image (somme de grady et gradx)
    % germ : matrix qui contient tous les germes et leurs couleurs,
    % n : côté du carré du voisinage
    % i : ième germe

    [h,w] = size(grad);

    min_grad_mat = grad(max(1,i-n):min(w,i+n),max(1,i-n):min(h,i+n));

