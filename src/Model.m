classdef Model < handle
% filtered data (position, velocity) in pixel is given to the model. Here
% the calculations and controlling will happen
    properties
        filter
        oldBallPos
        newBallPos
        ballVel
        alpha
    end
    
    methods
        function obj = Model(dbrad, dbcnt, alpha)
            %init filter
            obj.filter = DVSfilter(dbrad, dbcnt);
            obj.oldBallPos = [-1, -1];
            obj.newBallPos = [-1, -1];
            obj.ballVel = [0, 0];
            obj.alpha = alpha;
        end
        
        function updateBallPositionAndVelocity(obj, events, elapsed)
            if obj.oldBallPos == [-1, -1]
                obj.newBallPos = obj.filter.calculateBallPositionWithFilter(events);
                obj.oldBallPos = obj.newBallPos;
                obj.ballVel = [0, 0];
            else
                %obj.newBallPos = (1 - obj.alpha)*obj.oldBallPos + obj.alpha*obj.filter.calculateBallPositionWithFilter(events);
                obj.newBallPos = obj.filter.calculateBallPositionWithFilter(events);
                obj.ballVel = (obj.newBallPos - obj.oldBallPos)/elapsed;
                disp('ball velocity')
                disp(obj.ballVel)
                disp('obj.newBallPos')
                disp(obj.newBallPos)
                disp('obj.oldBallPos')
                disp(obj.oldBallPos)
            end
            obj.oldBallPos = obj.newBallPos;
            
        end
        
    end
    
end