#!/usr/bin/python3


mpcPrefix= "mpc -h mopidy@192.168.50.221 "

# mpc -h mopidy@localhost repeat on
# mpc -h mopidy@localhost stop
# mpc -h mopidy@localhost add "file:///path/to/music.mp3"
# mpc -h mopidy@localhost clear
# mpc -h mopidy@localhost play

import pathlib
import os
import glob
import subprocess

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


#files = glob.glob("/path/to/music/*mp3")
files = readm3u("/path/to/music/playlist..m3u")

subprocess.call(mpcPrefix+"repeat on", shell=True)
subprocess.call(mpcPrefix+"stop", shell=True)
subprocess.call(mpcPrefix+"clear", shell=True)

for file in files:
  absFile=os.path.abspath(file)
  uri=pathlib.Path(absFile).as_uri()
  subprocess.call(mpcPrefix+"add "+uri, shell=True)

subprocess.call(mpcPrefix+"play", shell=True)
