close all
clear all
clear workspace

arduino_board = arduino('com6', 'Uno', 'Libraries', 'Servo');
s = servo(arduino_board,'D4','MinPulseDuration',9.00e-4,'MaxPulseDuration',2.1e-3);

servoClass = Servo();
init(servoClass,arduino_board,s);

for x = (0:10:180)
    %moveServoToPosition_value(servoClass,x/180);
    moveServoToPosition_degrees(servoClass,x);
    display('MOVED SERVO TO POSITION:')
    display(x)
    pause(0.2);
    
end

display('FINISHED')