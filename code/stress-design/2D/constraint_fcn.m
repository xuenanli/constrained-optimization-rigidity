% Get the constraint |xi-xj|^2-l_ij^2
function fst = constraint_fcn(x,framework)
E = framework.E;

siz = size(E);
fst = zeros(siz(1),1);
dim = framework.dim;

for ji = 1:siz(1)
    ind1 = E(ji,1); ind2 = E(ji,2); len = E(ji,3);
    p1 = x(ind1*dim-1:ind1*dim); p2 = x(ind2*dim-1:ind2*dim); 
    fst(ji) = norm(p1-p2)^2 - len^2;
end
fst = fst/2;
end