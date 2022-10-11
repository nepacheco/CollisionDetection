classdef RestrictedBox
    %RESTRICTEDBOX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        splitPlaneAxis
        dir
        dist
        children
        edges
    end
    
    methods
        function obj = RestrictedBox(splitPlaneAxis, dir, dist, edges)
            arguments
                splitPlaneAxis
                dir
                dist
                edges
            end
            %RESTRICTEDBOX Construct an instance of this class
            %   Detailed explanation goes here
            obj.splitPlaneAxis = splitPlaneAxis;
            obj.dir = dir;
            obj.dist = dist;
            obj.edges = edges;
             
        end

        function obj = translateBox(obj,dist)
            
        end
    end
    methods(Static)
        function box = makeTree(box)
            arguments
                box (1,1) AABB
            end
            box.children = RestrictedBox.makeChildren(box.edges,box.l,box.h);
        end
        
        function children = makeChildren(edges,l,h)
            % MAKECHILDREN - make children out of the current edges
            arguments
                edges (1,:) Edge
                l (2,1) double 
                h (2,1) double 
            end 
            planes = [1 0; 0 1]; % x axis and y axis for splitting plane
            childrenDirection = [1 1;-1 -1; 1 -1];% upper children; lower children; upper child and lower child
%             childrenDirection  = [1 -1]; 
            minVolume = Inf;
            splittingAxis = [0;0];
            childDir = [0 0];
            dist = [0,0];
            edgeList1 = [];
            edgeList2 = [];
            for i = 1:length(planes)
                axis = planes(:,i);
                for j = 1:size(childrenDirection,1)
                    dir = childrenDirection(j,:);
                    [seed1, seed2, tedges] = RestrictedBox.getSeeds(edges,dir,axis);
                    [volumeTotal,edgeList1_,edgeList2_,corners] = RestrictedBox.createVolumes(tedges,seed1,seed2,axis);
                    tdist = [0,0];
                    volumeTotal = 0;
                    for k = 1:2
                        if dir(k) > 0  % set distance based on upper child
                            % if upper child we adjust l corner
                            tdist(k) = dot(corners(:,1,k),axis) - dot(l,axis);
                            sideLength = h - (l + tdist(k).*axis);
                            volumeTotal = volumeTotal + sideLength(1)*sideLength(2);
                        else % set distance based on lower child
                            % if lower child we adjust h corner
                            tdist(k) = dot(h,axis) - dot(corners(:,2,k),axis);
                            sideLength = (h - tdist(k).*axis) - l;
                            volumeTotal = volumeTotal + sideLength(1)*sideLength(2);
                        end
                    end
                     
                    if volumeTotal < minVolume
                        dist = tdist;
                        minVolume = volumeTotal;
                        edgeList1 = edgeList1_;
                        edgeList2 = edgeList2_;
                        splittingAxis = axis;
                        childDir = dir;
                    end
                end
            end
            % Child 1
            child1 = RestrictedBox(splittingAxis,childDir(1),dist(1),edgeList1);
            if length(edgeList1) > 1
                if childDir(1) >  0 % upper child
                    child1.children = RestrictedBox.makeChildren(edgeList1,l + splittingAxis*dist(1),h);
                else % lower chlid
                    child1.children = RestrictedBox.makeChildren(edgeList1,l,h - splittingAxis*dist(1));
                end
            end
            % Child 2
            child2 = RestrictedBox(splittingAxis,childDir(2),dist(2),edgeList2);
            if length(edgeList2) > 1
                if childDir(2) >  0 % upper child
                    child2.children = RestrictedBox.makeChildren(edgeList2,l + splittingAxis*dist(2),h);
                else % lower chlid
                    child2.children = RestrictedBox.makeChildren(edgeList2,l,h - splittingAxis*dist(2));
                end
            end
            % to return children
            children = [child1,child2];
        end
        
        function [seed1, seed2, edges] = getSeeds(edges,dir,axis)
            seedPos1 = dot(axis,(edges(1).vertex1 + edges(2).vertex2)/2); %*dir(1);
            seed1 = edges(1);
            seedPos2 = dot(axis,(edges(2).vertex1 + edges(2).vertex2)/2); %*dir(2);
            seed2 = edges(2);
            if seedPos2*dir(1) > seedPos1*dir(1)  % Necessary to check when we only have 2 edges 
                % this just lets us swap the two seeds off the bat since we
                % dont check them in the loop below
                tEdge = seed1;
                tPos = seedPos1;
                seed1 = seed2;
                seedPos1 = seedPos2;
                seed2 = tEdge;
                seedPos2 = tPos;
            end
            for edge = edges(3:end)
                edgePos = dot(axis,(edge.vertex1 + edge.vertex2)/2);
                if edgePos*dir(1) > seedPos1*dir(1) % modify based on lower or upper child
                    if seedPos1*dir(2) > seedPos2*dir(2)  
                        % Since anytime a somethign becomes a seed1, it
                        % doesn't get checked for seed2, if seed1 gets
                        % replaced we then see if the original seed1 works
                        % for seed 2
                        seed2 = seed1;
                        seedPos2 = seedPos1;
                    end
                    seed1 = edge;
                    seedPos1 = edgePos;
                    continue
                end
                if edgePos*dir(2) > seedPos2*dir(2)  % modify based on lower or upper child
                    seed2 = edge;
                    seedPos2 = edgePos;
                    continue
                end
            end
