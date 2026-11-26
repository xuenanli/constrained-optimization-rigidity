function plot_framework(framework,varargin)

x = framework.x; % vertices of the framework
pfix = framework.pfix; % fixed vertices
A = framework.a; % adjacency matrix
siz = size(A);
ind = find(triu(A)==1); % indices of bonds
E = framework.E;

if(nargin > 1)
    list_free_edge = varargin{1};
else
    list_free_edge = [];
end

% plot bonds
for ji=1:length(ind)
    p1 = E(ji,1); p2 = E(ji,2); % two vertices connected together
    X1 = x(2*p1-1:2*p1); X2 = x(2*p2-1:2*p2); % positions of the two vertices
    if find(list_free_edge == ji, 1) % this is a free edge
        plot([X1(1), X2(1)],[X1(2), X2(2)], 'r-', 'Linewidth', 2)
    else
        plot([X1(1), X2(1)],[X1(2), X2(2)], 'k-', 'Linewidth', 2)
    end
    hold on
    if find(pfix == p1) % if p1 is fixed
        scatter(X1(1),X1(2),100,'r^','filled')
        scatter(X2(1),X2(2),100,'bo','filled')
    elseif find(pfix == p2) % if p2 is fixed
        scatter(X1(1),X1(2),100,'bo','filled')
        scatter(X2(1),X2(2),100,'r^','filled')
    else % either p1 or p2 is fixed
        scatter(X1(1),X1(2),100,'bo','filled')
        scatter(X2(1),X2(2),100,'bo','filled')
    end
end

end