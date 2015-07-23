//
//  AppDelegate.h
//  HOSHK
//
//  Created by Pain on 13年10月23日.
//  Copyright (c) 2013年 Pain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    NSString *noticeID;
    NSString *contentID;
    NSDictionary *myLaunchOptions;
    NSString *isFistReicive;
    int count;
}

@property (strong, nonatomic) UIWindow *window;

//FaceBook分享
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
