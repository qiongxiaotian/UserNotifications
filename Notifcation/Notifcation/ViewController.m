//
//  ViewController.m
//  Notifcation
//
//  Created by mac on 2016/10/27.
//  Copyright © 2016年 LookTour. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import "NotificationAction.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestlocationNotification];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 30);
    [button setTitle:@"更新" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
- (void)buttonAction{
    [self requestlocationNotification];
    NSString *requestidentifer = @"TestRequestww1";
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    //删除设备已收到的所有消息推送
//    [center removeAllDeliveredNotifications];
    
    //删除设备已收到的特定id的所有消息推送
//    [center removeDeliveredNotificationsWithIdentifiers:@[requestidentifer]];
    
    //获取设备已收到的消息推送
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSLog(@"notifications = %@",notifications);
    }];
    
}

- (void)requestlocationNotification{

    //触发模式1（在2秒后提醒）
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    //触发模式2
//    /首先得导入#import <CoreLocation/CoreLocation.h>，不然会regin创建有问题。
    // 创建位置信息
    //进行注册，地区信息使用CLRegion的子类CLCircularRegion，可以配置region属性 notifyOnEntry和notifyOnExit，是在进入地区、从地区出来或者两者都要的时候进行通知，这个测试过程专门从公司跑到家时刻关注手机有推送嘛，果然是有的（定点推送）
    CLLocationCoordinate2D center1 = CLLocationCoordinate2DMake(39.788857, 116.5559392);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center1 radius:500 identifier:@"经海五路"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    // region 位置信息 repeats 是否重复 （CLRegion 可以是地理位置信息）
    UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
    //触发模式3
    //周一早上8点
    NSDateComponents *components = [[NSDateComponents alloc]init];
    //注意weakDay是从周日开始的
    components.weekday  = 2;
    components.hour = 8;
    UNCalendarNotificationTrigger *trigger3 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];

    
    //创建本地通知
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"穷笑天的通知";
    content.subtitle = @"来自人间的通知";
    content.body = @"来自穷笑天的简书";
    content.badge = @1;
    
    NSError *error = nil;
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"png"];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"gif"];
    
            NSString *path = [[NSBundle mainBundle] pathForResource:@"flv视频测试用例1" ofType:@"mp4"];
    
    
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"attachment error %@",error);
    }
    content.attachments = @[att];
    content.launchImageName = @"1.png";
    
    //这里设置category1，是与之前设置的category对应
    content.categoryIdentifier = @"category1";
    //设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    
    //可以在这里添加Actions,也可以在appdelegate中
        [NotificationAction addNotificationAction ];

    NSString *requestidentifer = @"TestRequestww1";//创建通知标示
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestidentifer content:content trigger:trigger1];
    //把通知加到UNUserNotificationCenter,到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
