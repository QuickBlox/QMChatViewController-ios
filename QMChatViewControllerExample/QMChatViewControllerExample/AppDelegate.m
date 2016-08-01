//
//  AppDelegate.m
//  QMChatViewControllerExample
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "AppDelegate.h"
#import "STKStickerPipe.h"
#import <SSKeychain/SSKeychain.h>
#import "NSString+MD5.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(NSString *)getUniqueDeviceIdentifierAsString
{
    
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
    }
    
    return strApplicationUUID;
}


- (NSString *)userId {
    
    NSString  *currentDeviceId = [self getUniqueDeviceIdentifierAsString];
    
    return [currentDeviceId MD5Digest];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [STKStickersManager initWitApiKey: @"847b82c49db21ecec88c510e377b452c"];
    [STKStickersManager setStartTimeInterval];
    [STKStickersManager setUserKey:[self userId]];
    
    [STKStickersManager setPriceBWithLabel:@"0.99 USD" andValue:0.99f];
    [STKStickersManager setPriceCwithLabel:@"1.99 USD" andValue:1.99f];
    
    [STKStickersManager setUserIsSubscriber:NO];
    return YES;
}

@end
