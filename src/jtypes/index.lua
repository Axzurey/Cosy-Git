local Console = {}
Console.__index = Console

local HttpService = game:GetService("HttpService")

Console.log = function(...)
    print(...)
end

Console.error = function(...)
    error(...)
end

Console.warn = function(...)
    warn(...)
end

local eval = function(...)
    return loadstring(...)
end

local JSON = {}
JSON.Encode = function(...)
    return HttpService:JSONEncode(...)
end

JSON.Decode = function(...)
    return HttpService:JSONDecode(...)
end

return {
    exports = {
        console = Console;
        eval = eval;
        JSON = JSON;
    }
}