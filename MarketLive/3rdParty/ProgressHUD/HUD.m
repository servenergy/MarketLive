//
//  HUD.m
//  Modular App
//
//  Created by BBIM1015 on 12/05/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "HUD.h"

@implementation HUD
  
static MBProgressHUD * hudObj;
static bool isPresent = false;

// Add HUD on the app window
+(void)addHUDWithText:(NSString *)message
{
    if (!isPresent)
    {
        AppDelegate * objAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        hudObj = [MBProgressHUD showHUDAddedTo:objAppDelegate.window animated:YES];
        hudObj.labelText = message;
        isPresent = true;
    }
}

+(void)updateHUDTitle:(NSString *)updateTitle
{
    hudObj.labelText = updateTitle;
}

// remove 
+(void)dismissHUD
{
    isPresent = false;
    
    AppDelegate * objAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideHUDForView:objAppDelegate.window animated:YES];
    
}
@end
