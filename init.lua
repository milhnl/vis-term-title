local print_tty = function(str)
  local file = io.open('/dev/tty', 'a')
  file:write(str)
  file:close()
end

local update = function(file)
    print_tty(
      ('\027]0;edit %s\007'):format((file.name or ''):gsub('\n', '␊'))
    )
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  update(win.file)
end)
