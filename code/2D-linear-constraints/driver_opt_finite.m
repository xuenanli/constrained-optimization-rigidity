% initialization of bar framework
clc;
clear;

% The square system with linear constraints definitely has 1 internal DOF
% By pinning two vertices, there are 10 free vertices --> 20 DOF
% There are 11 edges with quadratic constraints and 4x2 linear constraints

% choose the bar framework
Lambda = zeros(4,1);
Lambda = Lambda +1/2;
% framework = square_linear(Lambda);
% framework = square_linear_pert(Lambda);
% framework = square_linear_test;
framework = square_linear_pert_inner(Lambda);
E = framework.E;
n = framework.n;
dim = framework.dim;
pfix = framework.pfix;
x = framework.x;

limx = [-3, 7];
limy = [-1, 5];

% Video name
video_name = 'square-midpoint-min.mp4';

% Define the free edge
free_edge_list = 4;

figure(1)
plot_framework_2D(framework, free_edge_list)
axis equal
xlim(limx)
ylim(limy)

% Build the linear constraints
L = zeros(4,4);
L(1,:) = [1,2,5,Lambda(1)]; % store the x5 = 1/2 x1+ 1/2 x2
L(2,:) = [2,3,6,Lambda(2)]; % store the x6 = 1/2 x2+ 1/2 x3
L(3,:) = [3,4,7,Lambda(3)]; % store the x7 = 1/2 x3+ 1/2 x4
L(4,:) = [4,1,8,Lambda(4)]; % store the x8 = 1/2 x4+ 1/2 x1

R = rigidity_matrix_linear(framework,L);
R = full(R);

S = svd(R);

