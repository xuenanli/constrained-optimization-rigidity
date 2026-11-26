clear;
clc;

data = load('final-framework-10-4.mat');

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

% stress test
Nleft = U(:,end); % for one self-stress
% Nleft = U(:,end-2:end); % for two self-stresses
stress = [1,2]';

norm(R'*Nleft)
stress_final = Nleft([3,4],:);

% weight = stress_final \ stress;
% 
% test = stress_final*weight;
% 
% fprintf(['The error between target stress and final stress is: ', num2str(norm(test-stress)),'.\n\n'])
