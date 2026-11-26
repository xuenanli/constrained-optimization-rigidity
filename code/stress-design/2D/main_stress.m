%% framework initialization
clear;
clc;
% over-constrained framework
% DT initialization
global l_max
l_max = 5; % the cube size

% n = 20;
% framework = rand_DT(n);
% framework = isostatic_square;
framework = stressed_framework_square(1,4);

x = framework.x;
a = framework.a;
pfix = framework.pfix;
dim = framework.dim;

% [R,E] = formconstraints_bonds_free(x,a,pfix,dim);
[R,E] = formconstraints_bonds(x,a,pfix,dim);

R = full(R);
% Rmod = R;
% Rmod(8,:) = [];
% Rmod(4,:) = [];
framework.E = E;

figure(1)
plot_framework(framework);
axis equal

N = null(R);
fprintf(['The rank of the rigidity matrix is: ', int2str(rank(R)), '.\n\n'])

% print framework data
% siz = size(R);
% fprintf(['Number of vertcies: ', int2str(framework.n), '.\n'])
% fprintf(['Number of free vertcies: ', int2str(siz(2)/framework.dim), '.\n'])
% fprintf(['Number of edges: ', int2str(siz(1)), '.\n\n'])
% if rank(R) == min(siz(1),siz(2))
%     fprintf('This framework is REGULAR!\n')
% else
%     fprintf('This framework is SINGULAR!\n')
%     fprintf(['The rank of rigidity matrix is: ', int2str(rank(R)), '.\n'])
%     fprintf(['The corank of this framework: ', int2str(-rank(R)+siz(1)), '.\n\n'])
% end

fprintf(['The rank of rigidity matrix is: ', int2str(rank(R)), '.\n'])
% second-order stress test
S = null(R','rational'); % the only self-stress
[~,nstress] = size(S);
fprintf(['Number of self-stress is: ',num2str(nstress),'.\n'])

%% optimization
% list_free_edge = [1,3];
% data = load('list-free-edges-1-4.mat');
% list_free_edge = data.list_free_edge;
% AC, BD, CE, DF, EG, FH, GI, HJ in Figure 5(a).
list_free_edge = [1,4,6,9,11,14,16,19];
num_free_edge = length(list_free_edge);
global stress
% stress = [1,2];
% stress = 2*(rand(1,2)-1/2);
stress = [1,1/2,1/4,1/8,1,1/2,1/4,1/8];

x = framework.x;
a = framework.a;
pfix = framework.pfix;
n = framework.n;
dim = framework.dim;

[R,E] = formconstraints_bonds(x,a,pfix,dim);
framework.E = E;
figure(1)
plot_framework(framework)
rank(full(R))

% initialization of global variables
global rho h grad_tol tan_tol
global tau sigma
global N_iter_newton tol_newton N_iter_opt tol_opt eta

% list_free_edge = [2,3];
% num_free_edge = length(list_free_edge);

tau = 1e0; % controls the objective fcn w.r.t tangent form 
rho = 1e0; % regularization ratio
sigma = 1/4; % randomness radius
h = 1e-12; % numerical gradient
grad_tol = 1e-12; % gradient tolerance
tan_tol = 1e-12;
 
N_iter_newton = 10; % iteration number for Newton
tol_newton = 1e-8; % tolerance for newton
N_iter_opt = 1e3; % total iteration number
tol_opt = 1e-18; % tolerance for optimization
eta = 1e-1; % step size

x_cur = framework.x; % initial condition given by the framework
% x_cur = x_cur_save; % save the result for previous iteration

[opt_data, x_cur] = optimization_stress(x_cur, framework, num_free_edge, ...
    list_free_edge);

framework_cur = framework;
framework_cur.x = x_cur;
x_cur_save = x_cur;
save('final-framework1-4.mat','framework_cur')

%%
xc = framework_cur.x;
a(pfix(1),pfix(2)) = 1; a(pfix(2),pfix(1)) = 1;

[Rc,Ec] = formconstraints_bonds(xc,a,[],dim);
Rc = full(Rc);

% find the four self-stresses
[U,S,V] = svd(Rc); S = diag(S);
Nright = U(:,end-3:end);

% Adding the edge between the two pinned vertices shifts the edge rows.
[~,full_edge_index] = ismember(E(list_free_edge,1:2),Ec(:,1:2),'rows');
stress_edge = Nright(full_edge_index,:);
weight = stress_edge \ stress(:);
norm(stress_edge*weight-stress(:))
