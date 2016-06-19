classdef NeuroNeuer < handle
    
    properties
        dvsPort
        servoPort
        servo
        dvs
        filter
        model
        gui
    end
    
    methods
        
        function obj = NeuroNeuer()
            % set serial port names here
            obj.dvsPort = 'COM3';
            obj.servoPort = 'COM4';
            
            %close all serial ports
            obj.init();        
            %obj.connect();
        end
        
        % initialize servo and camera
        function init(obj)
            %init Servo Control
            obj.servo = Servo();
            %init DVS
            obj.dvs = DVS(obj.dvsPort, 6000000);
            %init filter
            obj.filter = DVSfilter(2, 10);
            %init model
            obj.model = Model();
            %init gui
            obj.gui = GUI();
        end
        
        % start serial connections
        function connect(obj)
            % connect servo
            %obj.servo.connect();
            
            % connect dvs
            %obj.dvs.connect();
        end
        
    end
    
end
