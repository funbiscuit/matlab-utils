function success = waitCondition(timeout, condition, update, updateInterval)
%WAITCONDITION Wait for certain condition to become true with timeout
% timeout   - how much time to wait in seconds (if negative, will wait
%             infinitely)
% condition - function handle that is used to evaluate condition
% update    - function handle that is called at update interval (optional)

t0 = clock;
time = 0;

if ~exist('updateInterval','var') || isempty(updateInterval)
    updateInterval=0.1;
end
try
    while (time<timeout || timeout<0) && ~condition()
        pause(updateInterval);
        time = etime(clock,t0);
        
        if exist('update','var') && ~isempty(update)
            update();
        end
    end
    
    success = condition();
catch
    success = false;
end

end

