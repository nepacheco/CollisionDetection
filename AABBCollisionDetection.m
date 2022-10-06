function [inCollision, edges] = AABBCollisionDetection(bvh1,bvh2)
    inCollision = false;
    edges = [];
    leaf1 = length(bvh1.edges) == 1; % The first BVH is a leaf
    leaf2 = length(bvh2.edges) == 1; % The second BVH is leaf
    if ~(leaf1 && leaf2) % at least one of the BVH is not a leaf
        x_collision = (bvh1.lw(1) < bvh2.hw(1)) && (bvh2.lw(1) < bvh1.hw(1));
        y_collision = (bvh1.lw(2) < bvh2.hw(2)) && (bvh2.lw(2) < bvh1.hw(2));
        if ~(x_collision && y_collision)
            return
        else
            if leaf1 % BVH 1 is a leaf, and BVH 2 is a regular node
                [child_collision, child_edges] = AABBCollisionDetection(bvh1, bvh2.children(1));
                [child_collision2, child_edges2] = AABBCollisionDetection(bvh1,bvh2.children(2));
                inCollision = child_collision || child_collision2;
                edges = [edges child_edges child_edges2];
            elseif leaf2 % BVH1 is a regular node and BVH2 is a leaf
                [child_collision, child_edges] = AABBCollisionDetection(bvh1.children(1), bvh2);
                [child_collision2, child_edges2] = AABBCollisionDetection(bvh1.children(2),bvh2);
                inCollision = child_collision || child_collision2;
                edges = [edges child_edges child_edges2];
            else % Both are regular Nodes
                [child_collision, child_edges] = AABBCollisionDetection(bvh1.children(1), bvh2.children(1));
                [child_collision2, child_edges2] = AABBCollisionDetection(bvh1.children(2),bvh2.children(1));
                [child_collision3, child_edges3] = AABBCollisionDetection(bvh1.children(1), bvh2.children(2));
                [child_collision4, child_edges4] = AABBCollisionDetection(bvh1.children(2),bvh2.children(2));
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