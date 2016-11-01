//
//  NotificationAction.m
//  Notifcation
//
//  Created by mac on 2016/10/31.
//  Copyright © 2016年 LookTour. All rights reserved.
//

#import "NotificationAction.h"
#import <UserNotifications/UserNotifications.h>
@implementation NotificationAction
+ (void)addNotificationAction{

    //创建Action按钮
    UNNotificationAction *lookAction = [UNNotificationAction actionWithIdentifier:@"action.join" title:@"接受邀请" options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationAction *joinAction = [UNNotificationAction actionWithIdentifier:@"action.look" title:@"查看邀请" options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"action.cancel" title:@"取消" options:UNNotificationActionOptionDestructive];
    
    //注册category
    //identifier 标示符
    //actions 操作数组
    // intentldentifiers 意图标示符 可在<Intents/INIntentIdentifiers.h>中查看，主要针对电话，carplay等开放的API.
    //options 通知选项 枚举类型，也是为了支持carplay
    UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[lookAction, joinAction, cancelAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //将category添加到通知中心
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObject:notificationCategory]];
}

+ (void)addNotificationActionTwo{
    //创建UNTextInputNotificationAction 比 UNNotificationAction 多了2个参数
    //buttonTitle 输入框右边的按钮标题
    //placeholder 输入框占位符
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"action.input" title:@"输入" options: UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"tell me loudly"];
    //注册category
    UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[inputAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObject:notificationCategory]];
}

@end
