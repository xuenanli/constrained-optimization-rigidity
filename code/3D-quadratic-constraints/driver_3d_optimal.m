%% Find the optimal bar framework in 3D

clc;
clear;

dim = 3;

% Figure 3: choose 9 for panels (a-c) or 10 for panels (d-f).
packing_size = 9;
switch packing_size
    case 9
        case_index = 1;
        free_bar = [3, 7];
        step_sign = 1;
        objective_name = 'max';
        make_packing = @spacking_9_pert;
    case 10
        case_index = 6;
        free_bar = [1, 3];
        step_sign = -1;
        objective_name = 'min';
        make_packing = @spacking_10_pert;
    otherwise
        error('Choose packing_size = 9 or 10 for Figure 3.')
end

case_name = sprintf('%d-%d',packing_size,case_index);
initial_file = ['init-framework-' case_name '.mat'];
final_file = ['final-framework-' case_name '.mat'];
edge_file = [objective_name '-edge-' case_name '.mat'];
video_name = ['clustering-' case_name '-' objective_name '.mp4'];

if isfile(initial_file)
    data = load(initial_file,'framework');
    framework = data.framework;
    fprintf('Using the saved initial state in %s.\n',initial_file);
else
    catalog_file = sprintf('n%d.txt',packing_size);
    if ~isfile(catalog_file)
        error('Place %s or %s in the current folder. See README.md.',catalog_file,initial_file);
    end
    rng(0,'twister');
    framework = make_packing(case_index,0.2);
    fprintf('Using a new perturbation of %s (seed 0, sigma 0.2).\n',catalog_file);
    save(initial_file,'framework');
end

opts = struct('srad',0.1,'fig',2,'lcolr',0.7*[1,1,1],'lrad',0.03,...
    'scolr',1,'salph',0.7,'ifgrid',0,'iftext',1,...
    'iftight',1,'az',20,'el',18,'zth',-0.5);

x = framework.x;
a = framework.a;
pfix = framework.pfix;
n = framework.n;

[~,E] = formconstraints_bonds_fix(x,a,pfix,dim);

[R,~] = formconstraints_bonds(x,a,pfix,dim);
R = full(R);

% Plot with options
plotcluster2b(x,E,pfix,opts);

fprintf('Rigidity of the initial state:\n\n')
fprintf(['The rank of the rigidity matrix is: ', int2str(rank(R)), '.\n\n'])

S = svd(R);

