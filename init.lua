require "ext.gridplus.gridplus"

-- auto reload
pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()

-- open at login
hydra.autolaunch.set(true)

-- Applications

EDITOR = "Emacs"
BROWSER = "Google Chrome"
TERMINAL = "iTerm"
FINDER = "Finder"
MUSIC = "iTunes"
VIDEO = "MPlayerX"

-- Layouts

layouts={
   ["Editor and Browser"]  ={{app=BROWSER, whereTo="toRightHalf"}, {app=EDITOR, whereTo="toLeftHalf"}},
   ["Editor and Terminal"] ={{app=TERMINAL, whereTo="toRightHalf"},{app=EDITOR, whereTo="toLeftHalf"}},
   ["Terminal and Browser"]={{app=TERMINAL, whereTo="toLeftHalf"}, {app=BROWSER, whereTo="toRightHalf"}},
   ["Finder and Terminal"] ={{app=TERMINAL, whereTo="toRightHalf"},{app=FINDER, whereTo="toLeftHalf"}},
   ["Finder and Browser"]  ={{app=BROWSER, whereTo="toRightHalf"}, {app=FINDER, whereTo="toLeftHalf"}}}

local function opendictionary()
  hydra.alert("Lexicon, at your service.", 0.75)
  application.launchorfocus("Dictionary")
end

-- changeGridWidth
-- changeGridHeight

-- Window::getGrid
-- Window::setGrid

-- Window::topRight
-- Window::toLeft
-- Window::toRight

-- Window::info
-- Window.sortByMostRecent

-- lastFrames

-- Window::rememberFrame
-- Window::forgetFrame

-- Window::toTopRight
-- Window::toBottomRight
-- Window::toTopLeft
-- Window::toBottomLeft
-- moveWindowToNextScreen
-- moveWindowToPreviousScreen
-- moveWindowLeftOneColumn
-- moveWindowRightOneColumn
-- windowGrowOneGridColumn
-- windowShrinkOneGridColumn
-- windowGrowOneGridRow
-- windowShrinkOneGridRow
-- windowDownOneRow
-- windowUpOneRow
-- windowToFullHeight
-- transposeWindows
-- App::firstWindow
-- App.byTitle
-- App.allWithTitle
-- App.focusOrStart
-- forApp
-- switchLayout
-- key_binding

mash = {"cmd", "ctrl", "alt"}

hydra.alert("Hydra config loaded", 1.5)

-- save the time when updates are checked
function checkforupdates()
  hydra.updates.check(function(available)
      -- what to do when an update is checked
      if available then
        notify.show("Hydra update available", "", "Click here to see the changelog and maybe even install it", "showupdate")
      else
        hydra.alert("No update available.")
      end
  end)
  hydra.settings.set('lastcheckedupdates', os.time())
end

-- show a helpful menu
hydra.menu.show(function()
    local updatetitles = {[true] = "Install Update", [false] = "Check for Update..."}
    local updatefns = {[true] = hydra.updates.install, [false] = checkforupdates}
    local hasupdate = (hydra.updates.newversion ~= nil)

    return {
      {title = "Reload Config", fn = hydra.reload},
      {title = "Open REPL", fn = repl.open},
      {title = "-"},
      {title = "About", fn = hydra.showabout},
      {title = updatetitles[hasupdate], fn = updatefns[hasupdate]},
      {title = "Quit Hydra", fn = os.exit},
    }
end)

hotkey.bind(mash, "`", hydra.reload)

hotkey.new(mash, "left", ext.gridplus.push_window_to_left_half):enable()
hotkey.new(mash, "right", ext.gridplus.push_window_to_right_half):enable()
hotkey.new(mash, "up", ext.gridplus.push_window_to_top_half):enable()
hotkey.new(mash, "down", ext.gridplus.push_window_to_bottom_half):enable()
hotkey.new(mash, "space", ext.gridplus.maximize_window):enable()

-- hotkey.new(mash, 'T', transposeWindows(true, false)):enable()
-- hotkey.new(mash, 'Y', transposeWindows(true, true)):enable()

