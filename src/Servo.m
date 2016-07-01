

classdef Servo < handle
    
    properties
        arduino_board
        servo_motor
        pixelRandLinks
        pixelrandRechts
        differenz
    end
    
    methods
        function obj = Servo(comPort)
            display('init Arduino and Servo')
            obj.arduino_board = arduino('Com6', 'Uno', 'Libraries', 'Servo');
            obj.servo_motor = servo(obj.arduino_board,'D4','MinPulseDuration',9.00e-4,'MaxPulseDuration',2.1e-3);
            obj.pixelRandLinks = 0;%150
            obj.pixelrandRechts = 128;%50
            obj.differenz = obj.pixelrandRechts - obj.pixelRandLinks;
        
        end
           
        function moveServoToPosition_value(obj,value)
            writePosition(obj.servo_motor, value);
        end
        function moveServoToPosition_pixel(obj,pixel)
            if(pixel>=9 && pixel <= 105)
                degree = acosd(((pixel/obj.differenz-obj.pixelRandLinks)*2)-1);
                obj.moveServoToPosition_degrees(degree);
            end
        end
        function moveServoToPosition_degrees(obj,degrees)
            if degrees>=50 && degrees <=150
                writePosition(obj.servo_motor, degrees/180);
            end
        end
    end
    
end

