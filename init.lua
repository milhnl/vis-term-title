local update = nil

local print_tty = function(str)
  local file = io.open('/dev/tty', 'a')
  file:write(str)
  file:close()
end

local get_cmd = function(cmd)
  local fz = io.popen(cmd)
  if fz then
    local out = fz:read('*a')
    local _, _, status = fz:close()
    if status == 0 then
      return out:gsub('\n$', '')
    end
  end
  return nil
end

local urlencode = function(str)
  return str:gsub('[^._%w/]', function(x)
    return ('%%%X'):format(string.byte(x))
  end)
end

if os.getenv('TERM_PROGRAM') == 'Apple_Terminal' then
  local cwd = urlencode(get_cmd('pwd'))
  local hostname = urlencode(get_cmd('hostname'))
  update = function(file)
    print_tty(
      '\027]0;\007'
        .. (cwd and ('\027]7;file://%s\007'):format(cwd) or '')
        .. (
          hostname
            and file.path
            and ('\027]6;file://%s/%s\007'):format(hostname, file.path or '')
          or ''
        )
    )
  end
else
  update = function(file)
    print_tty(
      ('\027]0;edit %s\007'):format((file.name or ''):gsub('\n', '␊'))
    )
  end
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  update(win.file)
end)
