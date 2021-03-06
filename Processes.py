#! /usr/bin/env python

"""
Gisto - Gitso is to support others

Gitso is a utility to facilitate the connection of VNC

@author: Aaron Gerber ('gerberad') <gerberad@gmail.com>
@author: Derek Buranen ('burner') <derek@buranen.info>
@copyright: 2008 - 2010

Gitso is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Gitso is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Gitso.  If not, see <http://www.gnu.org/licenses/>.
"""

import wx
import os, sys, signal, os.path, re

class Processes:
	def __init__(self, window, paths):
		self.returnPID = 0
		self.window = window
		self.paths = paths

	def getSupport(self, host):
		if sys.platform == 'darwin':
			self.returnPID = os.spawnl(os.P_NOWAIT, '%sOSXvnc/OSXvnc-server' % self.paths['resources'], '%sOSXvnc/OSXvnc-server' % self.paths['resources'], '-connectHost', '%s' % host)
		elif re.match('(?:open|free|net)bsd|linux',sys.platform):
			# We should include future versions with options for speed.
			#self.returnPID = os.spawnlp(os.P_NOWAIT, 'x11vnc', 'x11vnc','-nopw','-ncache','20','-solid','black','-connect','%s' % host)
			
			self.returnPID = os.spawnlp(os.P_NOWAIT, 'x11vnc', 'x11vnc','-nopw','-ncache','20','-connect','%s' % host)
			
			# Added for OpenBSD compatibility
			import time
			time.sleep(3)
		elif sys.platform == 'win32':
			#disable uac messages while connected - run as administrator on Windows 7
			import platform
			wver = platform.version()
			if wver > '5.2':
				import _winreg
				try:
					x = _winreg.ConnectRegistry(None, _winreg.HKEY_LOCAL_MACHINE)
					y = _winreg.OpenKey(x, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", 0, _winreg.KEY_ALL_ACCESS)
					_winreg.SetValueEx(y, "ConsentPromptBehaviorAdmin", 0, _winreg.REG_DWORD, 0)
					_winreg.CloseKey(y)
					_winreg.CloseKey(x)
				except:
					print 'error - not running as admin ?'
			#return
			 
			import subprocess
			self.returnPID = subprocess.Popen(['WinVNC.exe', '-run'])
			print "Launched WinVNC.exe, waiting to run -connect command..."
			import time
			#timeout von 3 auf 5 hochgesetzt, scheint besser zu klappen mit 2.7
			time.sleep(5)

			#tightvnc 2.7 (umbenannt) integriert, da besseres handling mit win7	/ UAC
			#controlapp-parameter ergaenzt
			if self.paths['mode'] == 'dev':
				subprocess.Popen(['%sWinVNC.exe' % self.paths['resources'], '-controlapp', '-connect', '%s' % host])
			else:
				subprocess.Popen(['WinVNC.exe', '-controlapp', '-connect', '%s' % host])
			#ultravnc wie tightvnc 1.3
			#if self.paths['mode'] == 'dev':
			#	subprocess.Popen(['%sWinVNC.exe' % self.paths['resources'], '-connect', '%s' % host])
			#else:
			#	subprocess.Popen(['WinVNC.exe', '-connect', '%s' % host])
		else:
			print 'Platform not detected'
		return self.returnPID
	
	def giveSupport(self):
		if sys.platform == 'darwin':
			vncviewer = '%scotvnc.app/Contents/MacOS/cotvnc' % self.paths['resources']
			self.returnPID = os.spawnlp(os.P_NOWAIT, vncviewer, vncviewer, '--listen')
		elif re.match('(?:open|free|net)bsd|linux',sys.platform):
			
			# These are the options for low-res connections.
			# In the future, I'd like to support cross-platform low-res options.
			# What aboot a checkbox in the gui
			if self.paths['low-colors'] == False:
				self.returnPID = os.spawnlp(os.P_NOWAIT, 'vncviewer', 'vncviewer', '-listen')
			else:
				self.returnPID = os.spawnlp(os.P_NOWAIT, 'vncviewer', 'vncviewer', '-bgr233', '-listen')
		elif sys.platform == 'win32':
			import subprocess
			if self.paths['mode'] == 'dev':
				self.returnPID = subprocess.Popen(['%svncviewer.exe' % self.paths['resources'], '-listen'])
			else:
				self.returnPID = subprocess.Popen(['vncviewer.exe', '-listen'])
		else:
			print 'Platform not detected'
		return self.returnPID

	def KillPID(self):
		"""
		Kill VNC instance, called by the Stop Button or Application ends.
		
		@author: Derek Buranen
		@author: Aaron Gerber
		"""
		if self.returnPID != 0:
			print "Processes.KillPID(" + str(self.returnPID) + ")"
			if sys.platform == 'win32':
				import platform
				wver = platform.version()
				if wver > '5.2':
					#re-enable UAC Messages on exit
					import _winreg
					try:
						x = _winreg.ConnectRegistry(None, _winreg.HKEY_LOCAL_MACHINE)
						y = _winreg.OpenKey(x, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", 0, _winreg.KEY_ALL_ACCESS)
						_winreg.SetValueEx(y, "ConsentPromptBehaviorAdmin", 0, _winreg.REG_DWORD, 2)
						_winreg.CloseKey(y)
						_winreg.CloseKey(x)
					except:
						print 'could not restore UAC dialog'
				#return
				

				import win32api
				PROCESS_TERMINATE = 1
				handle = win32api.OpenProcess(PROCESS_TERMINATE, False, self.returnPID.pid)
				win32api.TerminateProcess(handle, -1)
				win32api.CloseHandle(handle)
			elif re.match('(?:open|free|net)bsd|linux',sys.platform):
				# New processes are created when you made connections. So if you kill self.returnPID,
				# you're just killing the dispatch process, not the one actually doing business...
				os.spawnlp(os.P_NOWAIT, 'pkill', 'pkill', '-f', 'vncviewer')
				os.spawnlp(os.P_NOWAIT, 'pkill', 'pkill', '-f', 'x11vnc')
			else:
				os.kill(self.returnPID, signal.SIGKILL)
			self.returnPID = 0
		return