fprintf(sprintf('The smallest singular value is: %.4e.\n\n',S(end)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function definition

points = sym('p', [n*dim, 1]);
[m,~] = size(E);

% objective function
Fo = sym(length(free_edge_list));
for i=1:length(free_edge_list)
    e = free_edge_list(i);
    ind1 = E(e,1); ind2 = E(e,2); 
    p1 = points(ind1*dim-dim+1:ind1*dim);
    p2 = points(ind2*dim-dim+1:ind2*dim);
    Fo(i) = (p1(1)-p2(1))^2+(p1(2)-p2(2))^2;
end
Fo = sum(Fo);
Fo_grad = gradient(Fo,points);

% quadratic constraint functions Fc
[lm,~] = size(L);
Fc = sym(m-length(free_edge_list)+length(pfix)*dim+lm*dim);

% the edges with fixed lengths
Efix = E;
Efix(free_edge_list,:) = [];
% edge constraints
for i=1:m-length(free_edge_list)
    ind1 = Efix(i,1); ind2 = Efix(i,2); 
    p1 = points(ind1*dim-dim+1:ind1*dim);
    p2 = points(ind2*dim-dim+1:ind2*dim);
    Fc(i) = (p1(1)-p2(1))^2+(p1(2)-p2(2))^2 - Efix(i,3)^2;
end
Fc = Fc';

% One pinning constraints: fix the two ends of an edge
% pinning constraints
for k=1:length(pfix)
    ind = pfix(k);
    Fc(m-length(free_edge_list)+(k-1)*dim+1:m-length(free_edge_list)+k*dim) ...
        = points(ind*dim-dim+1:ind*dim) - x((ind*dim-dim+1:ind*dim));
end

% Add the linear constraints
for k=1:lm
    ind1 = L(k,1); ind2 = L(k,2); ind3 = L(k,3); ratio = L(k,4);
    k_ind = m-length(free_edge_list)+length(pfix)*dim+k*dim-dim;
    for i=1:dim
        Fc(k_ind+i) = ratio*points(ind1*dim-dim+i)+(1-ratio)*points(ind2*dim-dim+i)...
                    -points(ind3*dim-dim+i);
    end
end

% take the Jacobian matrix
J_mat = jacobian(Fc, points);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% start the optimization
clc;

% initialization
% xc = x_save;
xc = x;
framework_cur = framework;
framework_cur.x = xc;

% open video
video = VideoWriter(video_name, 'MPEG-4');
video.FrameRate = 5; % Frames per second
open(video);
figure(1)
plot_framework_2D(framework,free_edge_list)
% plot_framework_2D(framework_cur,free_edge_list)
axis equal
xlim(limx)
ylim(limy)

frame = getframe(gcf); % Capture the frame
writeVideo(video, frame); % Write the frame to video

% optimization setup
eta_init = 1e-1; % step size
Max_iter = 1e3; % Max iteration number
tol = 1e-8; % optimization termination error
Fo_list = zeros(Max_iter,1); % storing Fo

err = 1;
opt_err = 1;
count = 0;
while count < Max_iter & err > tol
    cla;
    count = count + 1;
    fprintf(['Current iteration count:', int2str(count),':\n'])

    xp = xc;
    eta = eta_init-1*count*eta_init/2/Max_iter;
    dxc = -eta*double(subs(Fo_grad,points,xc)); % descent direction
    
    % Newton's update
    xc = newton_a(xc,dxc,Fc,J_mat,points);

    % store the objective
    Fo_eval = double(subs(Fo,points,xc));
    Fo_list(count) = Fo_eval;

    err = norm(xc-xp);
    fprintf(sprintf('Difference between previous x and current x is: %.4e.\n',err))
    opt_err = abs(Fo_eval-double(subs(Fo,points,xp)));
    fprintf(sprintf('Optimization error is: %.4e.\n',opt_err))
    fprintf(sprintf('Current objective function is: %.4e.\n\n',Fo_eval))

    % plot the current framework
    framework_cur = framework;
    framework_cur.x = xc;
    plot_framework_2D(framework_cur,free_edge_list)
    axis equal
    xlim(limx)
    ylim(limy)

    frame = getframe(gcf); % Capture the frame
    writeVideo(video, frame); % Write the frame to video
end

close(video) % Close the video
Fo_list = Fo_list(1:count);
% plot the objective function
figure(3)
plot(1:count, Fo_list, 'b-', 'LineWidth',2)
title('Value of the objective','FontSize',14)

%% 2D Rigidity tests
clc;

framework_cur = framework;
framework_cur.x = xc;

save('init-framework.mat','framework')
save('final-framework.mat','framework_cur')

Rc = rigidity_matrix_linear(framework_cur,L);
Rc = full(Rc);

Sc = svd(Rc);

fprintf(sprintf('The smallest singular value for the final framework is: %.4e.\n\n',Sc(end)))

figure(4)
plot_framework_2D(framework,free_edge_list)
axis equal
xlim(limx)
ylim(limy)

figure(5)
plot_framework_2D(framework_cur,free_edge_list)
axis equal
xlim(limx)
ylim(limy)

%% Find the first-order flexes and the stress
[Uc,Sc,Vc] = svd(Rc);
Sc = diag(Sc);

% Only one self-stress
% Sc(end-3:end)

N_left = Uc(:,end);
N_right = Vc(:,end-4:end);

% find the infinitesimal 3 rigid body motions
t1 = zeros(size(xc)); t2 = zeros(size(xc));
t1(1:2:end) = 1; t2(2:2:end) = 1;
t3 = inf_rotation_2D(xc);

num_rigid = 3;

[Q,~] = qr([t1,t2,t3,N_right]);
% Orthonormal basis for the infinitesimal rigid body motions
q1 = Q(:,1);
q2 = Q(:,2);
q3 = Q(:,3);

% The rest non-trivial first-order flex
q4 = Q(:,4);
q5 = Q(:,5);

figure(6)
plot_framework_2D(framework_cur,free_edge_list)
hold on
plot_null_vec_framework(framework_cur,2*q4)
title('First non-trivial first-order flex','FontSize',16)

figure(7)
plot_framework_2D(framework_cur,free_edge_list)
hold on
plot_null_vec_framework(framework_cur,2*q5)
title('Second non-trivial first-order flex','FontSize',16)

% the original second-order rigidity test
stress_test1 = 0;
stress_test2 = 0;

[~,ER] = rigidity_matrix_linear(framework_cur,L);

[mE,~] = size(ER);
for k=1:mE
    ind1 = ER(k,1); ind2 = ER(k,2);
    v1 = q4(ind1*dim-dim+1:ind1*dim);
    v2 = q4(ind2*dim-dim+1:ind2*dim);
    stress_test1 = stress_test1+N_left(k)*norm(v1-v2)^2;

    v1 = q5(ind1*dim-dim+1:ind1*dim);
    v2 = q5(ind2*dim-dim+1:ind2*dim);
    stress_test2 = stress_test2+N_left(k)*norm(v1-v2)^2;
end
stress_test1
stress_test2

%% Find the sign of the stress test
Na = 1e4;
angle_list = linspace(0,pi,Na+1);
stress_test_list = zeros(1,Na+1);

for i=1:Na+1
    stress_test = 0;
    for k=1:mE
        ind1 = ER(k,1); ind2 = ER(k,2);
        q = q4*cos(angle_list(i)) + q5*sin(angle_list(i));
        v1 = q(ind1*dim-dim+1:ind1*dim);
        v2 = q(ind2*dim-dim+1:ind2*dim);
        stress_test = stress_test+N_left(k)*norm(v1-v2)^2;
    end
    stress_test_list(i) = stress_test;
end

min(stress_test_list)
max(stress_test_list)

%% Debugging: about the Lagrange multiplier

Fo_grad = gradient(Fo,points);
Fo_grad_eval = double(subs(Fo_grad,points,xc));

J_mat_eval = double(subs(J_mat,points,xc));

RJacob = [Fo_grad_eval';J_mat_eval];
SJacob = svd(RJacob);

fprintf(sprintf('The smallest singular value for the Jacobian matrix: %.4e.\n\n',min(SJacob)))

%% Defining useful functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting bar frameworks
function plot_framework_2D(framework,varargin)

x = framework.x; % vertices of the framework
pfix = framework.pfix; % fixed vertices
A = framework.a; % adjacency matrix
ind = find(triu(A)==1); % indices of bonds
E = framework.E;

if(nargin > 1)
    list_free_edge = varargin{1};
else
    list_free_edge = [];
end

% plot the bar between two fixed vertices
X1 = x(2*pfix(1)-1:2*pfix(1)); X2 = x(2*pfix(2)-1:2*pfix(2));
plot([X1(1), X2(1)],[X1(2), X2(2)], 'k-', 'Linewidth', 2)
hold on
% plot the other bars
for ji=1:length(ind)
    p1 = E(ji,1); p2 = E(ji,2); % two vertices connected together
    X1 = x(2*p1-1:2*p1); X2 = x(2*p2-1:2*p2); % positions of the two vertices
    if find(list_free_edge == ji, 1) % this is a free edge
        plot([X1(1), X2(1)],[X1(2), X2(2)], 'r-', 'Linewidth', 2)
    else
        plot([X1(1), X2(1)],[X1(2), X2(2)], 'k-', 'Linewidth', 2)
    end
    hold on
    if find(pfix == p1) % if p1 is fixed
        scatter(X1(1),X1(2),100,'r^','filled')
        scatter(X2(1),X2(2),100,'bo','filled')
    elseif find(pfix == p2) % if p2 is fixed
        scatter(X1(1),X1(2),100,'bo','filled')
        scatter(X2(1),X2(2),100,'r^','filled')
    else % either p1 or p2 is fixed
        scatter(X1(1),X1(2),100,'bo','filled')
        scatter(X2(1),X2(2),100,'bo','filled')
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Newton iteration
function xc = newton_a(xc,dxc,Fc,J_mat,points)
    % Newton's initialization
    tol = 1e-10; % termination tolerance
    Max_iter = 10; % Max iteration for Newton
    err = 1; 
    count = 0;

    J_eval = double(subs(J_mat,points,xc));
    [m,~] = size(J_eval);
    a_vec = zeros(m,1);
    xc_update = xc+dxc+J_eval'*a_vec; 
    Fc_eval = double(subs(Fc,points,xc_update));

    while count < Max_iter & err > tol
        Jc_eval = double(subs(J_mat,points,xc_update));
        Jc_eval = Jc_eval*(J_eval');
        a_vec = a_vec - Jc_eval \ Fc_eval;
        xc_update = xc+dxc+J_eval'*a_vec;
        Fc_eval = double(subs(Fc,points,xc_update));
        
        % update the error
        count = count + 1;
        err = norm(Fc_eval);
    end
    
    xc = xc_update;
    fprintf(sprintf('Newton error is: %.4e.\n',err))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inf_rot = inf_rotation_2D(x)
Rot = [0,1;-1,0];
inf_rot = zeros(size(x));
for i=1:floor(length(x)/2)
    inf_rot(i*2-1:i*2) = Rot*x(i*2-1:i*2);
end
end