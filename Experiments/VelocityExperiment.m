clear;close all;clc;
addpath("PrimitiveTest");
folder = "Results/Velocity/";
version = 1;
%% AABB Velocity Test
velocityTargets = 10:10:100;
numTrials = 10;
N = 20;
AABBAverageFrameRate = zeros(length(velocityTargets),numTrials);
AABBPenetrationDistance = zeros(length(velocityTargets),numTrials);
AABBCollisionMatrix = zeros(length(velocityTargets),numTrials);
for i = 1:length(velocityTargets)
    rng(1)
    for j = 1:numTrials
        close
        figure
        speed = velocityTargets(i);
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[speed;0]);
        polygon1.plotPolygon();
        polygon2.plotPolygon();
        bvh1 = AABB(polygon1.edges);
        bvh2 = AABB(polygon2.edges);
        inCollision = false;
        
        totalTime = 0;
        frameCount = 0;
        
        tic;
        while ~inCollision && totalTime < abs((speed+5)/speed)
            timeDiff = toc;
            tic
            dist = timeDiff*(-speed);
            totalTime = totalTime + timeDiff;
            polygon2.translate([dist;0],true);
            bvh2.translateBox([dist;0]);
            drawnow
            [inCollision, ~] = AABBCollisionDetection(bvh1,bvh2);
            AABBCollisionMatrix(i,j) = inCollision;
            frameCount = frameCount+1;
        end
        AABBAverageFrameRate(i,j) = frameCount/totalTime;
        distStep = 0.001;
        while inCollision
            AABBPenetrationDistance(i,j) = AABBPenetrationDistance(i,j) + distStep;
            polygon2.translate([distStep;0],true);
            bvh2.translateBox([distStep;0]);
        [inCollision, ~] = AABBCollisionDetection(bvh1,bvh2);   
        end
    end
end
saveloc = sprintf("%sAABBVelocityResults_v%d",folder,version);
save(saveloc,"AABBAverageFrameRate","AABBCollisionMatrix","AABBPenetrationDistance");
%% Restricted Velocity Test
velocityTargets = 10:10:100;
numTrials = 10;
N = 20;
RestrictedAverageFrameRate = zeros(length(velocityTargets),numTrials);
RestrictedPenetrationDistance = zeros(length(velocityTargets),numTrials);
RestrictedCollisionMatrix = zeros(length(velocityTargets),numTrials);
for i = 1:length(velocityTargets)
    rng(1)
    for j = 1:numTrials
        close 
        figure
        speed = velocityTargets(i);
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[speed;0]);
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
        while ~inCollision && totalTime < abs((speed+5)/speed)
            timeDiff = toc;
            tic
            dist = timeDiff*(-speed);
            totalTime = totalTime + timeDiff;
            polygon2.translate([dist;0],true);
            bvh2.translateBox([dist;0]);
            drawnow
            [inCollision, ~] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h);
            RestrictedCollisionMatrix(i,j) = inCollision;
            frameCount = frameCount+1;
        end
        RestrictedAverageFrameRate(i,j) = frameCount/totalTime;
        distStep = 0.001;
        while inCollision
            RestrictedPenetrationDistance(i,j) = RestrictedPenetrationDistance(i,j) + distStep;
            polygon2.translate([distStep;0],true);
            bvh2.translateBox([distStep;0]);
        [inCollision, ~] = RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h); 
        end
    end
end
saveloc = sprintf("%sRestrictedVelocityResults_v%d",folder,version);
save(saveloc,"RestrictedAverageFrameRate","RestrictedCollisionMatrix","RestrictedPenetrationDistance");

%% Brute Force Velocity Test
velocityTargets = 10:10:100;
numTrials = 1;
N = 20;
BruteForceAverageFrameRate = zeros(length(velocityTargets),numTrials);
BruteForcePenetrationDistance = zeros(length(velocityTargets),numTrials);
BruteForceCollisionMatrix = zeros(length(velocityTargets),numTrials);
for i = 1:length(velocityTargets)
    rng(1)
    for j = 1:numTrials
        close 
        figure
        speed = velocityTargets(i);
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[speed;0]);
        polygon1.plotPolygon();
        polygon2.plotPolygon();
        inCollision = false;
        
        totalTime = 0;
        frameCount = 0;
        tic;
        while ~inCollision && totalTime < abs((speed+5)/speed)
            timeDiff = toc;
            tic
            dist = timeDiff*(-speed);
            totalTime = totalTime + timeDiff;
            polygon2.translate([dist;0],true);
            drawnow
            [inCollision, ~] = BruteForceCollisionDetection(polygon1,polygon2);
            BruteForceCollisionMatrix(i,j) = inCollision;
            frameCount = frameCount+1;
        end
        RestrictedAverageFrameRate(i,j) = frameCount/totalTime;
        distStep = 0.001;
        while inCollision
            BruteForcePenetrationDistance(i,j) = BruteForcePenetrationDistance(i,j) + distStep;
            polygon2.translate([distStep;0],true);
            bvh2.translateBox([distStep;0]);
        [inCollision, ~] = BruteForceCollisionDetection(polygon1,polygon2); 
        end
    end
end
saveloc = sprintf("%sBruteForceVelocityResults_v%d",folder,version);
save(saveloc,"BruteForceAverageFrameRate","BruteForceCollisionMatrix","BruteForcePenetrationDistance");