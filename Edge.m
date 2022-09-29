classdef Edge
    %EDGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vertex1 (2,1) double 
        vertex2 (2,1) double 
    end
    
    methods
        function obj = Edge(vertex1,vertex2)
            %EDGE Construct an instance of this class
            %   Detailed explanation goes here
            obj.vertex1 = vertex1;
            obj.vertex2 = vertex2;
        end
    end
end

