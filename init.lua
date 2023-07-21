local update = function(file)
  vis:command(
    string.format(
      ":!echo -ne '\\033]0;edit %s\\007'",
      (file.name or ''):gsub("'", "'\\''"):gsub('\n', '␊')
    )
  )
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  update(win.file)
end)
