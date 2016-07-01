classdef DVSfilter < handle    
    
    properties
        % change if camera not aligned straight
        xmin
        xmax
        
        % cluster values
        epsilon
        minPts
        
    end
    
    methods
        
        function obj = DVSfilter(eps, minpts)
            obj.epsilon = eps;
            obj.minPts = minpts;
            
        end
        
        function ballPos = calculateBallPositionWithFilter(obj, events)
            %filteredEvents = obj.filterBorder(events);
            ballPos = obj.getBallPosition(events);
        end
        
        % deletes all elements beyond borders
        function filteredEvents = filterBorder(obj, events)
            % TODO implement border filter
            filteredEvents = events;%events(events(1) < obj.xmax & events(1) > obj.xmin);
        end
        
        
        % calculate ball position
        % may also return timestamp for velocity calculation
        function ballPos = getBallPosition(obj, filteredData)
            % run dbscan 'on ON' data
            A=filteredData(filteredData(:,3)==1, 1:2);
            %A=filteredData(:, 1:2);
            IDX=DBSCAN(A, obj.epsilon, obj.minPts);
%             if any(IDX == 2)
%                 ballPos = -1
%             else
                disp(IDX)
                clusterNumb = 1;%mode(IDX);
                ballPos = mean(A(IDX==clusterNumb, :));
%             end
        end
        
    end
    
end