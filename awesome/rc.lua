-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")

require("revelation")

beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/theme.lua")

terminal = "xterm "
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

--{{{ spawn commands
spawn_cmd = {
    ["web-browser"] = function(uri)
        if uri then uri = ' -u ' .. uri else uri = '' end
        awful.util.spawn("uzbl-browser " .. uri) 
    end,
    ["terminal"] = function(cmd) awful.util.spawn_with_shell(terminal.." -e "..cmd) end,
    ["ncmpc"] = function() awful.util.spawn_with_shell(terminal .. " -fs 8 -class \"ncmpc\" -geometry 56x70+944+26 -bw 0 -e ncmpc") end,
    ["ncmpcpp"] = function() awful.util.spawn_with_shell(terminal .. " -fs 8 -class \"ncmpcpp\" -geometry 190x58+50+30 -bw 0 -e ncmpcpp") end,
    ["editor"] = function(file) file = file or ''; awful.util.spawn_with_shell(terminal .. "-e vim "..file) end,
    ["rss"] = function() awful.util.spawn_with_shell(terminal .. " -e $HOME/.bin/run_rss.sh"); end,
    ["mail"] = function() awful.util.spawn_with_shell(terminal .. " -e $HOME/.bin/run_mail.sh"); update_mymail(); end,
    --["mail"] = function() awful.util.spawn_with_shell(terminal .. "  -e mutt -F $HOME/.mutt/muttrc.phusiatynski.imap"); end,
    ["mail-list"] = function() awful.util.spawn_with_shell('imapfilter &; ' .. terminal .. " -e mutt -F ~/.mutt/muttrc.piotrhusiatynski.imap -f imaps://imap.gmail.com:993/gevent") end,
    ["mpc"] = function(cmd) awful.util.spawn("mpc "..cmd); update_mympd();  end,
    ["vol"] = function(cmd) update_myvol("amixer -c 0 set Master "..cmd) end,
    ["sysload"] = function() awful.util.spawn(terminal.." -e htop") end,
    ["elinks"] = function() awful.util.spawn_with_shell(terminal .. " -e elinks") end,
    ["backlight"] = function(cmd) system('sudo macbook-backlight ' .. cmd) end,
    ["toggle_monitor"] = function(cmd) system('xrandr --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1 && killall xcompmgr') end,
    ["screen"] = function() system(terminal .. " screen -drU") end,
}
--}}}
--{{{ Mylib

function system(command)
    local data_file = io.popen(command)
    local out = data_file:read()
    data_file:close()
    return out
end

local label_color = beautiful.fg_widget_label
local message_color = beautiful.fg_widget_message

function format(label, message)
    -- return formated message
    local label = '<span color="'.. label_color ..'">'.. label ..'</span>'
    local message = '<span color="'.. message_color ..'">'.. message ..'</span>'
    return label .. ': ' .. message
end

--}}}


layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

myclock = awful.widget.textclock({ align="right" })
mysep = widget({ type="textbox", align="right"})
mysep.text = '<span color="'.. beautiful.fg_separator ..'">   ◉   </span>'
myvol = widget({ type="textbox", align="right" })
mympd = widget({ type="textbox", align="right" })
mymail = widget({ type="textbox", align="right" })
--myrss = widget({ type="textbox", align="right" })
myfan = widget({ type="textbox", align="right" })
mybatt = widget({ type="textbox", align="right" })

mysystray = widget({ type="systray" })
mywibox = {}
mypromptbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
for s = 1, screen.count() do
    mytaglist[s] = awful.widget.taglist(s,
            awful.widget.taglist.label.all, mytaglist.buttons)
    mypromptbox[s] = awful.widget.prompt(
        { layout=awful.widget.layout.horizontal.leftright })
    mywibox[s] = awful.wibox({ position="top", screen=s })
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright

        },
        myclock,
        mysep,
        s == 1 and mysystray or nil,
        mysep,
    --    mybatt,
    --    mysep,
        myfan,
        mysep,
        mymail,
        mysep,
    --    myrss,
    --    mysep,
        myvol,
        mysep,
        mympd,
        layout=awful.widget.layout.horizontal.rightleft
    }
