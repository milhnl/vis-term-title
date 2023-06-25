local update = function(file)
  vis:command(
    string.format(
      ":!echo -ne '\\033]0;edit %s\\007'",
      string.gsub(file.name or '', "'", "'\\''")
    )
  )
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  update(win.file)
end)
