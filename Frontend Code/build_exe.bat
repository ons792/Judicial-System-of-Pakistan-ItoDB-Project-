@echo off
echo Installing requirements...
python -m pip install pyinstaller pyqt5

echo Building Executable...
python -m PyInstaller --noconsole --onefile --name="JudicialSystem" main_app.py

echo Build Complete. Check the 'dist' folder.
pause
