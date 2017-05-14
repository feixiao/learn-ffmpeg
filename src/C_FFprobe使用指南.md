# FFprobe使用指南

#### FFprobe 是什么 ？

​	ffprobe 是一个多媒体流分析工具。它从多媒体流中收集信息，并且以人类和机器可读的形式打印出来。它可以用来检测多媒体流的容器类型，以及每一个多媒体流的格式和类型。它可以作为一个独立的应用来使用，也可以结合文本过滤器执行更复杂的处理。

####  FFprobe 使用示例

+ 最简单的使用方式  

  ```shell
  ffprobe test.mp4  
  ```


+ 不显示欢迎信息  	

  ```shell
  ffprobe -hide_banner test.mp4  
  ```

+ 以 JSON 格式显示每个流的信息  

  ```shell
  ffprobe -hide_banner -print_format json -show_streams test.mp4  
  ```

+ 显示容器格式相关信息  

  ```shell
  ffprobe -hide_banner -show_format test.mp4
  ```

#### 主要选项

```
‘-f format’    强制使用的格式  
‘-unit’        显示值的单位  
‘-prefix’      显示的值使用标准国际单位制词头  
‘-byte_binary_prefix’ 对字节值强制使用二进制前缀  
‘-sexagesimal’ 时间值使用六十进位的格式 HH:MM:SS.MICROSECONDS  
‘-pretty’      美化显示值的格式。它相当于 "-unit -prefix -byte_binary_prefix -sexagesimal"  
‘-of, -print_format writer_name[=writer_options]’   
              设置输出打印格式。writer_name 指定打印程序 (writer) 的名称，writer_options   
              指定传递给 writer 的选项。例如：将输出打印为 JSON 格式：-print_format json   
‘-select_streams stream_specifier’   
              只选择 stream_specifier 指定的流。该选项只影响那些与流相关的选项  
              (例如：show_streams, show_packets, 等)。  
              举例：只显示音频流，使用命令：  
                ffprobe -show_streams -select_streams a INPUT  
‘-show_data’ 显示有效载荷数据，以十六进制和ASCII转储。与 ‘-show_packets’ 结合使用，它将   
              dump 包数据；与 ‘-show_streams’ 结合使用，它将 dump codec 附加数据。  
‘-show_error’    显示探测输入文件时的错误信息  
‘-show_format’   显示输入多媒体流的容器格式信息  
‘-show_packets’  显示输入多媒体流中每一个包的信息  
‘-show_frames’   显示输入多媒体流中的每一帧以及字幕的信息  
‘-show_streams’  显示输入多媒体流中每一个流的信息  
‘-show_programs’ 显示输入多媒体流中程序以及它们的流的信息  
‘-show_chapters’ 显示格式中存储的章节信息  
‘-count_frames’  计算每一个流中的帧数，在相应的段中进行显示  
‘-count_packets’ 计算每一个流中的包数，在相应的段中进行显示  
‘-show_program_version’   显示程序版本及配置相关信息  
‘-show_library_versions’  显示库版本相关信息  
‘-show_versions’          显示程序和库版本相关信息。相当于同时设置‘-show_program_version’ 和   
                          ‘-show_library_versions’  
‘-i input_file’           指定输入文件  
```

#### 参考资料

+ [FFprobe使用指南](http://blog.csdn.net/stone_wzf/article/details/45378759#)