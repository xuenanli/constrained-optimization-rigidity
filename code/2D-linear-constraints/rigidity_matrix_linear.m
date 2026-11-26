function [R,ER] = rigidity_matrix_linear(framework,L)

x = framework.x;
a = framework.a;
pfix = framework.pfix;
dim = framework.dim;
n = framework.n;

% add the fixed edge
a(pfix(1),pfix(2)) = 1;
a(pfix(2),pfix(1)) = 1;

% first store the quadratic rigidity matrix part
[Rq,ER] = formconstraints_bonds(x,a,pfix,dim);

[m,~] = size(L);
Rl = zeros(m*dim,n*dim);
for k=1:m
    p1 = L(k,1); p2 = L(k,2); p3 = L(k,3); ratio = L(k,4);
    for i=1:dim
        Rl(k*dim-dim+i,p1*dim-dim+i) = ratio;
        Rl(k*dim-dim+i,p2*dim-dim+i) = 1-ratio;
        Rl(k*dim-dim+i,p3*dim-dim+i) = -1;
    end
end
% also add the fixed edge

R = [Rq;Rl];
end