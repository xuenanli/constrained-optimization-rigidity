function fs = target_stress(x,list_free_edge,framework)
global stress
lf = free_edge_length(x,list_free_edge,framework);
fs = dot(stress,lf);
end