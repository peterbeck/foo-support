# 26.9.2013 icon.ico auf foocube.ico geaendert, description, uac_info ergaenzt
# doch nicht, bringt nix... ('uac_info': "requireAdministrator",)

import glob
from distutils.core import setup
import py2exe
DATA_FILES = []
OPTIONS = {'argv_emulation': True}

setup(
  version = "0.6.0",
  description = "foo.li support - Gitso is to support Others",
  name="Gitso",
  
  windows=[{"script":"Gitso.py", "icon_resources":[(1,"foocube.ico")]}],
  data_files=[(".", ["foocube.ico"])],
  py_modules = ['AboutWindow', 'ConnectionWindow', 'ArgsParser', 'GitsoThread', 'Processes', 'NATPMP'],
)
