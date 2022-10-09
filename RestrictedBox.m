classdef RestrictedBox
    %RESTRICTEDBOX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        splitPlaneAxis
        childDir
        dist
        children
        edges
    end
    
    methods
        function obj = RestrictedBox(splitPlaneAxis, childDir, dist, edges)
            arguments
                splitPlaneAxis
                childDir
                dist
                edges
            end
            %RESTRICTEDBOX Construct an instance of this class
            %   Detailed explanation goes here
            obj.splitPlaneAxis = splitPlaneAxis;
            obj.childDir = childDir;
            obj.dist = dist;
            obj.edges = edges;
             
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
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
            arguments
                edges (1,:) Edge
                l
                h
            end 
            planes = [1 0; 0 1]; % x axis and y axis for splitting plane
            childrenDirection = [1 1;-1 -1; 1 -1];  % upper children; lower children; upper child and lower child
            minVolume = Inf;
            splitPlane = [0 0];
            childDir = [0 0];
            dist = [0,0];
            edgeList1 = [];
            edgeList2 = [];
            for i = 1:2
                axis = planes(i,:);
                for j = 1:3
                    dir = childrenDirection(i,:);
                    [seed1, seed2, tedges] = RestrictedBox.getSeeds(edges,dir,axis);
                    [volumeTotal,edgeList1_,edgeList2_,corners] = RestrictedBox.createVolumes(tedges,seed1,seed2);
                    if volumeTotal < minVolume
                        for k = 1:2
                            if dir(k) > 0  % set distance based on upper child
                                dist(k) = dot(h,axis) - dot(corners(2,:,k),axis);
                            else
                                dist(k) = dot(corners(1,:,k),axis) - dot(l,axis);
                            end
                        end
                        minVolume = volumeTotal;
                        edgeList1 = edgeList1_;
                        edgeList2 = edgeList2_;
                        splitPlane = axis;
                        childDir = dir;
                    end
                end
            end
            % Child 1
            child1 = RestrictedBox(splitPlane,childDir,dist,edgeList1);
            if length(edgeList1) > 1
                if dir(1) >  0 % upper child
                    child1.children = RestrictedBox.makeChildren(edgeList1,l + dist(1),h);
                else % lower chlid
                    child1.children = RestrictedBox.makeChildren(edgeList1,l,h - dist(1));
                end
            end
            % Child 2
            child2 = RestrictedBox(splitPlane,childDir,dist,edgeList2);
            if length(edgeList1) > 2
                if dir(1) >  0 % upper child
                    child2.children = RestrictedBox.makeChildren(edgeList2,l + dist(2),h);
                else % lower chlid
                    child2.children = RestrictedBox.makeChildren(edgeList2,l,h - dist(2));
                end
            end
            % to return children
            children = [child1,child2];
        end
        
        function [seed1, seed2, edges] = getSeeds(edges,dir,axis)
            seedPos1 = -100*dir(1);
            seed1 = 0;
            seedPos2 = -100*dir(2);
            seed2 = 0;
            for edge = edges
                edgePos = dot(axis,(edge.vertex1 + edge.vertex2)/2);
                if edgePos*dir(1) > seedPos1*dir(1) % modify based on lower or upper child
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
        function [volumeTotal, edgeList1,edgeList2, corners] = createVolumes(edges,seed1,seed2)
            edgeList1 = [seed1];
            l1 = min(seed1.vertex1,seed1.vertex2);
            h1 = max(seed1.vertex1,seed1.vertex2);
            edgeList2 = [seed2];
            l2 = min(seed2.vertex1,seed1.vertex2);
            h2 = max(seed2.vertex1,seed1.vertex2);
            for edge = edges
                if RestrictedBox.getVolume([edgeList1 edge]) < RestrictedBox.getVolume([edgeList2, edge])
                    temp_lw = min(edge.vertex1,edge.vertex2);
                    temp_hw = max(edge.vertex1,edge.vertex2);
                    l1 = min(l1,temp_lw);
                    h1 = max(h1,temp_hw);
                    edgeList1 = [edgeList1 edge];
                else
                    temp_lw = min(edge.vertex1,edge.vertex2);
                    temp_hw = max(edge.vertex1,edge.vertex2);
                    l2 = min(l2,temp_lw);
                    h2 = max(h2,temp_hw);
                    edgelist2 = [edgeList2, edge];
                end
            end
            corners(:,:,1) = [l1,h1];
            corners(:,:,2) = [l2,h2]; % corners of first child; corners of second child
            volumeTotal = RestrictedBox.getVolume(edgeList1) + RestrictedBox.getVolume(edgeList2);
        end
        
        function volume = getVolume(edges)
            l = min(edges(1).vertex1,edges(1).vertex2);
            h = max(edges(1).vertex1,edges(1).vertex2);
            for i = 2:length(edges)
                temp_lw = min(edges(i).vertex1,edges(i).vertex2);
                temp_hw = max(edges(i).vertex1,edges(i).vertex2);
                l = min(l,temp_lw);
                h = max(h,temp_hw);
            end
            sideLengths = h-l;
            volume = norm(sideLengths)^2;
        end
    end
end

