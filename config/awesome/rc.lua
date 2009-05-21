require("awful")
require("beautiful")
--require("naughty")
require("revelation")

theme_path = "/home/piotrek/.config/awesome/themes/dark/theme"
beautiful.init(theme_path)

terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

spawn_cmd = {
    ["terminal"] = function(cmd)
                        if cmd then cmd = "xterm -e "..cmd else cmd = "xterm" end
                        awful.util.spawn(cmd)
                    end,
    ["ncmpc"] = function() awful.util.spawn(terminal .. " -fs 8 -class \"ncmpc\" -geometry 55x65+944+16 -bw 0 -e ncmpc") end,
    ["editor"] = function(file) file = file or ''; awful.util.spawn(terminal .. "-e vim "..file) end,
    ["rss"] = function() awful.util.spawn(terminal .. " -e canto; cd /home/piotrek/.config/awesome/actions/ && ./rss.sh") end,
    ["mail"] = function() awful.util.spawn(terminal .. " -e mutt -f ~/.Mail/phusiatynski && cd /home/piotrek/.config/awesome/actions/ && ./mail.sh") end,
    ["mpc"] = function(cmd) awful.util.spawn("mpc "..cmd); mpd_info_update();  end,
    ["vol"] = function(cmd) volume_info_update("amixer -c 0 set Master "..cmd) end
}

layouts =
{
    awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating
}

floatapps =
{
    ["MPlayer"] = true,
    ["gajim.py"] = true,
    ["pidgin"] = true,
    ["sonata"] = true,
    ["gimp"] = true,
    ["ncmpc"] = true,
    ["nm-applet"] = true,
    ["wesnoth"] = true,
}

apptags =
{
    ["Firefox"] = { screen = 1, tag = 2 },
    ["Navigator"] = { screen =1, tag = 2},
}

use_titlebar = false

--{{{ Naughty
--[[
naughty.config.timeout          = 5
naughty.config.screen           = 1
naughty.config.position         = "top_right"
naughty.config.margin           = 10
naughty.config.height           = 240
naughty.config.width            = 800
naughty.config.gap              = 10
naughty.config.ontop            = true
naughty.config.font             = "Verdana 12"
naughty.config.icon             = nil
naughty.config.icon_size        = 42
--naughty.config.fg               = '#738DBF'
--naughty.config.bg               = '#313131'
--naughty.config.border_color     = '#8E8E8E'
naughty.config.border_width     = 1
naughty.config.hover_timeout    = nil
]]--
--}}}

-- {{{ Help functions
function system(command)
    local datafile = io.popen(command)
    local out = datafile:read()
    datafile:close()
    return out
end

function readfile(fname)
    local f = io.open(fname)
    if f == nil then return " can't open: " .. fname end
    local t = f:read()
    f:close()
    return t
end

function get_mpd_info()
    local mpd_state = system([=[ mpc | sed -n -e "s/^\[\(.*\)\].*/\1/p" ]=]) or "stop"
    if mpd_state == "playing" then return system("mpc | head -1") end
    return mpd_state or "lua script error: get_mpd_info"
end

function get_volume_info(arg)
    arg = arg or "amixer sget Master "
    arg = arg .. [=[ | sed -n -e 's/.*Playback.*\[\(.*%\)\].*\[\(.*\)\]$/\1 \[\2\]/p' ]=]
    local out = system(arg)
    return out
end
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = {}
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag(tagnumber)
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[1], tags[s][tagnumber])
    end
    tags[s][1].selected = true
end
-- }}}

