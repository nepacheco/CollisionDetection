classdef NPolygon < handle
    %NPOLYGON Polygon with N vertices and Edges
    %   Detailed explanation goes here
    
    properties
        vertices (2,:) double
        edges
        pos (2,1) double
    end
    
    methods
        function obj = NPolygon(pos,N)
            %NPolygon Construct an instance of this class
            %   Creates a polygon with the specified number of vertices and
            %   eges
            arguments
                pos (2,1) double = [0;0]
                N (1,1) double {mustBeGreaterThan(N,2)} = 3
            end
            obj.pos = pos;
            angleStep = 2*pi/N;
            for i = 1:N
                vertexAngle = (i-1)*angleStep + rand()*angleStep;
                vertexMag = rand();
                obj.vertices(:,i) = pos + [cos(vertexAngle) -sin(vertexAngle); sin(vertexAngle) cos(vertexAngle)]*[vertexMag;0];
            end
        end
        
        function p = plotPolygon(obj)
            %plotPolygon Plots the Polygon
            %   Detailed explanation goes here
            gca
            hold on
            polyVertices = [obj.vertices obj.vertices(:,1)];
            p = plot(polyVertices(1,:), polyVertices(2,:),'-.');
            grid on
            axis equal
            hold off
        end
    end
end

