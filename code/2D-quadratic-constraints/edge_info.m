% construct the E matrix (edge information)
function E = edge_info(x,a,dim)
[row,col] = find(triu(a)>0);
E = zeros(length(row),3);
for i=1:length(row)
    E(i,1) = row(i); E(i,2) = col(i); 
    E(i,3) = norm(x(row(i)*dim-dim+1:row(i)*dim)-x(col(i)*dim-dim+1:col(i)*dim));
end
end
