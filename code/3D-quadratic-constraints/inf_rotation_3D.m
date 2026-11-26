function [inf_rotxy,inf_rotxz,inf_rotyz] = inf_rotation_3D(x)
Rot2 = [0,1;-1,0];

Rotxy = zeros(3); Rotxy(1:2,1:2) = Rot2;
Rotxz = zeros(3); Rotxz([1,3],[1,3]) = Rot2;
Rotyz = zeros(3); Rotyz([2,3],[2,3]) = Rot2;

inf_rotxy = zeros(size(x));
inf_rotxz = zeros(size(x));
inf_rotyz = zeros(size(x));

for i=1:floor(length(x)/3)
    inf_rotxy(i*3-2:i*3) = Rotxy*x(i*3-2:i*3);
    inf_rotxz(i*3-2:i*3) = Rotxz*x(i*3-2:i*3);
    inf_rotyz(i*3-2:i*3) = Rotyz*x(i*3-2:i*3);
end
end