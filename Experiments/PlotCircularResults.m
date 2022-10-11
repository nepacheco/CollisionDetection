clc;clear;close all;

%% Plot Build Results
load("Results/BuildAABBResults.mat")
load("Results/BuildRestrictedBoxResults.mat")

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

load("Results/EdgeIntersectionTestResults.mat")
mean(edgeResults);
fprintf("Edge-Edge Comparisons take about %0.5f microseconds\n",mean(edgeResults)*1e6);

%% Heavy Collision Timing
load("Results/HeavyCollisionAABBResults.mat");
numAABBCollisions = numCollisions;
load("Results/HeavyCollisionBruteForceResults.mat");
numBruteCollisions = numCollisions;
load("Results/HeavyCollisionRestrictedBoxResults.mat");
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
title(sprintf("Time to perform heavy collision detection with\n AABB trees, RestricedBox Trees, and Brute Force Detection"))
xlabel("Number of Vertices")
ylabel("Time (s)")

%% Light Collision Timing

load("Results/LightCollisionAABBResults.mat");
numAABBCollisions = numCollisions;
load("Results/LightCollisionBruteForceResults.mat");
numBruteCollisions = numCollisions;
load("Results/LightCollisionRestrictedBoxResults.mat");
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
title(sprintf("Time to perform light collision detection with\n AABB trees, RestricedBox Trees, and Brute Force Detection"))
xlabel("Number of Vertices")
ylabel("Time (s)")