row_name = num2str((1:length(S)));
row_name = strsplit(row_name);
S = [(1:length(S));S'];
S = S';

T = array2table(S,'VariableNames',{'index','singularValue'},'RowName',row_name); 
% Display table
disp(T)

isCollinear = checkFourPointsCollinear(x,n);
if isCollinear
    fprintf('There are four points coplanar!\n')
else
    fprintf('There are no four points coplanar!!!\n')
end
 
%% Preparation for the optimal search

free_edge_list = find(E(:,1) == free_bar(1) & E(:,2) == free_bar(2));
assert(isscalar(free_edge_list),'The chosen free bar must occur exactly once.');

points = sym('p', [n*dim, 1]);
[m,~] = size(E);

% objective function
Fo = sym(length(free_edge_list));
for i=1:length(free_edge_list)
    e = free_edge_list(i);
    ind1 = E(e,1); ind2 = E(e,2); 
    p1 = points(ind1*dim-dim+1:ind1*dim);
    p2 = points(ind2*dim-dim+1:ind2*dim);
    Fo(i) = ((p1(1)-p2(1))^2+(p1(2)-p2(2))^2)+(p1(3)-p2(3))^2;
end
Fo = sum(Fo);
Fo_grad = gradient(Fo,points);

% constraint functions Fc
Fc = sym(m-length(free_edge_list)+length(pfix)*dim);

% the edges with fixed lengths
Efix = E;
Efix(free_edge_list,:) = [];
% edge constraints
for i=1:m-length(free_edge_list)
    ind1 = Efix(i,1); ind2 = Efix(i,2); 
    p1 = points(ind1*dim-dim+1:ind1*dim);
    p2 = points(ind2*dim-dim+1:ind2*dim);
    Fc(i) = (p1(1)-p2(1))^2+(p1(2)-p2(2))^2+(p1(3)-p2(3))^2 - Efix(i,3)^2;
end
Fc = Fc';

% One pinning constraints: fix the two ends of an edge
% pinning constraints
for k=1:length(pfix)
    ind = pfix(k);
    Fc(m-length(free_edge_list)+(k-1)*dim+1:m-length(free_edge_list)+k*dim) ...
        = points(ind*dim-dim+1:ind*dim) - x((ind*dim-dim+1:ind*dim));
end

% take the Jacobian matrix
J_mat = jacobian(Fc, points);

%% Optimization starts
clc;

xc = x;
% xc = xc_save;
framework_cur = framework;
framework_cur.x = xc;

% open video
video = VideoWriter(video_name, 'MPEG-4');
video.FrameRate = 5; % Frames per second
open(video);
figure(1)
plotcluster2b(x,E,pfix,opts);
axis equal

frame = getframe(gcf); % Capture the frame
writeVideo(video, frame); % Write the frame to video

% optimization setup
eta = 1e-1; % step size
Max_iter = 1e3; % Max iteration number
tol = 1e-9; % optimization termination error
Fo_list = zeros(Max_iter,1); % storing Fo

err = 1;
count = 0;
while count < Max_iter & err > tol
    cla;
    count = count + 1;
    fprintf(['Current iteration count:', int2str(count),':\n'])

    xp = xc;
    dxc = step_sign*eta*double(subs(Fo_grad,points,xc));
    
    % Newton's update
    xc = newton_a(xc,dxc,Fc,J_mat,points);

    % store the objective
    Fo_eval = double(subs(Fo,points,xc));
    Fo_list(count) = Fo_eval;

    err = norm(xc-xp);
    fprintf(sprintf('Objective function is: %.4e.\n',Fo_eval))
    fprintf(sprintf('Optimization error is: %.4e.\n\n',err))

    % plot the current framework
    framework_cur = framework;
    framework_cur.x = xc;
    plotcluster2b(xc,E,pfix,opts);
    axis equal

    frame = getframe(gcf); % Capture the frame
    writeVideo(video, frame); % Write the frame to video
end

close(video) % Close the video
Fo_list = Fo_list(1:count);
% plot the objective function
figure(1)
plot(1:count, Fo_list, 'b-', 'LineWidth',2)
title('Value of the objective','FontSize',14)

%% Plot the final configuration

framework_cur = framework;
framework_cur.x = xc;
save(final_file,'framework_cur')
save(edge_file,'free_edge_list')

% plot the initial configuration
opts = struct('srad',0.1,'fig',1,'lcolr',0.7*[1,1,1],'lrad',0.03,...
    'scolr',1,'salph',0.7,'ifgrid',0,'iftext',1,...
    'iftight',1,'az',20,'el',18,'zth',-0.5);

plotcluster2b(x,E,pfix,opts);
axis equal

% plot the final configuration
opts = struct('srad',0.1,'fig',2,'lcolr',0.7*[1,1,1],'lrad',0.03,...
    'scolr',1,'salph',0.7,'ifgrid',0,'iftext',1,...
    'iftight',1,'az',20,'el',18,'zth',-0.5);

plotcluster2b(xc,E,pfix,opts);
axis equal

[Rc,EfR] = formconstraints_bonds(xc,a,pfix,dim);
Rc = full(Rc);

fprintf('Rigidity of the final state:\n\n')
fprintf(['The rank of the rigidity matrix is: ', int2str(rank(Rc)), '.\n\n'])

Sc = svd(Rc);

row_name = num2str((1:length(Sc)));
row_name = strsplit(row_name);
Sc = [(1:length(Sc));Sc'];
Sc = Sc';

Tc = array2table(Sc,'VariableNames',{'index','singularValue'},'RowName',row_name); 
% Display table
disp(Tc) 

% test whether coplanar 
isCollinear = checkFourPointsCollinear(xc,n);

if isCollinear
    fprintf('There are four points coplanar!\n')
else
    fprintf('There are no four points coplanar!!!\n')
end

%% Numerical stress diagnostic for the selected optimized packing

% Only these two examples with a single numerical self-stress are covered.
[U,S,V] = svd(Rc);
singular_values = diag(S);
stress_tol = 1e-7*singular_values(1);
if err > tol || nnz(singular_values <= stress_tol) ~= 1
    fprintf('Stress diagnostic skipped: convergence and one numerical self-stress are required.\n');
else
    self_stress = U(:,end);
    fprintf('Self-stress residual: %.3e\n',norm(Rc'*self_stress));

    [rot_xy,rot_xz,rot_yz] = inf_rotation_3D(xc);
    rigid_motions = [repmat(eye(dim),n,1),rot_xy,rot_xz,rot_yz];
    % The final right singular vectors span all numerical first-order flexes.
    right_null = V(:,numel(singular_values):end);
    % Within that basis, retain only flexes orthogonal to rigid-body motions.
    flexes = right_null*null(rigid_motions'*right_null);
    if packing_size == 9 && size(flexes,2) == 1
        value = stress_test3d(EfR,self_stress,flexes(:,1));
        fprintf('Quadratic stress value on the unit flex: %.6g\n',value);
    elseif packing_size == 10 && size(flexes,2) == 2
        theta = linspace(0,pi,1001);
        stress_values = zeros(1,1000);
        for k=1:numel(stress_values)
            flex = cos(theta(k))*flexes(:,1) + sin(theta(k))*flexes(:,2);
            stress_values(k) = stress_test3d(EfR,self_stress,flex);
        end
        fprintf('Sampled stress range on unit flexes: [%.6g, %.6g]\n', ...
            min(stress_values),max(stress_values));
    else
        fprintf('Stress diagnostic skipped: unexpected flex-space dimension.\n');
    end
end

%% Function definitions

% Newton iteration
function xc = newton_a(xc,dxc,Fc,J_mat,points)
    % Newton's initialization
    tol = 1e-14; % termination tolerance
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
