% Get the constraint rho*/|xi-xj|^2
function fst = penalty_fcn(x,list_free_edge,framework,rho)
E = framework.E;

siz = size(E);
dim = framework.dim;
fst = 0;

for ji = 1:siz(1)
    ind1 = E(ji,1); ind2 = E(ji,2);
    p1 = x(ind1*dim-1:ind1*dim); p2 = x(ind2*dim-1:ind2*dim);
    l_cur = E(ji,3); % the original length of the bar
    if find(list_free_edge==ji,1)
%         fst = fst + 1/norm(p1-p2)^2;
        temp = min(norm(p1-p2), l_cur/4);
        temp = temp - l_cur/4;
        fst = fst + log(sec(pi/l_cur*temp));
    end
end
fst = fst*rho;
end