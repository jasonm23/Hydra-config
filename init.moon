require "ext.gridplus.gridplus"

pathwatcher.new("#{os.getenv("HOME")}/.hydra/", hydra.reload)\start()

hydra.autolaunch.set true

EDITOR   = "Emacs"
BROWSER  = "Google Chrome"
TERMINAL = "iTerm"
FINDER   = "Finder"
MUSIC    = "iTunes"
VIDEO    = "MPlayerX"

opendictionary = ()->
  hydra.alert "Lexicon, at your service.", 0.75
  application.launchorfocus "Dictionary"

hydra.alert "Hail Hydra", 1.5

checkforupdates = ()->
  hydra.updates.check (available)->
    if available
      notify.show "Hydra update available", "", "Click here to see the changelog and maybe even install it", "showupdate"
    else
      hydra.alert "No update available."

  hydra.settings.set 'lastcheckedupdates', os.time()

hydra.menu.show ()->
  updatetitles = {
    [true]: "Install Update",
    [false]: "Check for Update..."
  }

  updatefns = {
    [true]: hydra.updates.install,
    [false]: checkforupdates
  }

  hasupdate = (hydra.updates.newversion ~= nil)

  {
    {title: "Reload Config",         fn: hydra.reload},
    {title: "Open REPL",             fn: repl.open},
    {title: "-"},
    {title: "About",                 fn: hydra.showabout},
    {title: updatetitles[hasupdate], fn: updatefns[hasupdate]},
    {title: "Quit Hydra",            fn: os.exit}
  }

launch_editor = ()->
  application.launchorfocus(EDITOR)
launch_terminal = ()->
  application.launchorfocus(TERMINAL)
launch_browser = ()->
  application.launchorfocus(BROWSER)
launch_finder = ()->
  application.launchorfocus(FINDER)
launch_music = ()->
  application.launchorfocus(MUSIC)
launch_video = ()->
  application.launchorfocus(VIDEO)

mash = {"cmd", "ctrl", "alt"}

hotkey.bind mash, "`",     hydra.reload
hotkey.bind mash, "left",  ext.gridplus.push_window_to_left_half
hotkey.bind mash, "right", ext.gridplus.push_window_to_right_half
hotkey.bind mash, "up",    ext.gridplus.push_window_to_top_half
hotkey.bind mash, "down",  ext.gridplus.push_window_to_bottom_half
hotkey.bind mash, "space", ext.gridplus.maximize_window

hotkey.bind mash, "Q", ext.gridplus.push_window_to_top_left
hotkey.bind mash, "A", ext.gridplus.push_window_to_bottom_left
hotkey.bind mash, "W", ext.gridplus.push_window_to_top_right
hotkey.bind mash, "S", ext.gridplus.push_window_to_bottom_right

hotkey.bind mash, "D", opendictionary

hotkey.bind mash, "0", launch_editor
hotkey.bind mash, "9", launch_terminal
hotkey.bind mash, "8", launch_browser
hotkey.bind mash, "7", launch_finder
hotkey.bind mash, "V", launch_video
hotkey.bind mash, "B", launch_music

hotkey.bind mash, "N", ext.gridplus.push_window_next_screen
hotkey.bind mash, "P", ext.gridplus.push_window_prev_screen

hotkey.bind mash, "=", ()-> ext.gridplus.adjust_width(1)
hotkey.bind mash, "-", ()-> ext.gridplus.adjust_width(-1)
hotkey.bind mash, "[", ()-> ext.gridplus.adjust_height(1)
hotkey.bind mash, "]", ()-> ext.gridplus.adjust_height(-1)

hotkey.bind mash, ";", ()-> ext.gridplus.snap window.focusedwindow()
hotkey.bind mash, "'", ()-> fnutils.map window.visiblewindows(), ext.gridplus.snap

hotkey.bind mash, "J", ext.gridplus.push_window_down
hotkey.bind mash, "K", ext.gridplus.push_window_up
hotkey.bind mash, "H", ext.gridplus.push_window_left
hotkey.bind mash, "L", ext.gridplus.push_window_right

hotkey.bind mash, "U", ext.gridplus.resize_window_full_height
hotkey.bind mash, "I", ext.gridplus.resize_window_thinner
hotkey.bind mash, "O", ext.gridplus.resize_window_wider
hotkey.bind mash, ",", ext.gridplus.resize_window_shorter
hotkey.bind mash, ".", ext.gridplus.resize_window_taller

showupdate = ()-> os.execute "open https://github.com/sdegutis/Hydra/releases"

timer.new(timer.weeks(1), checkforupdates)\start()

notify.register "showupdate", showupdate

lastcheckedupdates = hydra.settings.get 'lastcheckedupdates'

if lastcheckedupdates == nil or lastcheckedupdates <= os.time() - timer.days 7
  checkforupdates()