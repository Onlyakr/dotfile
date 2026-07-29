# Theme variations

## Quick reference (read this first)

**Switch preset:**
```sh
~/.config/theme                # show what's active right now
~/.config/theme nightsea       # dark black/blue + amber string accent
~/.config/theme mono           # pure grey/white, no hue anywhere
~/.config/theme catppuccin     # the original theme, pre-mono/nightsea
```
Not on `$PATH` — call by full path, or alias/add it yourself. Auto-reloads
tmux. **ghostty needs `cmd+r`, nvim/zed need a full quit+reopen** (colorscheme
only applies at startup — `:so %` is not enough, this has bitten us before).
After switching, `git add`+commit the 4 changed files if you want the switch
to persist in history (the script only edits the working tree).

**What's blue/amber vs plain grey (Nightsea only — Mono/Catppuccin unaffected):**
- **Blue** (`#9bb9d7` / `#aac8e6` brighter) = "this should stand out": nvim
  Type/Function, zed's matching syntax tokens + focused-border/pane
  indicators, tmux's active-window indicator, ghostty's ANSI blue slot (4/12).
- **Amber** (`#e0a660`) = string literals: nvim String, zed `syntax.string`,
  ghostty's ANSI yellow slot (3/11).
- **Everything else** (comments, operators, variables, UI chrome, git status,
  diagnostics, the file tree/panel) = Mono's exact literal grey — no tint.

**Shell integration (outside this repo, lives in `$HOME` directly — not
git-tracked, not touched by `~/.config/theme`, easy to forget about):**
- `~/.zshrc` — no Nightsea-specific config currently (a zsh-syntax-highlighting
  `arg0` override was tried and reverted; nothing to maintain here right now).
- `~/.p10k.zsh` — Powerlevel10k's `my_git_formatter()` (around line 361) sets
  `clean='%2F'` (green) for the git-branch segment. Green (ANSI 2) isn't one of
  Nightsea's accented ANSI slots, so it renders as Mono's plain grey. Change to
  `%3F` (ANSI yellow → amber) if you want the branch segment tinted again.
- `~/.claude/statusline-command.sh` — Claude Code's own statusline script; the
  git-branch segment uses `${GREEN}` (also ANSI 2, same situation as above).
- `~/.config/ccstatusline/settings.json` exists but **is not what renders
  Claude Code's statusline** — `~/.claude/settings.json`'s `statusLine.command`
  points at the bash script above instead. Don't edit ccstatusline expecting
  it to do anything (this cost real time to figure out once already).

---

Three variations live side-by-side. **Nightsea** (dark black/blue) is active.
**Mono** (pure black & white, greyscale-only, no hue) and **Catppuccin Mocha**
(original) are kept intact — every switch below is one line, nothing is
deleted.

Grey ramp shared by Mono: `#000000 → 404040 → 606060 → 808080 → a0a0a0 →
d0d0d0 → e0e0e0 → f0f0f0 → #ffffff`. Nightsea re-tints every grey `v` (0-255,
true black/white left as anchors) to hue 210° with `R = v'-d, G = v', B =
v'+d`, `v' = clamp(v+20, 1, 254)` — a flat +20 lightness lift on top of `v` —
and `d(v')` following a lightness-skewed curve (`d = 30 · x³(1-x) /
0.10546875`, `x = v'/255`) instead of a flat saturation, so chroma peaks near
the light text/tree tones and vanishes near black/white. The +20 lift departs
from Mono's exact lightness values on purpose (brighter overall, per
feedback); the curve shape still avoids the oversaturated-dark/flat-light
problem a constant HSL-saturation ramp had in an earlier iteration. Hue
derived from the wallpaper (`~/Pictures/wallpapers/wallhaven-po75pp.jpg`);
see `docs/superpowers/specs/2026-07-29-nightsea-theme-design.md` for the
original design rationale (its formula section is superseded by this one).
Transparency/blur is kept in both.

**Exception:** almost everything runs through the formula above, but not
Type/Function — their original ramp position (`v'` near 244-254) landed in
the curve's near-255 zone, where `d` deliberately tapers to ~0 so true white
survives. That made the one tier meant to stand out read as white instead of
blue. Those two got hand-picked values instead (`#9bb9d7` / `#aac8e6`), and
every place they're reused (see Quick Reference above) copies those two
literal values rather than re-deriving them.

## Switch a single tool

`~/.config/theme <preset>` does all 4 rows below at once — this table is for
switching just one tool by hand, or for understanding what the script does.

| Tool | File | Nightsea (active) | Mono | Catppuccin |
|------|------|--------------------|------|------------|
| **ghostty** | `ghostty/config` | `theme = "nightsea.conf"` | `theme = "studio1804-monochrome.conf"` | `theme = "Catppuccin Mocha"` |
| **zed** | `zed/settings.json` | `"dark": "Nightsea"` | `"dark": "Mono"` | `"dark": "Catppuccin Mocha"` |
| **nvim** | `nvim/lua/plugins/ui.lua` | `local THEME = "nightsea"` | `local THEME = "mono"` | `local THEME = "catppuccin"` |
| **tmux** | `tmux/tmux.conf` | uncomment `NIGHTSEA override`, comment `MONO override` | uncomment `MONO override`, comment `NIGHTSEA override` | comment out both override blocks |
| **Claude Code** | `~/.claude/settings.json` | `"theme": "dark-ansi"` (routes through ghostty palette, no per-theme change needed) | same | same |

Only one of `ghostty/config`'s `theme = ` lines, one of `zed/settings.json`'s
`"dark":` values, and one tmux override block should be active at a time —
the others in each row stay present but disabled, exactly like Mono/Catppuccin
did before Nightsea existed.

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
# back to Mono (pre-nightsea) — HEAD is the final commit of the Nightsea branch work
git revert 8089b2e^..HEAD
```

## Files that make up the Mono variation

- `ghostty/themes/studio1804-monochrome.conf` — ghostty palette (pre-existing)
- `zed/themes/mono.json` — zed theme (greyscale syntax, transparent bg for blur)
- `nvim/lua/config/mono.lua` — hand-rolled colorscheme matching the ghostty ramp
- tmux `@thm_*` remap block in `tmux/tmux.conf`

## Files that make up the Nightsea variation

- `ghostty/themes/nightsea.conf` — ghostty palette (hue-shifted from studio1804-monochrome.conf)
- `zed/themes/nightsea.json` — zed theme (hue-shifted from mono.json)
- `nvim/lua/config/nightsea.lua` — nvim colorscheme (hue-shifted from mono.lua)
- tmux `NIGHTSEA override` block in `tmux/tmux.conf` (currently the active/uncommented block; MONO override is commented out)

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
