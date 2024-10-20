import os
import glob
import epub

dirName = "ebooks" #the folder containing your epub files, should be in the
                  #directory which contains the script.
                  
for File in glob.glob(dirName + "\\*.epub"):
    with epub.open_epub(File) as book:
        title = book.opf.metadata.titles[0][0]

    os.rename(File, dirName + "\\" + title + ".epub")
