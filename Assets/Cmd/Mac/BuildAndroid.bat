#!/bin/bash
#parameter 1 as version number, if null, it will use default num 0.0.1
#please set unityProjectPath and logFilePath before using

echo "[U3D_BUILD_MAC]Begin command line building..."
@echo off

unityProjectPath=balabala

logFilePath=balabala

#-debug or -release
debugMode="-release"

@echo on

/Applications/Unity/Unity.app/Contents/MacOS/Unity -batchmode -quit -projectPath $unityProjectPath -executeMethod LPCTools.BulidAndroid $debugMode -logFile $logFilePath $1
echo "[U3D_BUILD_MAC]Finish command line building..."