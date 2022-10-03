function output = TripletOrientation(p,q,r)
%TripletOrientation Determine the orientation from a triplet of points
%   Returns 0 if collinear, 1 of clockwise, 2 if counterclockwise
%   https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
output = 0;
val = (q(2) - p(2))*(r(1) - q(1)) - (q(1) - p(1))*(r(2) - q(2));
if val == 0
    output = 0;
    return
end
if val > 0
    output = 1;
else
    output = 2;
end
end

