function framework = framework_two_triangle

eps = 1e-7;

% x1 and x4 are fixed
% x1,x2,x5 forms the left triangle
% x4,x3,x6 forms the right triangle

% % Setup 1
% % the setup for a Croissant shape
% % length between two anchors
% l0 = 4.2; % length between x1 and x4
% 
% % lengths for the first triangle
% l1 = 1.2; % length between x1 and x2
% l6 = 2; % length between x1 and x5
% l5 = 1.2; % length between x2 and x5
% 
% % lengths for the second triangle
% l3 = 1.2*sqrt(3); % length between x3 and x4
% l7 = 1.2; % length between x3 and x6
% l8 = 1.2; % length between x4 and x6
% 
% % one connected edge between two triangles
% l2 = 2; % length between x2 and x3

% Setup 2
% length between two anchors
l0 = 3.2; % length between x1 and x4

% lengths for the first triangle
l1 = 1.3; % length between x1 and x2
l6 = 2; % length between x1 and x5
l5 = 1; % length between x2 and x5

% lengths for the second triangle
l3 = 2.2; % length between x3 and x4
l7 = 1.7; % length between x3 and x6
l8 = 1.2; % length between x4 and x6

% one connected edge between two triangles
l2 = 3; % length between x2 and x3


theta = pi/3;

l4 = sqrt(l0^2 + l1^2 - 2*l0*l1*cos(theta));

if abs(l2^2+l4^2-l3^2)/2/l2/l4 > 1+1e-12
    framework.x = 0;
    framework.a = 0;
    framework.pfix = 0;
    framework.n = 0;
    framework.dim = 0;
    return
end

A = [0,0];
B = l1*[cos(theta), sin(theta)];
D = l0*[1,0];

if theta > pi
    ABD = -acos((l1^2+l4^2-l0^2)/2/l1/l4);
else
    ABD = acos((l1^2+l4^2-l0^2)/2/l1/l4);
end

DBC = acos((l2^2+l4^2-l3^2)/2/l2/l4);

CBX = pi - ABD - DBC;
alpha = theta - CBX;
C = B + l2*[cos(alpha),sin(alpha)];

EAB = acos((l1^2+l6^2-l5^2)/2/l1/l6);
E = l6*[cos(theta-EAB), sin(theta-EAB)];

CDF = acos((l3^2+l8^2-l7^2)/2/l3/l8);
if theta > pi
    ADB = -acos((l0^2+l4^2-l1^2)/2/l0/l4);
else
    ADB = acos((l0^2+l4^2-l1^2)/2/l0/l4);
end
BDC = acos((l3^2+l4^2-l2^2)/2/l3/l4);
gamma = pi + CDF - ADB - BDC;
F = D + l8*[cos(gamma), sin(gamma)];

if abs(norm(C-D)-l3) > eps
    fprintf('Error on CD edge!\n')
end

if abs(norm(B-E)-l5) > eps
    fprintf('Error on BE edge!\n')
end

if abs(norm(C-F)-l7) > eps
    fprintf('Error on CF edge!\n')
end

x = [
    A(1) % X1 (fixed)
    A(2)
    B(1) % X2
    B(2)
    C(1) % X3
    C(2)
    D(1) % X4 (fixed)
    D(2)
    E(1) % X5
    E(2)
    F(1) % X6
    F(2)
];

a = zeros(6);
a(1,2) = 1; a(2,3) = 1; a(3,4) = 1;
a(1,5) = 1; a(2,5) = 1; a(3,6) = 1; a(4,6) = 1;
a(5,6) = 1; % the connected one to be optimized
a = a + a';

pfix = [1,4];
n = 6;
dim = 2;
E = edge_info(x,a,dim);

framework.x = x;
framework.a = a;
framework.pfix = pfix;
framework.n = n;
framework.dim = dim;
framework.E = E;

end