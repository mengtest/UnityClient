#!/bin/bash

/Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode -nographics -projectPath $(PWD) -logFile -editorTestsResultFile $(PWD)/unity_test.log -runEditorTests
#cat $(PWD)/unity_test.log
