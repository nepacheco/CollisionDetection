function [inCollision,edges] = BruteForceCollisionDetection(polygon1,polygon2)
%BRUTEFORCECOLLISIONDETECTION Summary of this function goes here
%   Detailed explanation goes here
N1 = length(polygon1.edges);
N2 = length(polygon2.edges);
inCollision = false;
edges = [];
for i = 1:N1
    for j = 1:N2
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            edges = [edges [polygon1.edges(1);polygon2.edges(2)]];
        end
    end
end
end

