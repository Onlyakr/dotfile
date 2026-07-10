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

## fastfetch cat logo

Default fastfetch layout (`config.jsonc`) with a braille dot-art cat as the logo.
fastfetch and nvim use **different** cats:

- **fastfetch** — `fastfetch/cat.txt`, a lineart sitting cat (48×28). Logo
  `width`/`height` in `config.jsonc` must match the file's columns/rows.
- **nvim dashboard** — `nvim/cat.txt`, a separate up-looking cat (40×15, round
  eyes), read by `nvim/lua/plugins/dashboard.lua`. No caption.

Both are plain braille (no ANSI colour) so they render in the terminal/theme
foreground. Files were pasted in directly; the helpers below are for editing them.

### Helpers (`cd fastfetch` first)

- **Resize an existing braille cat** — `./fit-cat.sh <rows> [file]` reconstructs
  the real bitmap from the dots and re-dithers smaller (lossless, unlike
  re-rasterising glyphs). Add `COLS=<n>` to stretch to an exact width (fix
  proportion). e.g. `COLS=40 ./fit-cat.sh 15 ../nvim/cat.txt`. For the fastfetch
  cat, set `config.jsonc` `width`/`height` to what it prints.
- **Generate from an image/ASCII** — put art in `logo-src.txt` (ASCII) or
  `logo-src.<img>` (photo) and run `./gen-logo.sh`; it rasterises + blurs (density
  → tone) + dithers to braille. **Overwrites `cat.txt`.** Tune `SIZE` / `BLUR` there.
- Both helpers need `chafa` + `imagemagick` (`brew install chafa imagemagick`).
- fastfetch can't resize a text logo to the window; the logo size is fixed.

## Notes

- **ccstatusline** and **Claude Code** don't have their own mono theme — they use
  named ANSI colors that resolve through ghostty's palette, so they follow ghostty
  automatically once Claude Code is on `dark-ansi`.
- **zed icons** use `Zed (Default)` — Zed's built-in monochrome icon set (full
  coverage, tints grey via the theme's `icon` color). Alternatives:
  `Min Icons` (12 icons, ultra-minimal grey) or `Catppuccin Mocha` (colored,
  original). To drop icons entirely:
  `"project_panel": { "file_icons": false, "folder_icons": false }`.
- **wallpaper** is OS-level (not in this repo). A B&W manga-style wall makes the
  blur read best.
