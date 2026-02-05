-- Trainer Card Video Player v0.1 
-- Written by minnow 
-- Designed for BizHawk 2.11

local FILENAME = "data.bin"

local function read_data(filename)
   local file, msg, code = io.open(filename, "rb")
   if not file then
      print(string.format("Error opening file \"%s\": %s (%d)", filename, err, code))
      return -1
   end

   local FORMAT_STR = "<H" -- unsigned short (little endian) (https://www.lua.org/manual/5.3/manual.html#6.4.2)

   local video = {}
   -- The first four bytes specify the width and height of the gif (should always be 192x64)
   local video["width"] = string.unpack(FORMAT_STR, file:read(2))
   local video["height"] = string.unpack(FORMAT_STR, file:read(2))

   -- The next two bytes indicate the amount of frames in the encoded gif
   local framecount = string.unpack(FORMAT_STR, file:read(2))
   assert(framecount > 0, string.format("amount of frames must be greater than zero")) -- Shouldn't ever happen

   video["framecount"] = framecount
   video["frames"] = {}

   for frame = 1, framecount do
      local raw_str = file:read(video["width"] * video["height"])
      table.insert(video["frames"], frame, {string.byte(raw_str, 1, -1)})
   end

   file:close()

   return video
end

local function get_canvas_addr()
   -- Game determination addresses taken from the `seed_injection.lua` script.
   local part1, part2 = memory.read_u32_le(0x2000024), memory.read_u32_le(0x2000028)
   if part1 == 0x0221B2F0 and part2 == 0x020AA9C4 then
      return 0x022817A8          -- black 1
   elseif part1 == 0x0221B310 and part2 == 0x020AA9E4 then
      return 0x022817A8 + 0x20   -- white 1
   elseif part1 == 0x02204CC4 and part2 == 0x0209E288 then
      return 0x02280320 - 0x40   -- black 2
   elseif part1 == 0x02204D04 and part2 == 0x0209E2C8 then
      return 0x02280320          -- white 2
   else
      return -1
   end
end

local function main()
   local CANVAS_ADDRESS = get_canvas_addr()
   if CANVAS_ADDRESS == -1 then
      print("Error: unable to determine game version")
      return -1
   end

   local video = read_data(FILENAME)
   if video == -1 then
      return -1
   end

   for _, frame in ipairs(video["frames"]) do
      memory.write_bytes_as_array(CANVAS_ADDRESS, frame)

      -- Touch screen needs to be held down at valid canvas point for the canvas to refresh
      joypad.setanalog({["Touch X"] = 32, ["Touch Y"] = 90, ["Touch"] = true})
      joypad.set({["Touch"] = true})

      emu.frameadvance(); emu.frameadvance()
   end

   joypad.setanalog({
      ["Touch X"] = "",
      ["Touch Y"] = "",
      ["Touch"]   = ""
   })
end

main()



