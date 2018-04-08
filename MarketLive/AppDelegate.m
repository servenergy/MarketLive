    //
//  AppDelegate.m
//  MarketLive
//
//  Created by Vinod on 06/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "AppDelegate.h"
#import "FileDownloader.h"
#import "DeviceTokenManager.h"



@interface AppDelegate () <DataChangeDelegate>

@end

@implementation AppDelegate
@synthesize objNavigationViewController,objNavigationViewController1;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2.0];
    
    
    [DatabaseManager sharedInstance];
    
    
    [DataChange getInstance].delegate = self;
    [[DataChange getInstance] checkForDataChange];
    
    
   /* UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  
    
  
    
    UIViewController *leftView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    
    UINavigationController *lefNav = [[UINavigationController alloc] initWithRootViewController:leftView];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
    
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerNav leftDrawerViewController:lefNav];
    
    
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView;
    
   
    
    _window.rootViewController = self.drawerController;
    [_window makeKeyAndVisible];
   */
    
    
    
    
    
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    
    id objViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

    
    id objViewController1 = [storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"selectedLanguage"])
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"selectedLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        objViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    }
    
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                         settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

  
    objNavigationViewController = [[NavigationViewController alloc]
                                   initWithRootViewController:objViewController];
    objNavigationViewController1 = [[NavigationViewController alloc] initWithRootViewController:objViewController1];
    
    [objNavigationViewController.view addSubview:[BottomTabBar sharedInstance]];
    

  //  objNavigationViewController  = [[NavigationViewController alloc] initWithRootViewController:objViewController];
    

    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:objNavigationViewController leftDrawerViewController:objNavigationViewController1];
    
    

    
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView;
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = objNavigationViewController;

    
     _window.rootViewController = self.drawerController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * deviceTokenString = [[[[NSString stringWithFormat:@"%@", deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSLog(@"device Token String : %@", deviceToken);
    
    [[DeviceTokenManager sharedInstance] saveTokenToServer:deviceTokenString];
    [[NSUserDefaults standardUserDefaults] setValue:deviceTokenString forKey:@"apnsToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary * test = [userInfo objectForKey:@"aps"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"News!"
                                                     message:[test objectForKey:@"alert"]
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert setTag:99];
    [alert show];
}

-(void) dataChanged:(BOOL)changed :(NSString *)DBVersion
{
    if (changed) {
        NSLog(@"Data Changed : %@", DBVersion);
        [[FileDownloader sharedInstance] downloadFileWithURLString:DBVersion];
        
    }
    else
    {
        NSLog(@"Data Not Changed : %@", DBVersion);
    }
}

@end
