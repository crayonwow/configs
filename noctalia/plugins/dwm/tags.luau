--!nonstrict
-- dwm-style tag bar for mango, as a noctalia scripted bar widget.
--
-- The built-in workspaces widget leaves a fixed gap of 1/4 pill between tags
-- and caps the pill at 2/3 of the bar, so the selected-tag fill never touches
-- its neighbours or the bar edges. This draws the cells itself: no gaps, the
-- selected tag filled edge to edge, and dwm's occupied marker (a small square
-- in the top-left corner, filled on the selected tag, hollow elsewhere),
-- followed by the layout symbol.
--
-- State comes from `mmsg watch monitor <output>`, one JSON line per change,
-- reconnecting whenever mango restarts.
-- Left click a tag to view it; click the layout symbol to cycle layouts.

local THICKNESS = noctalia.getSetting("bar.default.thickness") or 24
local PAD = 7 -- horizontal padding on each side of a label, like dwm's lrpad / 2
local BOX = 4 -- occupied marker size
local BOX_OFFSET = 2 -- marker distance from the cell's top-left corner

-- mango layout symbols mapped to the dwm-style ones people know.
local LAYOUT_SYMBOLS = {
  T = "[]=",
  RT = "=[]",
  M = "[M]",
  G = "###",
  K = "[D]",
  S = "[S]",
  CT = "|M|",
  DW = "[\\]",
  F = "[F]",
  VT = "TTT",
  VS = "[VS]",
  VG = "#V#",
  VK = "[VD]",
  VF = "[VF]",
}

local monitor = nil
local streaming = false
local state = nil

local function dispatch(arg)
  noctalia.runAsync({ "mmsg", "dispatch", arg })
end

local function tagCell(tag)
  local selected = tag.is_active
  local fill = "surface"
  local fg = "on_surface_variant"
  if tag.is_urgent then
    fill, fg = "error", "on_error"
  elseif selected then
    fill, fg = "primary", "on_primary"
  end

  -- Re-renders patch the existing node and keep any prop left out, so both
  -- states set every prop; an empty tag that omitted border kept the outline
  -- from when it last had windows.
  local occupied = tag.client_count > 0
  local marker = ui.box({
    width = BOX,
    height = BOX,
    fill = (occupied and selected) and fg or "#00000000",
    border = occupied and fg or "#00000000",
    borderWidth = occupied and 1 or 0,
  })

  local index = tag.index
  return ui.row({ key = `tag{index}`, height = THICKNESS, fill = fill, align = "center", onClick = function()
    dispatch(`view,{index},0`)
  end }, {
    -- The marker sits in the left padding, pinned to the top like in dwm.
    ui.column({ width = PAD, height = THICKNESS, paddingH = BOX_OFFSET, paddingV = BOX_OFFSET, align = "start", justify = "start" }, {
      marker,
    }),
    ui.label({ text = tostring(index), color = fg }),
    ui.spacer({ width = PAD }),
  })
end

local function render()
  if not state or not state.tags then
    return
  end
  local cells = {}
  for _, tag in ipairs(state.tags) do
    table.insert(cells, tagCell(tag))
  end
  local symbol = state.layout_symbol or ""
  table.insert(cells, ui.row({ key = "layout", height = THICKNESS, fill = "surface", paddingH = PAD, align = "center", onClick = function()
    dispatch("switch_layout")
  end }, {
    ui.label({ text = LAYOUT_SYMBOLS[symbol] or `[{symbol}]`, color = "on_surface_variant" }),
  }))
  -- The surface backdrop hides the bar fill that would otherwise bleed through
  -- the anti-aliased seams between cells at fractional scales.
  barWidget.render(ui.row({ gap = 0, height = THICKNESS, align = "center", fill = "surface" }, cells))
end

local function onLine(line)
  local value = noctalia.json.decode(line)
  if value and value.tags then
    state = value
    render()
  end
end

local function start()
  if streaming then
    return
  end
  monitor = barWidget.outputName() or noctalia.focusedOutputName()
  if not monitor then
    return
  end
  -- One snapshot right away, then live updates.
  noctalia.runAsync({ "mmsg", "get", "monitor", monitor }, function(result)
    if result.exitCode == 0 then
      onLine(result.stdout)
    end
  end)
  -- mmsg exits when mango goes away (restart, crash); the loop reconnects and
  -- mmsg sends the full state again on connect. runStream gives no exit
  -- callback, so the loop lives in the shell. SIGPIPE is ignored in the
  -- child, so the empty line after each exit probes the pipe instead: once
  -- noctalia has dropped this stream (script reload), the write fails and the
  -- loop ends rather than respawning mmsg forever. Empty lines are not JSON,
  -- so onLine skips them.
  streaming = noctalia.runStream(
    `while :; do mmsg watch monitor '{monitor}'; echo || exit; sleep 1; done`,
    onLine
  )
end

function update()
  -- Retries until the output name is known; a no-op once the stream runs.
  noctalia.setUpdateInterval(5000)
  start()
end

start()
