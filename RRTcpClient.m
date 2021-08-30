classdef RRTcpClient < handle
    %RRTcpClient Request-Response client over TCP
    % This class requires binnEncode and binnDecode functions to be
    % available in matlab path. See https://github.com/funbiscuit/binn-matlab
    % on how to compile them.
    % Example C++ implementation of Request-Response server with Qt:
    % https://github.com/funbiscuit/qt-rr-tcp
    %
    % Sample usage:
    %     % Create client
    %     client = RRTcpClient('localhost', 4141);
    %
    %     % Build request struct (all fields are just examples)
    %     request=[];
    %     request.info='test';
    %     request.num=21;
    %     request.data=zeros(1, 1000);
    %     request.delay=10;
    %
    %     % Send request and receive response
    %     response = client.sendRequest(request);
    
    properties
        % whether to automatically throw an error if
        % received response contains 'error' field
        throwErrors = false;
    end
    
    properties (SetAccess = private)
        tcpObj
        
        nextId=uint64(1);
        
        % map with pending responses
        responses;
        
        % list of all occured errors
        errors;
    end
    
    properties (Constant, GetAccess = private)
    end
    
    methods
        function obj = RRTcpClient(address, port)
            obj.responses = containers.Map('KeyType','uint64','ValueType','any');
            
            obj.tcpObj = tcpclient(address, port);
        end
        
        function response = sendRequest(obj, payload)
            id=obj.nextId;
            obj.nextId=id+1;
            
            request.request=id;
            request.data=payload;
            if isKey(obj.responses, id)
                remove(obj.responses, id);
            end
            data=binnEncode(request);
            data=[typecast(uint32(length(data)),'uint8') data];
            obj.tcpObj.write(data);
            while ~isKey(obj.responses, id)
                obj.read();
            end
            response = obj.responses(id);
            remove(obj.responses, id);
            if obj.throwErrors && isfield(response,'error')
                error(response.error);
            end
        end
        
        function delete(obj)
            delete(obj.tcpObj);
        end
    end
    
    methods (Access=private)
        function read(obj)
            % allows to execute tcp.read at least one time
            dataSize = 1;

            while dataSize ~= 0 || obj.tcpObj.BytesAvailable > 0
                dataSize = typecast(obj.tcpObj.read(4),'uint32');
                data=obj.tcpObj.read(dataSize);
                
                try
                    msg=binnDecode(data);
                    obj.onData(msg);
                catch ME
                    obj.errors{end+1}=ME;
                end
                dataSize=0;
            end
        end
        
        function onData(obj, msg)
            % only responses are supported
            id=msg.response;
            obj.responses(id)=msg.data;
        end
    end
end
