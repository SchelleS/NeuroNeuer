classdef GUI < handle
    
    properties
        plt
        plt2
    end
    
    methods
        function obj = GUI()
           hold off
           obj.plt = scatter([1 2], [1 2], 5, 'red');
           hold on
           obj.plt2 = quiver(0,0,0,0);
           axis([0,128,0,128]);
        end
        
        function update(obj, events, ballPos, ballVel)
           obj.plt.XData = events(:, 1);
           obj.plt.YData = events(:, 2);
           

           obj.plt2.XData = ballPos(1);
           obj.plt2.YData = ballPos(2);
           obj.plt2.UData = ballVel(1);
           obj.plt2.VData = ballVel(2);
           
           refreshdata;
        end
    end
    
end