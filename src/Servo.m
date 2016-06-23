

classdef Servo < handle
    
    properties
        arduino_board
        servo_motor
    end
    
    methods
        function obj = Servo(comPort)
            display('init Arduino and Servo')
            obj.arduino_board = arduino(comPort, 'Uno', 'Libraries', 'Servo');
            obj.servo_motor = servo(obj.arduino_board,'D4','MinPulseDuration',9.00e-4,'MaxPulseDuration',2.1e-3);
        end
           
        function moveServoToPosition_value(obj,value)
            writePosition(obj.servo_motor, value);
        end
        function moveServoToPosition_degrees(obj,degrees)
            writePosition(obj.servo_motor, degrees/180);
        end
    end
    
end

