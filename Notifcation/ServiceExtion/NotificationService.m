//
//  NotificationService.m
//  ServiceExtion
//
//  Created by mac on 2016/11/1.
//  Copyright © 2016年 LookTour. All rights reserved.
//

#import "NotificationService.h"
#import <UserNotifications/UserNotifications.h>
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService
//让你可以在后台处理接收到的推送，传递最终的内容给 contentHandler
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    //copy发来的通知，开始做一些处理
    self.bestAttemptContent = [request.content mutableCopy];
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    //重写一些东西
    self.bestAttemptContent.title = @"我是标题";
    self.bestAttemptContent.subtitle = @"我是子标题";
    self.bestAttemptContent.body = @"来自穷笑天";
    //附件（图片，视频，音乐等）
    NSDictionary *dict = self.bestAttemptContent.userInfo;
    NSDictionary *notiDict = dict[@"aps"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
    
    // 这里添加一些点击事件，可以在收到通知的时候，添加，也可以在拦截通知的这个扩展中添加
    
    self.bestAttemptContent.categoryIdentifier = @"category1";
    
    if (!imgUrl.length) {
        //展示通知
        self.contentHandler(self.bestAttemptContent);
    }
    
    [self loadAttachmentForUrlString:imgUrl withType:@"png" completionHandle:^(UNNotificationAttachment *attach) {
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
    }];
}
- (void)loadAttachmentForUrlString:(NSString *)urlStr withType:(NSString *)type completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:urlStr completionHandler:^(NSURL * _Nullable temporaryFileLocation, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"%@",error.localizedDescription);
        }else{
            NSFileManager *filemanger = [NSFileManager defaultManager];
            NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
            [filemanger moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
            
            NSError *attachmentError = nil;
            attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
            
            if (attachmentError) {
                NSLog(@"%@",attachmentError.localizedDescription);
            }
        }
        completionHandler(attachment);
    }]resume];
}
- (NSString *)fileExtensionForMediaType:(NSString *)type{
    NSString *ex = type;
    
    if ([type isEqualToString:@"image"]) {
        ex = @"jpg";
    }
    if ([type isEqualToString:@"video"]) {
        ex = @"mp4";
    }
    if ([type isEqualToString:@"audio"]) {
        ex = @"mp3";
    }
    return [@"."stringByAppendingString:ex];
}



//在你获得的一小段运行代码的时间即将结束的时候，如果仍然没有成功的传入内容，会走到这个方法，可以在这里传肯定不会出错的内容，或者他会默认传递原始的推送内容
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}
//mutable-content这个键值为1，这意味着此条推送可以被 Service Extension 进行更改，也就是说要用Service Extension需要加上这个键值为1.
/*
 {
 "aps": {
 "alert": "This is some fancy message.",
 "badge": 1,
 "sound": "default",
 "mutable-content": "1",
 "imageAbsoluteString": "http://upload.univs.cn/2012/0104/1325645511371.jpg"
 }
 }
 */
/*
 {
 "aps":{
 "alert" : {
 "title" : "iOS远程消息，我是主标题！-title",
 "subtitle" : "iOS远程消息，我是主标题！-Subtitle",
 "body" : "Dely,why am i so handsome -body"
 },
 "sound" : "default",
 "badge" : "1",
 "mutable-content" : "1",
 "category" : "Dely_category"
 },
 "image" : "https://p1.bpimg.com/524586/475bc82ff016054ds.jpg",
 "type" : "scene",
 "id" : "1007"
 }
 */
@end
