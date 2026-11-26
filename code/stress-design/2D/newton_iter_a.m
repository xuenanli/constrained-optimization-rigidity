% Newton's method to project x_cur+dx back to the constraint manifold

function [wx_vec, torf, torf_small, err_Newton_final] = newton_iter_a(a_vec_init, ...
    x_cur, dx, framework, list_free_edge, N_iter_newton, tol_newton)
a_vec = a_vec_init;
iter_count = 0;
err = 1;
a = framework.a;
pfix = framework.pfix;
dim = framework.dim;
[R,~] = formconstraints_bonds(x_cur,a,pfix,dim); % get the rigidity matrix
[m,~] = size(R); % m is the number of edges
ind_list = (1:1:m);
% ind_list = ind_list(ind_list~=list_free_edge);
ind_list = setdiff(ind_list,list_free_edge);

R = R(ind_list,:);
[Q,~] = qr(R');
Q = Q(:,1:length(ind_list));

% fprintf('Start Newton method:\n')
err_Newton_final = 1;
while (iter_count <= N_iter_newton) && (err > tol_newton)
%     fprintf(['Newton teration count: ', num2str(iter_count+1), '\n'])
    wx_vec = Q*a_vec;
    wx_vec = add_fix_vertices(framework,wx_vec); % size change

    [R_new,~] = formconstraints_bonds(x_cur+dx+wx_vec,a,pfix,dim);
    R_new = R_new(ind_list,:);
    R_a_mat = R_new * Q;

    fst = constraint_fcn(x_cur+dx+wx_vec,framework);
    fst = fst(ind_list);
    a_vec = a_vec - R_a_mat \ fst;
    wx_vec = Q*a_vec;
    wx_vec = add_fix_vertices(framework,wx_vec); % size change

    fst = constraint_fcn(x_cur+dx+wx_vec,framework); % current error in Newton
    fst = fst(ind_list);
    err = norm(fst);
%     fprintf(sprintf('Current error in Newton: %.4e.\n',err))
    iter_count = iter_count + 1;
end

if err > tol_newton
    fprintf('Newton iteration Failed!!\n\n')
    torf = false;
else
%     fprintf('End of Newton iteration.\n\n')
    torf = true;
    err_Newton_final = err;
end

if iter_count <= 1
    torf_small = true;
else
    torf_small = false;
end

end