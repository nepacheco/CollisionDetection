function output = OnSegment(p,q,r)
%ONSEGMENT - checks if point r is on the line segment p-q
%   from https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
output = false;
if (r(1) <= max(p(1), q(1)) && r(1) >= min(p(1),q(1)) && ...
        r(2) <= max(p(2),q(2)) && r(2) >= min(p(2),q(2)))
    output = true;
end
end