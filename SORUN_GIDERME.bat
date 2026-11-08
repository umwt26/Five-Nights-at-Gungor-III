@echo off
setlocal

echo ==== GUNGOR NETLIFY KONTROL ====
echo Oyun klasoru: %~dp0
if exist "%~dp0index.html" (echo index.html: OK) else (echo index.html: EKSIK - ZIP i cikart)
echo.
echo Node:
where node.exe
node --version
echo.
echo Npm:
where npm.cmd
call npm.cmd --version
echo.
echo Netlify:
where netlify.cmd
if not errorlevel 1 call netlify.cmd --version
echo.
echo SORUN varsa pencerenin ekran goruntusunu gonderebilirsin.
pause
