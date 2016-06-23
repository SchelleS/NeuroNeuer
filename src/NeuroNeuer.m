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
            fclose(instrfind);
            
            % set serial port names here
            obj.dvsPort = 'com9';
            obj.servoPort = 'com4';
            
            %close all serial ports
            obj.init();        
            obj.connect();
            
            % start main loop
            obj.run()
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
            obj.dvs.connect();
        end
        
        function run(obj)
            % endless loop
            while(1)
                if(obj.dvs.eventsAvailable())
                    events = obj.dvs.getEvents();
                    %disp(events);
                    obj.gui.update(events);
                else
                    disp('no events')
                end
                pause(0.0001)
            end
        end
        
    end
    
end
