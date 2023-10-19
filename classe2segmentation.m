function matrix_segmentation = classe2segmentation(matrix_label)
    n = size(matrix_label,1);
    m = size(matrix_label,2);
    matrix_segmentation = zeros(size(matrix_label));
    for i=2:n-1
        for j=2:m-1
            state = matrix_label(i,j);
            if((state ~= matrix_label(i-1,j)) || (state ~= matrix_label(i+1,j)) || (state ~= matrix_label(i,j-1)) || (state ~= matrix_label(i,j+1)))
                matrix_segmentation(i,j) = 1;
            end
        
        end    
    end