end

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "d",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey            }, ",",     function () spawn_cmd["mpc"]("prev")  end),
    awful.key({ modkey            }, ".",     function () spawn_cmd["mpc"]("next") end),
    awful.key({ modkey            }, "/",     function () spawn_cmd["mpc"]("toggle") end),
    awful.key({ modkey            }, "n",     spawn_cmd["ncmpc"]),
    awful.key({ modkey,"Shift"    }, "n",     spawn_cmd["ncmpcpp"]),
    awful.key({ modkey            }, "m",     spawn_cmd["mail"]),
    awful.key({ modkey            }, "v",     spawn_cmd["mail-list"]),
    awful.key({ modkey            }, "s",     spawn_cmd["screen"]),
    awful.key({ modkey            }, "c",     function () spawn_cmd["terminal"]("mc") end),
    awful.key({ modkey            }, "r",     spawn_cmd["rss"]),
    awful.key({ modkey            }, "e",     spawn_cmd["web-browser"]),
    awful.key({ modkey            }, "\\",    spawn_cmd["toggle_monitor"]),
    awful.key({ modkey, "Shift"   }, "c",     function () awful.util.spawn("python /home/piotrek/.scripts/color-chooser.py") end),

    awful.key({ "Control", "Mod1" }, "Return", function () spawn_cmd["terminal"]("ssh husiatyn@oceanic.wsisiz.edu.pl") end),
    awful.key({ modkey,   "Shift" }, "Return", function () spawn_cmd["terminal"]("ssh 192.168.0.1") end),

    awful.key({}, "XF86AudioRaiseVolume",     function() spawn_cmd["vol"]("5dB+") end),
    awful.key({}, "XF86AudioLowerVolume",     function() spawn_cmd["vol"]("5dB-") end),
    awful.key({}, "XF86AudioMute",            function() spawn_cmd["vol"]("toggle") end),
    awful.key({}, "XF86Eject",                function() awful.util.spawn("eject") end),
    awful.key({}, "XF86KbdBrightnessDown",    function() spawn_cmd['backlight']('-20') end),
    awful.key({}, "XF86KbdBrightnessUp",      function() spawn_cmd['backlight']('+20') end),
    awful.key({}, "XF86Display", function () awful.util.spawn("slock") end),

    awful.key({ modkey, "Shift" }, "Delete", function () awful.util.spawn("sudo poweroff") end)
)

clientkeys = awful.util.table.join(
    --awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey, "Control" }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Gajim.py" },
      properties = { floating = true } },
    { rule = { class = "Empathy" },
      properties = { floating = true } },
    { rule = { class = "Sonata" },
      properties = { floating = true } },
    { rule = { class = "ncmpc" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    { rule = { class = "Namoroka" },
       properties = { tag = tags[2] } },
    { rule = { class = "Navigator" },
      properties = { tag = tags[2] } },
    { rule = { class = "xpad" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
client.add_signal("manage", function (c, startup)
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)
    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Panel widgets signal handlers
myfan:buttons(awful.util.table.join(
    awful.button({ }, 1, function()
        update_myfan({up=500})
    end),
    awful.button({ }, 3, function()
        update_myfan({down=500})
    end)
))
-- }}}

-- {{{ Panel info update
function update_myvol(cmd)
    if cmd then system(cmd) end
    local out = system([=[ amixer -c 0 sget Master | sed -n -e 's/.*Playback.*\[\(.*%\)\].*\[\(.*\)\]$/\1 \[\2\]/p' ]=])
    myvol.text = format('vol', out)
    return out
end

function update_mympd()
    local mpd_state = system([=[ mpc | sed -n -e "s/^\[\(.*\)\].*/\1/p" ]=]) or "stop"
    if mpd_state == "playing" then
        mpd_state = system("mpc | head -1")
    end
    mympd.text = format('mpd', mpd_state)
    return mpd_state
end

function update_mymail()
    --mymail.text = format('mail', tostring(new_mail))
end

function update_myrss()
end

function update_myfan(options)
    if options == nil then
        myfan.text = format('fan', 
            system('$HOME/.bin/fanspeed.sh') .. '°C')
    elseif options.up then
        local cur_speed = tonumber(system("$HOME/.bin/fanspeed.sh --output"))
        myfan.text = format('fan', 
            system('$HOME/.bin/fanspeed.sh ' .. (cur_speed + options.up)) .. '°C')
    elseif options.down then
        local cur_speed = tonumber(system("$HOME/.bin/fanspeed.sh --output"))
        myfan.text = format('fan', 
            system('$HOME/.bin/fanspeed.sh ' .. (cur_speed - options.down)) .. '°C')
    elseif options.set then
        myfan.text = format('fan', 
            system('$HOME/.bin/fanspeed.sh ' .. options.set) .. '°C')
    end
end

function update_mybatt()
    local batt_state = system("acpi | awk '{ print $4 }'")
    mybatt.text = format('batt', batt_state)
end

function update_all()
    update_myvol()
    update_mympd()
    update_mymail()
    --update_myrss()
    update_myfan()
    --update_mybatt()
end

acron = timer { timeout=60 }
acron:add_signal("timeout", update_all)
acron:start()
update_all()
mymail.text = format('mail', 0)
-- }}}
