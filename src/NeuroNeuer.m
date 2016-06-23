classdef NeuroNeuer < handle
    
    properties
        dvsPort
        arduinoPort
        servo
        dvs
        filter
        model
        gui
        millis_last
        start1
        start2
    end
    
    methods
        
        function obj = NeuroNeuer()
            fclose(instrfind);
            
            % set serial port names here
            obj.dvsPort = 'com7';
            obj.arduinoPort = 'com6';
            
            %close all serial ports
            obj.init();        
            obj.connect();
            
            % start main loop
            obj.run()
            
            obj.millis_last = now;
        end
        
        % initialize servo and camera
        function init(obj)
            %init Servo Control
            obj.servo = Servo(obj.arduinoPort);
            %init DVS
            obj.dvs = DVS(obj.dvsPort, 12000000);
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
            obj.start1 = tic;
            obj.start2 = tic;
            while(1)
                elapsed = toc(obj.start1);
                if(elapsed>=0.00001)
                    obj.start1 = tic;
                    
                    if(obj.dvs.eventsAvailable())
                        events = obj.dvs.getEvents();
                        %disp(events);
                        obj.gui.update(events);
                        %some servo stuff just for testing
                       
                    else
                         
                        disp('no events')
                    end
                    
                    %moveServoToPosition_value(obj.servo,rand);
                    
                    elapsed = toc(obj.start2);
                    if(elapsed>=0.5)
                        obj.start2 = tic;
                        display('UPDATENEURONEUER')
                    end
                end
                pause(0.000000000000000000000001)
            end
        end
        
    end
    
end
