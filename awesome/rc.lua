-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Widget and layout library
require("wibox")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("menubar")

beautiful.init("/home/piotrek/.config/awesome/themes/theme.lua")

spawn_cmd = {
    ["terminal"] = function(cmd) awful.util.spawn_with_shell(terminal.." -e "..cmd) end,
    ["ncmpc"] = function() awful.util.spawn_with_shell(terminal .. " -fs 8 -class \"ncmpc\" -geometry 56x60+944+23 -bw 0 -e ncmpc") end,
    ["ncmpcpp"] = function() awful.util.spawn_with_shell(terminal .. " -fs 8 -class \"ncmpcpp\" -geometry 190x58+50+30 -bw 0 -e ncmpcpp") end,
    ["editor"] = function(file) file = file or ''; awful.util.spawn_with_shell(terminal .. "-e vim "..file) end,
    ["rss"] = function() awful.util.spawn_with_shell(terminal .. " -e $HOME/.bin/run_rss.sh"); end,
    ["mail"] = function() awful.util.spawn_with_shell(terminal .. " -e mutt -F ~/.mutt/muttrc.all.mailboxes -f ~/.Mail/phusiatynski/inbox && ~/.bin/check_mailboxes.sh") end,
    ["mpc"] = function(cmd) awful.util.spawn("mpc "..cmd); update_mympd();  end,
    ["vol"] = function(cmd) update_myvol("amixer -c 0 set Master "..cmd) end,
    ["sysload"] = function() awful.util.spawn(terminal.." -e htop") end,
    ["elinks"] = function() awful.util.spawn_with_shell(terminal .. " -e elinks") end,
    ["backlight"] = function(cmd) system('sudo macbook-backlight ' .. cmd) end,
    ["toggle_monitor"] = function(cmd) system('xrandr --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1 && killall xcompmgr') end,
    ["screen"] = function() system(terminal .. " screen -drU") end,
    ["screen_rotate"] = function() system("$HOME/.bin/screen_rotate") end,
    ["web_browser"] = function() awful.util.spawn_with_shell("luakit") end,
    ["reload_wallpaper"] = function() awful.util.spawn("sh $HOME/.bin/random_wallpaper.sh $HOME/.wallpapers/simpledesktop") end,
    --["web_browser"] = function() awful.util.spawn_with_shell("firefox ") end,
}

local label_color = beautiful.fg_widget_label
local message_color = beautiful.fg_widget_message


function system(command)
    local data_file = io.popen(command)
    local out = data_file:read()
    data_file:close()
    return out
end

function format(label, message)
    -- return formated message
    local label = '<span color="'.. label_color ..'">'.. label ..'</span>'
    local message = '<span color="'.. message_color ..'">'.. (message or '') ..'</span>'
    return label .. ': ' .. message
end

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Error",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))
mymainmenu = awful.menu({items={
    {"awesome", myawesomemenu, beautiful.awesome_icon }, { "open terminal", terminal }
}})

menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(format("time", "%H:%M"))

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mytaglist = {}
mymail = wibox.widget.textbox()
myvol = wibox.widget.textbox()
mysep = wibox.widget.textbox()
mysep:set_markup('<span color="'.. beautiful.fg_separator ..'">  ⟐  </span>')
mympd = wibox.widget.textbox()
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(mympd)
    right_layout:add(mysep)
    right_layout:add(mymail)
    right_layout:add(mysep)
    right_layout:add(mytextclock)
    right_layout:add(mysep)
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

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
    awful.key({ modkey,           }, "w",     spawn_cmd["web_browser"]),
    awful.key({ modkey            }, "c",     function () spawn_cmd["terminal"]("mc") end),
    awful.key({ modkey            }, "r",     spawn_cmd["rss"]),
    awful.key({ modkey            }, "\\",    spawn_cmd["toggle_monitor"]),
    awful.key({ modkey, "Shift"   }, "c",     function () awful.util.spawn("/home/piotrek/.scripts/color-chooser.py") end),

    awful.key({ "Control", "Mod1" }, "Return", function () spawn_cmd["terminal"]("ssh dark -t 'screen -drU'") end),
    awful.key({ modkey,   "Shift" }, "Return", function () spawn_cmd["terminal"]("ssh 192.168.0.1") end),

    awful.key({ modkey            }, "Delete",    spawn_cmd["screen_rotate"]),

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
    { rule = { class = "Gajim" },
      properties = { floating = true } },
    { rule = { class = "Empathy" },
      properties = { floating = true } },
    { rule = { class = "Pithos" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
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
    { rule = { class = "Namoroka" },
      properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

function update_myvol(cmd)
    if cmd then system(cmd) end
    local out = system([=[ amixer -c 0 sget Master | sed -n -e 's/.*Playback.*\[\(.*%\)\].*\[\(.*\)\]$/\1 \[\2\]/p' ]=])
    myvol:set_markup(format('vol', out))
    return out
end

function update_mympd()
    local mpd_state = system([=[ mpc | sed -n -e "s/^\[\(.*\)\].*/\1/p" ]=]) or "stop"
    if mpd_state == "playing" then
        mpd_state = system("mpc | head -1")
    end
    mympd:set_markup(format('mpd', mpd_state))
    return mpd_state
end

local timer = timer({timeout=10})
timer:connect_signal("timeout", function() update_myvol() end)
timer:connect_signal("timeout", update_mympd)
timer:start()
timer:emit_signal("timeout")
mymail:set_markup(format('mail', '?'))
