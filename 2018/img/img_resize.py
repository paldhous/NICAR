# import libraries
import glob, os
from PIL import Image

# set max X and Y sizes in px
size = 750, 750

# resize jpgs
for infile in glob.glob("*.jpg"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(file + ".jpg", "JPEG", quality = 100)
    print "processing " + file

# resize pngs
for infile in glob.glob("*.png"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(file + ".png", "png", quality = 100)
    print "processing " + file

print "DONE!"


