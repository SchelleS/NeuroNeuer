classdef DVS < handle
    
    properties
        baudRate
        portName
        serial
    end
    
    methods
        
        function obj = DVS(pn, br)
            obj.baudRate = br;
            obj.portName = pn;
        end
        
        function connect(obj)
            obj.serial = SerialPort();
            obj.serial.Open(obj.portName, obj.baudRate);
            disp('DVS COM port opened');
            %clear input
            obj.serial.Flush();
            obj.reset();
            disp('DVS reset');
            
            %data format
            obj.serial.WriteLine('!E2');
            pause(0.1);
            obj.serial.Flush();
            disp('DVS timestamp enabled');
            
            %start event sending
            obj.serial.WriteLine('E+');
            %dummy read 3 chars as reply
            obj.serial.Read(3);
            display('DVS started event streaming');
            
        end
        
        function reset(obj)
            obj.serial.WriteLine('r');           
            pause(0.2);                             
            obj.serial.Flush();                  
            disp('DVS128 reset');
        end
        
    end
end