-- {{{ Wibox


mymailbox = widget({ type = "textbox", align = "right" })
mymailbox:buttons({ button({}, 1, function() spawn_cmd["mail"]() end) })
myfanbox = widget({ type = "textbox", align = "right" })
myrssbox = widget({ type = "textbox", align = "right" })
myrssbox:buttons({ button({}, 1, function() spawn_cmd["rss"]() end) })
mybattbox = widget({ type = "textbox", align = "right" })
mytimebox = widget({ type = "textbox", align = "right" })
mydatebox = widget({ type = "textbox", align = "right" })
mympdbox = widget({ type = "textbox", align = "right" })
mympdbox:buttons({
    button({}, 4, function() spawn_cmd["mpc"]("prev") end),
    button({}, 5, function() spawn_cmd["mpc"]("next") end),
    button({}, 3, function() spawn_cmd["mpc"]("toggle") end),
    button({}, 1, function() spawn_cmd["ncmpc"]() end)
})
myvolbox = widget({ type = "textbox", align = "right" })
myvolbox:buttons({
    button({ }, 4, function() spawn_cmd["vol"]("1dB+") end),
    button({ }, 5, function() spawn_cmd["vol"]("1dB-") end),
    button({ }, 1, function() spawn_cmd["vol"]("toggle") end)
})


myseparator = widget({ type = "textbox", align = "right" })
myseparator.text = "<span color=\"".. beautiful.fg_dark .."\">   ❂   </span>"

mysystray = widget({ type = "systray", align = "right" })

mywibox = {}
mypromptbox = {}
mytaglist = {}

mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
for s = 1, screen.count() do
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    mywibox[s].widgets = {
                           mylauncher,
                           mytaglist[s],
                           mypromptbox[s],
                           mympdbox,
                           myseparator,
                           myvolbox,
                           myseparator,
                           myrssbox,
                           myseparator,
                           mymailbox,
                           myseparator,
                           myfanbox,
                           myseparator,
                           mybattbox,
                           myseparator,
                           mydatebox,
                           myseparator,
                           mytimebox,
                           myseparator,
                           s == 1 and mysystray or nil
                       }
    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings
globalkeys =
{
    key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    key({ modkey,           }, "Escape", awful.tag.history.restore),

    key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    key({ modkey            }, "`",     revelation.revelation),

    -- Layout manipulation
    key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Standard program
    key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    key({ modkey, "Control" }, "r", awesome.restart),
    key({ modkey, "Shift"   }, "q", awesome.quit),

    key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    key({ modkey            }, ",",     function () spawn_cmd["mpc"]("prev")  end),
    key({ modkey            }, ".",     function () spawn_cmd["mpc"]("next") end),
    key({ modkey            }, "/",     function () spawn_cmd["mpc"]("toggle") end),
    key({ modkey            }, "n",     function () spawn_cmd["ncmpc"]() end),

    key({ modkey            }, "a",     function () spawn_cmd["terminal"]("alsamixer") end),

    key({ modkey, "Shift"   }, "c",     function () awful.util.spawn("python /home/piotrek/.scripts/color-chooser.py") end),
    key({ modkey            }, "m",     function () spawn_cmd["mail"]() end),
    key({ modkey            }, "s",     function () spawn_cmd["terminal"]("slrn") end),
    key({ modkey            }, "c",     function () spawn_cmd["temrinal"]("mc") end),
    key({ modkey            }, "r",     function () spawn_cmd["rss"]() end),

    key({ "Control", "Mod1" }, "Return", function () spawn_cmd["terminal"]("ssh husiatyn@wit.edu.pl") end),
    key({ modkey,   "Shift" }, "Return", function () spawn_cmd["terminal"]("ssh piotrek@192.168.0.1") end),


    key({}, "XF86AudioRaiseVolume",     function() spawn_cmd["vol"]("5dB+") end),
    key({}, "XF86AudioLowerVolume",     function() spawn_cmd["vol"]("5dB-") end),
    key({}, "XF86AudioMute",            function() spawn_cmd["vol"]("toggle") end),

    key({}, "XF86Eject",                function() awful.util.spawn("eject") end),

    key({}, "XF86KbdBrightnessDown",    function() awful.util.spawn("sudo macbook-backlight -10") end),
    key({}, "XF86KbdBrightnessUp",      function() awful.util.spawn("sudo macbook-backlight +10") end),

    key({}, "XF86Display", function () awful.util.spawn("slock") end),


    key({ modkey, "Shift" }, "Delete", function () awful.util.spawn("sudo poweroff") end),

    -- Prompt
    key({ modkey }, "d",
        function ()
            awful.prompt.run({ prompt = "Run: " },
            mypromptbox[mouse.screen],
            awful.util.spawn, awful.completion.bash,
            awful.util.getdir("cache") .. "/history")
        end),
}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey,           }, "q",      function (c) c:kill()                         end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    key({ modkey }, "t", awful.client.togglemarked),
    key({ modkey,}, "g",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
}

keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys,
        key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end


for i = 1, keynumber do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
                 function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute

function mpd_info_update()
    mympdbox.text = "<span color=\"".. beautiful.fg_normal .."\">mpd: </span><span color=\"".. beautiful.fg_light .."\">" .. awful.util.escape(get_mpd_info()) .. "</span>"
end

function volume_info_update(arg)
    myvolbox.text = "<span color=\"".. beautiful.fg_normal .."\">vol: </span><span color=\"".. beautiful.fg_light .."\">" .. get_volume_info(arg) .. "</span>"
end

awful.hooks.timer.register(30,
    function()
        mpd_info_update()
        volume_info_update()
    end)

mpd_info_update()
volume_info_update()
-- }}}
