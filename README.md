# Hydra Config

This config is based on my Phoenix-config at [https://github.com/jasonm23/Phoenix-config][1]

It has the following features

- Load / Switch to developer (configurable) Applications:
  - Editor
  - Terminal
  - Browser
  - Finder
  - Music
  - Video

- Push windows to preset positions
  - `nw, n, ne, e, se, s, sw, w`

- Set grid (rows and columns)
  - snap to grid current or all windows
  - size window on grid
  - push window around grid cells

- Multi display support
  - push window between displays (next/previous)

The keyboard guide / cheatsheet shown on the [Phoenix config][1] is
compatible, except the following omissions.

- Layouts - My team and I like these in theory, but we never use them. (They may re-appear at some later date)

- Window Transpose - as above, these are cool in theory, but never used.

### Moonscript / Lua

Hydra supports Lua, and the config is written in [Moonscript][2],
because I like it.

I will almost certainly add an auto-compile step or deal with
compilation in some other way.  Currently updates to the Moonscript
files must be compiled to Lua manually.

Use `moonc` to compile (install the moonscript package via `luarocks`.)
[For more info on Moonscript, visit the project page][2]

[1]: https://github.com/jasonm23/Phoenix-config
[2]: https://github.com/leafo/moonscript/blob/master/docs/reference.md
