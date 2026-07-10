# Theme variations

Two variations live side-by-side. **Mono** (pure black & white, greyscale-only,
no hue) is active. **Catppuccin Mocha** (original) is kept intact — every switch
below is one line, nothing is deleted.

Grey ramp shared by all tools: `#000000 → 404040 → 606060 → 808080 → a0a0a0 →
d0d0d0 → e0e0e0 → f0f0f0 → #ffffff`. Transparency/blur is kept in Mono.

## Switch a single tool

| Tool | File | Mono | Revert to Catppuccin |
|------|------|------|----------------------|
| **ghostty** | `ghostty/config` | `theme = "studio1804-monochrome.conf"` | comment that line, uncomment `theme = "Catppuccin Mocha"` |
| **zed** | `zed/settings.json` | `"dark": "Mono"` | `"dark": "Catppuccin Mocha"` |
| **nvim** | `nvim/lua/plugins/ui.lua` | `local MONO = true` | `local MONO = false` |
| **tmux** | `tmux/tmux.conf` | keep the `MONO override` block at the bottom | delete that block |
| **Claude Code** | `~/.claude/settings.json` | `"theme": "dark-ansi"` (routes through ghostty palette) | `"theme": "dark"` |

Reload after switching:
- ghostty: `cmd+r`
- tmux: `prefix + r`
- zed / nvim: reopen
- Claude Code: `/theme` and pick, or restart

## Switch everything at once (git)

```sh
# back to the pre-mono snapshot
git reset --hard acf8864          # baseline commit "snapshot before mono ricing"
# or undo just the mono commit
git revert cb04c29
```

## Files that make up the Mono variation

- `ghostty/themes/studio1804-monochrome.conf` — ghostty palette (pre-existing)
- `zed/themes/mono.json` — zed theme (greyscale syntax, transparent bg for blur)
- `nvim/lua/config/mono.lua` — hand-rolled colorscheme matching the ghostty ramp
- tmux `@thm_*` remap block in `tmux/tmux.conf`

## Notes

- **ccstatusline** and **Claude Code** don't have their own mono theme — they use
  named ANSI colors that resolve through ghostty's palette, so they follow ghostty
  automatically once Claude Code is on `dark-ansi`.
- **zed icons** use the `Min Icons` theme (grey `#999999`). Revert to Catppuccin:
  `"icon_theme": { "dark": "Catppuccin Mocha" }`. To drop icons entirely, set
  `"project_panel": { "file_icons": false, "folder_icons": false }`.
- **wallpaper** is OS-level (not in this repo). A B&W manga-style wall makes the
  blur read best.
