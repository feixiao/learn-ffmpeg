# FFmpeg使用指南

#### FFmpeg是什么

​	ffmpeg(命令行工具) 是一个快速的音视频转换工具。

#### FFmpeg使用方法

​	ffmpeg [全局选项] {[输入文件选项] -i ‘输入文件’} ... {[输出文件选项] ‘输出文件’} 

#### 主要选项

```
‘-f fmt (input/output)’ 
	强制输入或输出文件格式。通常，输入文件的格式是自动检测的，
	输出文件的格式是通过文件扩展名来进行猜测的，所有该选项大
	多数时候不需要。
‘-i filename (input)’ 
	输入文件名
‘-y (global)’ 
	覆盖输出文件而不询问
‘-n (global)’ 
	不覆盖输出文件，如果一个给定的输出文件已经存在，则立即
	退出
‘-c[:stream_specifier] codec (input/output,per-stream)’
‘-codec[:stream_specifier] codec (input/output,per-stream)’
	为一个或多个流选择一个编码器(当使用在一个输出文件之前时)
	或者一个解码器(当使用在一个输入文件之前时)。codec 是一个
	编码器/解码器名称或者一个特定值“copy”(只适用输出)。
‘-t duration (output)’ 
	当到达 duration 时，停止写输出。
	duration 可以是一个数字(秒)，或者使用hh:mm:ss[.xxx]形式。
	-to 和 -t 是互斥的，-t 优先级更高。
‘-to position (output)’ 
	在 position 处停止写输出。
	duration 可以是一个数字(秒)，或者使用hh:mm:ss[.xxx]形式。
	-to 和 -t 是互斥的，-t 优先级更高。
‘-fs limit_size (output)’
	设置文件大小限制，以字节表示
‘-ss position (input/output)’
	当作为输入选项时(在 -i 之前)，在输入文件中跳转到 position。
	需要注意的是，在大多数格式中，不太可能精确的跳转，因此，
	ffmpeg 将跳转到 position 之前最接近的位置。当进行转码
	并且 ‘-accurate_seek’ 打开时(默认)，位于跳转点和 position 
	之间的额外部分将被解码并且丢弃。当做流拷贝或者当使用
	‘-noaccurate_seek’时，它将被保留下来。
	当作为输出选项时(在输出文件名前)，解码但是丢弃输入，直到
	时间戳到达 position。
	position 可以是秒或者 hh:mm:ss[.xxx] 形式
‘-itsoffset offset (input)’
	设置输入时间偏移。 offset 将被添加到输入文件的时间戳。指定
	一个正偏移，意味着相应的流将被延时指定时间。
‘-timestamp date (output)’
	在容器中设置录音时间戳
‘-metadata[:metadata_specifier] key=value (output,per-metadata)’
	设置metadata key/value对
‘-target type (output)’
	指定目标文件类型(vcd, svcd, dvd, dv, dv50)。
	type 可以带有 pal-, ntsc- 或 film- 前缀，以使用相应的标准。
	所有的格式选项(bitrate, codecs, buffer sizes)将自动设定。
‘-dframes number (output)’
	设置要录制数据帧的个数。这是 -frames:d 的别名
‘-frames[:stream_specifier] framecount (output,per-stream)’  
	framecount 帧以后，停止写流。
‘-q[:stream_specifier] q (output,per-stream)’
‘-qscale[:stream_specifier] q (output,per-stream)’ 
	使用固定质量范围(VBR)。
‘-filter[:stream_specifier] filtergraph (output,per-stream)’
	创建filtergraph 指定的过滤图，并使用它来过滤流。
‘-filter_script[:stream_specifier] filename (output,per-stream)’
	该选项与‘-filter’相似，唯一的不同是，它的参数是一个存放
	过滤图的文件的名称。
‘-pre[:stream_specifier] preset_name (output,per-stream)’ 
	指定匹配流的预设
‘-stats (global)’
	打印编码进程/统计信息。默认打开，可以使用 -nostats 禁用。
‘-stdin’ 
	开启标准输入交互。默认打开，除非标准输入作为一个输入。
	可以使用 -nostdin 禁止。
‘-debug_ts (global)’
	打印时间戳信息。默认关闭。
‘-attach filename (output)’
	添加一个附件到输出文件中
‘-dump_attachment[:stream_specifier] filename (input,per-stream)’ 
	提取匹配的附件流到filename指定的文件中。
```

#### 视频选项

