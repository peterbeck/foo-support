; makegitso.nsi
; ----------------
; Package Gitso for Windows using NSIS
; 
; Copyright 2008 - 2010: Aaron Gerber and Derek Buranen
; 
; Gitso is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; Gitso is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with Gitso.  If not, see <http://www.gnu.org/licenses/>.
;--------------------------------

!define VERSION "0.6" 
Name "foo.li support ${VERSION}"
Icon "./foocube.ico"
UninstallIcon "./foocube.ico"
OutFile "foo.li-support-install.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Gitso
; Registry key to check for directory (so if you install again, it will overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Gitso" "Install_Dir"

;--------------------------------
; Version Information
  VIProductVersion "0.6.0.0"
  VIAddVersionKey "ProductName" "foo.li Fernwartung - Gitso"
  VIAddVersionKey "Comments" "Gitso is to support others"
  VIAddVersionKey "CompanyName" "http://code.google.com/p/gitso"
  VIAddVersionKey "LegalCopyright" "GPL 3"
  VIAddVersionKey "FileDescription" "Gitso"
  VIAddVersionKey "FileVersion" "${VERSION}"
;--------------------------------

;--------------------------------
; Pages
;Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles
;--------------------------------

Section "Gitso"
  SectionIn RO
  SetOutPath $INSTDIR
	  ; Write the installation path into the registry
	  ; Write the uninstall keys for Windows
	  WriteRegStr HKLM SOFTWARE\Gitso "Install_Dir" "$INSTDIR"  
	  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gitso" "DisplayName" "foo.li support"
	  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gitso" "UninstallString" '"$INSTDIR\uninstall.exe"'
	  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gitso" "NoModify" 1
	  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gitso" "NoRepair" 1
	  WriteUninstaller "uninstall.exe"
  File ".\hosts.txt"
  File ".\icon.ico"
  File ".\foocube.ico"
  File ".\icon.png"
  File ".\COPYING"
  File ".\dist\Gitso.exe"
  File ".\dist\icon.ico"
  File ".\dist\library.zip"
  File ".\dist\msvcp71.dll"
  File ".\dist\MSVCR71.dll"
  File ".\dist\python25.dll"
  File ".\dist\pywintypes25.dll"
  File ".\dist\bz2.pyd"
  File ".\dist\win32api.pyd"
  File ".\dist\_ssl.pyd"
  File ".\dist\_socket.pyd"
  File ".\dist\select.pyd"
  File ".\dist\unicodedata.pyd"
  File ".\dist\w9xpopen.exe"
  File ".\dist\wx._controls_.pyd"
  File ".\dist\wx._core_.pyd"
  File ".\dist\wx._gdi_.pyd"
  File ".\dist\wx._misc_.pyd"
  File ".\dist\wx._windows_.pyd"
  File ".\dist\wxbase28uh_net_vc.dll"
  File ".\dist\wxbase28uh_vc.dll"
  File ".\dist\wxmsw28uh_adv_vc.dll"
  File ".\dist\wxmsw28uh_core_vc.dll"
  File ".\dist\wxmsw28uh_html_vc.dll"
  File ".\arch\win32\tightVNC_LICENCE.txt"
  File ".\arch\win32\tightVNC_COPYING.txt"
  File ".\arch\win32\tightVNC_README.txt"
  File ".\arch\win32\VNCHooks_COPYING.txt"
  File ".\arch\win32\msvcr71_README.txt"
 ; englisches Netstat, weil xp deutsch sonst zickt...
  File ".\dist\netstat.cmd"
  File ".\dist\sed.exe"
 ;start menu items
 ; sinnloser folder, wollen wir nicht
 ;CreateDirectory "$SMPROGRAMS\Gitso"
  CreateShortCut "$SMPROGRAMS\foo.li support.lnk" "$INSTDIR\Gitso.exe" "--connect gitso.foo.li" "$INSTDIR\foocube.ico" 0
 ; -------------- Gitso default TightVNC 1.3 ---------------------
 ;File ".\arch\win32\vncviewer.exe"
 ;File ".\arch\win32\WinVNC.exe"
 ;File ".\arch\win32\VNCHooks.dll"
 ; --------------------- TightVNC 2.7 ----------------------------
 ;VNCHooks ist tightvnc 1.3, neu ist's screenhooks...
 ;ACHTUNG: tightvnc2.7: code in process.py anpassen
 File ".\arch\win32\tightvnc2\screenhooks32.dll"
 File ".\arch\win32\tightvnc2\vncviewer.exe"
 File ".\arch\win32\tightvnc2\WinVNC.exe"
 ; --------------------- UltraVNC --------------------------------
 ;separate vnchooks.dll, zusaetzlich ultravnc.ini
 ;der server/viewer haben bereits die korrekte benennung
 ;File ".\arch\win32\ultravnc\UltraVNC.ini"
 ;File ".\arch\win32\ultravnc\vncviewer.exe"
 ;File ".\arch\win32\ultravnc\WinVNC.exe"

 ;Registry tweaks to TightVNC's server
  WriteRegDWORD HKCU "Software\ORL\WinVNC3" "RemoveWallpaper" 1
  WriteRegDWORD HKCU "Software\ORL\WinVNC3" "EnableFileTransfers" 1
 ;set default password to something so WinVNC.exe doesn't complain about having no password
  WriteRegBin HKCU "SOFTWARE\ORL\WinVNC3" "Password" "238f16962aeb734e"
  WriteRegBin HKCU "SOFTWARE\ORL\WinVNC3" "PasswordViewOnly" "238f16962aeb734e"
 ;Try to set it for all users, but I'm not positive this works
  WriteRegDWORD HKLM "Software\ORL\WinVNC3" "RemoveWallpaper" 1
  WriteRegDWORD HKLM "Software\ORL\WinVNC3" "EnableFileTransfers" 1
  WriteRegBin HKLM "SOFTWARE\ORL\WinVNC3" "Password" "238f16962aeb734e"
  WriteRegBin HKLM "SOFTWARE\ORL\WinVNC3" "PasswordViewOnly" "b0f0ac1997133bc9"
SectionEnd


; Uninstall
;------------------------------------------------------
Section "Uninstall"
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gitso"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gitso"
  ; Remove files and uninstaller
  Delete $INSTDIR\vncviewer.exe
  Delete $INSTDIR\VNCHooks.dll
  Delete $INSTDIR\WinVNC.exe
  ; Remove shortcuts and folder
;  RMDir /r "$SMPROGRAMS\Gitso"
  delete "$SMPROGRAMS\foo.li support.lnk"
  RMDir /r $INSTDIR
SectionEnd
