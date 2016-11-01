//
//  AppDelegate.h
//  Notifcation
//
//  Created by mac on 2016/10/27.
//  Copyright © 2016年 LookTour. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DDLOG(...) printf("%s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

