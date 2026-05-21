@echo off
chcp 65001 >nul
title R.E.P.O. 繁中翻譯自動安裝工具

echo ===================================================
echo        R.E.P.O. 繁體中文（香港）自動安裝工具
echo ===================================================
echo.

set "STEAM_REG="
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v "SteamPath" 2^>nul') do set "STEAM_REG=%%B"

if "%STEAM_REG%"=="" (
    echo [錯誤] 找不到 Steam 安裝路徑。
    goto P_PAUSE
)

set "STEAM_PATH=%STEAM_REG:/=\%"
set "TARGET_DIR=%STEAM_PATH%\steamapps\common\R.E.P.O.\REPO_Data\StreamingAssets\Localization"

if not exist "%TARGET_DIR%" (
    echo [錯誤] 找不到 R.E.P.O. 遊戲資料夾，請確認遊戲已下載。
    goto P_PAUSE
)

echo [執行] 正在安裝繁體中文翻譯檔...
copy /y *.tsv "%TARGET_DIR%\" >nul

if %errorlevel% equ 0 (
    echo [成功] 繁體中文（香港）翻譯檔已安裝完成！
) else (
    echo [錯誤] 複製失敗，請嘗試按右鍵選擇「以系統管理員身分執行」。
)

:P_PAUSE
echo.
pause
