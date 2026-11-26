function framework = square_linear(Lambda)

lambda1 = Lambda(1); lambda2 = Lambda(2);
lambda3 = Lambda(3); lambda4 = Lambda(4);

n = 12;
dim = 2;
pfix = [1,2]; % fix x1 and x2

x = zeros(24,1);
% the outer square
x(3:4) = [4,0]'; % P2
x(5:6) = [4,4]'; % P3
x(7:8) = [0,4]'; % P4

% the boundary four points 
x(9:10) = lambda1*x(1:2)+(1-lambda1)*x(3:4); % P5: mid point between x1 and x2
x(11:12) = lambda2*x(3:4)+(1-lambda2)*x(5:6); % P6: mid point between x2 and x3
x(13:14) = lambda3*x(5:6)+(1-lambda3)*x(7:8); % P7: mid point between x3 and x4
x(15:16) = lambda4*x(7:8)+(1-lambda4)*x(1:2); % P8: mid point between x1 and x4

% the inner square
x(17:18) = [2,1]'; % P9: point above P5
x(19:20) = [3,2]'; % P10: point left to P6
x(21:22) = [2,3]'; % P11: point below P7
x(23:24) = [1,2]'; % P12: point right to P8

% the adjacency matrix
a = zeros(12);
% form the outer square
a(2,3) = 1; a(3,4) = 1; a(4,1) = 1;

% form the inner square
a(9,10) = 1; a(10,11) = 1; a(11,12) = 1; a(12,9) = 1;

% form the four bars between the outer and the inner
a(5,9) = 1; a(6,10) = 1; a(7,11) = 1; a(8,12) = 1;

a = a + a';

[~,E] = formconstraints_bonds(x,a,pfix,dim);

framework.x = x;
framework.a = a;
framework.n = n;
framework.dim = dim;
framework.pfix = pfix;
framework.E = E;
end