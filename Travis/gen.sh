#!/bin/bash

/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -projectPath $(pwd) \
  -logFile \
  -executeMethod LPCTools.PreExportAndroid \
  -quit
