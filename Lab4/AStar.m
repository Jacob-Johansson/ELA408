function path = A_Star(map, start, goal)
    
    % Costs 
    diagonalCost = sqrt(2);  % Diagonal Cost
    straightCost = 1;        % Vertical/horizontal Cost
    
    % Initialize 
    PriorityQueue = containers.Map();  % Priority queue 
    Cost_Values = inf(size(map));    % Start cost
    fValues = inf(size(map));    
    Pointers = zeros(size(map, 1), size(map, 2), 2);  %  Pointers to reconstruct the path
    
    % Set initial values for the start node
    Cost_Values(start(1), start(2)) = 0;
    fValues(start(1), start(2)) = heuristic(start, goal);
    PriorityQueue(num2str(start)) = fValues(start(1), start(2));
    
    % push and pop 
    Push = 0;
    Pop = 0;
    
    while ~isempty(PriorityQueue)
        % Extract node with the lowest fValue from the PriorityQueue
        keys = PriorityQueue.keys;
        [~, minIdx] = min(cell2mat(PriorityQueue.values));
        currentStr = keys{minIdx};
        current = str2num(currentStr);
        PriorityQueue.remove(currentStr);
        
        % Increment pop counter
        Pop = Pop + 1;
        
        % if we reach the goal
        if isequal(current, goal)
            
            path = regeneratPath(Pointers, current);
            disp("PushCounter: " + Push);
            disp("PopCounter: " + Pop);
            return;
        end
        
        % Neighboring nodes
        neighbors = getNeighbors(current, map);
        
        for i = 1:size(neighbors, 1)
            neighbor = neighbors(i,:);
            
            % Calculate the cost from the current node to the neighbor
            if abs(neighbor(1) - current(1)) + abs(neighbor(2) - current(2)) == 2
                
                cost = diagonalCost;
            else
                
                cost = straightCost;
            end
            
            % Calculate cost_value
            new_Cost_Value = Cost_Values(current(1), current(2)) + cost;
           
            if new_Cost_Value < Cost_Values(neighbor(1), neighbor(2))
               
                Cost_Values(neighbor(1), neighbor(2)) = new_Cost_Value;
                fValues(neighbor(1), neighbor(2)) = new_Cost_Value + heuristic(neighbor, goal);
                Pointers(neighbor(1), neighbor(2), :) = current;
                
                PriorityQueue(num2str(neighbor)) = fValues(neighbor(1), neighbor(2));
               
                Push = Push + 1;
            end
        end
    end
    
    % When we do not find the goal
    path = [];
    disp("No path found!");
    disp("PushCounter: " + Push);
    disp("PopCounter: " + Pop);
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

function h = heuristic(position, goal)
    % Euclidean distance 
    h = sqrt((position(1) - goal(1))^2 + (position(2) - goal(2))^2);
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
