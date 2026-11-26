function [err_data,x_cur] = optimization_stress(x_cur, framework, num_free_edge, ...
    list_free_edge, varargin)

global N_iter_newton tol_newton N_iter_opt tol_opt eta grad_tol tan_tol
global rho h
global tau
global sigma

beta = 0; % using gradient descent

if(nargin > 4)
    name = varargin{1};
    v = VideoWriter(name,'MPEG-4');
else
    v = VideoWriter('bar-framework','MPEG-4');
end

% save error
err_opt_list = zeros(1,N_iter_opt);
err_Newton_final_list = zeros(1,N_iter_opt);
tangentform_list = zeros(1,N_iter_opt);
penalty_list = zeros(1,N_iter_opt);
diff_list = zeros(1,N_iter_opt);

v.FrameRate = 10;
open(v);
cla;

x = framework.x;
a = framework.a;
pfix = framework.pfix;
dim = framework.dim;
E = framework.E;
[e,~] = size(E); % e is the number of edges

cur_framework = framework;
cur_framework.x = x_cur;

figure(1)
plot_framework(cur_framework,list_free_edge)
axis equal
axis([-3 3 -1 5])
% axis([-5 5 -5 5])
% axis([-1 2 -1 2])
set(gca,'nextplot','replacechildren');
% lim_max = max(abs(x)) + 0.5;
% xlim([-2*lim_max 2*lim_max])
% ylim([-2*lim_max 2*lim_max])
F(1) = getframe(gcf);
writeVideo(v,F(1));

f0_prev = 0;

iter_opt_count = 0;
err_opt = 1;

opt_prev = 0;

[R,~] = formconstraints_bonds(x_cur,a,pfix,dim);
f_tan = target_stress(x_cur,list_free_edge,framework);
update_tf = false;
f_tan_prev = -1e4;
while (iter_opt_count <= N_iter_opt) && err_opt > tol_opt % (err_opt > tol_opt)
    fprintf(['Optimization iteration count: ', num2str(iter_opt_count+1), '.\n'])

    [dx, grad_tan_approx, grad_pen_approx] = approx_grad_obj_fcn(x_cur,a,pfix,dim,h,list_free_edge,rho,framework);
    dx = -dx * eta;
    
    pen_tf = norm(grad_tan_approx) < norm(grad_pen_approx);
    tan_tf = (norm(grad_tan_approx) < grad_tol) && (f_tan > tan_tol);
    new_tf = tan_tf || pen_tf || update_tf;
    
%     if new_tf
%         fprintf('Generating new vertices!!!\n')
%         dx = random_generator(x,pfix,sigma); % generate new vertices
%     end

    a_vec_init = zeros(e-num_free_edge,1);
    [wx_vec, torf, torf_small, err_Newton_final] = newton_iter_a(a_vec_init, ...
    x_cur, dx, framework, list_free_edge, N_iter_newton, tol_newton);
    err_Newton_final_list(iter_opt_count+1) = err_Newton_final;

    while ~torf % if Newton's method failed
        eta = eta/2; % get a smaller step size
        dx = dx/2;
        fprintf(sprintf('Current eta: %.4e.\n', eta))
        [wx_vec, torf, torf_small, err_Newton_final] = newton_iter_a(a_vec_init, ...
    x_cur, dx, framework, list_free_edge, N_iter_newton, tol_newton);
        err_Newton_final_list(iter_opt_count+1) = err_Newton_final;
    end
%     if torf_small && norm(dx) < 1e-4 && length(list_free_edge) ~= e% if step size is too small
%         eta = eta*2;
%         fprintf('Enlarge step size!!!\n\n')
%     end

    y_cur = x_cur+dx+wx_vec;
    %[Ry,~] = formconstraints_bonds(y_cur,a,pfix,dim);
    f_tan_y = target_stress(y_cur,list_free_edge,framework);
    alpha = exp(-beta*f_tan) / exp(-beta*f_tan_y);
    u = rand(1);
    fprintf(sprintf('Current alpha is: %.4e.\n', alpha))
    fprintf(sprintf('Current u is: %.4e.\n', u))
    if u <= alpha
        fprintf('Accepting the new vertices!!!\n')
        x_cur = y_cur; % accept otherwise reject
    end
    % x_cur = x_cur+dx+wx_vec; % update the current framework
    cur_framework = framework;
    cur_framework.x = x_cur;

    % plot framework
    cla;
    plot_framework(cur_framework,list_free_edge)
%     xlim([-2*lim_max 2*lim_max])
%     ylim([-2*lim_max 2*lim_max])
    
    % write the video
    F(iter_opt_count+1) = getframe(gcf);
    writeVideo(v,F(iter_opt_count+1));
    
    % save current optimization error
%     err_opt = f0_tan_form_corank_1(x_cur,a,pfix,dim); % current optimization error
    f0_cur = f0_objective_fcn(x_cur,a,pfix,dim,list_free_edge,rho,framework);
    err_opt = max(abs(f0_cur - f0_prev));
    f0_prev = f0_cur;

    iter_opt_count = iter_opt_count + 1;
    err_opt_list(iter_opt_count) = f0_cur;
%     fprintf(sprintf('Current target function: %.4e.\n', f0_cur))
    
    [R,~] = formconstraints_bonds(x_cur,a,pfix,dim);
    f_tan_prev = f_tan;
    f_tan = target_stress(x_cur,list_free_edge,framework);
    f_pen = penalty_fcn(x_cur,list_free_edge,framework,rho);
%     opt_cur = norm(R(list_free_edge,:));
%     err_opt = max(f_tan,abs(opt_prev - opt_cur));
%     opt_prev = opt_cur;
    
    update_tf = (abs(f_tan_prev - f_tan) < tan_tol) && (f_tan_prev <= f_tan);
    tangentform_list(iter_opt_count) = f_tan;
    penalty_list(iter_opt_count) = f_pen;
    diff_list(iter_opt_count) = err_opt;

    fprintf(sprintf('Current penalty function: %.4e.\n', f_pen))
    fprintf(sprintf('Current objective function: %.4e.\n', f_tan))
    fprintf(sprintf('Current optimizatoin error: %.4e.\n\n', err_opt))
end

close(v)
err_opt_list = err_opt_list(1:iter_opt_count);
err_Newton_final_list = err_Newton_final_list(1:iter_opt_count);
tangentform_list = tangentform_list(1:iter_opt_count);
penalty_list = penalty_list(1:iter_opt_count);
diff_list = diff_list(1:iter_opt_count);

err_data.err_opt_list = err_opt_list;
err_data.err_Newton_final_list = err_Newton_final_list;
err_data.tangentform_list =  tangentform_list;
err_data.penalty_list = penalty_list;
err_data.diff_list = diff_list;

end