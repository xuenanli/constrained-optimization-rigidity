function lf = free_edge_length(x,list_free_edge,framework)
lf = zeros(length(list_free_edge),1);
E = framework.E;
d = framework.dim;

for i=1:length(list_free_edge)
    el = list_free_edge(i);
    p1 = E(el,1); p2 = E(el,2); 
    lf(i) = norm(x(p1*d-(d-1):p1*d)-x(p2*d-(d-1):p2*d))^2;
end