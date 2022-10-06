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
        
        function plot(obj,options)
            arguments
                obj
                options.LineWidth (1,1) double = 1.5
                options.color (3,1) double = [1;0;0]
            end
            gca;
            hold on;
            x = [obj.vertex1(1);obj.vertex2(1)];
            y = [obj.vertex1(2);obj.vertex2(2)];
            plot(x,y,'LineWidth',options.LineWidth, 'Color',options.color);
            hold off;
        end
    end
end

