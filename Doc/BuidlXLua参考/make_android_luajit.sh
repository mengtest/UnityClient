export ANDROID_NDK=/root/client_build/build/android-ndk-r10e
#export ANDROID_NDK=/cygdrive/e/ProjectTrunk/U3D/xLua/xLua-master/build/android-ndk-r10e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRCDIR=$DIR/luajit-2.1.0b2
#NDK=/cygdrive/e/ProjectTrunk/U3D/xLua/xLua-master/build/android-ndk-r10e
NDK=/root/client_build/build/android-ndk-r10e

echo "Building armv7 lib"
NDKVER=$NDK/toolchains/arm-linux-androideabi-4.9  
NDKP=$NDKVER/prebuilt/linux-x86_64/bin/arm-linux-androideabi-  
NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"  
NDKABI=14 
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"
cd "$SRCDIR"
make clean
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF $NDKARCH"

cd "$DIR"
mkdir -p build_lj_v7a && cd build_lj_v7a
cmake -DUSING_LUAJIT=ON -DANDROID_ABI=armeabi-v7a -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-4.9 -DANDROID_NATIVE_API_LEVEL=android-9 ../
cd "$DIR"
cmake --build build_lj_v7a --config Release
mkdir -p plugin_luajit/Plugins/Android/libs/armeabi-v7a/
cp build_lj_v7a/libxlua.so plugin_luajit/Plugins/Android/libs/armeabi-v7a/libxlua.so


echo "Building x86 lib"
NDKVER=$NDK/toolchains/x86-4.9  
NDKP=$NDKVER/prebuilt/linux-x86_64/bin/i686-linux-android-  
NDKABI=14  
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-x86"  
cd "$SRCDIR"
make clean
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF"

cd "$DIR"
mkdir -p build_lj_x86 && cd build_lj_x86
cmake -DUSING_LUAJIT=ON -DANDROID_ABI=x86 -DCMAKE_TOOLCHAIN_FILE=../cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN_NAME=x86-4.9 -DANDROID_NATIVE_API_LEVEL=android-9 ../
cd "$DIR"
cmake --build build_lj_x86 --config Release
mkdir -p plugin_luajit/Plugins/Android/libs/x86/
cp build_lj_x86/libxlua.so plugin_luajit/Plugins/Android/libs/x86/libxlua.so


