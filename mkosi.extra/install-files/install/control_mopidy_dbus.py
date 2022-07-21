#!/usr/bin/python3

# /usr/bin/busctl --user introspect org.mpris.MediaPlayer2.mopidy /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player
# /usr/bin/busctl --user call org.mpris.MediaPlayer2.mopidy /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Stop
# /usr/bin/busctl --user call org.mpris.MediaPlayer2.mopidy /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player OpenUri s "file:///path/to/music.mp3"
# /usr/bin/busctl --user call org.mpris.MediaPlayer2.mopidy /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Play


import pathlib
import os
import glob
from pydbus import SessionBus
from gi.repository import GLib

def readm3u(m3ufilepath):
  basedir=os.path.dirname(m3ufilepath)
  m3ufile = open(m3ufilepath,'r')
  firstLine=m3ufile.readline()
  playlist = []
  for entry in m3ufile:
    entry=entry.strip()
    if entry.startswith('#EXTM3U'):
      pass
    elif entry.startswith('#EXTINF:'):
      pass
    elif (len(entry) != 0):
      if os.path.isabs(entry):
        playlist.append(entry)
      else:
        newpath=os.path.join(basedir,entry)
        playlist.append(newpath)
  m3ufile.close()
  return playlist


bus = SessionBus()
mopidy = bus.get("org.mpris.MediaPlayer2.mopidy","/org/mpris/MediaPlayer2")

#files = glob.glob("/path/to/music/*mp3")
files = readm3u("/path/to/music/playlist..m3u")

for file in files:
  absFile=os.path.abspath(file)
  uri=pathlib.Path(absFile).as_uri()
  uriAsVariant=GLib.Variant("s",uri)
  mopidy.OpenUri(uriAsVariant)

