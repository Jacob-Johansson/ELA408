function [logMap, path] = OccupancyMapping(logMap, sensorReadings, robotPoses, log_occupied, log_free, log_prior, gridResolution, maxRange, occupancyCellSize, livePlotting)
    
    path = zeros(size(sensorReadings, 1), 2);
    averagePosition = mean([robotPoses(:, 1), robotPoses(:, 2)]);

    if livePlotting
        for t = 1:size(sensorReadings, 1)
            x_t = robotPoses(t, :);
            z_t = sensorReadings(t, :);

            path(t, :) = ConvertLocalPositionToGridPosition([x_t(1), x_t(2)], logMap, gridResolution, averagePosition);
            logMap = OccupancyMappingImpl(logMap, z_t, x_t, log_occupied, log_free, log_prior, gridResolution, maxRange, occupancyCellSize, averagePosition);
            
            map = 1 - (1 ./ (1 + exp(logMap)));
            imagesc(map');
            colorbar;
            title('Occupancy Grid with Robot Path');
            xlabel('X');
            ylabel('Y');
            hold on;
            plot(path(1:t, 1), path(1:t, 2), 'r', 'LineWidth', 2);
            hold off;

            drawnow;
        end
    else
        for t = 1:size(sensorReadings, 1)
            x_t = robotPoses(t, :);
            z_t = sensorReadings(t, :);
    
            path(t, :) = ConvertLocalPositionToGridPosition([x_t(1), x_t(2)], logMap, gridResolution, averagePosition);
            logMap = OccupancyMappingImpl(logMap, z_t, x_t, log_occupied, log_free, log_prior, gridResolution, maxRange, occupancyCellSize, averagePosition);
        end
    end
end

function map = OccupancyMappingImpl(map, sensorReadings_t, robotPose_t, log_occupied, log_free, log_prior, resolution, maxRange, occupancyCellSize, averagePosition)

    % Convert robot local coordinates to grid coordinates
    localPos = [robotPose_t(1), robotPose_t(2)];
    gridPos = ConvertLocalPositionToGridPosition(localPos, map, resolution, averagePosition);

    % Convert sensor reading end coordinates to grid coordinates
    localSensorAngles = robotPose_t(3) + deg2rad((0:1:length(sensorReadings_t)-1) - 90); % Map readings [0, 180] to [-90, 90] relative the robot's heading
    localSensorPositions = localPos + sensorReadings_t(:) .* [cos(localSensorAngles); sin(localSensorAngles)]';
    gridSensorPositions = ConvertLocalPositionToGridPosition(localSensorPositions, map, resolution, averagePosition);

    % Update log-odds of cells within range of the robot at time t
    for i = 1:length(sensorReadings_t)
        
        % Ensures no unreliable readings are considered as valid
        if sensorReadings_t(i) > maxRange
            continue;
        end

        % Inverse Sensor model
        cellsWithinRange = Bresenham(gridPos(1), gridPos(2), gridSensorPositions(i, 1), gridSensorPositions(i, 2));

        % Update free cells
        if size(cellsWithinRange, 1) - occupancyCellSize > 0
            freeCells = cellsWithinRange(1:end-occupancyCellSize, :);
            for c = 1:size(freeCells, 1)
                map(freeCells(c, 1), freeCells(c, 2)) = map(freeCells(c, 1), freeCells(c, 2)) + log_free - log_prior;
            end
        end
    
        % Update occupied cells
        if size(cellsWithinRange, 1) - occupancyCellSize > 0
            occupiedCells = cellsWithinRange(end-occupancyCellSize:end, :);
            for c = size(occupiedCells, 1)
                map(occupiedCells(c, 1), occupiedCells(c, 2)) = map(occupiedCells(c, 1), occupiedCells(c, 2)) + log_occupied - log_prior;
            end
        end
    end
end

% Converts local position to grid position relative to the map
function gridPosition = ConvertLocalPositionToGridPosition(localPosition, map, resolution, averagePosition)
    gridPosition = round(localPosition ./ resolution) + round(size(map) .* 0.5) - round(averagePosition ./ resolution);
end
