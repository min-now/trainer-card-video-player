-- Trainer Card Video Player v0.1 
-- Written by minnow 
-- Designed for DeSmuME 0.9.11

local FILENAME = "data.bin"

local function read_data(filename)
   local file, msg, code = io.open(filename, "rb")
   if not file then
      print(string.format("Error opening file \"%s\": %s (%d)", filename, err, code))
      return -1
   end

   local video = {}

   -- This sucks
   video["width"] = string.byte(file:read(1)) + string.byte(file:read(1)) * 256
   video["height"] = string.byte(file:read(1)) + string.byte(file:read(1)) * 256
   local framecount = string.byte(file:read(1)) + string.byte(file:read(1)) * 256

   assert(framecount > 0, string.format("amount of frames must be greater than zero")) -- Shouldn't ever happen

   video["framecount"] = framecount
   video["frames"] = {}

   for frame = 1, framecount do
      local raw_str = file:read(video["width"] * video["height"])
      -- "string slice too long" ffs
      -- table.insert(video["frames"], frame, {string.byte(raw_str, 1, -1)})
      
      local str_bytes = {}
      for i = 1, #raw_str do
         str_bytes[i] = string.byte(raw_str, i)
      end
      table.insert(video["frames"], frame, str_bytes)
   end

   file:close()

   return video
end

local function get_canvas_addr()
   -- Game determination addresses taken from the `seed_injection.lua` script.
   local part1, part2 = memory.readdword(0x2000024), memory.readdword(0x2000028)

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
      for i = 1, #frame do
        memory.writebyte(CANVAS_ADDRESS + (i - 1), frame[i])
      end

      -- Touch screen needs to be held down at valid canvas point for the canvas to refresh
      stylus.set({x = 32, y = 90, touch = true})

      emu.frameadvance(); emu.frameadvance()
   end
end

main()



