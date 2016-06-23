close all
clear all
clear workspace


servoClass = Servo();

for x = (0:10:180)
    %moveServoToPosition_value(servoClass,x/180);
    moveServoToPosition_degrees(servoClass,x);
    display('MOVED SERVO TO POSITION:')
    display(x)
    pause(0.2);
    
end

display('FINISHED')