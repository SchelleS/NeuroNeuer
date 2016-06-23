

classdef Servo < handle
    
    properties
        arduino_board
        servo_motor
    end
    
    methods
        function obj = Servo()
            

        end
        function init(obj,arduino_board,s)
            obj.arduino_board = arduino_board;
            obj.servo_motor = s;
        end
            
        function moveServoToPosition_value(obj,value)
            writePosition(obj.servo_motor, value);
        end
        function moveServoToPosition_degrees(obj,degrees)
            writePosition(obj.servo_motor, degrees/180);
        end
    end
    
end

