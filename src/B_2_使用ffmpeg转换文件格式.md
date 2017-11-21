# 使用ffmpeg转换文件格式

### 格式转换

```shell
# 将mp4文件转换为flv
ffmpeg -i IU.mp4 -acodec aac test.flv   
```

```shell
-i "1.avi"		# 输入文件是
-title "Test" 	# 影片的标题
-s 368x208 		# 输出的分辨率为368x208，注意片源一定要是16:9的不然会变形
-r 29.97		# 帧数
-b 1500			# 视频数据流量，用-b xxxx的指令则使用固定码率,还可以用动态码率如：-qscale 4和-qscale 6，4的质量比6高
-acodec 		# aac音频编码用AAC
-ac 			# 声道数1或2
-ar 24000		# 声音的采样频率
-ab 128			# 音频数据流量，一般选择32、64、96、128
-vol 200		# 200%的音量，自己改
-ab bitrate     # 设置音频码率
-ar freq 		# 设置音频采样率
-ss 			# 指定时间点开始转换任务(time_off set the start time offset),-ss后跟的时间单位为秒 .
-s 320x240 		# 指定分辨率   
-bitexact 		# 使用标准比特率 
-vcodec xvid    # 使用xvid压缩
```

### 参考资料

+  [FFMpeg 常用命令格式转换和视频合成](http://blog.csdn.net/coloriy/article/details/47447369)
+  [使用ffmpeg转换文件格式](http://blog.csdn.net/sunbingzibo/article/details/1649137)