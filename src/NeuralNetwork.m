classdef NeuralNetwork < handle
% filtered data (position, velocity) in pixel is given to the model. Here
% the calculations and controlling will happen
    properties
        hiddenLayerSize
        net
        tr
        input
        target
    end
    
    methods
        function obj = NeuralNetwork()
            hiddenLayerSize = 17;
            obj.net = fitnet(hiddenLayerSize);
            obj.net = init(obj.net);
            
            load 'NNinput.mat' input;
            load 'NNtarget.mat' target;
            obj.input = input;
            obj.target = target;
            obj.trainIt();
        end
        function addSample(obj,X,Y,dX,dY,pixelNeuer)
            obj.input = [obj.input,[X;Y;dX;dY]];
            obj.target = [obj.target,pixelNeuer];
            input = obj.input;
            target = obj.target;
            save 'NNinput.mat' input;
            save 'NNtarget.mat' target;
        end
        function trainIt(obj)% function name 
            %[obj.net] = adapt(obj.net,input,target);
            if(size(obj.input,2)>1 && length(obj.target)>1)
                inputTrain = obj.input(:,2:end);
                targetTrain = obj.target(2:end);
                [obj.net] = train(obj.net,inputTrain,targetTrain); % eckige Klammer ?
            end
        end
        function numberTrained = getNumberTrained(obj)
            numberTrained = length(obj.target);
            
        end
        function output = evaluate(obj,inputs)
            [output] = sim(obj.net,inputs);
        end
        function trainedNet = getNet(obj)
            trainedNet = obj.net;
        end
        function absorbBadData(obj)
            newInput = [];
            newTarget = [];
            for sample =1: size(obj.input,2)
                for wert = (1:size(obj.input,1))
                    if(wert == 1)
                        
                    end
                    if(wert == 2)
                            
                        end
                    if(wert == 3)
                                    
                        end
                    if(wert == 4)
                            
                    end
                end
            end
        end
    end
    
end

