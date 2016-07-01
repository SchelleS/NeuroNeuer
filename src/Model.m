classdef Model < handle
% filtered data (position, velocity) in pixel is given to the model. Here
% the calculations and controlling will happen
    properties
        filter
        neuralNet
        servo
        oldBallPos
        newBallPos
        ballVel
        velBuffer
        ballVelocityTemp
        predLine
        tarLine
        eps
        ballPosForPrediction
        ballVelForPrediction
        ballPosForTarget
        ballVelForTarget
        positionPredicted
        targetPredicted
        predPixel
        allowTraining
    end
    
    methods
        function obj = Model(dbrad, dbcnt, predictionLine, targetLine, ardPort, aT)
            %init filter
            obj.filter = DVSfilter(dbrad, dbcnt);
            obj.neuralNet = NeuralNetwork();
            obj.servo = Servo(ardPort);
            
            obj.oldBallPos = [-1, -1];
            obj.newBallPos = [-1, -1];
            obj.ballVel = [0, 0];
            obj.velBuffer = zeros(2, 2);
            obj.predLine = predictionLine;
            obj.tarLine = targetLine;
            obj.eps = 12;
            obj.positionPredicted = 0;
            obj.allowTraining = aT;
        end
        
        function updateBallPositionAndVelocity(obj, events, elapsed)
            if obj.oldBallPos == [-1, -1]
                obj.newBallPos = obj.filter.calculateBallPositionWithFilter(events);
                obj.oldBallPos = obj.newBallPos;
                obj.ballVel = [0, 0];
            else
                %obj.newBallPos = (1 - obj.alpha)*obj.oldBallPos + obj.alpha*obj.filter.calculateBallPositionWithFilter(events);
                obj.newBallPos = obj.filter.calculateBallPositionWithFilter(events);
                obj.ballVelocityTemp = (obj.newBallPos - obj.oldBallPos)/(elapsed);
                
                %obj.velBuffer = [obj.ballVelocityTemp; obj.velBuffer(1:end-1, :)];
                %mean2 = mean(obj.velBuffer,1);
                obj.ballVel = obj.ballVelocityTemp / norm(obj.ballVelocityTemp);
                
                if length(obj.newBallPos) == 2 && length(obj.oldBallPos) == 2
                    
                    %if (obj.positionPredicted == 0 && obj.ballVel(2) > 0 && obj.newBallPos(2) < obj.predLine + obj.eps && obj.newBallPos(2) > obj.predLine - obj.eps)
                     if (obj.ballVel(2) > 0 && obj.newBallPos(2) < obj.predLine + obj.eps && obj.newBallPos(2) > obj.predLine - obj.eps)
                        obj.ballPosForPrediction = obj.newBallPos;
                        obj.ballVelForPrediction = obj.ballVel;
                        obj.positionPredicted = 1;
                        X = obj.ballPosForPrediction(1);
                        Y = obj.ballPosForPrediction(2);
                        dX = obj.ballVelForPrediction(1);
                        dY = obj.ballVelForPrediction(2);
                        
                        disp(obj.neuralNet.getNumberTrained())
                        if obj.neuralNet.getNumberTrained()>1
                            obj.predPixel = obj.neuralNet.evaluate([X;Y;dX;dY]);
                            obj.servo.moveServoToPosition_pixel(obj.predPixel);
                        end
                        
                        %disp(obj.ballPosForPrediction)
                    end
                    
                    if (obj.positionPredicted == 1 && obj.newBallPos(2) < obj.tarLine + obj.eps && obj.newBallPos(2) > obj.tarLine - obj.eps)
                        obj.ballPosForTarget = obj.newBallPos;
                        obj.ballVelForTarget = obj.ballVel;
                        
                        X = obj.ballPosForPrediction(1);
                        Y = obj.ballPosForPrediction(2);
                        dX = obj.ballVelForPrediction(1);
                        dY = obj.ballVelForPrediction(2);
                        
                        
                        dXTarget = obj.ballPosForTarget(1);
                        
                        obj.positionPredicted = 0;
                        
                        %add sample for training network
                        if obj.allowTraining
                            obj.neuralNet.addSample(X, Y, dX, dY, dXTarget);
                            obj.neuralNet.trainIt();
                        end
                        %disp(obj.ballPosForPrediction)
                    end
                    
                end

                obj.oldBallPos = obj.newBallPos;
            end

        end
        
    end
    
end