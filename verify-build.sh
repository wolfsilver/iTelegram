#!/bin/bash

# 构建验证脚本
# 用于验证 GitHub Actions 构建的 APK 是否与本地构建匹配

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数：打印带颜色的消息
print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查参数
if [ $# -ne 2 ]; then
    echo "使用方法: $0 <release-tag> <downloaded-apk-path>"
    echo "示例: $0 release-9.3.3_3026 ./telegram-release-9.3.3_3026-playstore.apk"
    exit 1
fi

RELEASE_TAG="$1"
DOWNLOADED_APK="$2"

# 检查文件是否存在
if [ ! -f "$DOWNLOADED_APK" ]; then
    print_error "下载的 APK 文件不存在: $DOWNLOADED_APK"
    exit 1
fi

# 检查是否在正确的目录
if [ ! -f "build.gradle" ] || [ ! -f "Dockerfile" ]; then
    print_error "请在项目根目录运行此脚本"
    exit 1
fi

print_info "开始验证构建..."
print_info "标签: $RELEASE_TAG"
print_info "APK 文件: $DOWNLOADED_APK"

# 切换到指定标签
print_info "切换到标签 $RELEASE_TAG"
git checkout "$RELEASE_TAG" || {
    print_error "无法切换到标签 $RELEASE_TAG"
    exit 1
}

# 清理之前的构建
print_info "清理之前的构建产物"
rm -rf TMessagesProj/build/outputs/

# 构建 Docker 镜像
print_info "构建 Docker 镜像..."
docker build -t telegram-build-verify . || {
    print_error "Docker 镜像构建失败"
    exit 1
}

# 运行构建
print_info "开始构建 APK..."
docker run --rm -v "$PWD":/home/source telegram-build-verify || {
    print_error "APK 构建失败"
    exit 1
}

# 查找生成的 APK
print_info "查找生成的 APK 文件..."

# 根据下载的文件名确定应该比较哪个 APK
if [[ "$DOWNLOADED_APK" == *"standalone"* ]]; then
    BUILT_APK="TMessagesProj/build/outputs/apk/afat/standalone/app.apk"
    APK_TYPE="standalone"
elif [[ "$DOWNLOADED_APK" == *"playstore"* ]]; then
    BUILT_APK="TMessagesProj/build/outputs/apk/afat/release/app.apk"
    APK_TYPE="playstore"
elif [[ "$DOWNLOADED_APK" == *"huawei"* ]]; then
    BUILT_APK="TMessagesProj/build/outputs/apk/afat/release/app-huawei.apk"
    APK_TYPE="huawei"
else
    print_error "无法识别 APK 类型，请确保文件名包含 'standalone'、'playstore' 或 'huawei'"
    exit 1
fi

if [ ! -f "$BUILT_APK" ]; then
    print_error "本地构建的 APK 不存在: $BUILT_APK"
    exit 1
fi

print_info "比较 $APK_TYPE 版本的 APK"
print_info "本地构建: $BUILT_APK"
print_info "下载文件: $DOWNLOADED_APK"

# 检查文件大小
LOCAL_SIZE=$(stat -c%s "$BUILT_APK")
DOWNLOADED_SIZE=$(stat -c%s "$DOWNLOADED_APK")

print_info "文件大小比较:"
print_info "  本地构建: $LOCAL_SIZE 字节"
print_info "  下载文件: $DOWNLOADED_SIZE 字节"

if [ "$LOCAL_SIZE" != "$DOWNLOADED_SIZE" ]; then
    print_error "文件大小不匹配!"
else
    print_success "文件大小匹配"
fi

# 计算并比较 SHA256 校验和
print_info "计算 SHA256 校验和..."
LOCAL_SHA=$(sha256sum "$BUILT_APK" | cut -d' ' -f1)
DOWNLOADED_SHA=$(sha256sum "$DOWNLOADED_APK" | cut -d' ' -f1)

print_info "SHA256 校验和比较:"
print_info "  本地构建: $LOCAL_SHA"
print_info "  下载文件: $DOWNLOADED_SHA"

if [ "$LOCAL_SHA" = "$DOWNLOADED_SHA" ]; then
    print_success "✅ APK 完全匹配! 构建是可重现的"
    echo ""
    print_success "验证通过: $APK_TYPE 版本的 APK 与本地构建完全一致"
else
    print_error "❌ APK 不匹配! 构建可能不可重现"
    echo ""
    print_error "验证失败: 请检查构建环境和依赖版本"
    exit 1
fi

# 可选：使用 apkdiff.py 进行详细比较（如果存在）
if [ -f "apkdiff.py" ]; then
    print_info "使用 apkdiff.py 进行详细比较..."
    python3 apkdiff.py "$DOWNLOADED_APK" "$BUILT_APK" || true
fi

print_success "验证完成!"
