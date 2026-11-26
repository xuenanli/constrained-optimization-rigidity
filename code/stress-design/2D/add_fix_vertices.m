% Add zero displacements to fixed vertices

function dx = add_fix_vertices(framework,dx)
pfix = framework.pfix;
n = framework.n;
dim = framework.dim;

dx_new = zeros(dim*n,1);
pfree = setdiff(1:n,pfix); % free vertices

for i = 1:n
    if find(pfree == i) % if vertex i is free
        i_ind = find(pfree == i,1);
        dx_new(2*i-1:2*i) = dx(2*i_ind-1:2*i_ind);
    else % vertex i is fixed
        dx_new(2*i-1:2*i) = 0;
    end
end
dx = dx_new;
end