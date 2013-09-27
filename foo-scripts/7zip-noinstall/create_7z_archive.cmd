@echo off
echo creating 7Zip archive of gitso folder
echo.
"%PROGRAMFILES%\7-Zip\7z.exe" a C:\temp\foo-support.7z "%PROGRAMFILES%\Gitso\*.*"
echo starting 7Zip SFX Maker
echo.
::echo don't forget to add your icon to \resources
echo don't forget to load the correct settings.xml
copy /y ..\..\foocube.ico "%PROGRAMFILES%\7-Zip SFX Maker\resources"
copy /y foo-support_sfxmaler.xml "%PROGRAMFILES%\7-Zip SFX Maker\Config"
echo.
"%PROGRAMFILES%\7-Zip SFX Maker\7-ZIP SFX Maker.exe" C:\temp\foo-support.7z 
