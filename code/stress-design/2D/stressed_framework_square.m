function framework = stressed_framework_square(m1,m2)
x = zeros(2*(m1+1)*(m2+1),1);
n = (m1+1)*(m2+1);
dim = 2;
pfix = (1:m1+1);
a = zeros(n);

for i = 1:m1+1
    for j = 1:m2+1
        index = i+(j-1)*(m1+1);
        x(2*index-1) = i-1; % x location
        x(2*index) = j-1; % y location
    end
end

for i = 1:m1
    for j = 1:m2
        index = i+(j-1)*(m1+1);
        index_right = i+1+(j-1)*(m1+1);
        index_up = i+j*(m1+1);
        index_diag = i+1+j*(m1+1);
        a(index,index_up) = 1;
        a(index,index_diag) = 1;
        a(index_up, index_diag) = 1;
        a(index_right, index_up) = 1;
    end
end

% the vertical springs at the most right
for j = 1:m2
    index = m1+1+(j-1)*(m1+1);
    index_up = m1+1+j*(m1+1);
    a(index,index_up) = 1;
end
% a(1,4) = 1; a(5,8) = 1; a(3,6) = 1;
% a(3,7) = 1; a(4,8) = 1;
% 
% a = a + a';
% a(3,5) = 0; a(5,3) = 0;
% a(4,6) = 0; a(6,4) = 0;

framework.x = x;
framework.n = n;
framework.dim = dim;
framework.pfix = pfix;
framework.a = a;
end