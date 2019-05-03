# YXMemoryDetector

ios/macos 内存检测相关工具，有时间会继续写(等我个人wiki写完的。。。)


#### 内存边界检查

最近发现代码中，有一些内存溢出的崩溃，于是做了一些尝试，用于在线上查找内存溢出代码。

注意：
1. 需要完善的符号平台和灰度机制，灰度千分之一用户。
2. 对内存有额外消耗，通过iphone5测试，但可以只在iphone 7 以上机器上开启。
3. 可在某功能激活时再开启。
4. 只是实验性质代码，谨慎使用。


TODO:
1. 支持自定义zone
2. 性能优化
3. 添加内存泄漏检测，收集泄漏实例和过滤器
4. 添加内存峰值统计，减少因内存问题被系统杀掉问题(h5 ?)

```objc
/*启动*/
[YXMemoryDector start];

/*关闭*/
[YXMemoryDector stop];
```


联系方式：
mail: liu.yuxi.canaan@gmail.com
QQ: 422099986
wechat: piequal23p1415926897
