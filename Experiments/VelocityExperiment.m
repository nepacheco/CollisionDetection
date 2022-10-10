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