# 在 macOS 上为 FFmpeg 启用 Whisper 支持

从 FFmpeg 8.0 ("Huffman") 版本开始，FFmpeg 原生支持通过 `whisper` 音频滤镜进行语音转文字（ASR）。这需要集成 `whisper.cpp` 库。

以下是在 macOS 上配置和使用的步骤。

## 1. 安装基础依赖

首先确保你安装了 [Homebrew](https://brew.sh/)。

安装 `whisper.cpp` 库及其头文件（FFmpeg 编译时需要）：
```bash
brew install whisper-cpp
```

## 2. 安装支持 Whisper 的 FFmpeg

由于 Homebrew 默认仓库（core）中的 `ffmpeg` 通常不带一些实验性或重量级的第三方插件，建议使用 `homebrew-ffmpeg` 这个功能更全的第三方库。

### 卸载原有的 FFmpeg（如果已安装）
```bash
brew uninstall ffmpeg
```

### 使用 homebrew-ffmpeg 安装
```bash
# 添加定制化的 tap
brew tap homebrew-ffmpeg/ffmpeg

# 安装并启用 whisper-cpp 选项
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-whisper-cpp
```

> [!TIP]
> 编译过程可能较慢（取决于你的机器性能），因为它会从源码构建 FFmpeg 及其相关依赖。

## 3. 验证安装

安装完成后，验证 `whisper` 滤镜是否已成功加载：
```bash
ffmpeg -filters | grep whisper
```
如果看到 `whisper` 字样，说明 FFmpeg 已经具备了调用 Whisper 模型的能力。

## 4. 使用指南

### 下载与存放模型文件

Whisper 需要预训练模型才能工作。你需要下载 `.bin` 格式的模型文件，并将其存放在你方便管理的目录中。

#### 模型存放位置
FFmpeg 的 `whisper` 滤镜通过 `model` 参数指定模型文件的路径。你可以将模型放在：
1. **当前工作目录**：直接使用文件名引用（如 `model=ggml-small.bin`）。
2. **自定义全局目录**：例如创建一个 `~/.whisper-models` 文件夹，然后在命令中使用绝对路径（如 `model=/Users/你的用户名/.whisper-models/ggml-small.bin`）。

#### 下载示例
```bash
# 建议先创建一个统一存放模型的目录
mkdir -p ~/models/whisper
cd ~/models/whisper

# 下载 small 模型 (约 460MB)
curl -L https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin -o ggml-small.bin
```
常见的模型有：`tiny`, `base`, `small`, `medium`, `large-v3`。

### 基本转录命令 (在控制台查看)
使用 `whisper` 滤镜进行转录。如果你不指定 `destination`，转录结果通常会直接输出到控制台（注意：这取决于 FFmpeg 的日志级别，且需要音频中有清晰的语音）：

```bash
# 如果模型在当前目录
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh" -f null -

# 如果模型在其他目录（推荐）
ffmpeg -i input.mp4 -af "whisper=model=/Users/frank/models/whisper/ggml-small.bin:language=zh" -f null -
```

### 提取字幕 (SRT/JSON/TXT)
如果你想将转录结果保存到文件中，必须在滤镜参数中使用 `destination` 和 `format`：

```bash
# 生成 SRT 字幕文件
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh:destination=output.srt:format=srt" -f null -

# 生成 JSON 格式 (包含时间戳和概率)
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh:destination=output.json:format=json" -f null -
```

> [!CAUTION]
> 注意：不能直接使用 `ffmpeg -i ... output.srt`，因为 `whisper` 是音频滤镜，它不输出字幕流，而是通过内置参数直接写文件。

> [!IMPORTANT]
> FFmpeg 8.0 的 `whisper` 滤镜具体参数可以通过 `ffmpeg -h filter=whisper` 查看。

### 进阶：直接合成字幕到视频
由于 `whisper` 是音频滤镜，无法在一次处理中直接改变视频像素。我们可以使用 `&&` 将转录和合成命令串联起来。

#### 1. 硬字幕合成 (将字幕压制在画面上)
这种方式会将字幕变成视频画面的一部分。需要重编码视频，速度较慢，但兼容性最强。

```bash
# 自动生成并压制硬字幕 (注意：macOS 上建议对文件名加单引号)
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh:destination=sub.srt:format=srt" -f null - && \
ffmpeg -i input.mp4 -vf "subtitles='sub.srt'" -c:v libx264 -crf 20 -c:a copy output_hardcode.mp4
```

> [!TIP]
> **常见失败原因：**
> 1. **找不到字幕文件**：确保第一步生成的 `sub.srt` 确实存在。
> 2. **中文字体缺失**：如果合成后是方块或乱码，可以强制指定中文字体（如 `PingFang SC`）：
>    `-vf "subtitles='sub.srt':force_style='FontName=PingFang SC'"`
> 3. **模型路径错误**：确保 `whisper` 滤镜中的 `model` 路径是正确的。

#### 3. 自动化脚本 (推荐)
为了方便使用，本项目提供了一个名为 `whisper_burn.sh` 的脚本，可以一键完成转录和压制：

```bash
# 基本用法
./whisper_burn.sh input.mp4

# 指定模型和语言
./whisper_burn.sh input.mp4 ~/models/whisper/ggml-medium.bin zh
```
该脚本会自动处理 macOS 下的路径转义和字体设置。

#### 4. 软字幕嵌入 (作为可开关的轨道)
这种方式将 SRT 文件封装进视频容器。不需要重编码视频，速度极快（秒级完成），且字幕可以由播放器开启或关闭。

```bash
# 自动生成并嵌入软字幕
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh:destination=sub.srt:format=srt" -f null - && \
ffmpeg -i input.mp4 -i sub.srt -c copy -c:s mov_text output_softcode.mp4
```

> [!TIP]
> 如果你的输出格式是 MKV，可以将 `-c:s mov_text` 替换为 `-c:s srt` 或 `-c:s ass` 以获得更好的兼容性。

## 5. 备选方案：通过 whisper-cpp 独立处理

如果你发现编译 FFmpeg 太麻烦，或者只想快速处理，可以直接使用 `whisper-cpp` 命令行工具，它在 macOS 上对 Metal (GPU加速) 支持得非常好。

1. **使用 FFmpeg 提取标准音频 (16kHz, 单声道)：**
   ```bash
   ffmpeg -i video.mp4 -ar 16000 -ac 1 audio.wav
   ```
2. **使用 whisper-cpp 转录：**
   ```bash
   whisper-cpp -m ggml-small.bin -f audio.wav -osrt
   ```

---

## 参考链接
- [FFmpeg 官方文档 - whisper filter](https://ffmpeg.org/ffmpeg-filters.html#whisper)
- [whisper.cpp GitHub 仓库](https://github.com/ggerganov/whisper.cpp)
- [homebrew-ffmpeg 仓库](https://github.com/homebrew-ffmpeg/homebrew-ffmpeg)
