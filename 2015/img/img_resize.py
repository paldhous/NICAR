# import libraries
import glob, os
from PIL import Image

# set max X and Y sizes in px
size = 750, 750

# resize images
for infile in glob.glob("*.jpg"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(file + ".jpg", "JPEG", quality = 100)
    print "processing " + file

print "DONE!"


