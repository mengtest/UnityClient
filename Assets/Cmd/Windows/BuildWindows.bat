::parameter 1 as version number, if null, it will use default num 0.0.1
::please set unityExePath and unityProjectPath before using

echo "[U3D_BUILD_WINDOWS]Begin command line building..."
@echo off

set unityExePath="C:\program files\Unity\Editor\Unity.exe"

set unityProjectPath="E:\ProjectTrunk\LightPaw\Panda\male7client"

::-debug or -release
set debugMode = -release

@echo on

%unityExePath% -batchmode -quit -projectPath %unityProjectPath% -executeMethod LPCTools.BulidWindows %debugMode% -logFile %~dp0BuildWindows.log -versionNum %1

echo "[U3D_BUILD_WINDOWS]Finish command line building..."

pause