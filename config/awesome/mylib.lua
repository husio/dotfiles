-- mylib.lua

require("beautiful")

function system(command)
    local data_file = io.popen(command)
    local out = data_file:read()
    data_file:close()
    return out
end

local label_color = beautiful.fg_normal
local message_color = beautiful.fg_focus

function format(label, message)
    -- return formated message
    local label = '<span color="'.. label_color ..'>'.. label ..'</span>'
    local message = '<span color="'.. message_color ..'</span>'.. message ..'</span>'
    return label .. ': ' .. message
end
