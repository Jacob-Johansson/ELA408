% Ray casting algorithm for finding the cells from coordinates (x1, y1) and
% (x2, y2).
function cells = Bresenham(x1, y1, x2, y2)
    % Initialize variables
    cells = [];
    
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    sx = sign(x2 - x1);
    sy = sign(y2 - y1);
    err = dx - dy;
    
    while true
        cells = [cells; x1, y1];
        
        if x1 == x2 && y1 == y2
            break;
        end
        
        e2 = 2 * err;
        if e2 > -dy
            err = err - dy;
            x1 = x1 + sx;
        end
        if e2 < dx
            err = err + dx;
            y1 = y1 + sy;
        end
    end
end
