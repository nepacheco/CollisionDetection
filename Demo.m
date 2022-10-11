%% 
clc;clear; close all;

%% Generating Polygons
rng(1);
vertices = [10,40,60];
figure 
for i = 1:length(vertices)
    subplot(2,3,i)
    hold on
    polygon = NPolygon(vertices(i));
    polygon.plotPolygon();
    title(sprintf("%d Vertices",vertices(i)));
    hold off
end
for i = 1:length(vertices)
    subplot(2,3,i+3)
    polygon = SimplePolygon(vertices(i));
    polygon.plotPolygon();
    title(sprintf("%d Vertices",vertices(i)));
end
waitforbuttonpress;

%% Showing an AABB Tree
rng(1)
N = 6;
polygon = NPolygon(N);
bvh = AABB(polygon.edges);

c = distinguishable_colors(5);
figure
polygon.plotPolygon();
for i = 1:4
    bvh.plotBox('Layer',i,'LineWidth',3.5-i*0.5,'Color',c(i,:));
    w = waitforbuttonpress();
end

%% Showing Restricted Box Tree
rng(1)
N = 6;
polygon = NPolygon(N);
bvh = AABB(polygon.edges,0,false);
bvh = RestrictedBox.makeTree(bvh);

c = distinguishable_colors(10);
f = figure;
polygon.plotPolygon();
movegui(f,[0,550])
RestrictedBox.plotBox(bvh,'Layer',1,'LineWidth',3.5-1*0.5,'Color',c(1,:),'plotEdges',true);
hold on
waitforbuttonpress();
for i = 2:5
    ft = figure;
    RestrictedBox.plotBox(bvh,'Layer',i,'LineWidth',3.5-i*0.5,'Color',c(i,:),'plotEdges',true);
    w = waitforbuttonpress();
end

%%