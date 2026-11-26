function framework = spacking_10(index)

dim = 3;
% open the file
% fileID = fopen('n10.txt', 'r');
fileID = fopen('n10.txt', 'r');

num = 263;
n = 10;

% Read the content of the file into a string
textString = fscanf(fileID, '%c');

% Close the file
fclose(fileID);

substrings = strsplit(textString, ' ');
substrings = substrings(~cellfun('isempty', substrings));

% Using str2double
numericArray = str2double(substrings);

% Check for conversion errors (NaN values)
conversionErrors = isnan(numericArray);
numericArray = numericArray(~conversionErrors);

numericArray = numericArray';

L = length(numericArray)/num;
x = numericArray(1+(index-1)*L:index*L); % choose the index-th one


D_mat = find_dist(x,dim,n);
a = find_adj_mat(D_mat,n);

% pfix must be two connected vertices
% choose the first edge
[pfix,a] = find_fixed_plane(a,n);

framework.pfix = pfix;
framework.a = a;

framework.x = x;

framework.n = n;
framework.dim = dim;

[R,E] = formconstraints_bonds(x,a,pfix,dim);
framework.E = E;

R = full(R);

fprintf(['The rank of the rigidity matrix is: ', int2str(rank(R)), '.\n\n'])

% print framework data
siz = size(R);
fprintf(['Number of vertcies: ', int2str(framework.n), '.\n'])
fprintf(['Number of free vertcies: ', int2str(siz(2)/framework.dim), '.\n'])
fprintf(['Number of edges: ', int2str(siz(1)), '.\n\n'])
if rank(R) == min(siz(1),siz(2))
    fprintf('This framework is REGULAR!\n')
else
    fprintf('This framework is SINGULAR!\n')
    fprintf(['The rank of rigidity matrix is: ', int2str(rank(R)), '.\n'])
    fprintf(['The corank of this framework: ', int2str(-rank(R)+siz(1)), '.\n\n'])
end

end