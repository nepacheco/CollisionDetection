classdef SimplePolygon < handle
    %NPOLYGON Polygon with N vertices and Edges
    %   Detailed explanation goes here
    
    properties
        vertices (2,:) double
        edges (1,:) Edge
        pos (2,1) double
        plotHandle
    end
    
    methods
        function obj = SimplePolygon(numSides,pos)
        arguments
            numSides
            pos = [0;0];
        end
        % https://stackoverflow.com/questions/8997099/algorithm-to-generate-random-2d-polygon
            if numSides < 3
                x = [];
                y = [];
                dt = DelaunayTri();
                return
            end

            oldState = warning('off', 'MATLAB:TriRep:PtsNotInTriWarnId');

            fudge = ceil(numSides/10);
            x = rand(numSides+fudge, 1);
            y = rand(numSides+fudge, 1);
            dt = DelaunayTri(x, y);
            boundaryEdges = freeBoundary(dt);
            numEdges = size(boundaryEdges, 1);

            while numEdges ~= numSides
                if numEdges > numSides
                    triIndex = vertexAttachments(dt, boundaryEdges(:,1));
                    triIndex = triIndex(randperm(numel(triIndex)));
                    keep = (cellfun('size', triIndex, 2) ~= 1);
                end
                if (numEdges < numSides) || all(keep)
                    triIndex = edgeAttachments(dt, boundaryEdges);
                    triIndex = triIndex(randperm(numel(triIndex)));
                    triPoints = dt([triIndex{:}], :);
                    keep = all(ismember(triPoints, boundaryEdges(:,1)), 2);
                end
                if all(keep)
                    warning('Couldn''t achieve desired number of sides!');
                    break
                end
                triPoints = dt.Triangulation;
                triPoints(triIndex{find(~keep, 1)}, :) = [];
                dt = TriRep(triPoints, x, y);
                boundaryEdges = freeBoundary(dt);
                numEdges = size(boundaryEdges, 1);
            end

            boundaryEdges = [boundaryEdges(:,1); boundaryEdges(1,1)];
            x = dt.X(boundaryEdges, 1);
            y = dt.X(boundaryEdges, 2);
            warning(oldState);
            
            for i = 1:numSides
                obj.vertices(:,i) = pos + [x(i);y(i)];
            end
            for i = 1:numSides
                obj.edges(1,i) = Edge(obj.vertices(:,i),obj.vertices(:,mod(i,numSides)+1));
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
                obj.edges(i).vertex1 = obj.edges(i).vertex1 + dist;
                obj.edges(i).vertex2 = obj.edges(i).vertex2 + dist;
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