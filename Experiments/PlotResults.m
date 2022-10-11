% clc;clear;close all;
version = 2;
folder = "Results/Circle/";
%% Plot Build Results
loadloc = sprintf("%sBuildAABBResults_v%d",folder,version);
load(loadloc)
loadloc = sprintf("%sBuildRestrictedBoxResults_v%d",folder,version);
load(loadloc)

figure
hold on
grid on
plot(numVertices, mean(buildAABBResults,2),'LineWidth',2,'DisplayName',"AABB BVH")
plot(numVertices, mean(buildRestrictedResults,2),'LineWidth',2,'DisplayName',"Restricted Box BVH")
legend()
title("Time to build AABB trees and RestricedBox Trees")
xlabel("Number of Vertices")
ylabel("Time (s)")

%% Plot Edge-Edge Timing

load(sprintf("%sEdgeIntersectionTestResults_v%d",folder,version))
mean(edgeResults);
fprintf("Edge-Edge Comparisons take about %0.5f microseconds\n",mean(edgeResults)*1e6);

%% Heavy Collision Timing
load(sprintf("%sHeavyCollisionAABBResults_v%d",folder,version));
numAABBCollisions = numCollisions;
load(sprintf("%sHeavyCollisionBruteForceResults_v%d",folder,version));
numBruteCollisions = numCollisions;
load(sprintf("%sHeavyCollisionRestrictedBoxResults_v%d",folder,version));
numRestrictedCollisions = numCollisions;

if sum(sum(numRestrictedCollisions == numBruteCollisions))/400 == 1
    fprintf("Same number of detected Collisions\n");
end
if sum(sum(numAABBCollisions == numBruteCollisions))/400 == 1
    fprintf("Same number of detected Collisions\n");
end

figure
hold on
grid on
plot(numVertices, mean(collisionAABBResults,2),'LineWidth',2,'DisplayName',"AABB BVH")
plot(numVertices, mean(collisionRestrictedResults,2),'LineWidth',2,'DisplayName',"Restricted Box BVH")
plot(numVertices, mean(collisionBruteForceResults,2),'LineWidth',2,'DisplayName',"Brute Force")
legend()
title(sprintf("Time to perform heavy collision detection with\n AABB trees, RestrictedBox Trees, and Brute Force Detection"))
xlabel("Number of Vertices")
ylabel("Time (s)")


figure
hold on
grid on

plot(numVertices,mean(numCollisions,2),'LineWidth',2)
xlabel("Number of Vertices")
ylabel("Number of Collisions");
title("Number of Collisions vs Number of Vertices");

%% Light Collision Timing

load(sprintf("%sLightCollisionAABBResults_v%d",folder,version));
numAABBCollisions = numCollisions;
load(sprintf("%sLightCollisionBruteForceResults_v%d",folder,version));
numBruteCollisions = numCollisions;
load(sprintf("%sLightCollisionRestrictedBoxResults_v%d",folder,version));
numRestrictedCollisions = numCollisions;

if sum(sum(numRestrictedCollisions == numBruteCollisions))/400 == 1
    fprintf("Same number of detected Collisions\n");
end
if sum(sum(numAABBCollisions == numBruteCollisions))/400 == 1
    fprintf("Same number of detected Collisions\n");
end

figure
hold on
grid on
plot(numVertices, mean(collisionAABBResults,2),'LineWidth',2,'DisplayName',"AABB BVH")
plot(numVertices, mean(collisionRestrictedResults,2),'LineWidth',2,'DisplayName',"Restricted Box BVH")
plot(numVertices, mean(collisionBruteForceResults,2),'LineWidth',2,'DisplayName',"Brute Force")
legend()
title(sprintf("Time to perform light collision detection with\n AABB trees, RestrictedBox Trees, and Brute Force Detection"))
xlabel("Number of Vertices")
ylabel("Time (s)")

figure
hold on
grid on
plot(numVertices,mean(numCollisions,2),'LineWidth',2)
xlabel("Number of Vertices")
ylabel("Number of Collisions");
title("Number of Collisions vs Number of Vertices");