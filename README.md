# MYAVFoundation
封装音视频框架，支持音视频录制播放，音视频元数据获取、修改


## 1. 音视频元数据获取、修改

### 方法调用

```objc
#import "MYMetadataItem.h"

// 获取元数据
_metadataItem = [[MYMetadataItem alloc] initWithURL:url];
[_metadataItem prepareWithCompletionHandler:^(BOOL complete) {
    titleLabel.text = _metadataItem.metadata.title;
}];
```   
 
```objc
// 保存元数据
_metadataItem.metadata.title = @"new title";
[_metadataItem saveWithCompletionHandler:^(BOOL complete) {
    titleLabel.text = _metadataItem.metadata.title;
}];
``` 

### 注意

可以修改 MPEG-4 和 QuickTime 容器中存在的元数据信息，不过不能添加新的元数据。此外，不能修改 ID3 标签，不支持写入 MP3 数据。

### 示例截图

![01](https://github.com/Mayan29/MYAVFoundation/blob/master/SampleData/01.gif)


## 2. 视频播放

在新页面打开调用下面方法：

```objc
MYPlayerViewController *vc = [[MYPlayerViewController alloc] init];
vc.assetURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hubblecast" ofType:@"m4v"]];
[self presentViewController:vc animated:YES completion:nil];
```

将视频播放控件放在指定 view 上调用下面方法：

```objc
self.controller = [[MYPlayerController alloc] initWithURL:self.assetURL];
    
UIView *playerView = self.controller.view;
playerView.frame = frame;
[self.view addSubview:playerView];
```    

![02](https://github.com/Mayan29/MYAVFoundation/blob/master/SampleData/02.gif)