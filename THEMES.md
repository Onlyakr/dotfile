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
- **Blue** (`#9bb9d7`, brighter `#aac8e6` for Function) = "this should stand
  out": nvim Type/Function, zed's matching syntax tokens + focused-border/pane
  indicators, tmux's active-window indicator, ghostty's ANSI blue slot (4/12).
  Also the zsh prompt: Powerlevel10k's git-branch segment when repo is dirty
  (`modified='%3F'`/`untracked='%4F'` — untouched, was already colored) and
  the command name you type (`~/.zshrc`'s `ZSH_HIGHLIGHT_STYLES[arg0]`).
- **Amber** (`#e0a660`) = string literals: nvim String, zed `syntax.string`,
  ghostty's ANSI yellow slot (3/11). Also the Powerlevel10k git-branch segment
  when the repo is clean (icon + branch name + text, both driven by ANSI
  yellow — see below) and the double/single-quoted arguments you type at
  the CLI (zsh-syntax-highlighting's default is already yellow, no config
  needed for that part).
- **Everything else** (comments, operators, variables, UI chrome, git status,
  diagnostics) = Mono's exact literal grey — no tint. The nvim file tree/zed
  panel are a partial exception — see below, they're brighter than plain
  Mono on purpose.

**nvim file tree vs zed panel — both grey, deliberately brighter than Mono:**
- `nvim/lua/config/nightsea.lua`'s `c.neutral = "#f0f0f0"` (not Mono's
  `#c0c0c0`) applied to `NeoTreeNormal`/`NeoTreeNormalNC`/`NvimTreeNormal`/
  `NeoTreeDirectoryIcon`/`NeoTreeFileIcon`/`NeoTreeDirectoryName` — chosen to
  match zed's panel brightness exactly, not Mono's.
- **`NeoTreeDirectoryName` needs its own override** — unlike `NeoTreeFileName`
  (no default link, just inherits plain text), it links to the global
  `Directory` group by default, which stays blue (`g11`) for netrw/telescope.
  Miss this override and directory *names* stay blue while file names/icons
  go grey — happened once already.
- **File icon colors need a 3rd override**, not just `NeoTreeFileIcon`:
  `nvim-web-devicons` (with `color_icons = false`, set in the user's own
  `navigation.lua`) collapses every file's icon highlight to a single shared
  group, `DevIconDefault` — which still carries devicons' own hardcoded color
  (`#6d8086`) unless something overrides it. Worse, devicons re-applies that
  color itself the moment it finishes lazy-loading (its own `ColorScheme`
  autocmd, registered at its own setup time) — which happens *after* our
  theme's one-time startup setup, silently clobbering any override set
  upfront. Fixed with a `User LazyLoad` autocmd keyed to `nvim-web-devicons`
  that re-applies `DevIconDefault` right after devicons finishes loading, so
  our color wins regardless of plugin load order.
- zed has no per-panel icon token like nvim's — its `icon`/`icon.muted`/
  `icon.disabled`/`text.muted` are one shared value used for the panel *and*
  buttons/tabs/status bar app-wide. Brightened to `#f0f0f0`/`#c0c0c0`/
  `#808080`/`#c0c0c0` on purpose (whiter than Mono's own values) per explicit
  request — don't "fix" these back to literal Mono values, that was already
  tried and reverted once.

**Shell integration (outside this repo, lives in `$HOME` directly — not
git-tracked, not touched by `~/.config/theme`, easy to forget about):**
- `~/.zshrc` — `ZSH_HIGHLIGHT_STYLES[arg0]='fg=blue,bold'`, set *before*
  `source $ZSH/oh-my-zsh.sh` (the plugin only sets defaults for keys not
  already set, so order matters). Colors the command name you type, if it's
  recognized. Quoted string arguments are already yellow/amber by the
  plugin's own default — nothing to configure there.
- `~/.p10k.zsh` — two separate settings control the Powerlevel10k git-branch
  segment, both currently ANSI yellow (amber):
  - `POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=3` (~line 490) — the segment's
    icon (the octocat-ish glyph before the branch name).
  - `my_git_formatter()`'s `clean='%3F'` (~line 374) — the branch *name* text
    when the repo has no changes. `modified`/`untracked` (yellow/blue) were
    already colored by Powerlevel10k's own defaults, untouched.
  These are two independent settings for what looks like one visual element —
  missing one leaves half the segment grey. Learned that the hard way once.
- `~/.claude/statusline-command.sh` — Claude Code's own statusline script,
  **left as plain Mono grey on purpose** (`${GREEN}` for the git-branch
  segment, i.e. ANSI 2, not one of Nightsea's accented slots) — explicitly
  requested to stay unstyled while the shell prompt above gets the accent.
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
