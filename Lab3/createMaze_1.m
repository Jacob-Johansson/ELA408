clear all 
clc
clf
PlotWalls=1; %PlotWalls=1 -> The walls will be plotted, otherwise it will not.

MazeSize = 80; 


Maze.map = zeros(MazeSize);
Maze.start = [40 40]; %start point
Maze.goal = [55 55]; % goal point

%obstacles/walls
Maze.map(35:40,43)=inf;
Maze.map(40:45,37)=inf;

Maze.map(45,37:48)=inf;
Maze.map(35,32:43)=inf;

Maze.map(30:45,48)=inf;
Maze.map(35:50,32)=inf;

Maze.map(50,32:53)=inf;
Maze.map(30,27:48)=inf;

Maze.map(30:50, 27)=inf;
Maze.map(30:50, 53)=inf;


grid=zeros(size(Maze.map,1));
surf(grid')
fig=gcf;
fig.Position=[10 10 500 500];
colormap(gray)
view(2)
hold all

%plotting known obstacles
for i=1:size(grid,1)
    for j=1:size(grid,2)
        if(Maze.map(i,j)==inf)
            plot(i,j,'s','LineWidth',1,'MarkerFaceColor','w','color','w', 'MarkerSize',5);
        end
    end
end 

%plotting initial and goal position
plot(Maze.start(1),Maze.start(2),'s','MarkerFaceColor','b','MarkerSize',10, 'color','b')
plot(Maze.goal(1),Maze.goal(2),'s','MarkerFaceColor','y','MarkerSize',10,'color','y')
axis equal
axis ([1 80 1 80]);
hold off

%Saves the maze structure
save('Maze.mat','Maze');




















