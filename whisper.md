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

### 基本转录命令
使用 `whisper` 滤镜进行转录。注意 `model` 参数需要指向你真实的 `.bin` 文件路径（推荐使用绝对路径）：

```bash
# 如果模型在当前目录
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh" -f null -

# 如果模型在其他目录（推荐）
ffmpeg -i input.mp4 -af "whisper=model=/Users/你的用户名/models/whisper/ggml-small.bin:language=zh" -f null -
```

### 提取字幕 (SRT)
如果你想直接通过 FFmpeg 生成字幕文件：
```bash
ffmpeg -i input.mp4 -af "whisper=model=ggml-small.bin:language=zh" output.srt
```

> [!IMPORTANT]
> FFmpeg 8.0 的 `whisper` 滤镜具体参数可以通过 `ffmpeg -h filter=whisper` 查看。

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
