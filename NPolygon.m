classdef NPolygon < handle
    %NPOLYGON Polygon with N vertices and Edges
    %   Detailed explanation goes here
    
    properties
        vertices (2,:) double
        edges (1,:) Edge
        pos (2,1) double
        plotHandle
    end
    
    methods
        function obj = NPolygon(N,pos,random)
            %NPolygon Construct an instance of this class
            %   Creates a polygon with the specified number of vertices and
            %   eges
            arguments
                N (1,1) double {mustBeGreaterThan(N,2)} = 3
                pos (2,1) double = [0;0]
                random (1,1) double = 1
            end
            obj.pos = pos;
            angleStep = 2*pi/N;
            for i = 1:N
                if random
                    vertexAngle = (i-1)*angleStep + rand()*angleStep;
                    vertexMag = rand()*random + (1-random);
                else
                    vertexAngle = (i-1)*angleStep;
                    vertexMag = 1;
                end
                obj.vertices(:,i) = pos + [cos(vertexAngle) -sin(vertexAngle); sin(vertexAngle) cos(vertexAngle)]*[vertexMag;0];
            end
            for i = 1:N
                obj.edges(1,i) = Edge(obj.vertices(:,i),obj.vertices(:,mod(i,N)+1));
            end
        end
        
        function translate(obj,dist,display)
            arguments
                obj
                dist (2,1) double
                display (1,1) logical = false
            end
            for i = 1:length(obj.vertices)
                obj.vertices(:,i) = obj.vertices(:,i) + dist;
                obj.edges(i).translate(dist);
            end
            obj.pos = obj.pos + dist;
            if display
                obj.updatePlot();
            end
        end
        
        function plotPolygon(obj,options)
            %plotPolygon Plots the Polygon
            %   Detailed explanation goes here
            arguments
                obj
                options.Color (1,3) double = [0 0 1];
                options.LineWidth (1,1) double = 1.5;
            end
            gca;
            hold on;
            points = [obj.vertices obj.vertices(:,1)];
            obj.plotHandle = plot(points(1,:),points(2,:),'Color',...
                options.Color,'LineWidth',options.LineWidth);
            grid on;
            axis equal;
            hold off;
        end
        
        function updatePlot(obj,options)
            %plotPolygon Plots the Polygon
            %   Detailed explanation goes here
            arguments
                obj
                options.Color (1,3) double = [0 0 1];
                options.LineWidth (1,1) double = 1.5;
            end
            points = [obj.vertices obj.vertices(:,1)];
            obj.plotHandle.XData = points(1,:);
            obj.plotHandle.YData = points(2,:);
        end
        
        function markEdge(obj,index,options)
            arguments
                obj
                index (1,1) double {mustBeInteger}
                options.color (3,1) double = [1;0;0]
            end
            obj.edges(index).plot('Color',options.color)
        end
        
    end
end