%             edges = edges((edges~=seed1)&(edges~=seed));
            remIndex = [0,0];
            remCount = 1;
            for i = 1:length(edges)
                if edges(i) == seed1 || edges(i) == seed2
                    remIndex(remCount) = i;
                    remCount = remCount + 1;
                end
            end
            edges(remIndex) = [];
        end
        function [volumeTotal, edgeList1,edgeList2, corners] = createVolumes(edges,seed1,seed2,axis)
            %CREATEVOLUMES - divide an edge list into two separate
            %edgeLists for bounding volumes 
            edgeList1 = seed1;
            l1 = min(seed1.vertex1,seed1.vertex2); % lower corner box 1
            h1 = max(seed1.vertex1,seed1.vertex2); % upper corner box 1
            edgeList2 = seed2;
            l2 = min(seed2.vertex1,seed2.vertex2); % lower corner box 2
            h2 = max(seed2.vertex1,seed2.vertex2); % upper corner box 2
            for edge = edges  % loop through edges
%                 volume1 = RestrictedBox.getVolume(edgeList1);
%                 volume2 = RestrictedBox.getVolume(edgeList2);
                % instead of figuring out the entire volume, just see which
                % edge set extends the most along the axis chosen for
                % separation. The distance is found by dotting the axis
                % with the distance between the corners. This is because,
                % we can't shrink the distance of any side perpendicular to
                % the splitting axis.
                [~, l1T, h1T] = RestrictedBox.getVolume([edgeList1 edge]);
                [~, l2T, h2T] = RestrictedBox.getVolume([edgeList2, edge]);
                volume1 = dot((h1-l1),axis);
                volume2 = dot((h2-l2),axis);
                volume1Ext = dot((h1T-l1T),axis);
                volume2Ext = dot((h2T-l2T),axis);
                if volume1Ext + volume2 < volume1 + volume2Ext
                    % Adding to list 1 will keep total volume lowest
                    % update corners
                    temp_lw = min(edge.vertex1,edge.vertex2);
                    temp_hw = max(edge.vertex1,edge.vertex2);
                    l1 = min(l1,temp_lw);
                    h1 = max(h1,temp_hw);
                    % update list
                    edgeList1 = [edgeList1 edge];
                else
                    % Adding to list 2 will keep total volume lowest
                    % update corners
                    temp_lw = min(edge.vertex1,edge.vertex2);
                    temp_hw = max(edge.vertex1,edge.vertex2);
                    l2 = min(l2,temp_lw);
                    h2 = max(h2,temp_hw);
                    % update list
                    edgeList2 = [edgeList2, edge];
                end
            end
            corners(:,:,1) = [l1,h1];
            corners(:,:,2) = [l2,h2]; % corners of first child; corners of second child
            volumeTotal = RestrictedBox.getVolume(edgeList1) + RestrictedBox.getVolume(edgeList2);
        end
        
        function [volume, l, h] = getVolume(edges)
            %GETVOLUME - return the volume of the box with the given set of
            %edges and the corners of the new box. 
            l = min(edges(1).vertex1,edges(1).vertex2);
            h = max(edges(1).vertex1,edges(1).vertex2);
            for i = 2:length(edges)
                temp_lw = min(edges(i).vertex1,edges(i).vertex2);
                temp_hw = max(edges(i).vertex1,edges(i).vertex2);
                l = min(l,temp_lw);
                h = max(h,temp_hw);
            end
            sideLengths = h-l;
            volume = sideLengths(1)*sideLengths(2);
        end
        
        function [l, h] = updateCorner(l,h,box)
            arguments
                l (2,1) double
                h (2,1) double
                box (1,1) RestrictedBox
            end
            if box.dir > 0
                l = l + box.splitPlaneAxis.*box.dist;
            else
                h = h - box.splitPlaneAxis.*box.dist;
            end
        end
        
        function plotBox(box,options)
            arguments
                box (1,1) AABB
                options.layer (1,1) double = 1;
                options.Color = [0 0 1];
                options.LineWidth = 2;
                options.plotEdges = false;
            end
            if options.layer == 1
                box.plotBox('color',options.Color,'LineWidth',options.LineWidth);
            else
                RestrictedBox.plotLayer(box.children(1),box.l,box.h,options.layer-1,...
                    'Color',options.Color,'LineWidth',options.LineWidth,'PlotEdges',options.plotEdges)
                RestrictedBox.plotLayer(box.children(2),box.l,box.h,options.layer-1,...
                    'Color',options.Color,'LineWidth',options.LineWidth,'PlotEdges',options.plotEdges)
            end
                
        end
        
        function plotLayer(box,l,h,layer,options)
            arguments
                box (1,1) RestrictedBox
                l 
                h
                layer
                options.Color = [0 0 1]
                options.LineWidth = 2
                options.PlotEdges = false
            end
            if box.dir > 0
                l = l + box.splitPlaneAxis.*box.dist;
            else
                h = h - box.splitPlaneAxis.*box.dist;
            end
            if layer == 1
                gca;
%                 figure
                if options.PlotEdges
                    for edge = box.edges
                        edge.plot('color',options.Color)
                    end
                end
                hold on;
                points = [l, [l(1);h(2)], h, [h(1);l(2)], l];
                plot(points(1,:), points(2,:),'LineWidth',options.LineWidth,...
                    'Color', options.Color,'LineStyle','--');
                hold off;
            elseif ~isempty(box.children)
                RestrictedBox.plotLayer(box.children(1),l,h,layer-1,...
                    'Color',options.Color,'LineWidth',options.LineWidth,'plotEdges',options.PlotEdges)
                RestrictedBox.plotLayer(box.children(2),l,h,layer-1,...
                    'Color',options.Color,'LineWidth',options.LineWidth,'plotEdges',options.PlotEdges)
            end
        end
    end
end

