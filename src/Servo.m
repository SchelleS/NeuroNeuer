

classdef Servo < handle
    
    properties
        arduino_board
        servo_motor
        pixelRandLinks
        pixelrandRechts
        differenz
        degreeRandLinks
        degreeRandRechts
    end
    
    methods
        function obj = Servo(comPort)
            display('init Arduino and Servo')
            obj.arduino_board = arduino(comPort, 'Uno', 'Libraries', 'Servo');
            obj.servo_motor = servo(obj.arduino_board,'D4','MinPulseDuration',9.00e-4,'MaxPulseDuration',2.1e-3);
            obj.pixelRandLinks = 25;%150
            obj.pixelrandRechts = 105;%50
            obj.degreeRandLinks = 50;
            obj.degreeRandRechts = 160;
            
            obj.differenz = abs(obj.pixelrandRechts - obj.pixelRandLinks);
        
        end
           
        function moveServoToPosition_value(obj,value)
            writePosition(obj.servo_motor, value);
        end
        function moveServoToPosition_pixel(obj,pixel)
            %if(pixel>=9 && pixel <= 105)
            pixel = obj.pixelRandLinks + (obj.pixelrandRechts-pixel);
            if pixel<=obj.pixelRandLinks
                pixel = obj.pixelRandLinks;
            end
            if pixel >= obj.pixelrandRechts
               pixel = obj.pixelrandRechts; 
            end
            degree = acosd((((pixel-obj.pixelRandLinks)/obj.differenz)*2)-1);
            factor = degree/180;
            
            degree = obj.degreeRandLinks + factor*(obj.degreeRandRechts-obj.degreeRandLinks);
            obj.moveServoToPosition_degrees(degree);
            %end
        end
        function moveServoToPosition_degrees(obj,degrees)
                writePosition(obj.servo_motor, degrees/180);
        end
    end
    
end

