# Trainer Card Video Player v0.1 
# Written by minnow 

import sys
from PIL import Image, ImageSequence

OUT_FILE = "data.bin"

IMG_WIDTH, IMG_HEIGHT = (192, 64)
IMG_SIZE = IMG_WIDTH * IMG_HEIGHT

BLOCK_SIZE = 8
BLOCK_AREA = BLOCK_SIZE ** 2
BLOCK_AMT = IMG_WIDTH * IMG_HEIGHT // BLOCK_AREA

# Individual pixels are stored within 8x8 blocks in memory
# Blocks are ordered sequentially, from left to right and top to bottom
# For instance: pixel (7, 0) is at offset 7, (8, 0) is at 64, (0, 8) is at 1536

def encode_gif(in_file: str, out_file: str):
    def map_coords(x: int, y: int) -> int:
        offset_y = (y // BLOCK_SIZE) * BLOCK_AREA * (IMG_WIDTH // BLOCK_SIZE)
        offset_x = (x // BLOCK_SIZE) * BLOCK_AREA

        extra_y = y % BLOCK_SIZE * BLOCK_SIZE
        extra_x = x % BLOCK_SIZE

        return (offset_x + offset_y) + (extra_y + extra_x)

    with Image.open(in_file) as gif, open(out_file, "wb+") as raw:
        data = bytearray(6 + gif.n_frames * IMG_SIZE)

        data[:2]    = IMG_WIDTH.to_bytes(length=2, byteorder="little")
        data[2:4]   = IMG_HEIGHT.to_bytes(length=2, byteorder="little")
        data[4:6]   = gif.n_frames.to_bytes(length=2, byteorder="little")

        offset = 4 + 2
        for frame in ImageSequence.Iterator(gif):
            pixels = frame.load()
            for y in range(IMG_HEIGHT):
                for x in range(IMG_WIDTH):
                    # Pixel mappings:
                    #   255 -> 7
                    #   0   -> 0
                    data[offset + map_coords(x, y)] = 7 if pixels[x, y] == 255 else 0

            offset += IMG_SIZE

        raw.write(data)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} input_file")
        sys.exit(1)
    encode_gif(sys.argv[1], OUT_FILE)
