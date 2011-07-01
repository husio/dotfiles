module(..., package.seeall)

function split(str, splitchar, times)
    local splitchar = splitchar or ' '
    local times = times or -1
    local result = {}
    local start = 1
    -- cut place - begin & end
    local cut = { begins = 1, ends = 0 }

    repeat 
        start = cut.ends + 1
        cut.begins, cut.ends = str:find(splitchar, start)
        if cut.begins ~= nil then cut.begins = cut.begins - 1 end
        table.insert(result, str:sub(start, cut.begins))
        times = times - 1
    until cut.begins == nil or times == 0
    -- append the rest of the string
    if times == 0 then
        table.insert(result, str:sub(cut.ends + 1))
    end
    return result
end
-- add it as string method
string.split = split


function startswith(str, begstr)
    if str:sub(1, begstr:len()) == begstr then
        return true
    end
    return false
end
string.startswith = startswith


function endswith(str, endstr)
    local endlen = str:len() - endstr:len()  + 1
    if str:sub(endlen) == endstr then
        return true
    end
    return false
end
string.endswith = endswith


function join(str, strtab)
    return table.concat(strtab, str)
end
string.join = join


function strip(str)
    local start = 1
    local end_ = str:len()
    for char in str:gmatch(".") do
        if char ~= " " then break end
        start = start + 1
    end
    for char in str:reverse():gmatch(".") do
        if char ~= " " then break end
        end_ =  end_ + 1
    end
    return str.sub(start, end_)
end
string.strip = strip
