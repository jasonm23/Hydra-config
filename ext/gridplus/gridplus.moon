ext.gridplus = {}

ext.gridplus.MARGINX = 5
ext.gridplus.MARGINY = 5
ext.gridplus.GRIDWIDTH = 3
ext.gridplus.GRIDHEIGHT = 2

round = (num, idp)->
  mult = 10^(idp or 0)
  math.floor(num * mult + 0.5) / mult

get_window_and_frame = ()->
  win = window.focusedwindow()
  frame = win\screen()\frame_without_dock_or_menu()
  win, frame

ext.gridplus.push_window_to_top_half = ()->
  w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  f.w = f.w - (ext.gridplus.MARGINX*2)
  w\setframe f

ext.gridplus.push_window_to_bottom_half = ()->
  w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  f.w = f.w - (ext.gridplus.MARGINY*2)
  w\setframe f

ext.gridplus.push_window_to_left_half = ()->
  w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.h = f.h - (ext.gridplus.MARGINY*2)
  w\setframe f

ext.gridplus.push_window_to_right_half = ()->
  w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX + f.w / 2
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.h = f.h - (ext.gridplus.MARGINY*2)
  w\setframe f

ext.gridplus.push_window_to_top_left = ()->
  w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX*2)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  w\setframe f

ext.gridplus.push_window_to_bottom_left = ()->
  w, f = get_window_and_frame()
  f.x = ext.gridplus.MARGINX
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX*2)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  w\setframe f

ext.gridplus.push_window_to_top_right = ()->
  w, f = get_window_and_frame()
  f.x = (f.w / 2) + ext.gridplus.MARGINX
  f.y = ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY)
  w\setframe f

ext.gridplus.push_window_to_bottom_right = ()->
  w, f = get_window_and_frame()
  f.x = (f.w / 2) + ext.gridplus.MARGINX
  f.y = (f.h / 2) + ext.gridplus.MARGINY
  f.w = (f.w / 2) - (ext.gridplus.MARGINX*2)
  f.h = (f.h / 2) - (ext.gridplus.MARGINY*2)
  w\setframe f

ext.gridplus.get = (win)->
  win_frame = win\frame()
  screen_rect = win\screen()\frame_without_dock_or_menu()
  cell_width = screen_rect.w / ext.gridplus.GRIDWIDTH
  cell_height = screen_rect.h / ext.gridplus.GRIDHEIGHT
  {
    x: round((win_frame.x - screen_rect.x) / cell_width),
    y: round((win_frame.y - screen_rect.y) / cell_height),
    w: math.max(1, round(win_frame.w / cell_width)),
    h: math.max(1, round(win_frame.h / cell_height)),
  }

ext.gridplus.set = (win, grid, screen)->
  screen_rect = screen\frame_without_dock_or_menu()
  cell_width = screen_rect.w / ext.gridplus.GRIDWIDTH
  cell_height = screen_rect.h / ext.gridplus.GRIDHEIGHT
  full_frame = {
    x: (grid.x * cell_width) + screen_rect.x,
    y: (grid.y * cell_height) + screen_rect.y,
    w: grid.w * cell_width,
    h: grid.h * cell_height,
  }
  full_frame.x = full_frame.x + ext.gridplus.MARGINX
  full_frame.y = full_frame.y + ext.gridplus.MARGINY
  full_frame.w = full_frame.w - (ext.gridplus.MARGINX * 2)
  full_frame.h = full_frame.h - (ext.gridplus.MARGINY * 2)
  win\setframe(full_frame)

ext.gridplus.snap = (win)->
  if win\isstandard()
    ext.gridplus.set win, ext.gridplus.get(win), win\screen()

ext.gridplus.snap_all = ()->
  fnutils.map window.visiblewindows(), ext.gridplus.snap

ext.gridplus.adjust_width = (by)->
  ext.gridplus.GRIDWIDTH = math.max 1, ext.gridplus.GRIDWIDTH + by
  hydra.alert "grid is now #{ext.gridplus.GRIDWIDTH} tiles wide", 1
  fnutils.map window.visiblewindows(), ext.gridplus.snap

ext.gridplus.adjust_height = (by)->
  ext.gridplus.GRIDHEIGHT = math.max 1, ext.gridplus.GRIDHEIGHT + by
  hydra.alert "grid is now #{ext.gridplus.GRIDHEIGHT} tiles high", 1
  fnutils.map window.visiblewindows(), ext.gridplus.snap

ext.gridplus.adjust_focused_window = (fn)->
  win = window.focusedwindow()
  f = ext.gridplus.get win
  fn f
  ext.gridplus.set win, f, win\screen()

ext.gridplus.maximize_window = ()->
  win = window.focusedwindow()
  f = {
    x: 0,
    y: 0,
    w: ext.gridplus.GRIDWIDTH,
    h: ext.gridplus.GRIDWIDTH
  }
  ext.gridplus.set win, f, win\screen()

ext.gridplus.push_window_next_screen = ()->
  win = window.focusedwindow()
  ext.gridplus.set win, ext.gridplus.get(win), win\screen()\next()

ext.gridplus.push_window_prev_screen = ()->
  win = window.focusedwindow()
  ext.gridplus.set win, ext.gridplus.get(win), win\screen()\previous()

ext.gridplus.push_window_left = ()->
  ext.gridplus.adjust_focused_window (f)-> f.x = math.max f.x - 1, 0

ext.gridplus.push_window_right = ()->
  ext.gridplus.adjust_focused_window (f)-> f.x = math.min f.x + 1, ext.gridplus.GRIDWIDTH - f.w

ext.gridplus.push_window_down = ()->
  ext.gridplus.adjust_focused_window (f)-> f.y = math.min f.y + 1, ext.gridplus.GRIDHEIGHT - f.h

ext.gridplus.push_window_up = ()->
  ext.gridplus.adjust_focused_window (f)-> f.y = math.max f.y - 1, 0

ext.gridplus.resize_window_wider = ()->
  ext.gridplus.adjust_focused_window (f)-> f.w = math.min f.w + 1, ext.gridplus.GRIDWIDTH - f.x

ext.gridplus.resize_window_thinner = ()->
  ext.gridplus.adjust_focused_window (f)-> f.w = math.max f.w - 1, 1

ext.gridplus.resize_window_taller = ()->
  ext.gridplus.adjust_focused_window (f)-> f.h = math.min f.h + 1, ext.gridplus.GRIDHEIGHT - f.y

ext.gridplus.resize_window_shorter = ()->
  ext.gridplus.adjust_focused_window (f)-> f.h = math.max f.h - 1, 1

ext.gridplus.resize_window_full_height = ()->
  ext.gridplus.adjust_focused_window (f)->
    f.h = ext.gridplus.GRIDHEIGHT
    f.y = 0