```
‘-vframes number (output)’
	设置录制视频帧的个数。这是 -frames:v 的别名
‘-r[:stream_specifier] fps (input/output,per-stream)’
	设置帧率(Hz 值， 分数或缩写)
‘-s[:stream_specifier] size (input/output,per-stream)’
	设置帧大小。格式为 ‘wxh’ (默认与源相同)
‘-aspect[:stream_specifier] aspect (output,per-stream)’
	设置视频显示长宽比
‘-vn (output)’
	禁止视频录制
‘-vcodec codec (output)’
	设置视频 codec。这是 -codec:v 的别名
‘-pass[:stream_specifier] n (output,per-stream)’
	选择pass number (1 or 2)。用来进行双行程视频编码。
‘-passlogfile[:stream_specifier] prefix (output,per-stream)’
	设置 two-pass 日志文件名前缀，默认为“ffmpeg2pass”。
‘-vf filtergraph (output)’
	创建 filtergraph 指定的过滤图，并使用它来过滤流。
‘-pix_fmt[:stream_specifier] format (input/output,per-stream)’
	设置像素格式。
‘-sws_flags flags (input/output)’
	设置软缩放标志
‘-vdt n’
	丢弃阈值
‘-psnr’
	计算压缩帧的 PSNR 
‘-vstats’
	复制视频编码统计信息到‘vstats_HHMMSS.log’
‘-vstats_file file’
	复制视频编码统计信息到 file
‘-force_key_frames[:stream_specifier] time[,time...] (output,per-stream)’
‘-force_key_frames[:stream_specifier] expr:expr (output,per-stream)’
	在指定的时间戳强制关键帧
‘-copyinkf[:stream_specifier] (output,per-stream)’
	当进行流拷贝时，同时拷贝开头的非关键帧
‘-hwaccel[:stream_specifier] hwaccel (input,per-stream)’
	使用硬件加速来解码匹配的流
‘-hwaccel_device[:stream_specifier] hwaccel_device (input,per-stream)’
	选择硬件加速所使用的设备。该选项只有‘-hwaccel’同时指定时才有意义。

```

#### 音频选项

```
‘-aframes number (output)’
	设置录制音频帧的个数。这是 -frames:a 的别名
‘-ar[:stream_specifier] freq (input/output,per-stream)’
	设置音频采样率。
‘-aq q (output)’
	设置音频质量。这是 -q:a 的别名
‘-ac[:stream_specifier] channels (input/output,per-stream)’
	设置音频通道数。
‘-an (output)’
	禁止音频录制
‘-acodec codec (input/output)’
	设置音频codec。这是-codec:a的别名
‘-sample_fmt[:stream_specifier] sample_fmt (output,per-stream)’
	设置音频采样格式
‘-af filtergraph (output)’
	创建filtergraph 所指定的过滤图，并使用它来过滤流
```

#### 高级选项

```
‘-map [-]input_file_id[:stream_specifier][,sync_file_id[:stream_specifier]] | [linklabel] (output)’
	指定一个或多个流作为输出文件的源。
	命令行中的第一个 -map 选项，指定输出流0的源，
	第二个 -map 选项，指定输出流1的源，等等。
‘-map_channel [input_file_id.stream_specifier.channel_id|-1][:output_file_id.stream_specifier]’
	将一个给定输入的音频通道映射到一个输出。
‘-map_metadata[:metadata_spec_out] infile[:metadata_spec_in] (output,per-metadata)’
	设置下一个输出文件的 metadata 信息。
‘-map_chapters input_file_index (output)’
	从索引号为 input_file_index 的输入文件中拷贝章节到下一个输出文件中。
‘-timelimit duration (global)’
	ffmpeg 运行 duration 秒后推出
‘-dump (global)’
	将每一个输入包复制到标准输出
‘-hex (global)’
	复制包时，同时复制负载
‘-re (input)’
	以本地帧率读取数据。主要用来模拟一个采集设备，
	或者实时输入流(例如：当从一个文件读取时).
‘-vsync parameter’
	视频同步方法
‘-async samples_per_second’
	音频同步方法
‘-shortest (output)’
	当最短的输入流结束时，终止编码
‘-muxdelay seconds (input)’
	设置最大解封装-解码延时
‘-muxpreload seconds (input)’
	设置初始解封装-解码延时
‘-streamid output-stream-index:new-value (output)’
	为一个输出流分配一个新的stream-id。
‘-bsf[:stream_specifier] bitstream_filters (output,per-stream)’
	为匹配的流设置比特流过滤器
‘-filter_complex filtergraph (global)’
	定义一个复杂的过滤图
‘-lavfi filtergraph (global)’
	定义一个复杂的过滤图。相当于‘-filter_complex’
‘-filter_complex_script filename (global)’
   该选项类似于‘-filter_complex’，唯一的不同是
   它的参数是一个定义过滤图的文件的文件名
‘-accurate_seek (input)’
   打开或禁止在输入文件中的精确跳转。默认打开。
```

#### 参考资料

+ [FFmpeg 使用指南](http://www.tuicool.com/articles/nquMZv)

