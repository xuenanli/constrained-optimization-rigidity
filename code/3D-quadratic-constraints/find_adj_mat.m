function a = find_adj_mat(D_mat,n)
    [m,~] = size(D_mat);
    a = zeros(n);
    edge_count = 0;
    % count the edge if the distance is 1
    for k=1:m
        if abs(D_mat(k,3)-1) < 1e-10
            edge_count = edge_count+1;
            a(D_mat(k,1),D_mat(k,2)) = 1;
            a(D_mat(k,2),D_mat(k,1)) = 1;
        end
    end
end