//
//  NotificationViewController.m
//  NotificationScene
//
//  Created by mac on 2016/11/1.
//  Copyright © 2016年 LookTour. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController
//默认的NotificationContent的VC中，默认有两个方法。分别为viewDidLoad和didReceiveNotification。前者渲染UI，后者获取通知信息，更新UI控件中的数据。
//UNNotificationExtensionDefaultContentHidden 这个key是boolean类型，之前我设置好自定义UI之后发现，出现了两个title，两个message,是因为我们没有隐藏苹果官方格式的通知，隐藏掉就好了，这里要设置为YES
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveNotification:(UNNotification *)notification {
//    self.label.text = notification.request.content.body;
    NSDictionary *dict = notification.request.content.userInfo;
    
    NSLog(@"%@",dict);
    /****************************打印的信息是************
     aps =     {
     alert = "This is some fancy message.";
     badge = 1;
     from = "大家好，我是徐不同";
     imageAbsoluteString = "http://upload.univs.cn/2012/0104/1325645511371.jpg";
     "mutable-content" = 1;
     sound = default;
     };
     }
     *******************************************/

}
//返回默认样式的播放button
-(UNNotificationContentExtensionMediaPlayPauseButtonType)mediaPlayPauseButtonType{
    return UNNotificationContentExtensionMediaPlayPauseButtonTypeDefault;
}
//返回button的frame
-(CGRect)mediaPlayPauseButtonFrame{
    return CGRectMake(100, 100, 100, 100);
}
//返回button的颜色
-(UIColor *)mediaPlayPauseButtonTintColor{
    return [UIColor redColor];
}
//点击这个按钮可以进行一些操作
-(void)mediaPlay{
    NSLog(@"开始播放");
    // 点击播放按钮后，4s后暂停播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extensionContext mediaPlayingPaused];
    });
}
-(void)mediaPause{
    NSLog(@"停止播放");
    // 点击暂停按钮，10s后开始播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extensionContext mediaPlayingStarted];
    });
}

//这两个方法也是复写系统方法
- (void)mediaPlayingStarted{
    NSLog(@"主动调用开始的方法");
}
- (void)mediaPlayingPaused
{
    NSLog(@"主动调用暂停的方法");
    
}


@end
