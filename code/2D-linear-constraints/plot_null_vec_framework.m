function plot_null_vec_framework(framework,N_vec)
x = framework.x; % locations of vertices
n = framework.n;
dim = framework.dim;
if dim == 2
    for i = 1:n
    quiver(x(i*2-1), x(2*i), N_vec(2*i-1), N_vec(2*i), ...
        0.5, 'g', 'LineWidth',2, 'MaxHeadSize',1)
    end
else
    for i = 1:n
        quiver3(x(i*3-2), x(i*3-1), x(i*3),N_vec(i*3-2), N_vec(i*3-1),  N_vec(i*3), ...
        0.5, 'g', 'LineWidth',2, 'MaxHeadSize',1)
    end
end
end
