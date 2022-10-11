%% utils
clc; clear; close all;
addpath("PrimitiveTest")
version = 4;
folder = "Results/Square/";
SimplePolygon(10);
SimplePolygon(10);
%% Timing Building AABB Tree
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
buildAABBResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon = SimplePolygon(N);
        tic
        bvh = AABB(polygon.edges,0,true);
        buildAABBResults(i,trial) = toc;
    end
end
saveloc = sprintf("%sBuildAABBResults_v%d.mat",folder,version);
save(saveloc,"buildAABBResults","numVertices");
%% Timing Building RestrictedBoxTree
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
buildRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon = SimplePolygon(N);
        tic
        bvh = AABB(polygon.edges,0,false);
        bvh = RestrictedBox.makeTree(bvh);
        buildRestrictedResults(i,trial) = toc;
    end
end
saveloc = sprintf("%sBuildRestrictedBoxResults_v%d.mat",folder,version);
save(saveloc,"buildRestrictedResults","numVertices");
%% Timing Collision Check AABB Tree and HEAVY COLLISION
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionAABBResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = SimplePolygon(N);
        polygon2 = SimplePolygon(N);
        
        restrictedBVH1 = AABB(polygon1.edges,0,true);

        restrictedBVH2 = AABB(polygon2.edges,0,true);
        tic
        [~,edges] = AABBCollisionDetection(restrictedBVH1,restrictedBVH2);
        collisionAABBResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
saveloc = sprintf("%sHeavyCollisionAABBResults_v%d.mat",folder,version);
save(saveloc,"collisionAABBResults","numVertices","numCollisions");
%% Timing Collision Check with Brute Force and HEAVY COLLISION
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionBruteForceResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = SimplePolygon(N);
        polygon2 = SimplePolygon(N);
        tic
        [~,edges] = BruteForceCollisionDetection(polygon1,polygon2);
        collisionBruteForceResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
saveloc = sprintf("%sHeavyCollisionBruteForceResults_v%d.mat",folder,version);
save(saveloc,"collisionBruteForceResults","numVertices","numCollisions");
%% Timing Collision Check RestrictedBoxTree and HEAVY COLLISION
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = SimplePolygon(N);
        polygon2 = SimplePolygon(N);
        
        restrictedBVH1 = AABB(polygon1.edges,0,false);
        restrictedBVH1 = RestrictedBox.makeTree(restrictedBVH1);

        restrictedBVH2 = AABB(polygon2.edges,0,false);
        restrictedBVH2 = RestrictedBox.makeTree(restrictedBVH2);
        tic
        [~,edges] = RestrictedCollisionDetection(restrictedBVH1,restrictedBVH2,...
            restrictedBVH1.l,restrictedBVH1.h, restrictedBVH2.l, restrictedBVH2.h);
        collisionRestrictedResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
saveloc = sprintf("%sHeavyCollisionRestrictedBoxResults_v%d.mat",folder,version);
save(saveloc,"collisionRestrictedResults","numVertices","numCollisions");
%% Timing Collision Check AABB Tree and LIGHT COLLISION
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionAABBResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = SimplePolygon(N);
        polygon2 = SimplePolygon(N,[0.8;0]);
        
        restrictedBVH1 = AABB(polygon1.edges,0,true);

        restrictedBVH2 = AABB(polygon2.edges,0,true);
        tic
        [~,edges] = AABBCollisionDetection(restrictedBVH1,restrictedBVH2);
        collisionAABBResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
saveloc = sprintf("%sLightCollisionAABBResults_v%d.mat",folder,version);
save(saveloc,"collisionAABBResults","numVertices","numCollisions");
%% Timing Collision Check with Brute Force and HEAVY COLLISION

rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionBruteForceResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = SimplePolygon(N);
        polygon2 = SimplePolygon(N,[0.8;0]);
        tic
        [~,edges] = BruteForceCollisionDetection(polygon1,polygon2);
        collisionBruteForceResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
saveloc = sprintf("%sLightCollisionBruteForceResults_v%d.mat",folder,version);
save(saveloc,"collisionBruteForceResults","numVertices","numCollisions");
%% Timing Collision Check RestrictedBoxTree and LIGHT COLLISION
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = SimplePolygon(N);
        polygon2 = SimplePolygon(N,[0.8;0]);
        
        restrictedBVH1 = AABB(polygon1.edges,0,false);
        restrictedBVH1 = RestrictedBox.makeTree(restrictedBVH1);

        restrictedBVH2 = AABB(polygon2.edges,0,false);
        restrictedBVH2 = RestrictedBox.makeTree(restrictedBVH2);
        tic
        [~,edges] = RestrictedCollisionDetection(restrictedBVH1,restrictedBVH2,...
            restrictedBVH1.l,restrictedBVH1.h, restrictedBVH2.l, restrictedBVH2.h);
        collisionRestrictedResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
saveloc = sprintf("%sLightCollisionRestrictedBoxResults_v%d.mat",folder,version);
save(saveloc,"collisionRestrictedResults","numVertices","numCollisions");