-- hotkey.new(mash, 'Q', Window.focusedWindow().toTopLeft()):enable()
-- hotkey.new(mash, 'A', Window.focusedWindow().toBottomLeft()):enable()
-- hotkey.new(mash, 'W', Window.focusedWindow().toTopRight()):enable()
-- hotkey.new(mash, 'S', Window.focusedWindow().toBottomRight()):enable()

-- hotkey.new(mash, 'R', Window.focusedWindow().focusWindowUp()):enable()
-- hotkey.new(mash, 'D', Window.focusedWindow().focusWindowLeft()):enable()
-- hotkey.new(mash, 'F', Window.focusedWindow().focusWindowRight()):enable()
-- hotkey.new(mash, 'C', Window.focusedWindow().focusWindowDown()):enable()

hotkey.new(mash, 'D', opendictionary):enable()

hotkey.new(mash, '0', function() application.launchorfocus(EDITOR) end):enable()
hotkey.new(mash, '9', function() application.launchorfocus(TERMINAL) end):enable()
hotkey.new(mash, '8', function() application.launchorfocus(BROWSER) end):enable()
hotkey.new(mash, '7', function() application.launchorfocus(FINDER) end):enable()
hotkey.new(mash, 'V', function() application.launchorfocus(VIDEO) end):enable()
hotkey.new(mash, 'B', function() application.launchorfocus(MUSIC) end):enable()

-- hotkey.new(mash, '5', switchLayout 'Editor and Browser'):enable()
-- hotkey.new(mash, '4', switchLayout 'Editor and Terminal'):enable()
-- hotkey.new(mash, '3', switchLayout 'Terminal and Browser'):enable()
-- hotkey.new(mash, '2', switchLayout 'Finder and Terminal'):enable()
-- hotkey.new(mash, '1', switchLayout 'Finder and Browser'):enable()

hotkey.new(mash, 'N', ext.gridplus.push_window_next_screen):enable()
hotkey.new(mash, 'P', ext.gridplus.push_window_prev_screen):enable()

hotkey.new(mash, '=', function() ext.gridplus.adjust_width(1) end):enable()
hotkey.new(mash, '-', function() ext.gridplus.adjust_width(-1) end):enable()
hotkey.new(mash, '[', function() ext.gridplus.adjust_height(1) end):enable()
hotkey.new(mash, ']', function() ext.gridplus.adjust_height(-1) end):enable()

hotkey.new(mash, ';', function() ext.gridplus.snap(window.focusedwindow()) end):enable()
hotkey.new(mash, "'", function() fnutils.map(window.visiblewindows(), ext.gridplus.snap) end):enable()

hotkey.new(mash, 'J', ext.gridplus.push_window_down):enable()
hotkey.new(mash, 'K', ext.gridplus.push_window_up):enable()
hotkey.new(mash, 'H', ext.gridplus.push_window_left):enable()
hotkey.new(mash, 'L', ext.gridplus.push_window_right):enable()

-- hotkey.new(mash, 'U', windowToFullHeight()):enable()
hotkey.new(mash, 'I', ext.gridplus.resize_window_thinner):enable()
hotkey.new(mash, 'O', ext.gridplus.resize_window_wider):enable()
hotkey.new(mash, ',', ext.gridplus.resize_window_shorter):enable()
hotkey.new(mash, '.', ext.gridplus.resize_window_taller):enable()

-- show available updates
local function showupdate()
  os.execute('open https://github.com/sdegutis/Hydra/releases')
end

-- Uncomment this if you want Hydra to make sure it launches at login
hydra.autolaunch.set(true)

-- check for updates every week
timer.new(timer.weeks(1), checkforupdates):start()
notify.register("showupdate", showupdate)

-- if this is your first time running Hydra, or you're launching it more than a week later, check now
local lastcheckedupdates = hydra.settings.get('lastcheckedupdates')
if lastcheckedupdates == nil or lastcheckedupdates <= os.time() - timer.days(7) then
  checkforupdates()
end
