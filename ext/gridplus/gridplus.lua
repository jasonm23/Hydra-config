ext.gridplus = {}

ext.gridplus.MARGINX = 5
ext.gridplus.MARGINY = 5
ext.gridplus.GRIDWIDTH = 3
ext.gridplus.GRIDHEIGHT = 2

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function get_window_and_frame()
   local win = window.focusedwindow()
   local frame = win:screen():frame_without_dock_or_menu()
   return win, frame
end

function ext.gridplus.push_window_to_top_half()
  local w, f = get_window_and_frame()
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  f.w = f.w - (ext.gridplus.MARGINX*2)
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  w:setframe(f)
end

function ext.gridplus.push_window_to_bottom_half()
  local w, f = get_window_and_frame()
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  f.w = f.w - (ext.gridplus.MARGINY*2)
  f.x = ext.gridplus.MARGINX
  w:setframe(f)
end

function ext.gridplus.push_window_to_left_half()
  local w, f = get_window_and_frame()
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.h = f.h - (ext.gridplus.MARGINY*2)
  w:setframe(f)
end

function ext.gridplus.push_window_to_right_half()
  local w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX + f.w / 2
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.y = ext.gridplus.MARGINY
  f.h = f.h - (ext.gridplus.MARGINY*2)
  w:setframe(f)
end

function ext.gridplus.get(win)
  local win_frame = win:frame()
  local screen_rect = win:screen():frame_without_dock_or_menu()
  local cell_width = screen_rect.w / ext.gridplus.GRIDWIDTH
  local cell_height = screen_rect.h / ext.gridplus.GRIDHEIGHT
  return {
    x = round((win_frame.x - screen_rect.x) / cell_width),
    y = round((win_frame.y - screen_rect.y) / cell_height),
    w = math.max(1, round(win_frame.w / cell_width)),
    h = math.max(1, round(win_frame.h / cell_height)),
  }
end

function ext.gridplus.set(win, grid, screen)
  local screen_rect = screen:frame_without_dock_or_menu()
  local cell_width = screen_rect.w / ext.gridplus.GRIDWIDTH
  local cell_height = screen_rect.h / ext.gridplus.GRIDHEIGHT
  local full_frame = {
    x = (grid.x * cell_width) + screen_rect.x,
    y = (grid.y * cell_height) + screen_rect.y,
    w = grid.w * cell_width,
    h = grid.h * cell_height,
  }

  full_frame.x = full_frame.x + ext.gridplus.MARGINX
  full_frame.y = full_frame.y + ext.gridplus.MARGINY
  full_frame.w = full_frame.w - (ext.gridplus.MARGINX * 2)
  full_frame.h = full_frame.h - (ext.gridplus.MARGINY * 2)

  win:setframe(full_frame)
end

function ext.gridplus.snap(win)
  if win:isstandard() then
    ext.gridplus.set(win, ext.gridplus.get(win), win:screen())
  end
end

function ext.gridplus.snap_all()
  fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end

function ext.gridplus.adjust_width(by)
  ext.gridplus.GRIDWIDTH = math.max(1, ext.gridplus.GRIDWIDTH + by)
  hydra.alert("grid is now " .. tostring(ext.gridplus.GRIDWIDTH) .. " tiles wide", 1)
  fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end

function ext.gridplus.adjust_height(by)
  ext.gridplus.GRIDHEIGHT = math.max(1, ext.gridplus.GRIDHEIGHT + by)
  hydra.alert("grid is now " .. tostring(ext.gridplus.GRIDHEIGHT) .. " tiles high", 1)
  fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end

function ext.gridplus.adjust_focused_window(fn)
  local win = window.focusedwindow()
  local f = ext.gridplus.get(win)
  fn(f)
  ext.gridplus.set(win, f, win:screen())
end

function ext.gridplus.maximize_window()
  local win = window.focusedwindow()
  local f = {x = 0, y = 0, w = ext.gridplus.GRIDWIDTH, h = 2}
  ext.gridplus.set(win, f, win:screen())
end

function ext.gridplus.push_window_next_screen()
  local win = window.focusedwindow()
  ext.gridplus.set(win, ext.gridplus.get(win), win:screen():next())
end

function ext.gridplus.push_window_prev_screen()
  local win = window.focusedwindow()
  ext.gridplus.set(win, ext.gridplus.get(win), win:screen():previous())
end

function ext.gridplus.push_window_left()
  ext.gridplus.adjust_focused_window(function(f) f.x = math.max(f.x - 1, 0) end)
end

function ext.gridplus.push_window_right()
  ext.gridplus.adjust_focused_window(function(f) f.x = math.min(f.x + 1, ext.gridplus.GRIDWIDTH - f.w) end)
end

function ext.gridplus.push_window_down()
  ext.gridplus.adjust_focused_window(function(f) f.y = math.min(f.y + 1, ext.gridplus.GRIDHEIGHT - f.h) end)
end

function ext.gridplus.push_window_up()
  ext.gridplus.adjust_focused_window(function(f) f.y = math.max(f.y - 1, 0) end)
end

function ext.gridplus.resize_window_wider()
  ext.gridplus.adjust_focused_window(function(f) f.w = math.min(f.w + 1, ext.gridplus.GRIDWIDTH - f.x) end)
end

function ext.gridplus.resize_window_thinner()
  ext.gridplus.adjust_focused_window(function(f) f.w = math.max(f.w - 1, 1) end)
end

function ext.gridplus.resize_window_taller()
  ext.gridplus.adjust_focused_window(function(f) f.h = math.min(f.h + 1, ext.gridplus.GRIDHEIGHT - f.y) end)
end

function ext.gridplus.resize_window_shorter()
  ext.gridplus.adjust_focused_window(function(f) f.h = math.max(f.h - 1, 1) end)
end
