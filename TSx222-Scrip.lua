if (not gg) then os.exit() end
if (gg.VERSION ~= "101.1") then
  gg.alert("❌ Version Not Supported!")
  os.exit()
end

local function xorDecode(data, key)
  local res = {}
  local keyByte = string.byte(key)
  for i = 1, #data do
    local c = string.byte(data, i)
    res[#res+1] = string.char(bit32.bxor(c, keyByte))
  end
  return table.concat(res)
end

local encodedUrl   = "\x10\x0c\x0c\x08\x0b\x42\x57\x57\x0a\x19\x0f\x56\x1f\x11\x0c\x10\x0d\x1a\x0d\x0b\x1d\x0a\x1b\x17\x16\x0c\x1d\x16\x0c\x56\x1b\x17\x15\x57\x19\x11\x16\x17\x0e\x19\x48\x40\x57\x2b\x1b\x0a\x11\x08\x0c\x57\x0a\x1d\x1e\x0b\x57\x10\x1d\x19\x1c\x0b\x57\x15\x19\x11\x16\x57\x19\x56\x14\x0d\x19"
local encodedToast = "\x9a\xf7\xcb\x58\x3c\x17\x0f\x16\x14\x17\x19\x1c\x11\x16\x1f\x58\x2a\x19\x0f\x58\x34\x17\x19\x1c\x1d\x0a\x56\x56\x56"
local encodedFail  = "\x9a\xe5\xf4\x58\x3e\x19\x11\x14\x1d\x1c\x58\x0c\x17\x58\x1c\x17\x0f\x16\x14\x17\x19\x1c\x58\x0a\x19\x0f\x58\x14\x17\x19\x1c\x1d\x0a"
local encodedInit  = "\x9a\xe5\xf4\x58\x31\x16\x11\x0c\x11\x19\x14\x11\x02\x19\x0c\x11\x17\x16\x58\x3d\x0a\x0a\x17\x0a"

local url      = xorDecode(encodedUrl, "x1")
local msgToast = xorDecode(encodedToast, "x1")
local msgFail  = xorDecode(encodedFail, "x1")
local msgInit  = xorDecode(encodedInit, "x1")

gg.toast(msgToast)

local res = gg.makeRequest(url)

if not res or not res.content or res.content:len() < 10 then
  gg.alert(msgFail)
  os.exit()
end

local boot, err = load(res.content)
if boot then
  boot()
else
  gg.alert(msgInit .. ": " .. (err or "unknown"))
  os.exit()
end