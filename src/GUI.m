classdef GUI < handle
    
    properties
        plt
        plt2
        plt3
        plt4
        plt5
        pline
        tline
    end
    
    methods
        function obj = GUI(predictionLine, targetLine)
           hold off
           obj.pline = plot([128-predictionLine, 128-predictionLine],[0, 128]);
           hold on
           obj.tline = plot([128-targetLine, 128-targetLine],[0, 128]);
           
           obj.plt = scatter([1 2], [1 2], 5, 'red');
           obj.plt2 = quiver(0,0,0,0);
           obj.plt3 = quiver(0,0,0,0);
           obj.plt4 = scatter(0, 0, 100, 'blue');
           obj.plt5 = scatter(0, 0, 50, 'red');
           axis([-10, 138,-10,138]);
           xlabel('128-y')
           ylabel('128-x')
        end
        
        function update(obj, events, ballPos, ballVel, ballPosForPred, ballVelForPred, ballPosForTar, ballPosPredicted)
           %events = events(events(:,3)==1, 1:4);
           events(:,[1,2,3]) = events(:, [2,1,3]);
           events(:,1:2) = 128 - events(:,1:2);
           obj.plt.XData = events(:, 1);
           obj.plt.YData = events(:, 2);
           C = zeros(size(events, 1), 3);
           C(:, 2) = events(:,3);
           obj.plt.CData = C;

           obj.plt2.XData = 128 - ballPos(2);
           obj.plt2.YData = 128 - ballPos(1);
           obj.plt2.UData = -ballVel(2);
           obj.plt2.VData = -ballVel(1);
           
           if length(ballPosForPred) == 2
               obj.plt3.XData = 128 - ballPosForPred(2);
               obj.plt3.YData = 128 - ballPosForPred(1);
               obj.plt3.UData = -ballVelForPred(2);
               obj.plt3.VData = -ballVelForPred(1);
           end
           if length(ballPosPredicted) == 1
               obj.plt5.XData = 20;
               obj.plt5.YData = 128 - ballPosPredicted;
           end
           if length(ballPosForTar) == 2
               obj.plt4.XData = 128 - ballPosForTar(2);
               obj.plt4.YData = 128 - ballPosForTar(1);
           end
           refreshdata;
        end
    end
    
end