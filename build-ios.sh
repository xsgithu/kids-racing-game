#!/bin/bash

echo "儿童赛车游戏 - iOS 构建脚本"
echo "=============================="

# 检查是否在 macOS 系统上运行
if [[ "$(uname)" != "Darwin" ]]; then
    echo "错误: iOS 构建只能在 macOS 系统上进行"
    exit 1
fi

# 检查 Node.js 和 npm
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "错误: 请安装 Node.js 和 npm"
    exit 1
fi

# 检查 Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "错误: 请安装 Xcode"
    exit 1
fi

# 检查 CocoaPods
if ! command -v pod &> /dev/null; then
    echo "错误: 请安装 CocoaPods"
    echo "可以使用以下命令安装: sudo gem install cocoapods"
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
cordova prepare ios

# 安装 iOS 依赖
echo "正在安装 iOS 依赖..."
cd platforms/ios
pod install
cd ../..

# 构建 iOS 应用
echo "正在构建 iOS 应用..."
cordova build ios --release

# 检查构建结果
if [ -d "platforms/ios/build/device" ]; then
    echo "构建成功！"
    echo "应用文件位置: platforms/ios/build/device/"
    echo ""
    echo "下一步操作："
    echo "1. 使用 Xcode 打开项目："
    echo "   open platforms/ios/KidsRacing.xcworkspace"
    echo ""
    echo "2. 在 Xcode 中："
    echo "   - 选择您的开发者账号"
    echo "   - 选择目标设备"
    echo "   - 点击 'Build and Run' 按钮"
    echo ""
    echo "3. 或者导出 IPA 文件用于分发："
    echo "   - 在 Xcode 中选择 'Product' -> 'Archive'"
    echo "   - 在 Organizer 中选择构建并点击 'Distribute App'"
else
    echo "构建失败，请检查错误信息"
    exit 1
fi

echo ""
echo "构建完成！"