//
//  AppDelegate.h
//  MarketLive
//
//  Created by Vinod on 06/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain) NavigationViewController *objNavigationViewController;
@property(nonatomic,retain) NavigationViewController *objNavigationViewController1;
@property(nonatomic,strong) MMDrawerController *drawerController;
@end

