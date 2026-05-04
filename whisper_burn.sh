#!/bin/bash

# ==============================================================================
# Whisper Subtitle Burn-in Tool
# Usage: ./whisper_burn.sh <input_video> [model_path] [language]
# ==============================================================================

INPUT="$1"
MODEL="${2:-/Users/frank/models/whisper/ggml-medium.bin}"
LANG="${3:-zh}"

# 检查输入参数
if [ -z "$INPUT" ]; then
    echo "❌ 错误: 请提供输入视频文件。"
    echo "用法: $0 <input_video> [model_path] [language]"
    echo "示例: $0 video.mp4"
    exit 1
fi

# 检查文件是否存在
if [ ! -f "$INPUT" ]; then
    echo "❌ 错误: 找不到文件 '$INPUT'"
    exit 1
fi

if [ ! -f "$MODEL" ]; then
    echo "❌ 错误: 找不到模型文件 '$MODEL'"
    exit 1
fi

# 变量准备
BASENAME="${INPUT%.*}"
SRT="${BASENAME}.srt"
OUTPUT="${BASENAME}_hardcode.mp4"

echo "----------------------------------------------------"
echo "🚀 开始处理: $INPUT"
echo "📂 使用模型: $MODEL"
echo "🌐 识别语言: $LANG"
echo "----------------------------------------------------"

# 第一步: 转录
echo "🎬 步骤 1/2: 正在提取并生成字幕 ($SRT)..."
ffmpeg -i "$INPUT" -af "whisper=model=\"$MODEL\":language=$LANG:destination=\"$SRT\":format=srt" -f null - 

if [ $? -ne 0 ]; then
    echo "❌ 错误: 第一步转录失败。"
    exit 1
fi

# 第二步: 合成
echo "📺 步骤 2/2: 正在将字幕压制到视频 ($OUTPUT)..."
# 注意: macOS 下建议使用 PingFang SC 字体以获得最佳中文支持
ffmpeg -i "$INPUT" -vf "subtitles='$SRT':force_style='FontName=PingFang SC'" -c:v libx264 -crf 20 -c:a copy "$OUTPUT" -y

if [ $? -ne 0 ]; then
    echo "❌ 错误: 第二步合成失败。"
    exit 1
fi

echo "----------------------------------------------------"
echo "✅ 处理完成!"
echo "📄 生成字幕: $SRT"
echo "🎥 输出视频: $OUTPUT"
echo "----------------------------------------------------"
