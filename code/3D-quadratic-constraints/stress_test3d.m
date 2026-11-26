function stress_test = stress_test3d(ER,stress,flex)
stress_test = 0;
dim = 3;

[m,~] = size(ER);
for k=1:m
    ind1 = ER(k,1); ind2 = ER(k,2);
    v1 = flex(ind1*dim-dim+1:ind1*dim);
    v2 = flex(ind2*dim-dim+1:ind2*dim);
    stress_test = stress_test+stress(k)*norm(v1-v2)^2;
end

end