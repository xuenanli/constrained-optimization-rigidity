function isCollinear = checkFourPointsCollinear(x,n)
    points = reshape(x, [3, n])';
    % points: n x 3 matrix where each row represents a vertex (x, y, z)
    % isCollinear: returns true if there are four collinear points, otherwise false.

    numPoints = size(points, 1);
    if numPoints < 4
        isCollinear = false;
        return;
    end

    % Iterate over all combinations of four points
    combinations = nchoosek(1:numPoints, 4); % All combinations of 4 points from the vertices
    numComb = size(combinations, 1);

    for i = 1:numComb
        % Extract the four points
        p1 = points(combinations(i, 1), :);
        p2 = points(combinations(i, 2), :);
        p3 = points(combinations(i, 3), :);
        p4 = points(combinations(i, 4), :);

        % Check collinearity using cross product
        v1 = p2 - p1; % Vector from p1 to p2
        v2 = p3 - p1; % Vector from p1 to p3
        v3 = p4 - p1; % Vector from p1 to p4

        % Compute the determinant for coplanarity (det = 0 means coplanar, i.e., collinear in 3D)
        detMatrix = [v1; v2; v3];
        if abs(det(detMatrix)) < 1e-8 % Threshold to account for floating-point precision
            isCollinear = true;
            fprintf(['The four vertices coplanar are: ', num2str(combinations(i, 1)),', ',...
                num2str(combinations(i, 2)), ', ', num2str(combinations(i, 3)), ', ', ...
                num2str(combinations(i, 4)), '.\n\n'])
            return;
        end
    end

    isCollinear = false; % No four collinear points found
end
