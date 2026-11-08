@echo off
setlocal EnableExtensions DisableDelayedExpansion
title Five Nights at Gungor - Netlify Auto Deploy

echo.
echo ============================================
echo  FIVE NIGHTS AT GUNGOR - NETLIFY DEPLOY
echo ============================================
echo.

echo [1/5] Oyun klasoru kontrol ediliyor...
if not exist "%~dp0index.html" (
  echo.
  echo HATA: index.html bulunamadi!
  echo ZIP dosyasini once tamamen bir klasore cikart.
  echo BAT dosyasini ZIP onizlemesinden calistirma.
  goto :error
)
pushd "%~dp0"
if errorlevel 1 (
  echo HATA: Oyun klasorune girilemiyor.
  echo Lutfen dosyalari Masaustu gibi kisa bir yola cikartip dene.
  goto :error
)

echo Klasor: %CD%
echo.
echo [2/5] Node.js ve npm kontrol ediliyor...
where node.exe >nul 2>&1
if errorlevel 1 (
  echo HATA: Node.js bulunamadi.
  echo https://nodejs.org/en/download adresinden LTS surumunu yukle.
  echo Ardindan CMD penceresini yeniden acip tekrar dene.
  goto :error_in_dir
)
where npm.cmd >nul 2>&1
if errorlevel 1 (
  echo HATA: npm bulunamadi. Node.js kurulumunu onar.
  goto :error_in_dir
)
call node.exe --version
if errorlevel 1 goto :npm_error
call npm.cmd --version
if errorlevel 1 goto :npm_error

echo.
echo [3/5] Netlify CLI kontrol ediliyor...
set "NETLIFY_CLI="
for /f "delims=" %%V in ('where netlify.cmd 2^>nul') do if not defined NETLIFY_CLI set "NETLIFY_CLI=%%V"
if not defined NETLIFY_CLI (
  echo Netlify CLI yuklu degil. npm ile kuruluyor...
  echo Internet hizina gore surebilir; kurulum ciktilari burada gorunecek.
  call npm.cmd install --global netlify-cli@latest --no-audit --no-fund --loglevel info
  if errorlevel 1 (
    echo.
    echo HATA: Netlify CLI kurulumu basarisiz oldu.
    echo npm baglanti ya da izin hatasini yukaridan kontrol et.
    goto :error_in_dir
  )
  for /f "delims=" %%V in ('where netlify.cmd 2^>nul') do if not defined NETLIFY_CLI set "NETLIFY_CLI=%%V"
)
if not defined NETLIFY_CLI if exist "%APPDATA%\npm\netlify.cmd" set "NETLIFY_CLI=%APPDATA%\npm\netlify.cmd"
if not defined NETLIFY_CLI (
  echo HATA: Netlify CLI kuruldu fakat netlify.cmd PATH icinde bulunamadi.
  echo CMD'yi kapatip yeniden acarak tekrar dene.
  goto :error_in_dir
)
call "%NETLIFY_CLI%" --version
if errorlevel 1 (
  echo HATA: Netlify CLI baslatilamadi.
  goto :error_in_dir
)

echo.
echo [4/5] Netlify girisi kontrol ediliyor...
call "%NETLIFY_CLI%" status >nul 2>&1
if errorlevel 1 (
  echo Netlify hesabina giris yapman gerekiyor.
  echo Tarayici acilirsa girisi tamamla, sonra terminale don.
  call "%NETLIFY_CLI%" login
  if errorlevel 1 (
    echo HATA: Netlify girisi basarisiz oldu.
    goto :error_in_dir
  )
)

echo.
echo [5/5] Site Netlify'a yayinlaniyor...
echo Ilk kurulumda "Create & configure a new project" secebilirsin.
echo.
call "%NETLIFY_CLI%" deploy --prod --dir "."
if errorlevel 1 (
  echo.
  echo HATA: Deploy basarisiz oldu. Yukaridaki Netlify hatasina bak.
  goto :error_in_dir
)
echo.
echo ============================================
echo  BASARILI! Netlify adresin ustte yaziyor.
echo ============================================
echo.
popd
pause
exit /b 0

:npm_error
echo HATA: Node/npm calistirilamadi. Node.js'i yeniden kur.
goto :error_in_dir

:error_in_dir
popd
:error
echo.
echo Yukaridaki hata satirlarini bana gonderebilirsin.
echo.
pause
exit /b 1
