-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")


local HOME = os.getenv("HOME")
local EDITOR = os.getenv("EDITOR") or "vim"

beautiful.init(HOME .. "/.config/awesome/themes/faenza/theme.lua")
icons = HOME .. "/.icons/custom"

terminal = "xterm "
modkey = "Mod4"





function system(command)
    local data_file = io.popen(command)
    local out = data_file:read()
    data_file:close()
    return out
end

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
    ["mail-list"] = function() awful.util.spawn_with_shell('imapfilter &; ' .. terminal .. " -e mutt -F ~/.mutt/muttrc.piotrhusiatynski.imap -f imaps://imap.gmail.com:993/luakit-dev") end,
    ["mpc"] = function(cmd) awful.util.spawn("mpc "..cmd); update_mympd();  end,
    ["vol"] = function(cmd) update_myvol("amixer -c 0 set Master "..cmd) end,
    ["sysload"] = function() awful.util.spawn(terminal.." -e htop") end,
    ["elinks"] = function() awful.util.spawn_with_shell(terminal .. " -e elinks") end,
    ["backlight"] = function(cmd) system('sudo macbook-backlight ' .. cmd) end,
    ["toggle_monitor"] = function(cmd) system('xrandr --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1 && killall xcompmgr') end,
    ["screen"] = function() system(terminal .. " screen -drU") end,
    ["screen_rotate"] = function() system("$HOME/.bin/screen_rotate") end,
    ["web_browser"] = function() awful.util.spawn_with_shell("luakit") end,
}

layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
}

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({1, 2, 3, 4, 5, 6, 7, 8, 9}, s, layouts[1])
end


w_clock = awful.widget.textclock({ align="right"})
w_sep = widget({type="textbox", align="right"})
w_sep.text = '   '
w_vol_i = widget({type="imagebox", align="right"})
w_mpd = widget({type="textbox", align="right"})
w_mpd_i = widget({type="imagebox", align="right"})
w_mail = widget({type="imagebox", align="right"})
w_mail.image = image(beautiful.icons.mail.normal)
w_systray = widget({type="systray"})

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
        w_clock,
        w_sep,
        s == 1 and w_systray or nil,
        w_sep,
        w_mail,
        w_sep,
        w_vol_i,
        w_sep,
        w_mpd_i,
        w_sep,
        w_mpd,
        layout=awful.widget.layout.horizontal.rightleft
    }
end

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
    awful.key({ modkey            }, "e",     spawn_cmd["web-browser"]),
    awful.key({ modkey            }, "\\",    spawn_cmd["toggle_monitor"]),
    awful.key({ modkey, "Shift"   }, "c",     function () awful.util.spawn("/home/piotrek/.scripts/color-chooser.py") end),

    awful.key({ "Control", "Mod1" }, "Return", function () spawn_cmd["terminal"]("ssh husiatyn@oceanic.wsisiz.edu.pl -t 'screen -drU'") end),
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

keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

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

root.keys(globalkeys)

awful.rules.rules = {
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





function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end


function update_vol(cmd)
    if cmd then system(cmd) end
    local vol = system([=[ amixer -c 0 sget Master | sed -n -e 's/.*Playback.*\[\(.*%\)\].*\[\(.*\)\]$/\1 \2/p' ]=]):split(' ')
    if vol[2] == 'off' then
        w_vol_i.image = image(beautiful.icons.vol.muted)
    else
        w_vol_i.image = image(beautiful.icons.vol.normal)
    end
    return out
end

function update_mpd()
    local mpd_state = system([=[ mpc | sed -n -e "s/^\[\(.*\)\].*/\1/p" ]=]) or "stop"
    if mpd_state == "playing" then
        mpd_state = system("mpc | head -1")
        w_mpd_i.image = image(beautiful.icons.mpd.playing)
        w_mpd.text = mpd_state
    else
        w_mpd_i.image = image(beautiful.icons.mpd.stop)
        w_mpd.text = ''
    end
    return mpd_state
end

function update_all()
    update_vol()
    update_mpd()
end

acron = timer { timeout=60 }
acron:add_signal("timeout", update_all)
acron:start()
update_all()
