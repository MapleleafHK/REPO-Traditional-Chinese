@echo off
chcp 65001 >nul
title R.E.P.O. 繁中翻譯自動安裝工具

echo ===================================================
echo        R.E.P.O. 繁體中文（香港）自動安裝工具
echo ===================================================
echo.

:: 偵測 Steam 註冊表以獲取預設安裝路徑
set "STEAM_REG="
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v "SteamPath" 2^>nul') do set "STEAM_REG=%%B"

if "%STEAM_REG%"=="" (
    echo [錯誤] 找不到 Steam 安裝紀錄。
    goto P_PAUSE
)

:: 設定預設遊戲路徑
set "STEAM_PATH=%STEAM_REG:/=\%"
set "GAME_PATH=%STEAM_PATH%\steamapps\common\R.E.P.O."
set "TARGET_DIR=%GAME_PATH%\REPO_Data\StreamingAssets\Localization"

:: 檢查遊戲資料夾是否存在
if not exist "%GAME_PATH%" (
    echo [提示] 在預設 Steam 庫中找不到遊戲。
    echo [提示] 請手動輸入或貼上你的 R.E.P.O. 遊戲根目錄路徑：
    set /p GAME_PATH="請輸入路徑: "
    set "TARGET_DIR=%GAME_PATH%\REPO_Data\StreamingAssets\Localization"
)

:: 驗證目標 Localization 資料夾
if not exist "%TARGET_DIR%" (
    echo [錯誤] 找不到有效的遊戲 Localization 資料夾。
    goto P_PAUSE
)

:: 檢查當前資料夾是否有 .tsv 檔案
dir *.tsv >nul 2>&1
if %errorlevel% equ 0 (
    goto COPY_FILES
)

:: 若無 .tsv，嘗試尋找並解壓 .zip 檔案
if exist "REPO-zhHK-v1.2.1 -AutoInstall.zip" (
    echo [執行] 正在解壓縮 REPO-zhHK-v1.2.1 -AutoInstall.zip ...
    powershell -Command "Expand-Archive -Path 'REPO-zhHK-v1.2.1 -AutoInstall.zip' -DestinationPath '.' -Force"
    goto COPY_FILES
) else (
    echo [錯誤] 找不到 .tsv 檔案或 REPO-zhHK-v1.2.1 -AutoInstall.zip。
    goto P_PAUSE
)

:COPY_FILES
echo [執行] 正在覆蓋安裝繁體中文檔案...
copy /y *.tsv "%TARGET_DIR%\" >nul

if %errorlevel% equ 0 (
    echo.
    echo ===================================================
    echo [成功] 繁體中文（香港）翻譯檔已直接覆蓋完成！
    echo ===================================================
) else (
    echo [錯誤] 檔案複製失敗，請嘗試以「系統管理員身分」執行。
)

:P_PAUSE
echo.
pause
