classdef NeuroNeuer < handle
    
    properties
        dvsPort
        arduinoPort
        servo
        dvs
        buffer
        model
        gui
        millis_last
        start1
        start2
        start3
        dbrad
        dbcnt
        alpha
        minEvents
        buffSize
    end
    
    methods
        
        function obj = NeuroNeuer()
            fclose(instrfind);
            
            obj.dbrad = 2;
            obj.dbcnt = 15;
            obj.alpha = 0.5;
            obj.buffSize = 400;
            
            % set serial port names here
            obj.dvsPort = 'com9';
            obj.arduinoPort = 'com10';
            
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
            
            %init model
            obj.model = Model(obj.dbrad, obj.dbcnt, obj.alpha);
            %init gui
            obj.gui = GUI();
            
            %init buffer
            obj.buffer = BufferRing(obj.buffSize);
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
            obj.start3 = tic;
            while(1)
                elapsed = toc(obj.start1);
                if(elapsed>=0.0000000000001)
                    obj.start1 = tic;
                    %display('very fast stuff')
                    if(obj.dvs.eventsAvailable())
                        elapsed = tic - obj.start1;
                        events = obj.dvs.getEvents();
                        obj.buffer.Add(events)
                    end
                end
                %moveServoToPosition_value(obj.servo,rand);
                elapsed = toc(obj.start3);
                if(elapsed>=0.01)
                    obj.start3 = tic;
                    display('fast stuff')
                    obj.model.updateBallPositionAndVelocity(obj.buffer.GetAll(), elapsed);
                    if length(obj.model.newBallPos) == 2 && length(obj.model.ballVel) == 2
                        %update gui
                        obj.gui.update(obj.buffer.GetAll(), obj.model.newBallPos, obj.model.ballVel);
                    end
                end

                elapsed = toc(obj.start2);
                if(elapsed>=0.5)
                    obj.start2 = tic;
                    display('slow stuff')
                end

                pause(0.000000000000000000000001)
            end
        end
        
    end
    
end
