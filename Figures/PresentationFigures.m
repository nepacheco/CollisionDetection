%% PolygonFigures
close all
rng(1);
vertices = [10,40,60];
figure 
for i = 1:length(vertices)
  	f = figure;
    hold on
    polygon = NPolygon(vertices(i));
    polygon.plotPolygon();
    title(sprintf("%d Vertices",vertices(i)),'FontSize',32,'FontName','CMU Serif');
    hold off
    saveas(f,sprintf("Figures/Circle%dVertices.png",vertices(i)));
end
for i = 1:length(vertices)
    f = figure;
    polygon = SimplePolygon(vertices(i));
    polygon.plotPolygon();
    title(sprintf("%d Vertices",vertices(i)),'FontSize',32,'FontName','CMU Serif');
    saveas(f,sprintf("Figures/Square%dVertices.png",vertices(i)));
end