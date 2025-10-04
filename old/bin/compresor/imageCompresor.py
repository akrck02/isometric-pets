from PIL import Image
import os

img_path = "foxy.png"
img = Image.open(img_path)
img = img.convert("P", palette=Image.ADAPTIVE, colors=16)
img.save("compto16colors.png", optimize=True)