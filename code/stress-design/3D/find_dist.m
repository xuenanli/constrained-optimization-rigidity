function D_mat = find_dist(x,dim,n)
D_mat = zeros(n*(n-1)/2,3);
k = 1;
for i=1:n
    for j=i+1:n
        D_mat(k,1) = i; D_mat(k,2) = j; 
        x1 = x(dim*i-dim+1:dim*i);
        x2 = x(dim*j-dim+1:dim*j);
        D_mat(k,3) = norm(x1-x2); 
        k = k+1;
    end
end
end