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
           events(:,[1,2,3,4]) = events(:, [2,1,3,4]);
           events(:,1:2) = 128 - events(:,1:2);
            %events = events(events(:,3)==1, 1:4);
           obj.plt.XData = events(:, 1);
           obj.plt.YData = events(:, 2);
           C = zeros(size(events, 1), 3);
           C(:, 2) = events(:,3);
           obj.plt.CData = C;

           obj.plt2.XData = 128 - ballPos(2);
           obj.plt2.YData = 128 - ballPos(1);
           obj.plt2.UData = -ballVel(2);
           obj.plt2.VData = -ballVel(1);
           
           refreshdata;
        end
    end
    
end