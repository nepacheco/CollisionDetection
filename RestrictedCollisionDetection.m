function [inCollision, edges] = RestrictedCollisionDetection(bvh1,bvh2,l1,h1,l2,h2)
%RESTRICTEDCOLLISIONDETECTION Performs collision detection between two
%Restricted Box Trees
%   Detailed explanation goes here
inCollision = false;
edges = [];
leaf1 = length(bvh1.edges) == 1; % The first BVH is a leaf
leaf2 = length(bvh2.edges) == 1; % The second BVH is leaf
if ~(leaf1 && leaf2) % at least one of the BVH is not a leaf
    x_collision = (l1(1) < h2(1)) && (l2(1) < h1(1));
    y_collision = (l1(2) < h2(2)) && (l2(2) < h1(2));
    if ~(x_collision && y_collision)
        return
    else
        if leaf1 % BVH 1 is a leaf, and BVH 2 is a regular node
            [bvh2Child1_l,bvh2Child1_h] = RestrictedBox.updateCorner(l2,h2,bvh2.children(1));
            [child_collision, child_edges] = RestrictedCollisionDetection(bvh1,bvh2.children(1),l1,h1,bvh2Child1_l,bvh2Child1_h);
            [bvh2Child2_l,bvh2Child2_h] = RestrictedBox.updateCorner(l2,h2,bvh2.children(2));
            [child_collision2, child_edges2] = RestrictedCollisionDetection(bvh1,bvh2.children(2),l1,h1,bvh2Child2_l,bvh2Child2_h);
            inCollision = child_collision || child_collision2;
            edges = [edges child_edges child_edges2];
        elseif leaf2 % BVH1 is a regular node and BVH2 is a leaf
            [bvh1Child1_l,bvh1Child1_h] = RestrictedBox.updateCorner(l1,h1,bvh1.children(1));
            [child_collision, child_edges] = RestrictedCollisionDetection(bvh1.children(1), bvh2,bvh1Child1_l,bvh1Child1_h,l2,h2);
            [bvh1Child2_l, bvh1Child1_h] = RestrictedBox.updateCorner(l1,h1,bvh1.children(2));
            [child_collision2, child_edges2] = RestrictedCollisionDetection(bvh1.children(2),bvh2,bvh1Child2_l, bvh1Child1_h,l2,h2);
            inCollision = child_collision || child_collision2;
            edges = [edges child_edges child_edges2];
        else % Both are regular Nodes
            [bvh1Child1_l,bvh1Child1_h] = RestrictedBox.updateCorner(l1,h1,bvh1.children(1)); % Get updated corners
            [bvh1Child2_l, bvh1Child2_h] = RestrictedBox.updateCorner(l1,h1,bvh1.children(2));
            [bvh2Child1_l,bvh2Child1_h] = RestrictedBox.updateCorner(l2,h2,bvh2.children(1));
            [bvh2Child2_l,bvh2Child2_h] = RestrictedBox.updateCorner(l2,h2,bvh2.children(2));
            
            [child_collision, child_edges] = RestrictedCollisionDetection(bvh1.children(1), bvh2.children(1),bvh1Child1_l,bvh1Child1_h,bvh2Child1_l,bvh2Child1_h);
            [child_collision2, child_edges2] = RestrictedCollisionDetection(bvh1.children(2),bvh2.children(1),bvh1Child2_l,bvh1Child2_h,bvh2Child1_l,bvh2Child1_h);
            [child_collision3, child_edges3] = RestrictedCollisionDetection(bvh1.children(1), bvh2.children(2),bvh1Child1_l,bvh1Child1_h,bvh2Child2_l,bvh2Child2_h);
            [child_collision4, child_edges4] = RestrictedCollisionDetection(bvh1.children(2),bvh2.children(2),bvh1Child2_l,bvh1Child2_h,bvh2Child2_l,bvh2Child2_h);
            inCollision = child_collision || child_collision2 || child_collision3 || child_collision4;
            edges = [edges child_edges child_edges2 child_edges3 child_edges4];   
        end
    end
else
    inCollision = EdgeIntersectionTest(bvh1.edges(1),bvh2.edges(1));
    if inCollision
        edges = [bvh1.edges;bvh2.edges];
    end
    return
end
end

