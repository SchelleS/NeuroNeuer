classdef NeuroNeuer < handle
    
    properties
        servo
        dvsread
        model
        gui
    end
    
    methods
        function obj = NeuroNeuer()
            %init Servo Control
            obj.servo = Servo();
            %init DVS
            obj.dvsread = DVSread();
            %init model
            obj.model = Model();
            %init gui
            obj.gui = GUI();
        end
    end
    
end
