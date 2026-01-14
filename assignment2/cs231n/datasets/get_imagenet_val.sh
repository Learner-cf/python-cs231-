#!/usr/bin/env bash
set -euo pipefail

# 切换到脚本所在目录，确保相对路径正确
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir" || exit 1

fileName="imagenet_val_25.npz"
url="http://cs231n.stanford.edu/imagenet_val_25.npz"

if [ ! -f "$fileName" ]; then
  echo "文件 $fileName 不存在，开始下载..."
  if command -v curl >/dev/null 2>&1; then
    curl -fSL "$url" -o "$fileName"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$fileName" "$url"
  else
    echo "未找到下载工具 (curl 或 wget)。" >&2
    exit 1
  fi
  echo "下载完成：$fileName"
else
  echo "文件 $fileName 已存在，跳过下载。"
fi
