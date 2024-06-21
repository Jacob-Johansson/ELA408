clear
close all
clc


%NOTE
%After running the script, the x and y axis are flipped. This is due to how
%the maze is plotted.


%% Create map
%Set color using the colorcube colormap - you are free to change this as
%you wish
wColor=0;
gColor=191;
oColor=wColor; %obstacle and walls have the same color
sColor=237;
pathColor=35;

%goal and start pos - don't change these
gPos=[22,35];
sPos=[11,5];

%size of map - don't change these
SizeX=400;
SizeY=400;

x = (1:SizeX);
y = (1:SizeY);
[X,Y] = meshgrid(x,y);
Z=ones(SizeX, SizeY)*255;

%create walls
Z(1:end,1)=wColor;
Z(1:end,end)=wColor;
Z(1,1:end)=wColor;
Z(end,1:end)=wColor;

%create obstacles
Z(10,15:30)=oColor;
Z(11:30,30)=oColor;
Z(30,18:30)=oColor;
Z(20:30,18)=oColor;

%Mark start and goal position
Z(sPos(1),sPos(2))=sColor;
Z(gPos(1),gPos(2))=gColor;


%plot the base figure with start, goal and the maze
figure(1)
clf;
image(Z);
colormap colorcube;
grid on
grid minor
axis xy
axis([0.5 40.5 0.5 40.5]);
text(sPos(2)-0.4,sPos(1)-1.4,'$$x_0$$','fontsize',15, 'interpreter', 'latex');
text(gPos(2)-0.4,gPos(1)-1.4,'$$x_g$$','fontsize',15,'interpreter','latex');