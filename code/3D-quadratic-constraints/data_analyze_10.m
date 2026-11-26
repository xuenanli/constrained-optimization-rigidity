clear;
clc;

% plot the original
framework = spacking_10(6);

opts = struct('srad',0.1,'fig',2,'lcolr',0.7*[1,1,1],'lrad',0.03,...
    'scolr',1,'salph',0.7,'ifgrid',0,'iftext',1,...
    'iftight',1,'az',20,'el',18,'zth',-0.5);

x = framework.x;
a = framework.a;
pfix = framework.pfix;
n = framework.n;
dim = framework.dim;

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

[R,~] = formconstraints_bonds(x,a,pfix,dim);
R = full(R);

[U,~,~] = svd(R);
Nleft = U(:,end); 

%% stress test
% construct the infinitesimal rigid body motions
[t4,t5,t6] = inf_rotation_3D(x);
t1 = zeros(n*dim,1); t2 = zeros(n*dim,1); t3 = zeros(n*dim,1);
t1(1:3:end) = 1; t2(2:3:end) = 1; t3(3:3:end) = 1;

inf_rigid_motion = [t1,t2,t3,t4,t5,t6];
fprintf(['Test of inf rigid body motions: ', num2str(norm(R*inf_rigid_motion)),'.\n'])
S_test = svd(inf_rigid_motion);
fprintf(['Smallest singular value of inf rigid body motions: ', num2str(min(S_test)), '.\n\n'])

% find the self-stresses
[U,~,V] = svd(R);
num_rigid = 6;

% for non-special ones, there is 1 self-stresses; 1 first-order flex
Nleft = U(:,end); 
Nright = V(:,end-num_rigid:end); % 7 first-order flexes (including trivial ones)

test_left = R'*Nleft; 
fprintf(['Test of left null space: ', num2str(norm(test_left)),'.\n\n'])

test_right = R*Nright; 
fprintf(['Test of right null space: ', num2str(norm(test_right)),'.\n\n'])

% find the two non-trivial first-order flexes

[Q,~] = qr([inf_rigid_motion,Nright]);
q1 = Q(:,1); q2 = Q(:,2); q3 = Q(:,3);
q4 = Q(:,4); q5 = Q(:,5); q6 = Q(:,6);

flex = Q(:,7);

% test_mat = [inf_rigid_motion,flex]; min(svd(test_mat))

stress_test = stress_test3d(ER,Nleft,flex);
fprintf(['The second order stress test is: ', num2str(stress_test), '.\n\n'])

%% plot the perturbed initial one

data = load('init-framework-10-6.mat');
framework = data.framework;

x = framework.x;
a = framework.a;
pfix = framework.pfix;
dim = framework.dim;
n = framework.n;

[~,E] = formconstraints_bonds_fix(x,a,pfix,dim);
[R,ER] = formconstraints_bonds_fix(x,a,pfix,dim);
R = full(R);

plotcluster2b(x,E,pfix,opts);

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

%% plot the perturbed final one

data = load('final-framework-10-6.mat');
framework_cur = data.framework_cur;

xc = framework_cur.x;

[~,Ec] = formconstraints_bonds_fix(xc,a,pfix,dim);
[Rc,EcR] = formconstraints_bonds(xc,a,pfix,dim);
Rc = full(Rc);

plotcluster2b(xc,Ec,pfix,opts);

Sc = svd(Rc);

row_name = num2str((1:length(Sc)));
row_name = strsplit(row_name);
Sc = [(1:length(Sc));Sc'];
Sc = Sc';

T = array2table(Sc,'VariableNames',{'index','eigenvalue'},'RowName',row_name); 
% Display table
disp(T)

isCollinear = checkFourPointsCollinear(xc,n);
if isCollinear
    fprintf('There are four points coplanar!\n')
else
    fprintf('There are no four points coplanar!!!\n')
end

[U,S,V] = svd(Rc);
Nleft = U(:,end);

norm(Rc'*Nleft)