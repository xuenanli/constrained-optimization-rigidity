%% Find the optimal bar framework in 3D

clc;
clear;

dim = 3;

% Choose a Figure 5 packing and its stress target.
packing_size = 10;
switch packing_size
    case 10
        case_name = '10-4';
        framework = spacking_10(4);
        free_edge_list = [2,3];
        stress = [1,2];
    case 11
        case_name = '11-34';
        framework = spacking_11(34);
        free_edge_list = [1,2,3];
        stress = [1,1.5,1];
    otherwise
        error('Set packing_size to 10 or 11.')
end
video_name = ['stress-design-', case_name, '.mp4'];

opts = struct('srad',0.1,'fig',2,'lcolr',0.7*[1,1,1],'lrad',0.03,...
    'scolr',1,'salph',0.7,'ifgrid',0,'iftext',1,...
    'iftight',1,'az',20,'el',18,'zth',-0.5);

x = framework.x;
a = framework.a;
pfix = framework.pfix;
n = framework.n;

[~,E] = formconstraints_bonds_fix(x,a,pfix,dim);

[R,ER] = formconstraints_bonds(x,a,pfix,dim);
R = full(R);

% Plot with options
plotcluster2b(x,E,pfix,opts);

fprintf('Rigidity of the final state:\n\n')
fprintf(['The rank of the rigidity matrix is: ', int2str(rank(R)), '.\n\n'])

S = svd(R);

row_name = num2str((1:length(S)));
row_name = strsplit(row_name);
S = [(1:length(S));S'];
S = S';

T = array2table(S,'VariableNames',{'index','eigenvalue'},'RowName',row_name); 
% Display table
disp(T)

isCollinear = checkFourPointsCollinear(x,n);
if isCollinear
    fprintf('There are four points coplanar!\n')
else
    fprintf('There are no four points coplanar!!!\n')
end

[U,~,V] = svd(R);

Nleft = U(:,end); % for one self-stress
% Nleft = U(:,end-1:end); % for two self-stresses
% norm(R'*Nleft)

Nleft([2,3])

%% Preparation for the optimal search

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
Fo = sum(Fo.*stress);
Fo_grad = gradient(Fo,points);

% constraint functions Fc
Fc = sym(m-length(free_edge_list)+length(pfix)*dim);

% % constraints without pinning
% Fc = sym(m-length(free_edge_list));

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
plotcluster2b(x,E,pfix,opts);
axis equal

frame = getframe(gcf); % Capture the frame
writeVideo(video, frame); % Write the frame to video

% optimization setup
eta = 1e-1; % step size
Max_iter = 1e4; % Max iteration number
tol = 1e-8; % optimization termination error
Fo_list = zeros(Max_iter,1); % storing Fo

err = 1;
count = 0;
while count < Max_iter & err > tol
    cla;
    count = count + 1;
    fprintf(['Current iteration count:', int2str(count),':\n'])

    xp = xc;
    dxc = -eta*double(subs(Fo_grad,points,xc)); % descent direction
    
    % Newton's update
    [xc,err_newton] = newton_a(xc,dxc,Fc,J_mat,points);

    if err_newton > 1e-10
        break;
    end

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

save(['init-framework-',case_name,'.mat'],'framework')
save(['final-framework-',case_name,'.mat'],'framework_cur')
save(['min-edge-',case_name,'.mat'],'free_edge_list','stress')

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
[Rc,ERc] = formconstraints_bonds(xc,a,pfix,dim);
Rc = full(Rc);

fprintf('Rigidity of the final state:\n\n')
fprintf(['The rank of the rigidity matrix is: ', int2str(rank(Rc)), '.\n\n'])

Sc = svd(Rc);

row_name = num2str((1:length(Sc)));
row_name = strsplit(row_name);
Sc = [(1:length(Sc));Sc'];
Sc = Sc';

Tc = array2table(Sc,'VariableNames',{'index','eigenvalue'},'RowName',row_name); 
% Display table
disp(Tc) 

% test whether coplanar 
isCollinear = checkFourPointsCollinear(xc,n);

if isCollinear
    fprintf('There are four points coplanar!\n')
else
    fprintf('There are no four points coplanar!!!\n')
end

%% Check whether the target lies in the computed self-stress space

[Rf,EfR] = formconstraints_bonds(xc,a,pfix,dim);
Rf = full(Rf);
[Uf,~,~] = svd(Rf);

if packing_size == 10
    Nleft = Uf(:,end);
else
    Nleft = Uf(:,end-2:end);
end
norm(Rf'*Nleft)

% EfR includes the edges between the three pinned vertices also.
[~,target_rows] = ismember(E(free_edge_list,1:2),EfR(:,1:2),'rows');
stress_final = Nleft(target_rows,:);

weight = stress_final \ (stress');

test = stress_final*weight;

norm(test-stress')

target = Nleft*weight;

%% Function defini
% tions

% Newton iteration
function [xc,err] = newton_a(xc,dxc,Fc,J_mat,points)
    % Newton's initialization
    tol = 1e-15; % termination tolerance
    Max_iter = 30; % Max iteration for Newton
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
