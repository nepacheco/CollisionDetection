%% utils
clc;clear; close all;
addpath("PrimitiveTest")
version = 3;
folder = "Results/Circle/";
NPolygon(10);
NPolygon(10);
%% Timing Building AABB Tree
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
buildAABBResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon = NPolygon(N);
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
        polygon = NPolygon(N);
        tic
        bvh = AABB(polygon.edges,0,false);
        bvh = RestrictedBox.makeTree(bvh);
        buildRestrictedResults(i,trial) = toc;
    end
end
saveloc = sprintf("%sBuildRestrictedBoxResults_v%d.mat",folder,version);
save(saveloc,"buildRestrictedResults","numVertices");
%% Edge-Edge Collision Timing 
rng(1);
numTrials = 10000;
edgeResults = zeros(1,100);
for i = 1:numTrials
    edge1 = Edge(rand(2,1)*0.6,rand(2,1)*0.6 + 0.4);
    edge2 = Edge(rand(2,1)*0.6 + 0.4,rand(2,1)*0.6);
    tic
    EdgeIntersectionTest(edge1,edge2);
    edgeResults(1,i) = toc;
end

saveloc = sprintf("%sEdgeIntersectionTestResults_v%d.mat",folder,version);
save(saveloc,"edgeResults");
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
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N);
        
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
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N);
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
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N);
        
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
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[0.9,0.9]);
        
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
%% Timing Collision Check with Brute Force and LIGHT COLLISION
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionBruteForceResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    rng(1);
    for trial = 1:numTrialsPerVertice
        
        N = numVertices(i);
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[0.9,0.9]);
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
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N,[0.9,0.9]);
        
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