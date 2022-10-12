%%
clc; clear; close all;
version = 3;
folder = "Results/Velocity/";
%%
saveloc = sprintf("%sRestrictedVelocityResults_v%d",folder,4);
load(saveloc,"RestrictedAverageFrameRate","RestrictedCollisionMatrix","RestrictedPenetrationDistance");
velocity  = 10:10:100;

saveloc = sprintf("%sBruteForceVelocityResults_v%d",folder,4);
load(saveloc,"BruteForceAverageFrameRate","BruteForceCollisionMatrix","BruteForcePenetrationDistance");

saveloc = sprintf("%sAABBVelocityResults_v%d",folder,version);
load(saveloc,"AABBAverageFrameRate","AABBCollisionMatrix","AABBPenetrationDistance");

figure
hold on
title(sprintf("Average penetration distance\n during moving collisions"),'FontSize',16)
xlabel("Velocity of object",'FontSize',14)
ylabel("Penetration Distance",'FontSize',14)
plot(velocity, mean(AABBPenetrationDistance,2),'LineWidth',2','DisplayName','AABB BVH');
plot(velocity, mean(RestrictedPenetrationDistance,2),'LineWidth',2','DisplayName','Restricted Box Tree');
plot(velocity, mean(BruteForcePenetrationDistance,2),'LineWidth',2','DisplayName','Brute Force');
legend('FontSize',12)
grid on

figure
hold on
plot(velocity, mean(AABBAverageFrameRate,2),'LineWidth',2','DisplayName','AABB BVH');
plot(velocity, mean(RestrictedAverageFrameRate,2),'LineWidth',2','DisplayName','Restricted Box Tree');
plot(velocity, mean(BruteForceAverageFrameRate,2),'LineWidth',2','DisplayName','Brute Force');
legend('FontSize',12)
xlabel("Velocity",'FontSize',14);
ylabel("Average Frame Rate",'FontSize',14);
grid on
title("Frame Rate for different velocities",'FontSize',16);
