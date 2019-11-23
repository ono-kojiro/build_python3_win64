@ECHO OFF

CD /D %~dp0

FOR /F "tokens=* USEBACKQ" %%F IN (`cd`) DO SET TOP_DIR=%%F


SET PYTHONHOME=%TOP_DIR%
SET PYTHONPATH=%TOP_DIR%\Lib;%TOP_DIR%\Lib\site-packages

SET PATH=%TOP_DIR%;%TOP_DIR%\Scripts;%PATH%

@ECHO ON
