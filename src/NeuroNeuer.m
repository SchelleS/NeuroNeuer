classdef NeuroNeuer < handle
    
    properties
        servo
        dvs
        model
        gui
    end
    
    methods
        function obj = NeuroNeuer()
            %close all serial ports
                        
            %init Servo Control
            obj.servo = Servo();
            %init DVS
            obj.dvs = DVS('COM3', 6000000);
            %init model
            obj.model = Model();
            %init gui
            obj.gui = GUI();
        end
    end
    
end
