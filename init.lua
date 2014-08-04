require("ext.gridplus.gridplus")
pathwatcher.new(tostring(os.getenv("HOME")) .. "/.hydra/", hydra.reload):start()
hydra.autolaunch.set(true)
local EDITOR = "Emacs"
local BROWSER = "Google Chrome"
local TERMINAL = "iTerm"
local FINDER = "Finder"
local MUSIC = "iTunes"
local VIDEO = "MPlayerX"
local opendictionary
opendictionary = function()
  hydra.alert("Lexicon, at your service.", 0.75)
  return application.launchorfocus("Dictionary")
end
hydra.alert("Hydra Config Reloaded", 1.5)
local check_for_updates
check_for_updates = function()
  hydra.updates.check(function(available)
    if available then
      return notify.show("Hydra update available", "", "Click here to see the changelog and maybe even install it", "show_update")
    else
      return hydra.alert("No update available.")
    end
  end)
  return hydra.settings.set('last_checked_updates', os.time())
end
hydra.menu.show(function()
  local has_update = hydra.updates.newversion ~= nil
  local update_titles
  update_titles = function(u)
    if u then
      return "Install Update"
    else
      return "Check for Update..."
    end
  end
  local update_fns
  update_fns = function(u)
    if u then
      return hydra.updates.install
    else
      return check_for_updates
    end
  end
  return {
    {
      title = "Reload Config",
      fn = hydra.reload
    },
    {
      title = "Open REPL",
      fn = repl.open
    },
    {
      title = "-"
    },
    {
      title = "About",
      fn = hydra.showabout
    },
    {
      title = update_titles(has_update),
      fn = update_fns(has_update)
    },
    {
      title = "Quit Hydra",
      fn = os.exit
    }
  }
end)
local mash = {
  "cmd",
  "ctrl",
  "alt"
}
hotkey.bind(mash, "R", hydra.reload)
hotkey.bind(mash, "/", repl.open)
hotkey.bind(mash, "left", ext.gridplus.push_window_to_left_half)
hotkey.bind(mash, "right", ext.gridplus.push_window_to_right_half)
hotkey.bind(mash, "up", ext.gridplus.push_window_to_top_half)
hotkey.bind(mash, "down", ext.gridplus.push_window_to_bottom_half)
hotkey.bind(mash, "space", ext.gridplus.maximize_window)
hotkey.bind(mash, "Q", ext.gridplus.push_window_to_top_left)
hotkey.bind(mash, "A", ext.gridplus.push_window_to_bottom_left)
hotkey.bind(mash, "W", ext.gridplus.push_window_to_top_right)
hotkey.bind(mash, "S", ext.gridplus.push_window_to_bottom_right)
hotkey.bind(mash, "N", ext.gridplus.push_window_next_screen)
hotkey.bind(mash, "P", ext.gridplus.push_window_prev_screen)
hotkey.bind(mash, "0", function()
  return application.launchorfocus(EDITOR)
end)
hotkey.bind(mash, "9", function()
  return application.launchorfocus(TERMINAL)
end)
hotkey.bind(mash, "8", function()
  return application.launchorfocus(BROWSER)
end)
hotkey.bind(mash, "7", function()
  return application.launchorfocus(FINDER)
end)
hotkey.bind(mash, "V", function()
  return application.launchorfocus(MUSIC)
end)
hotkey.bind(mash, "B", function()
  return application.launchorfocus(VIDEO)
end)
hotkey.bind(mash, "=", function()
  return ext.gridplus.adjust_width(1)
end)
hotkey.bind(mash, "-", function()
  return ext.gridplus.adjust_width(-1)
end)
hotkey.bind(mash, "[", function()
  return ext.gridplus.adjust_height(1)
end)
hotkey.bind(mash, "]", function()
  return ext.gridplus.adjust_height(-1)
end)
hotkey.bind(mash, ";", function()
  return ext.gridplus.snap(window.focusedwindow())
end)
hotkey.bind(mash, "'", function()
  return fnutils.map(window.visiblewindows(), ext.gridplus.snap)
end)
hotkey.bind(mash, "J", ext.gridplus.push_window_down)
hotkey.bind(mash, "K", ext.gridplus.push_window_up)
hotkey.bind(mash, "H", ext.gridplus.push_window_left)
hotkey.bind(mash, "L", ext.gridplus.push_window_right)
hotkey.bind(mash, "U", ext.gridplus.resize_window_full_height)
hotkey.bind(mash, "I", ext.gridplus.resize_window_thinner)
hotkey.bind(mash, "O", ext.gridplus.resize_window_wider)
hotkey.bind(mash, ",", ext.gridplus.resize_window_shorter)
hotkey.bind(mash, ".", ext.gridplus.resize_window_taller)
local show_keyboard
show_keyboard = function()
  return os.execute("open https://raw.githubusercontent.com/jasonm23/Hydra-config/master/hydra-keyboard.png")
end
hotkey.bind(mash, "`", show_keyboard)
local show_update
show_update = function()
  return os.execute("open https://github.com/sdegutis/Hydra/releases")
end
timer.new(timer.weeks(1), check_for_updates):start()
notify.register("show_update", show_update)
local last_checked_updates = hydra.settings.get('last_checked_updates')
if last_checked_updates == nil or last_checked_updates <= os.time() - timer.days(7) then
  return check_for_updates()
end
