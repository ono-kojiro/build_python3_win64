@ECHO OFF

@SETLOCAL ENABLEDELAYEDEXPANSION

SET NAME=Python
SET VERSION=3.7.5

REM Initialie environment variable "PATH"
SET PATH=%SystemRoot%\System32

REM Change path of PortableGit
SET GIT_ROOT=C:\opt\PortableGit-2.23.0-64-bit
SET PATH=%GIT_ROOT%\usr\bin;%PATH%
SET PATH=%GIT_ROOT%\mingw64\bin;%PATH%
SET PATH=%GIT_ROOT%\bin;%PATH%

CALL "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

REM =============================================================

FOR /F "tokens=* USEBACKQ" %%F IN (`cd`) DO SET TOP_DIR=%%F

SET INSTALL_DIR=!TOP_DIR!\Python-%VERSION%-amd64-bin

SET ARCHIVE=Python-%VERSION%.tar.xz

IF NOT EXIST %ARCHIVE% (
	curl -o %ARCHIVE% https://www.python.org/ftp/python/%VERSION%/%ARCHIVE%
) ELSE (
	ECHO %ARCHIVE% exists. skip download.
)

IF NOT EXIST %NAME%-%VERSION% (
	ECHO extract source code
	tar xJf %ARCHIVE%
) ELSE (
	ECHO directory %NAME%-%VERSION% exists. skip extract.
)

PUSHD %NAME%-%VERSION%\PCbuild
IF NOT EXIST amd64\python.exe (
	ECHO build python.exe
	CALL build.bat -e -k -v -p x64
) ELSE (
	ECHO python.exe exists. skip build.
)
POPD

IF EXIST !INSTALL_DIR! ( RMDIR /Q /S !INSTALL_DIR! )

MD !INSTALL_DIR!
XCOPY /Y /E /Q %NAME%-%VERSION%\Lib !INSTALL_DIR!\Lib\

XCOPY /Y /Q %NAME%-%VERSION%\PCbuild\amd64\*.pyd !INSTALL_DIR!\DLLs\
XCOPY /Y /Q %NAME%-%VERSION%\PCbuild\amd64\*.dll !INSTALL_DIR!\DLLs\

MOVE /Y !INSTALL_DIR!\DLLs\python3*.dll !INSTALL_DIR!\
XCOPY /Y /Q %NAME%-%VERSION%\PCbuild\amd64\python*.exe !INSTALL_DIR!\

XCOPY /Y /E /Q %NAME%-%VERSION%\Include !INSTALL_DIR!\include\

XCOPY /Y /Q %NAME%-%VERSION%\PCbuild\amd64\*.lib !INSTALL_DIR!\libs\

COPY /Y python-%VERSION%-amd64.bat !INSTALL_DIR!\

curl -o !INSTALL_DIR!\get-pip.py https://bootstrap.pypa.io/get-pip.py

PUSHD !INSTALL_DIR!
CALL python-%VERSION%-amd64.bat
@ECHO OFF
python get-pip.py

REM install your favorite package here!

POPD

tar cJf python-%VERSION%-amd64-bin.tar.xz python-%VERSION%-amd64-bin

ENDLOCAL

@ECHO ON
