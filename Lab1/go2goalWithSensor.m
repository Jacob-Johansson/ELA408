clc
clear 
close all

%Create the maze and load parameters such as the start position (sPos),
%goal position (gPos). The matrix named 'Z' corresponds to the map but is
%flipped, a good idea is to compare Z with the maze to understand how it is
%flipped. Also, notice that sPos(2) and gPos(2) corresponds to the x
%positions and sPos(1) and gPos(1) are the y positions..
CreateMaze;
hold on
v=0.5; %Velocity - you will probably have low velocity, i.e 0.5-1 m/s

%Inital position and orientation - notice how the indices are flipped
xinit=sPos(2);
yinit=sPos(1);
thetainit=0;

%Goal position - we don't care about final orientation
xg=gPos(2);
yg=gPos(1);
uc = [0, 0];
ucc = [0, 0];

%PID controller - or actually just a P controller
P=10;

%Tolerance distance for when to cancel simulation
tol=0.1;

%Simulation time
SimulationTime=40; %you should increase this

output=sim('UnicycleWithSensor2019b_Solution', SimulationTime);

%View the result
plot(output.xpos, output.ypos)
legend({'Path'})
hold off

