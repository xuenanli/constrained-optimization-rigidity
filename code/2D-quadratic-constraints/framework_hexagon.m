function framework = framework_hexagon

% Setup for hexagon-1.mp4
l1 = 1;
l2 = 1.3;
l3 = 2;
l4 = 1.2;
l5 = 1;

theta1 = pi/3;
theta2 = pi/6;
theta3 = 0;
theta4 = pi/4;

% l1 = 1+rand-1/2;
% l2 = 1+rand-1/2;
% l3 = 1+rand-1/2;
% l4 = 1+rand-1/2;
% l5 = 1+rand-1/2;
% 
% theta1 = pi/3;
% theta2 = pi/6;
% theta3 = 0;
% theta4 = pi/4;


% regular hexagon
% l1 = 1;
% l2 = 1;
% l3 = 1;
% l4 = 1;
% l5 = 1;

% theta1 = pi/3;
% theta2 = pi/3;
% theta3 = 0;
% theta4 = pi/3;

x1 = [0,0];
x2 = x1+l1*[cos(pi-theta1),sin(pi-theta1)];
x3 = x2+l2*[cos(theta2),sin(theta2)];
x4 = x3+l3*[cos(theta3),sin(theta3)];
x5 = x4+l4*[cos(-theta4),sin(-theta4)];
x6 = [l5,0];

pfix = [1,6];
n = 6;
dim = 2;
x = zeros(n*dim,1);
x(1:2) = x1';
x(3:4) = x2';
x(5:6) = x3';
x(7:8) = x4';
x(9:10) = x5';
x(11:12) = x6';

a = zeros(6);
a(1,2) = 1;
a(2,3) = 1;
a(3,4) = 1;
a(4,5) = 1;
a(5,6) = 1;

a(2,5) = 1;
a(3,6) = 1;
% free edge
a(4,1) = 1;
a = a + a';
E = edge_info(x,a,dim);

framework.x = x;
framework.a = a;
framework.n = n;
framework.dim = dim;
framework.pfix = pfix;
framework.E = E;
end