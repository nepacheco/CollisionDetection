clc; clear; close all;
polygon = NPolygon(20);
polygon.plotPolygon();
hold on
bvh = AABB(polygon.edges);
bvh.plotBox('Layer',5);

%% Testing Edge Intersection Test
clc; close all; clear;
N = 20;
polygon1 = NPolygon(N);
polygon2 = NPolygon(N);
polygon1.plotPolygon();
polygon2.plotPolygon();
xlim([-1,1]);
ylim([-1,1]);
total = 0;
for i = 1:N
    for j = 1:N
        if EdgeIntersectionTest(polygon1.edges(i),polygon2.edges(j))
            hold on;
            polygon1.markEdge(i,'Color',[0,0.5,0]);
            polygon2.markEdge(j,'Color',[0,0,1]);
            hold off;
            total = total + 1;
        end
    end
end
disp(total);