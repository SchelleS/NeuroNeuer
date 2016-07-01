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
            
            %baudrate
            %obj.serial.WriteLine('!U=4000000'); 
            
            %data format
            obj.serial.WriteLine('!E0');
            pause(0.1);
            obj.serial.Flush();
            disp('DVS timestamp enabled');

            %start event sending
            obj.serial.WriteLine('E+');
            %obj.serial.Flush();
            %dummy read 3 chars as reply
            obj.serial.Read(3);
            display('DVS started event streaming');
            
        end
        
        function dispEvents(obj)
            disp(obj.serial.Read(1));
        end
        
        function events = getEvents(obj)  % get n events (=4*n bytes) from sensor
            events = [];
            n = obj.eventsAvailable();
            %if at leat one response is complete
            %TODO: check if Bytes Availible is always multible of 4
            %makes problem when not 4 bytes are returned see Mode 'E1'
            if (n>0)     
                bytes2Read = n*2;
                %TODO: For other modi g.E. 'E1'. Read all an buffer uncomplete 
                eventBytes=obj.serial.Read(bytes2Read);
                eventY=eventBytes(1:2:end);         % fetch every 2nd byte starting from 1st
                eventX=eventBytes(2:2:end);         % fetch every 2nd byte starting from 2nd

                %timeStamp = 256*eventBytes(3:4:end) + eventBytes(4:4:end);

                % split data in polarity and y-events
                eventP=eventX>127;
                eventX=(eventX-(128*eventP));

                eventY = eventY - 128;
                events =[eventX eventY eventP];% timeStamp];
            end % (n>3)
        end
        
        function events = eventsAvailable(obj)
            n=obj.serial.BytesAvailable();
            events = floor(n/2);
        end
        
        function reset(obj)
            obj.serial.WriteLine('r');           
            pause(0.2);                             
            obj.serial.Flush();                  
            disp('DVS128 reset');
        end
        
        function disconnect(obj)
            obj.serial.WriteLine('E-');                     
            obj.serial.Close();                             
            disp ('COM-Port closed');  
        end
        
    end
end