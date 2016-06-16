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
        
        function events = GetEvents(obj)  % get n events (=4*n bytes) from sensor
            events = [];
            n = EventsAvailable(obj);
            %if at leat one response is complete
            %TODO: check if Bytes Availible is always multible of 4
            %makes problem when not 4 bytes are returned see Mode 'E1'
            if (n>0)     
                bytes2Read = n*4;
                %TODO: For other modi g.E. 'E1'. Read all an buffer uncomplete 
                eventBytes=obj.serial.Read(bytes2Read);
                eventY=eventBytes(1:4:end);         % fetch every 2nd byte starting from 1st
                eventX=eventBytes(2:4:end);         % fetch every 2nd byte starting from 2nd

                timeStamp = 256*eventBytes(3:4:end) + eventBytes(4:4:end);

                % split data in polarity and y-events
                eventP=eventX>127;
                eventX=(eventX-(128*eventP));

                eventY = eventY - 128;
                events =[eventX eventY eventP timeStamp];
            end % (n>3)
        end
        
        function events = EventsAvailable(obj)
            n=obj.serial.BytesAvailable();
            events = floor(n/4);
        end
        
        function reset(obj)
            obj.serial.WriteLine('r');           
            pause(0.2);                             
            obj.serial.Flush();                  
            disp('DVS128 reset');
        end
        
    end
end