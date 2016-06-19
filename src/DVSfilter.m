classdef DVSfilter < handle    
    
    properties
        % change if camera not aligned straight
        xmin
        xmax
        ymin
        ymax
        
        % cluster values
        epsilon
        minPts
        
    end
    
    methods
        
        function obj = DVSfilter(eps, minpts)
            obj.epsilon = eps;
            obj.minPts = minpts;
            
        end
        
        % deletes all elements beyond borders
        function filteredEvents = filterBorder(obj, events)
            % TODO implement border filter
            filteredEvents = events;
        end
        
        
        % calculate ball position
        % may also return timestamp for velocity calculation
        function ballPos = getBallPosition(filteredData)
            
            % run dbscan 'on ON' data
            A=filteredData(filteredData(:,3)==1, 1:2);
            IDX=DBSCAN(A, obj.epsilon, obj.MinPts);
            clusterNumb = mode(IDX);
            ballPos = mean(A(IDX==clusterNumb, :));
            
        end
        
    end
    
end