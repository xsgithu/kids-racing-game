#!/bin/bash

echo "儿童赛车游戏 - Android 构建脚本"
echo "=================================="

# 检查 Node.js 和 npm
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "错误: 请安装 Node.js 和 npm"
    exit 1
fi

# 检查 Java JDK
if ! command -v javac &> /dev/null; then
    echo "错误: 请安装 Java JDK 8 或更高版本"
    exit 1
fi

# 检查 Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "错误: 请设置 ANDROID_HOME 环境变量指向 Android SDK"
    exit 1
fi

# 安装依赖
echo "正在安装项目依赖..."
npm install

# 安装 Cordova CLI
echo "正在安装 Cordova CLI..."
npm install -g cordova

# 准备 Cordova 项目
echo "正在准备 Cordova 项目..."
cordova prepare android

# 构建 Android APK
echo "正在构建 Android APK..."
cordova build android --release

# 检查构建结果
if [ -f "platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk" ]; then
    echo "构建成功！"
    echo "APK 文件位置: platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
    echo ""
    echo "下一步操作："
    echo "1. 签名 APK 文件："
    echo "   keytool -genkey -v -keystore kidsracing.keystore -alias kidsracing -keyalg RSA -keysize 2048 -validity 10000"
    echo "   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore kidsracing.keystore platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk kidsracing"
    echo "   zipalign -v 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk kids_racing_game.apk"
    echo ""
    echo "2. 安装到设备："
    echo "   adb install kids_racing_game.apk"
else
    echo "构建失败，请检查错误信息"
    exit 1
fi

echo ""
echo "构建完成！"