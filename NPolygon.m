classdef NPolygon < handle
    %NPOLYGON Polygon with N vertices and Edges
    %   Detailed explanation goes here
    
    properties
        vertices (2,:) double
        edges (1,:) Edge
        pos (2,1) double
    end
    
    methods
        function obj = NPolygon(N,pos,random)
            %NPolygon Construct an instance of this class
            %   Creates a polygon with the specified number of vertices and
            %   eges
            arguments
                N (1,1) double {mustBeGreaterThan(N,2)} = 3
                pos (2,1) double = [0;0]
                random (1,1) logical = true
            end
            obj.pos = pos;
            angleStep = 2*pi/N;
            for i = 1:N
                if random
                    vertexAngle = (i-1)*angleStep + rand()*angleStep;
                    vertexMag = rand();
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
        
        function plotPolygon(obj)
            %plotPolygon Plots the Polygon
            %   Detailed explanation goes here
            gca;
            hold on;
            for i = 1:length(obj.edges)
                obj.markEdge(i)
            end
            grid on;
            axis equal;
            hold off;
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

