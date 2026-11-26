%% test the case with 11 nodes (index 34)
clear;
clc;

data = load('final-framework-11-34.mat');

framework = data.framework_cur;
% framework = data.framework;

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
plotcluster2b(x,ER,pfix,opts);

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
    fprintf('There are four points coplanar!\n\n')
else
    fprintf('There are no four points coplanar!!!\n')
end

[U,~,V] = svd(R);

% Nleft = U(:,end); % for one self-stress
Nleft = U(:,end-2:end); % for two self-stresses
stress = [1,1.5,1]';

% norm(R'*Nleft)
stress_final = Nleft([2,3,4],:);

weight = stress_final \ stress;

test = stress_final*weight;

fprintf(['The error between target stress and final stress is: ', num2str(norm(test-stress)),'.\n\n'])

% there exists one first-order flex
[t4,t5,t6] = inf_rotation_3D(x);
t1 = zeros(dim*n,1); t2 = zeros(dim*n,1); t3 = zeros(dim*n,1); 
t1(1:3:end) = 1; t2(2:3:end) = 1; t3(3:3:end) = 1;

Nright = V(:,end-6:end);
norm(R*Nright)

[Q,~] = qr([t1,t2,t3,t4,t5,t6,Nright]);
flex = Q(:,7); % the special flex

% test = [t1,t2,t3,t4,t5,t6,flex];
% svd(test)

% the second-order stress test (there are three self-stresses)
alpha_list = linspace(0,2*pi,2e3+1);
beta_list = linspace(0,pi,1e3+1);

test_mat = zeros(2e3,1e3);
for i=1:2e3
    alpha = alpha_list(i);
    for j=1:1e3
        beta = beta_list(j);
        stress = Nleft(:,1)*cos(alpha)*cos(beta) + ...
            Nleft(:,2)*sin(alpha)*cos(beta) + ...
            Nleft(:,3)*sin(beta);
        test_mat(i,j) = stress_test3d(ER,stress,flex);
    end
end

fprintf(['Maximum of all stress test: ', num2str(max(test_mat,[],"all")),'.\n'])
fprintf(['Minimum of all stress test: ', num2str(min(test_mat,[],"all")),'.\n'])
% Comment: the prestress stability test only needs one stress to pass the
% test, here there are many stresses that pass the test!!!

% This bar framework is definitely prestress stable!!!