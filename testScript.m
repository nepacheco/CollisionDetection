%% Simple AABB Collision Check
clc; clear; close all;
rng(1)

N = 100;
polygon1 = NPolygon(N,[0;0],0.8);
polygon2 = NPolygon(N,[0.9;0.9]);
figure
polygon1.plotPolygon();
polygon2.plotPolygon();
bvh1 = AABB(polygon1.edges);
bvh1.plotBox('Layer',1);


bvh2 = AABB(polygon2.edges);
bvh2.plotBox('Layer',1);
tic
[inCollsion, collisionEdges] = AABBCollisionDetection(bvh1,bvh2);
toc
figure
for edgePair = collisionEdges
    edgePair(1).plot('color',[0 0.5 0]);
    edgePair(2).plot('color',[0 0 1]);
end
axis equal
grid on
total = 0;
figure
tic
for i = 1:N
    for j = 1:N
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            hold on;
            polygon1.markEdge(i,'Color',[0,0.5,0]);
            polygon2.markEdge(j,'Color',[0,0,1]);
            hold off;
             total = total+1;
        end
    end
end
toc
axis equal
grid on
if total == size(collisionEdges,2)
    fprintf("Detected the same number of Collisions\n")
end
%% Simple AABB Collision Check with square polgyon
clc; clear; close all;
rng(1)

N = 5;
polygon1 = SimplePolygon(N);
polygon2 = SimplePolygon(N,[0.8;0]);
polygon1.plotPolygon();
polygon2.plotPolygon();
bvh1 = AABB(polygon1.edges);
bvh1.plotBox('Layer',1);


bvh2 = AABB(polygon2.edges);
bvh2.plotBox('Layer',1);
tic
[inCollsion, collisionEdges] = AABBCollisionDetection(bvh1,bvh2);
toc
figure
for edgePair = collisionEdges
    edgePair(1).plot('color',[0 0.5 0]);
    edgePair(2).plot('color',[0 0 1]);
end
axis equal
grid on
total = 0;
figure
tic
for i = 1:N
    for j = 1:N
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            hold on;
            polygon1.markEdge(i,'Color',[0,0.5,0]);
            polygon2.markEdge(j,'Color',[0,0,1]);
            hold off;
             total = total+1;
        end
    end
end
toc
axis equal
grid on
if total == size(collisionEdges,2)
    fprintf("Detected the same number of Collisions\n")
end
%% Restricted Box Tree Test
clc; clear; close all;
rng(1)
N = 100;
polygon1 = NPolygon(N);
polygon2 = NPolygon(N,[1;0]);
polygon1.plotPolygon();
polygon2.plotPolygon();

bvh1 = AABB(polygon1.edges,0,false);
bvh1 = RestrictedBox.makeTree(bvh1);
RestrictedBox.plotBox(bvh1,'Layer',2);
% RestrictedBox.plotBox(bvh1,'Layer',3,'Color',[1 0 0]);

bvh2 = AABB(polygon2.edges,0,false);
bvh2 = RestrictedBox.makeTree(bvh2);
RestrictedBox.plotBox(bvh2,'Layer',2);
tic
[inCollsion, collisionEdges] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h);
toc
figure
for edgePair = collisionEdges
    edgePair(1).plot('color',[0 0.5 0]);
    edgePair(2).plot('color',[0 0 1]);
end
axis equal
grid on
total = 0;
figure
for i = 1:N
    for j = 1:N
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            hold on;
            polygon1.markEdge(i,'Color',[0,0.5,0]);
            polygon2.markEdge(j,'Color',[0,0,1]);
            hold off;
            total = total + 1;
        end
    end
end
axis equal
grid on
if total == size(collisionEdges,2)
    fprintf("Match\n")
end
%% Restricted Box Tree Test with square polygon
clc; clear; close all;
rng(1)
N = 100;
polygon1 = SimplePolygon(N);
polygon2 = SimplePolygon(N,[0.8;0]);
polygon1.plotPolygon();
polygon2.plotPolygon();

bvh1 = AABB(polygon1.edges,0,false);
bvh1 = RestrictedBox.makeTree(bvh1);
RestrictedBox.plotBox(bvh1,'Layer',2);
% RestrictedBox.plotBox(bvh1,'Layer',3,'Color',[1 0 0]);

bvh2 = AABB(polygon2.edges,0,false);
bvh2 = RestrictedBox.makeTree(bvh2);
RestrictedBox.plotBox(bvh2,'Layer',2);
tic
[inCollsion, collisionEdges] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h);
toc
figure
for edgePair = collisionEdges
    edgePair(1).plot('color',[0 0.5 0]);
    edgePair(2).plot('color',[0 0 1]);
end
axis equal
grid on
total = 0;
figure
for i = 1:N
    for j = 1:N
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            hold on;
            polygon1.markEdge(i,'Color',[0,0.5,0]);
            polygon2.markEdge(j,'Color',[0,0,1]);
            hold off;
            total = total + 1;
        end
    end
end
axis equal
grid on
if total == size(collisionEdges,2)
    fprintf("Match\n")
end
%% Testing Edge Intersection Test
clc; close all; clear;
N = 20;
polygon1 = NPolygon(N);
polygon2 = NPolygon(N);
polygon1.plotPolygon();
polygon2.plotPolygon();
xlim([-1,1]);
ylim([-1,1]);
total = 0;
for i = 1:N
    for j = 1:N
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            hold on;
            polygon1.markEdge(i,'Color',[0,0.5,0]);
            polygon2.markEdge(j,'Color',[0,0,1]);
            hold off;
            total = total + 1;
        end
    end
end
[inCollision, edges] = BruteForceCollisionDetection(polygon1,polygon2);
disp(total);

%% Testing Movement
clear;close all; clc;
N = 20;
polygon1 = NPolygon(N);
polygon1.plotPolygon();
tic
for i = 1:1000
    polygon1.translate([0.1;0.1],true)
    drawnow
end
toc

%% Testing Collision while moving
clear;close all;clc;
velocity = -100;
N = 20;
polygon1 = NPolygon(N);
polygon2 = NPolygon(N,[100;0]);
polygon1.plotPolygon();
polygon2.plotPolygon();
inCollision = false;
tic;
totalTime = 0;
while ~inCollision && totalTime < abs(100/velocity)
    timeDiff = toc;
    tic
    dist = timeDiff*velocity;
    totalTime = totalTime + timeDiff;
    polygon2.translate([dist;0],true);
    drawnow
    [inCollision, edges] = BruteForceCollisionDetection(polygon1,polygon2);
end
% [inCollision, edges] = BruteForceCollisionDetection(polygon1,polygon2);
%% 
clc;
velocity = -10;
N = 10;
polygon1 = NPolygon(N);
polygon2 = NPolygon(N,[5;0]);
polygon1.plotPolygon();
polygon2.plotPolygon();
% inCollision = false;
bvh = AABB(polygon2.edges);
edge = polygon2.edges(1);
edge.vertex1
bvh.edges(1).vertex1
dist = velocity;
totalTime = totalTime + timeDiff;
polygon2.translate([dist;0],true);
drawnow
%     [inCollision, edges] = BruteForceCollisionDetection(polygon1,polygon2);
edge.vertex1
polygon2.markEdge(1);
polygon2.edges(1).vertex1
bvh.edges(1).vertex1
[inCollision, edges] = BruteForceCollisionDetection(polygon1,polygon2);