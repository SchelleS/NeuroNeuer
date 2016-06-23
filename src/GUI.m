classdef GUI < handle
    
    properties
        plt
    end
    
    methods
        function obj = GUI()
           obj.plt = scatter([1 2], [1 2], 5, 'red'); 
           axis([0,128,0,128]);
        end
        
        function update(obj, events)
           obj.plt.XData = events(:, 1);
           obj.plt.YData = events(:, 2);
           refreshdata;
        end
    end
    
end