local socket = require("socket")

local host = "127.0.0.1"
local port = 6600

function mpd(cmd)
    local received = ''
    local r
    local client
    
    client = socket.connect(host, port)
    client:send(cmd .. "\n")
    r = client:receive()
    if not r:sub(1, 2) == "OK" then return nil end
    while true do
        if r == "OK" then 
            break
        else
            r = client:receive()
            received = received .. '\n' .. r
        end
    end
    client:close()
    return received
end


