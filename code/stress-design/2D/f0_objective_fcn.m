function [f0,f_tan,f_pen] = f0_objective_fcn(x,a,pfix,dim,list_free_edge,rho,framework)
f_pen = penalty_fcn(x,list_free_edge,framework,rho);
% [R,~] = formconstraints_bonds(x,a,pfix,dim);
% f_tan = tangentform_anysize(R);
% f_tan = tangentform_corank2(R);

% if there is only one free edge
% E = framework.E;
% ji = list_free_edge;
% ind1 = E(ji,1); ind2 = E(ji,2);
% p1 = x(ind1*dim-1:ind1*dim); p2 = x(ind2*dim-1:ind2*dim);
% f0 = f_pen + norm(p1-p2)^2;
% f_tan = norm(p1-p2)^2;

% f_tan is the new objective function
global stress
% f_tan
lf = free_edge_length(x,list_free_edge,framework);
f_tan = dot(stress,lf);

f0 = f_pen+f_tan;
end