require("awful")
require("base")


-- {{{ Mouse bindings
mousebindings = 
{
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
}
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
    key({ modkey            }, "n",     spawn_cmd["ncmpc"]),

    key({ modkey            }, "a",     function () spawn_cmd["terminal"]("alsamixer") end),
    
    key({ modkey,           }, "ISO_Level3_Shift", function () mymainmenu:show(true) end),

    key({ modkey, "Shift"   }, "c",     function () awful.util.spawn("python /home/piotrek/.scripts/color-chooser.py") end),
    key({ modkey            }, "m",     spawn_cmd["mail"]),
    key({ modkey            }, "s",     spawn_cmd["sysload"]),
    --key({ modkey            }, "s",     function () spawn_cmd["terminal"]("slrn") end),
    key({ modkey            }, "c",     function () spawn_cmd["terminal"]("mc") end),
    key({ modkey            }, "r",     spawn_cmd["rss"]),
    key({ modkey            }, "e",     spawn_cmd["elinks"]),

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

    -- Prmpt
    key({ modkey }, "d",
        function ()
            awful.prompt.run({ prompt = "Run: " },
            mypromptbox[mouse.screen],
            awful.util.spawn, awful.completion.bash,
            awful.util.getdir("cache") .. "/history")
        end),

    key({ modkey }, "x", 
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen],
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end)
}
-- }}}

-- Client awful tagging
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
--}}}
