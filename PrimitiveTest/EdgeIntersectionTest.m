function inCollision = EdgeIntersectionTest(edge1,edge2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
inCollision = false;
o1 = TripletOrientation(edge1.vertex1,edge1.vertex2,edge2.vertex1);
o2 = TripletOrientation(edge1.vertex1,edge1.vertex2,edge2.vertex2);
o3 = TripletOrientation(edge2.vertex1,edge2.vertex2,edge1.vertex1);
o4 = TripletOrientation(edge2.vertex1,edge2.vertex2,edge1.vertex2);

% General case
if (o1 ~= o2 && o3 ~= o4)
    inCollision = true;
    return
end

% Collinear Case
if ((o1 == 0) && OnSegment(edge1.vertex1,edge1.vertex2,edge2.vertex1))
    inCollision = true;
    return
end
% p1 , q1 and q2 are collinear and q2 lies on segment p1q1
if ((o2 == 0) && OnSegment(edge1.vertex1,edge1.vertex2,edge2.vertex2))
    inCollision = true;
    return
end
% p2 , q2 and p1 are collinear and p1 lies on segment p2q2
if ((o3 == 0) && OnSegment(edge2.vertex1,edge2.vertex2,edge1.vertex1))
    inCollision = true;
    return
end
% p2 , q2 and q1 are collinear and q1 lies on segment p2q2
if ((o4 == 0) && OnSegment(edge2.vertex1,edge2.vertex2,edge1.vertex2))
    inCollision = true;
    return
end
end

