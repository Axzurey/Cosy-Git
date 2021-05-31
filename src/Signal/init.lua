local Signal = {}
Signal.__index = Signal

local Players = game:GetService("Players")

local Defaults = {
    ClientJoined = Players.PlayerAdded;
    ClientLeft = Players.PlayerRemoving;
}

function Signal:LoadSignals()
    local CustomSignals = {
        ClientChatted = {
            Dep = Defaults.ClientJoined;
            Function = function(this, Client, ...)
                Client.Chatted:Connect(function(Message)
                    for _, v in next, self.Signals[this] do
                        coroutine.wrap(function()
                            v(Client, Message)
                        end)()
                    end
                    for _, v in next, self.SignalsOnce[this] do
                        coroutine.wrap(function()
                            v(Client, Message)
                        end)()
                    end
                    self.SignalsOnce[this] = {}
                end)
            end;
        };
        CharacterAdded = {
            Dep = Defaults.ClientJoined;
            Function = function(this, Client, ...)
                Client.CharacterAdded:Connect(function(Character)
                    for _, v in next, self.Signals[this] do
                        coroutine.wrap(function()
                            v(Client, Character)
                        end)()
                    end
                    for _, v in next, self.SignalsOnce[this] do
                        coroutine.wrap(function()
                            v(Client, Character)
                        end)()
                    end
                    self.SignalsOnce[this] = {}
                end)
            end;
        }
    }

    for i, v in next, CustomSignals do
        self.Connections[i] = {}
        self.Signals[i] = {}
        self.SignalsOnce[i] = {}
        v.Dep:Connect(function(...)
            v.Function(i, ...)
        end)
    end
    for i, v in next, Defaults do
        self.Signals[i] = {}
        self.SignalsOnce[i] = {}
        self.Connections[i] = {}
        v:Connect(function(...)
            for _, x in next, self.Signals[i] do
                coroutine.wrap(function(...)
                    x(...)
                end)(...)
            end
            for _, x in next, self.SignalsOnce[i] do
                coroutine.wrap(function(...)
                    x(...)
                end)(...)
            end
            self.SignalsOnce[i] = {}
        end)
    end
end

function Signal.new()
    local self = setmetatable({
        Signals = {};
        SignalsOnce = {};
        Connections = {};
        Clients = {};
    }, Signal)
    function self.on(Event, Callback)
        if self.Signals[Event] then
            table.insert(self.Signals[Event], Callback)
        else
            error(Event.." is not an event")
        end
        return {
            Disconnect = function()
                if self.Signals[table.find(self.Signals[Event], self.Callback)] then
                    self.Signals[table.find(self.Signals[Event], self.Callback)] = nil
                end
            end;
        }
    end
    self:LoadSignals()
    function self.once(Event, Callback)
        if self.SignalsOnce[Event] then
            table.insert(self.SignalsOnce[Event], Callback)
        else
            error(Event.." is not an event")
        end
        return {
            Disconnect = function()
                if self.SignalsOnce[table.find(self.SignalsOnce[Event], self.Callback)] then
                    self.SignalsOnce[table.find(self.SignalsOnce[Event], self.Callback)] = nil
                end
            end;
        }
    end
    return self
end

return {
    exports = {
        constructor = function()
            return Signal.new()
        end
    }
}