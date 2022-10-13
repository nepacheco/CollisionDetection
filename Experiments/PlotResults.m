clc;clear;close all;
version = 3;
folder = "Results/Square/";
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
legend('FontSize',12)
str = sprintf("Time to build bounding volume \nhierarchies for %s polygons",erase(erase(folder,"Results/"),"/"));
title(str,'FontSize',16)
xlabel("Number of Vertices",'FontSize',14)
ylabel("Time (s)",'FontSize',14)

%% Plot Edge-Edge Timing
try
    load(sprintf("%sEdgeIntersectionTestResults_v%d",folder,version))
    mean(edgeResults);
    fprintf("Edge-Edge Comparisons take about %0.5f microseconds\n",mean(edgeResults)*1e6);
catch
end

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
legend('FontSize',12)
str = sprintf("Time to perform heavy collision  \ndetection for %s polygons",erase(erase(folder,"Results/"),"/"));
title(str,'FontSize',16)
xlabel("Number of Vertices",'FontSize',14)
ylabel("Time (s)",'FontSize',14)


figure
hold on
grid on

plot(numVertices,mean(numCollisions,2),'LineWidth',2)
xlabel("Number of Vertices",'FontSize',14)
ylabel("Number of Collisions",'FontSize',14);
title("Number of Collisions vs Number of Vertices",'FontSize',16);

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
legend('FontSize',12)
str = sprintf("Time to perform light collision  \ndetection for %s polygons",erase(erase(folder,"Results/"),"/"));
title(str,'FontSize',16)
xlabel("Number of Vertices",'FontSize',14)
ylabel("Time (s)",'FontSize',14)
ylim([0,0.12])

figure
hold on
grid on
plot(numVertices,mean(numCollisions,2),'LineWidth',2)
xlabel("Number of Vertices",'FontSize',14)
ylabel("Number of Collisions",'FontSize',14);
title("Number of Collisions vs Number of Vertices",'FontSize',16);