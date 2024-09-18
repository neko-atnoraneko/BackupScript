@echo off
setlocal

:: バッチファイルが置かれているディレクトリに移動
cd /d "%~dp0"

:: Pythonの最新版のURLを取得する
echo Fetching the latest Python version...
for /f "tokens=*" %%i in ('powershell -Command "(Invoke-WebRequest -Uri 'https://www.python.org/downloads/windows/').Content -match 'https://www.python.org/ftp/python/[\d\.]+/python-[\d\.]+-amd64.exe' | Out-Null; $matches[0]"') do set "installer_url=%%i"

if not defined installer_url (
    echo Failed to retrieve the latest Python version.
    pause
    exit /b 1
)

:: インストーラファイル名を抽出
for /f "tokens=*" %%i in ('powershell -Command "$url='%installer_url%'; $url.Substring($url.LastIndexOf('/')+1)"') do set "installer=%%i"

echo Latest Python installer URL: %installer_url%
echo Installer file: %installer%

:: Pythonインストーラをダウンロード
if not exist "%installer%" (
    echo Downloading Python installer...
    powershell -Command "Invoke-WebRequest -Uri '%installer_url%' -OutFile '%installer%'"
    if %errorlevel% neq 0 (
        echo Failed to download Python installer.
        pause
        exit /b 1
    )
    echo Python installer downloaded successfully.
)

:: インストール先ディレクトリを設定
set "install_dir=%USERPROFILE%\AppData\Local\Programs\Python\PythonLatest"
set "python_scripts_dir=%install_dir%\Scripts"

:: Pythonをインストール
echo Installing Python...
start /wait "" "%installer%" /passive InstallAllUsers=1 PrependPath=1 TargetDir="%install_dir%" /log "python_install.log"
if not exist "%install_dir%\python.exe" (
    echo Python installation failed.
    type "python_install.log"
    pause
    exit /b 1
)
echo Python installation complete.

:: PATH環境変数を更新
echo Updating PATH...
set "new_path=%python_scripts_dir%;%install_dir%;%PATH%"
setx PATH "%new_path%" /M

:: pipのアップグレード
echo Upgrading pip...
"%install_dir%\python.exe" -m pip install --upgrade pip

:: requirements.txtがある場合、ライブラリをインストール
if exist "requirements.txt" (
    echo Installing Python libraries...
    "%install_dir%\python.exe" -m pip install -r requirements.txt
    if %errorlevel% neq 0 (
        echo Failed to install Python libraries.
        pause
        exit /b 1
    )
    echo Python libraries installed successfully.
) else (
    echo requirements.txt not found.
)

:: 完了メッセージ
echo Setup complete. Press any key to exit.
pause

endlocal
