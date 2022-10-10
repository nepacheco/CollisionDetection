%% Timing Building AABB Tree
clc;clear;close all;
NPolygon(10);
NPolygon(10);
rng(1);
numVertices = 5:5:1000;
numTrialsPerVertice = 20;
buildAABBResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
        N = numVertices(i);
        polygon = NPolygon(N);
        tic
        bvh = AABB(polygon.edges,0,true);
        buildAABBResults(i,trial) = toc;
    end
end
save("BuildAABBResults.mat",buildAABBResults,numVertices);
%% Timing Building RestrictedBoxTree
clc;clear;close all;
NPolygon(10);
NPolygon(10);
rng(1);
numVertices = 5:5:1000;
numTrialsPerVertice = 20;
buildRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
        N = numVertices(i);
        polygon = NPolygon(N);
        tic
        bvh = AABB(polygon.edges,0,false);
        bvh = RestrictedBox.makeTree(bvh);
        buildRestrictedResults(i,trial) = toc;
    end
end
save("Results/BuildRestrictedBoxResults.mat","buildRestrictedResults","numVertices");
%% Edge-Edge Collision Timing
clc; clear; close all;
rng(1);
numTrials = 10000;
edgeResults = zeros(1,1000);
for i = 1:numTrials
    edge1 = Edge(rand(2,1),rand(2,1));
    edge2 = Edge(rand(2,1),rand(2,1));
    tic
    EdgeIntersectionTest(edge1,edge2);
    edgeResults(1,i) = toc;
end

save("Results/EdgeIntersectionTestResults.mat","edgeResults");

%% Timing Collision Check AABB Tree
clc;clear;close all;
NPolygon(10);
NPolygon(10);
rng(1);
numVertices = 5:5:1000;
numTrialsPerVertice = 20;
collisionAABBResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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
save("CollisionAABBResults.mat","collisionAABBResults","numVertices");
%% Timing Collision Check with Brute Force
clc;clear;close all;
NPolygon(10);
NPolygon(10);
rng(1);
numVertices = 5:5:1000;
numTrialsPerVertice = 20;
collisionAABBResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
        N = numVertices(i);
        polygon1 = NPolygon(N);
        polygon2 = NPolygon(N);
        tic
        [~,edges] = BruteForceCollisionDetection(polygon1,polygon2);
        collisionAABBResults(i,trial) = toc;
        numCollisions(i,trial) = size(edges,2);
    end
end
save("CollisionAABBResults.mat","collisionAABBResults","numVertices");
%% Timing Collision Check RestrictedBoxTree
clc;clear;close all;
NPolygon(10);
NPolygon(10);
rng(1);
numVertices = 5:5:1000;
numTrialsPerVertice = 20;
collisionRestrictedResults = zeros(length(numVertices),numTrialsPerVertice);
numCollisions = zeros(length(numVertices),numTrialsPerVertice);
for i = 1:length(numVertices)
    for trial = 1:numTrialsPerVertice
        rng(1);
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
save("CollisionRestrictedBoxResults.mat","collisionRestrictedResults","numVertices");