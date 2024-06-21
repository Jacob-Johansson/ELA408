function path = Dijkstra(map, start, goal)
    
    % Initialize data 
    distances = inf(size(map));  % Start distances
    Pointers = zeros(size(map, 1), size(map, 2), 2);  % Pointers to reconstruct the path
    
    % start node values
    distances(start(1), start(2)) = 0;
    
    %  push and pop variabels 
    push = 0;
    pop = 0;
    
    % Dijkstra's algorithm
    while true
        % Find smallest distance path/node
        SmallestDistance = inf;
        currentNode = [];
        for i = 1:size(map, 1)
            for j = 1:size(map, 2)
                if map(i, j) ~= inf && distances(i, j) < SmallestDistance
                    SmallestDistance = distances(i, j);
                    currentNode = [i, j];
                end
            end
        end
        
        if isempty(currentNode)
            % when we find no path
            path = [];
            disp("No path found!");
            disp("PushCounter: " + push);
            disp("PopCounter: " + pop);
            return;
        end
        
        % popcounter
        pop = pop + 1;
        
        % Check if goal node is reached
        if isequal(currentNode, goal)
            % Reconstruct the path from goal to start
            path = regeneratPath(Pointers, currentNode);
            disp("PushCounter: " + push);
            disp("PopCounter: " + pop);
            return;
        end
        
        % Neighboring nodes Update distances 
        neighbors = getNeighbors(currentNode, map);
        for i = 1:size(neighbors, 1)
            neighbor = neighbors(i, :);
            distance = distances(currentNode(1), currentNode(2)) + calculateDistance(currentNode, neighbor);
            if distance < distances(neighbor(1), neighbor(2))
                distances(neighbor(1), neighbor(2)) = distance;
                Pointers(neighbor(1), neighbor(2), :) = currentNode;
                
                % pushcounter
                push = push + 1;
            end
        end
        
        % saving that we visited the current node so we do not visit it
        % again. 
        map(currentNode(1), currentNode(2)) = inf;
    end
end

function path = regeneratPath(parentPointers, goal)
    % Reconstruct the path from the goal to the start using pointers
    path = [];
    current = goal;
    
    while ~isequal(current, [0, 0])
        path = [current; path];
        current = squeeze(parentPointers(current(1), current(2), :))';
    end
 
end

function distance = calculateDistance(position1, position2)
    distanceX = abs(position1(1) - position2(1));
    distanceY = abs(position1(2) - position2(2));
    diagonalCost = sqrt(2);
    straightCost = 1;
    distance = straightCost * (distanceX + distanceY) + (diagonalCost - 2 * straightCost) * min(distanceX, distanceY);
end
 

function neighbors = getNeighbors(position, map)
      
    % Extract x and y coordinates of the current point
    x = position(1);
    y = position(2);

   
    dx = [-1, -1, 0, 0, 1, 1, -1, 1]; % Displacement in x-direction for each neighbor
    dy = [-1, 0, 1, -1, 0, 1, 1, -1]; % Displacement in y-direction for each neighbor
    
  
    nx = x + dx; % Potential x-coordinates of neighbors
    ny = y + dy; % Potential y-coordinates of neighbors

   % Identify indices of neighbors within map boundaries and not obstacles
    valid_indices = nx >= 1 & nx <= size(map, 1) & ny >= 1 & ny <= size(map, 2) & map(nx + (ny - 1) * size(map, 1)) ~= inf;
    
    neighbors = [nx(valid_indices)', ny(valid_indices)']; % Store valid neighbor coordinates in a matrix
end
