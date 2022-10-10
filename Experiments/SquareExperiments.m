%% utils
clc; clear; close all;
addpath("PrimitiveTest")
version = 2;
folder = "Results/Square/";
%% Timing Building AABB Tree
SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
buildAABBResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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
SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
buildRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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
%% Edge-Edge Collision Timing 

rng(1);
numTrials = 10000;
edgeResults = zeros(1,100);
for i = 1:numTrials
    edge1 = Edge(rand(2,1),rand(2,1));
    edge2 = Edge(rand(2,1),rand(2,1));
    tic
    EdgeIntersectionTest(edge1,edge2);
    edgeResults(1,i) = toc;
end
saveloc = sprintf("%sEdgeIntersectionTestResults_v%d.mat",folder,version);
save(saveloc,"edgeResults");
%% Timing Collision Check AABB Tree and HEAVY COLLISION

SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionAABBResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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

SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionBruteForceResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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

SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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

SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionAABBResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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

SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:10;
numTrialsPerVertice = 20;
collisionBruteForceResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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

SimplePolygon(10);
SimplePolygon(10);
rng(1);
numVertices = 5:5:100;
numTrialsPerVertice = 20;
collisionRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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