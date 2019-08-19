# FFmpeg推流到SRS

### SRS安装
```shell
unzip SRS-CentOS6-x86_64-2.0.243.zip
cd SRS-CentOS6-x86_64-2.0.243/
bash   INSTALL 
/etc/init.d/srs start
```

### 推流
```
ffmpeg -re -i "/root/test.flv" -vcodec copy -acodec copy -f flv rtmp://172.17.229.3/live/test001 

ffmpeg -re -i 20190314.mp4 -c copy -f flv rtmp://172.17.229.3/live/test001
# -r 以本地帧频读数据，主要用于模拟捕获设备。
# 表示ffmpeg将按照帧率发送数据，不会按照最高的效率发送
```

### 拉流
```
ffmpeg -i rtmp://server/live/streamName -c copy dump.flv
```
### 参考资料
+ [srs官方镜像](https://github.com/ossrs/srs)
+ [FFMPEG推流到RTMP服务器命令](https://blog.csdn.net/weixin_37897683/article/details/81225228)