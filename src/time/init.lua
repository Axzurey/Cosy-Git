local time = {}
time.__index = time

local RunService = game:GetService("RunService")

function time.benchmark(F, ...)
    local t = os.clock()
    F(...)
    return os.clock() - t
end

function time.sleep(len)
    local l = 0
    repeat
        l += RunService.Heartbeat:Wait()
    until l >= len
        return l
end

return {
    exports = {
        sleep = time.sleep;
        benchmark = time.benchmark;
    }
}