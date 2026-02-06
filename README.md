# Trainer Card Video Player

Lua script to play videos in the trainer card signature area, for use in the 5th generation Pokemon games. Video playback is simulated by modifying the trainer card signature memory location. The script supports Pokemon Black, White, Black 2, and White 2. Emulator-only.

Tested on BizHawk 2.11 with the MelonDS core, and DeSmuME 0.9.11

## Demo
![](demo.gif)

See also: [Bad Apple but it's on the Pokemon White 2 Trainer Card](https://www.youtube.com/watch?v=i7jDshgE50g)

## Usage

### Requirements
- Lua 5.1 (DeSmuME) or 5.4 (Bizhawk)
- Python 3.10 or later
    - PIL
- FFmpeg

### Windows
```bat
convert_video.bat video.mp4
```
### Linux
```bash
./convert_video.sh video.mp4
```

Finally, import the respective Lua script in BizHawk or DeSmuME
