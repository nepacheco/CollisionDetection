classdef AABB < handle
    %AABB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        children = []
        parent (1,1)
        l (2,1) double
        h (2,1) double 
        edges (1,:) 
        makeTree (1,1) logical = false
    end
    
    methods
        function obj = AABB(edges,parent,makeTree)
            arguments
                edges (1,:) Edge
                parent = 0
                makeTree (1,1) logical = true
            end
            %AABB Construct an instance of this class
            %   Detailed explanation goes here
            obj.edges = edges;
            obj.parent = parent;
            obj.l = min(edges(1).vertex1,edges(1).vertex2);
            obj.h = max(edges(1).vertex1,edges(1).vertex2);
            for i = 2:length(edges)
                temp_lw = min(edges(i).vertex1,edges(i).vertex2);
                temp_hw = max(edges(i).vertex1,edges(i).vertex2);
                obj.l = min(obj.l,temp_lw);
                obj.h = max(obj.h,temp_hw);
            end
            if makeTree
                obj.createChildren()
                obj.makeTree = true;
            end
        end
        
        
        function createChildren(obj)
            if (obj.h(2) - obj.l(2)) > (obj.h(1) - obj.l(1)) % split along y
                split_index = 2;
            else % split along x
                split_index = 1;
            end
            threshold = (obj.h(split_index) + obj.l(split_index))/2;
            edgeList1 = [];
            edgeList2 = [];
            tempList = [];
            if length(obj.edges) > 1
                for edge = obj.edges()
                    midpoint = (edge.vertex2(split_index) + edge.vertex1(split_index))/2;
                    if abs(midpoint - threshold) < eps
                        tempList = [tempList edge];
                        continue
                    end
                    if midpoint >= threshold
                        edgeList1 = [edgeList1 edge];
                    else
                        edgeList2 = [edgeList2 edge];
                    end
                end
                for edge = tempList
                    if length(edgeList1) < length(edgeList2)
                        edgeList1 = [edgeList1 edge];
                    else
                        edgeList2 = [edgeList2 edge];
                    end
                end
            obj.children = [AABB(edgeList1,obj), AABB(edgeList2,obj)];
            end
        end

        function translateBox(obj,dist)
            obj.h = obj.h + dist;
            obj.l = obj.l + dist;
            if length(obj.edges) == 1
                obj.edges.vertex1 = obj.edges.vertex1 + dist;
                obj.edges.vertex2 = obj.edges.vertex2 + dist;
            end
            obj.children(1).translateBox(dist);
            obj.children(2).translateBox(dist);
        end
        
        function plotBox(obj,options)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            arguments
                obj
                options.color = [0;0;1]
                options.LineWidth = 1
                options.layer = 1
            end
            if options.layer == 1  
                gca;
                hold on;
                points = [obj.l, [obj.l(1);obj.h(2)], obj.h, [obj.h(1);obj.l(2)], obj.l];
                plot(points(1,:), points(2,:),'LineWidth',options.LineWidth,...
                    'Color', options.color,'LineStyle','--');
                hold off;
            else
                if ~isempty(obj.children) && obj.makeTree
                    obj.children(1).plotBox('LineWidth', options.LineWidth,'layer',options.layer-1)
                    obj.children(2).plotBox('LineWidth', options.LineWidth,'layer',options.layer-1)
                end
            end
        end
    end
end

