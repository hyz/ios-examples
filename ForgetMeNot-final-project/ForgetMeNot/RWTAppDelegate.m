//
//  RWTAppDelegate.m
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/28/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "RWTAppDelegate.h"

//@import CoreLocation;

@interface RWTAppDelegate () // <CLLocationManagerDelegate>
//@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation RWTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.delegate = self;
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        NSUInteger msk = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:msk categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    NSLog(@"didFinishLaunchingWithOptions");
    return YES;
}

///- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
///    NSLog(@"locationManager:didExitRegion %@", region);
///    ///if ([region isKindOfClass:[CLBeaconRegion class]]) {
///    ///    UILocalNotification *notification = [[UILocalNotification alloc] init];
///    ///    notification.alertBody = @"Are you forgetting something?";
///    ///    notification.soundName = UILocalNotificationDefaultSoundName; // @"Default";
///    ///    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
///    ///}
///}
///
///- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
///    NSLog(@"locationManager:didChangeAuthorizationStatus %d", status);
///}

// self.window.rootViewController
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillTerminate:(UIApplication *)application { NSLog(@"applicationWillTerminate"); }


@end
