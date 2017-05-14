# FFplay使用指南

#### FFplay是什么

+ ffplay 是一个使用了 ffmpeg 和 sdl 库的简单的可移植的媒体播放器。

  ```
  命令行： ffplay [选项] ['输入文件']
  ```

#### FFplay 使用示例

+ 播放 test.mkv ，播放完成后自动退出

  ```shell
  ffplay -autoexit test.mkv
  ```

+ 以 320 × 240 的大学播放 test.mkv

  ```shell
  ffplay -x 320 -y 240 test.mkv
  ```

#### 通用选项

```
'-L'    显示 license
'-h, -?, -help, --help [arg]' 打印帮助信息；可以指定一个参数 arg ，如果不指定，只打印基本选项
    可选的 arg 选项：
    'long'    除基本选项外，还将打印高级选项
    'full'    打印一个完整的选项列表，包含 encoders, decoders, demuxers, muxers, filters 等的共享以及私有选项
    'decoder=decoder_name'    打印名称为 "decoder_name" 的解码器的详细信息
    'encoder=encoder_name'    打印名称为 "encoder_name" 的编码器的详细信息
    'demuxer=demuxer_name'    打印名称为 "demuxer_name" 的 demuxer 的详细信息
    'muxer=muxer_name'        打印名称为 "muxer_name" 的 muxer 的详细信息
    'filter=filter_name'      打印名称为 "filter_name" 的过滤器的详细信息
	
'-version'     显示版本信息
'-formats'     显示有效的格式
'-codecs'      显示 libavcodec 已知的所有编解码器
'-decoders'    显示有效的解码器
'-encoders'    显示有效的编码器
'-bsfs'        显示有效的比特流过滤器
'-protocols'   显示有效的协议
'-filters'     显示 libavfilter 有效的过滤器
'-pix_fmts'    显示有效的像素格式 
'-sample_fmts' 显示有效的采样格式
'-layouts'     显示通道名称以及标准通道布局
'-colors'      显示认可的颜色名称
'-hide_banner' 禁止打印欢迎语；也就是禁止默认会显示的版权信息、编译选项以及库版本信息等
```

#### 主要选项

```
'-x width'        强制以 "width" 宽度显示
'-y height'       强制以 "height" 高度显示
'-an'	          禁止音频
'-vn'             禁止视频
'-ss pos'         跳转到指定的位置(秒)
'-t duration'     播放 "duration" 秒音/视频
'-bytes'          按字节跳转
'-nodisp'         禁止图像显示(只输出音频)
'-f fmt'          强制使用 "fmt" 格式
'-window_title title'  设置窗口标题(默认为输入文件名)
'-loop number'    循环播放 "number" 次(0将一直循环)
'-showmode mode'  设置显示模式
    可选的 mode ：
    '0, video'    显示视频
    '1, waves'    显示音频波形
    '2, rdft'     显示音频频带
    默认值为 'video'，你可以在播放进行时，按 "w" 键在这几种模式间切换

'-i input_file'   指定输入文件
```

#### 高级选项

```
'-sync type'          设置主时钟为音频、视频、或者外部。默认为音频。主时钟用来进行音视频同步
'-threads count'      设置线程个数
'-autoexit'           播放完成后自动退出
'-exitonkeydown'      任意键按下时退出
'-exitonmousedown'    任意鼠标按键按下时退出
'-acodec codec_name'  强制指定音频解码器为 "codec_name"
'-vcodec codec_name'  强制指定视频解码器为 "codec_name"
'-scodec codec_name'  强制指定字幕解码器为 "codec_name"
```

#### 快捷键

```
'q, ESC'            退出
'f'                 全屏
'p, SPC'            暂停
'w'                 切换显示模式(视频/音频波形/音频频带)
's'                 步进到下一帧
'left/right'        快退/快进 10 秒
'down/up'           快退/快进 1 分钟
'page down/page up' 跳转到前一章/下一章(如果没有章节，快退/快进 10 分钟)
'mouse click'       跳转到鼠标点击的位置(根据鼠标在显示窗口点击的位置计算百分比)
```

#### 参考资料

+ [《FFplay使用指南》](http://blog.csdn.net/wishfly/article/details/44222297)



