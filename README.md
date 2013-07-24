PicViewer
=========

PicViewer is a small application used to browse through and display graphic files under any Windows operating system.  
There are many paint programs that can accomplish this; in fact, even Windows itself now has a thumbnail view in its 
Explorer.  So why the need for this program?

It was created originally as a slide-show type application to display a directory full of scanned or digital photgraphs, 
and work well on an under-powered laptop that did not have enough CPU or RAM to run Microsoft PowerPoint effectively.  
Eventually, other benefits became obvious: it is small, loads quickly, and is geared for easily navigating various 
directories filled with graphic files.  With a few extra features and command-line arguements added, it has become a 
tool I use often.  And one I have not found elsewhere.

PicViewer is written in Delphi 6 using only standard components and one open source graphics library, 
GraphicEx (http://www.delphi-gems.com/Graphics.php).

It was originally posted to SourceForge in 2005: http://sourceforge.net/projects/picviewer.

Command Line Parameters
=======================

Possible command-line parameters include:

-maximize
This maximizes the application''s window to the full height and width of your screen.

-fullscreen
This hides the toolbar buttons, drive, directory, and file list and sets a black background. Also, the scroll bars and mouse pointer are hidden. The shortcut is F12.

-fitinwin
This scales the pictures to the size of the viewable area. The shortcut is F11.

-movie
This starts stepping through the pictures, loading the next one every 7 seconds.  At the end of the list, it starts over at the beginning.  Any key except F5 (the shortcut) leaves movie mode.

-directory=<Path>
This starts the application in the specified directory.  If the directory has spaces in it, enclose it in quotes.


Update
======

While this code has not been worked on for several years, I have confirmed it compiles in Delphi 2010.

David Cornelius, July, 2013
