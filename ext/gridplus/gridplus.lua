ext.gridplus = { }
ext.gridplus.MARGINX = 5
ext.gridplus.MARGINY = 5
ext.gridplus.GRIDWIDTH = 3
ext.gridplus.GRIDHEIGHT = 2
local round
round = function(num, idp)
  local mult = 10 ^ (idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
local get_window_and_frame
get_window_and_frame = function()
  local win = window.focusedwindow()
  local frame = win:screen():frame_without_dock_or_menu()
  return win, frame
end
ext.gridplus.push_window_to_top_half = function()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.h = (f.h / 2) - (ext.gridplus.MARGINY * 2)
  f.w = f.w - (ext.gridplus.MARGINX * 2)
  return w:setframe(f)
end
ext.gridplus.push_window_to_bottom_half = function()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.h = (f.h / 2) - (ext.gridplus.MARGINY * 2)
  f.w = f.w - (ext.gridplus.MARGINY * 2)
  return w:setframe(f)
end
ext.gridplus.push_window_to_left_half = function()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.h = f.h - (ext.gridplus.MARGINY * 2)
  return w:setframe(f)
end
ext.gridplus.push_window_to_right_half = function()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX + f.w / 2
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.h = f.h - (ext.gridplus.MARGINY * 2)
  return w:setframe(f)
end
ext.gridplus.push_window_to_top_left = function()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX * 2)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY * 2)
  return w:setframe(f)
end
ext.gridplus.push_window_to_bottom_left = function()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX * 2)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY * 2)
  return w:setframe(f)
end
ext.gridplus.push_window_to_top_right = function()
  local w, f = get_window_and_frame()
  f.x = (f.w / 2) + ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY)
  return w:setframe(f)
end
ext.gridplus.push_window_to_bottom_right = function()
  local w, f = get_window_and_frame()
  f.x = (f.w / 2) + ext.gridplus.MARGINX
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX * 2)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY * 2)
  return w:setframe(f)
end
ext.gridplus.get = function(win)
  local win_frame = win:frame()
  local screen_rect = win:screen():frame_without_dock_or_menu()
  local cell_width = screen_rect.w / ext.gridplus.GRIDWIDTH
  local cell_height = screen_rect.h / ext.gridplus.GRIDHEIGHT
  return {
    x = round((win_frame.x - screen_rect.x) / cell_width),
    y = round((win_frame.y - screen_rect.y) / cell_height),
    w = math.max(1, round(win_frame.w / cell_width)),
    h = math.max(1, round(win_frame.h / cell_height))
  }
end
ext.gridplus.set = function(win, grid, screen)
  local screen_rect = screen:frame_without_dock_or_menu()
  local cell_width = screen_rect.w / ext.gridplus.GRIDWIDTH
  local cell_height = screen_rect.h / ext.gridplus.GRIDHEIGHT
  local full_frame = {
    x = (grid.x * cell_width) + screen_rect.x,
    y = (grid.y * cell_height) + screen_rect.y,
    w = grid.w * cell_width,
    h = grid.h * cell_height
  }
  full_frame.x = full_frame.x + ext.gridplus.MARGINX
  full_frame.y = full_frame.y + ext.gridplus.MARGINY
  full_frame.w = full_frame.w - (ext.gridplus.MARGINX * 2)
  full_frame.h = full_frame.h - (ext.gridplus.MARGINY * 2)
  return win:setframe(full_frame)
end
ext.gridplus.snap = function(win)
  if win:isstandard() then
    return ext.gridplus.set(win, ext.gridplus.get(win), win:screen())
  end
end
ext.gridplus.snap_all = function()
  return fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end
ext.gridplus.adjust_width = function(by)
  ext.gridplus.GRIDWIDTH = math.max(1, ext.gridplus.GRIDWIDTH + by)
  hydra.alert("grid is now " .. tostring(ext.gridplus.GRIDWIDTH) .. " tiles wide", 1)
  return fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end
ext.gridplus.adjust_height = function(by)
  ext.gridplus.GRIDHEIGHT = math.max(1, ext.gridplus.GRIDHEIGHT + by)
  hydra.alert("grid is now " .. tostring(ext.gridplus.GRIDHEIGHT) .. " tiles high", 1)
  return fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end
ext.gridplus.adjust_focused_window = function(fn)
  local win = window.focusedwindow()
  local f = ext.gridplus.get(win)
  fn(f)
  return ext.gridplus.set(win, f, win:screen())
end
ext.gridplus.maximize_window = function()
  local win = window.focusedwindow()
  local f = {
    x = 0,
    y = 0,
    w = ext.gridplus.GRIDWIDTH,
    h = ext.gridplus.GRIDWIDTH
  }
  return ext.gridplus.set(win, f, win:screen())
end
ext.gridplus.push_window_next_screen = function()
  local win = window.focusedwindow()
  return ext.gridplus.set(win, ext.gridplus.get(win), win:screen():next())
end
ext.gridplus.push_window_prev_screen = function()
  local win = window.focusedwindow()
  return ext.gridplus.set(win, ext.gridplus.get(win), win:screen():previous())
end
ext.gridplus.push_window_left = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.x = math.max(f.x - 1, 0)
  end)
end
ext.gridplus.push_window_right = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.x = math.min(f.x + 1, ext.gridplus.GRIDWIDTH - f.w)
  end)
end
ext.gridplus.push_window_down = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.y = math.min(f.y + 1, ext.gridplus.GRIDHEIGHT - f.h)
  end)
end
ext.gridplus.push_window_up = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.y = math.max(f.y - 1, 0)
  end)
end
ext.gridplus.resize_window_wider = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.w = math.min(f.w + 1, ext.gridplus.GRIDWIDTH - f.x)
  end)
end
ext.gridplus.resize_window_thinner = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.w = math.max(f.w - 1, 1)
  end)
end
ext.gridplus.resize_window_taller = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.h = math.min(f.h + 1, ext.gridplus.GRIDHEIGHT - f.y)
  end)
end
ext.gridplus.resize_window_shorter = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.h = math.max(f.h - 1, 1)
  end)
end
ext.gridplus.resize_window_full_height = function()
  return ext.gridplus.adjust_focused_window(function(f)
    f.h = ext.gridplus.GRIDHEIGHT
    f.y = 0
  end)
end
