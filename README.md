# Trainer Card Video Player

Video player within the trainer card, for use in the 5th generation Pokemon games. Video playback is simulated by modifying the trainer card signature memory area every frame. Supports Pokemon Black, White, Black 2, and White 2. Emulator-only.

There is no practical use case; it's just for the memes. 

## Demo
![](demo.gif)

See also: [Bad Apple but it's on the Pokemon White 2 Trainer Card](https://www.youtube.com/watch?v=i7jDshgE50g)

## Usage

### Requirements
- BizHawk with the MelonDS core, or DeSmuME 0.9.11
- Python 3.10 or later
    - PIL
- FFmpeg
- Lua 5.1 (DeSmuME) or 5.4 (Bizhawk)

### Windows
```bat
convert_video.bat video.mp4
```
### Linux
```bash
./convert_video.sh video.mp4
```

Finally, import the respective Lua script in BizHawk or DeSmuME
