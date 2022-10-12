%%
clc;clear; close all;
addpath('PrimitiveTest')
figurePosition = [0 0 1 1];
%% Generating Polygons
rng(1);
vertices = [10,40,60];
f = figure('WindowState','maximized');
% f('units','normalized','outerPosition',figurePosition);
for i = 1:length(vertices)
    subplot(2,3,i)
    hold on
    polygon = NPolygon(vertices(i));
    polygon.plotPolygon();
    title(sprintf("%d Vertices",vertices(i)));
    hold off
end
for i = 1:length(vertices)
    subplot(2,3,i+3)
    polygon = SimplePolygon(vertices(i));
    polygon.plotPolygon();
    title(sprintf("%d Vertices",vertices(i)));
end
waitforbuttonpress;

%% Showing an AABB Tree
rng(1)
N = 6;
polygon = NPolygon(N);
bvh = AABB(polygon.edges);

c = distinguishable_colors(5);
f = figure('WindowState','maximized');
% f('units','normalized','outerPosition',figurePosition)
title("AABB Tree",'FontSize',16);
xlabel('X Axis');
ylabel('Y Axis');
polygon.plotPolygon();
for i = 1:4
    bvh.plotBox('Layer',i,'LineWidth',3.5-i*0.5,'Color',c(i,:));
    w = waitforbuttonpress();
end

%% Showing Restricted Box Tree
rng(1)
N = 6;
polygon = NPolygon(N);
bvh = AABB(polygon.edges,0,false);
bvh = RestrictedBox.makeTree(bvh);

c = distinguishable_colors(20);
f = figure('WindowState','maximized');
% f.Position(1:4) = [550 300 750 650];
title("Restricted Box Tree",'FontSize',16);
xlabel('X Axis');
ylabel('Y Axis');
polygon.plotPolygon();

RestrictedBox.plotBox(bvh,'Layer',1,'LineWidth',3.5-1*0.5,'Color',c(1,:),'plotEdges',false);
hold on
waitforbuttonpress();
for i = 2:5
    %     ft = figure;
    RestrictedBox.plotBox(bvh,'Layer',i,'LineWidth',3.5-i*0.5,'Color',c(i,:),'plotEdges',false);
    w = waitforbuttonpress();
end

%% Collision Example
rng(1)
f = figure('WindowState','maximized');
% f.Position(1:4) = [550 300 750 650];
title("Stationary collision test",'FontSize',16);
xlabel('X Axis');
ylabel('Y Axis');
N = 5;
polygon1 = NPolygon(N);
polygon2 = NPolygon(N,[1;0]);
polygon1.plotPolygon();
polygon2.plotPolygon('Color',[0 0.5 0]);

bvh1 = AABB(polygon1.edges,0,false);
bvh1 = RestrictedBox.makeTree(bvh1);
RestrictedBox.plotBox(bvh1,'Layer',1);
% RestrictedBox.plotBox(bvh1,'Layer',3,'Color',[1 0 0]);

bvh2 = AABB(polygon2.edges,0,false);
bvh2 = RestrictedBox.makeTree(bvh2);
RestrictedBox.plotBox(bvh2,'Layer',1,'Color',[0 0.5 0]);
waitforbuttonpress();
tic
[inCollsion, collisionEdges] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h);
collisionTime = toc;
hold on
for edge = collisionEdges
    edge(1).plot('Color',[1 0 0]);
    edge(2).plot('Color',[1 0 0]);
end
dim = [.4 0.6 0.5 .3];
str = sprintf("Collision Detection in %0.4f seconds\n %d Collisions Detected",collisionTime,size(collisionEdges,2));
annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',14);
waitforbuttonpress();
%% Motion Test
velocityTargets = 10:10:50;
numTrials = 1;
N = 20;
RestrictedAverageFrameRate = zeros(length(velocityTargets),numTrials);
RestrictedPenetrationDistance = zeros(length(velocityTargets),numTrials);
RestrictedCollisionMatrix = zeros(length(velocityTargets),numTrials);

for i = 1:length(velocityTargets)
    rng(1)
    for j = 1:numTrials
        
        f = figure('WindowState','maximized');
%         f.Position(1:4) = [550 300 750 650];
        hold on;
        title("Moving Collision test",'FontSize',16);
        xlabel('X Axis');
        ylabel('Y Axis');
        speed = velocityTargets(i);
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[50;0]);
        polygon1.plotPolygon();
        polygon2.plotPolygon();
        bvh1 = AABB(polygon1.edges,0,false);
        bvh1 = RestrictedBox.makeTree(bvh1);
        bvh2 = AABB(polygon2.edges,0,false);
        bvh2 = RestrictedBox.makeTree(bvh2);
        inCollision = false;
        
        totalTime = 0;
        frameCount = 0;
        tic;
        while ~inCollision && totalTime < abs((50+5)/speed)
            timeDiff = toc;
            tic
            dist = timeDiff*(-speed);
            totalTime = totalTime + timeDiff;
            polygon2.translate([dist;0],true);
            bvh2.translateBox([dist;0]);
            drawnow
            [inCollision, collisionEdges] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h);
            RestrictedCollisionMatrix(i,j) = inCollision;
            frameCount = frameCount+1;
        end
        for edge = collisionEdges
            edge(1).plot('Color',[1 0 0]);
            edge(2).plot('Color',[1 0 0]);
        end
        RestrictedAverageFrameRate(i,j) = frameCount/totalTime;
        distStep = 0.001;
        while inCollision
            RestrictedPenetrationDistance(i,j) = RestrictedPenetrationDistance(i,j) + distStep;
            polygon2.translate([distStep;0],false);
            bvh2.translateBox([distStep;0]);
            [inCollision, ~] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h); 
        end
        dim = [.4 0.6 0.0 .3];
        str = sprintf("Penetration distance of %0.3f",RestrictedPenetrationDistance(i,j));
        annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',14);
        dim = [.4 0 0.5 .3];
        str = sprintf("Average Frame Rate of %0.1f",RestrictedAverageFrameRate(i,j));
        annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',14);
        waitforbuttonpress()
    end
end