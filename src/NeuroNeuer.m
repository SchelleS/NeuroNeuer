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
        predictionLine
        targetLine
    end
    
    methods
        
        function obj = NeuroNeuer()
            fclose(instrfind);
            
            obj.dbrad = 5;
            obj.dbcnt = 20;
            obj.buffSize = 100;
            obj.predictionLine = 15;
            obj.targetLine = 120;
            
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
            %obj.servo = Servo(obj.arduinoPort);
            %init DVS
            obj.dvs = DVS(obj.dvsPort, 12000000);
            
            %init model
            obj.model = Model(obj.dbrad, obj.dbcnt, obj.predictionLine, obj.targetLine);
            %init gui
            obj.gui = GUI(obj.predictionLine, obj.targetLine);
            
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
                el1 = toc(obj.start1);
                if(el1>=0.00001)
                    obj.start1 = tic;
                    %display('very fast stuff')
                    if(obj.dvs.eventsAvailable())
                        events = obj.dvs.getEvents();
                        events = events(events(:,3)==1, 1:3);
                        obj.buffer.Add(events)
                    end
                end
                %moveServoToPosition_value(obj.servo,rand);
                el2 = toc(obj.start2);
                if(el2>=0.0001)
                    obj.start2 = tic;
                    %display('fast stuff')
                    obj.model.updateBallPositionAndVelocity(obj.buffer.GetAll(), el2);
                end

                el3 = toc(obj.start3);
                if(el3>=0.1)
                    obj.start3 = tic;
                    %display('slow stuff')
                    if length(obj.model.newBallPos) == 2 && length(obj.model.ballVel) == 2
                        %update gui
                        obj.gui.update(obj.buffer.GetAll(), obj.model.newBallPos, obj.model.ballVel, obj.model.ballPosForPrediction, obj.model.ballVelForPrediction, obj.model.ballPosForTarget, obj.model.ballVelForTarget);
                    end
                end

                pause(0.00000001)
            end
        end
        
    end
    
end
