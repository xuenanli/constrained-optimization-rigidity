function [pfix,a] = find_fixed_plane(a,n)
for i = 1:n
    for j = i+1:n
        for k = j+1:n
            if a(i,j) && a(j,k) && a(k,i)
                % Found a triangle
                fprintf('Triangle found: %d - %d - %d\n',i,j,k);
                pfix = [i,j,k];
                a(i,j) = 0; a(j,i) = 0; 
                a(i,k) = 0; a(k,i) = 0; 
                a(k,j) = 0; a(j,k) = 0; 
                return;
            end
        end
    end
end
end