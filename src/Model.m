classdef Model < handle
% filtered data (position, velocity) in pixel is given to the model. Here
% the calculations and controlling will happen
    properties
        filter
        oldBallPos
        newBallPos
        ballVel
        alpha
        list
        ballVelocityTemp
    end
    
    methods
        function obj = Model(dbrad, dbcnt, alpha)
            %init filter
            obj.filter = DVSfilter(dbrad, dbcnt);
            obj.oldBallPos = [-1, -1];
            obj.newBallPos = [-1, -1];
            obj.ballVel = [0, 0];
            obj.alpha = alpha;
            obj.list = [0, 0];
        end
        
        function updateBallPositionAndVelocity(obj, events, elapsed)
            if obj.oldBallPos == [-1, -1]
                obj.newBallPos = obj.filter.calculateBallPositionWithFilter(events);
                obj.oldBallPos = obj.newBallPos;
                obj.ballVel = [0, 0];
            else
                %obj.newBallPos = (1 - obj.alpha)*obj.oldBallPos + obj.alpha*obj.filter.calculateBallPositionWithFilter(events);
                obj.newBallPos = obj.filter.calculateBallPositionWithFilter(events);
                obj.ballVelocityTemp = (obj.newBallPos - obj.oldBallPos)/elapsed;
                
                obj.ballVel = obj.ballVelocityTemp;
                
%                 if length(obj.newBallPos) == 2 && length(obj.oldBallPos) == 2
%                     obj.list = vertcat(obj.list , obj.ballVelocityTemp);
% 
%                     if(length(obj.list)>10)
%                         obj.list=obj.list(2:end, :);
%                     end
%                     disp('IM HEREEEEEEEE')
%                     obj.ballVel = mean(obj.list);
%                 end
                
                obj.oldBallPos = obj.newBallPos;
            end

        end
        
    end
    
end