#! /bin/sh

set -e

BASE_URL=http://netstorage.unity3d.com/unity
HASH=2860b30f0b54
VERSION=5.6.1f1

download() {
 file=$1
 url="$BASE_URL/$HASH/$package"

 echo "Downloading from $url: "
 cd Unity
 curl -o `basename "$package"` "$url"
 cd ../
}

install() {
 package=$1
 filename=`basename "$package"`
 packagePath="Unity/$filename"
 if [ ! -f $packagePath ] ; then
   echo "$packagePath not found. downloading `basename "$packagePath"`"
   download "$package"
 fi

 echo "Installing "`basename "$package"`
 sudo installer -dumplog -package $packagePath -target /
}

if [ ! -d "Unity" ] ; then
 mkdir -p -m 777 Unity
fi

install "MacEditorInstaller/Unity-$VERSION.pkg"
# install "MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-$VERSION.pkg"
