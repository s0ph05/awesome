local naughty = require("naughty")

function readNetFile(adapter, ...)
  local basepath = "/sys/class/net/"..adapter.."/"
  for i, name in pairs({...}) do
    file = io.open(basepath..name, "r")
    if file then
      local str = file:read()
      file:close()
      return str
    end
  end
end

function setMarkup(string,state)
  local str
  -- green
  if state == 1 then
    str = "<span color='darkgreen'>"..string.."</span>"
  -- yellow
  elseif state == 2 then
    str = "<span color='yellow'>"..string.."</span>"
  -- red
  elseif state == 3 then
    str = "<span color='darkred'>"..string.."</span>"
  end
  return str
end

function netInfo(eth,wifi)
  local wifi_flag   = 0
  local net_flag    = 0
  local eth_state   = readNetFile(eth, "operstate")
  local wifi_state  = readNetFile(wifi, "operstate")

  if eth_state == nil then
    eth_state = "down"
  end
  if wifi_state == nil then
    wifi_state = "down"
  end

  if eth_state:match("up") then
    en = setMarkup("EN",1)
    net_flag = 1
  elseif eth_state:match("down") then
    en = setMarkup("EN",3)
  else
    en = setMarkup("EN",3)
  end

  if wifi_state:match("up") then
    wf = setMarkup("WF",1)
    wifi_flag = 1
    net_flag = 1
  elseif wifi_state:match("down") then
    wf = setMarkup("WF",3)
  else
    wf = setMarkup("WF",3)
  end

  return en.." | "..wf
end
