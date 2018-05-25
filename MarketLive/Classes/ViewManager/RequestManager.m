//
//  RequestManager.m
//  Bimber
//
//  Created by Vinod on 28/11/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "RequestManager.h"


@implementation RequestManager

+(void) pushViewWithStoryboardIdentifier : (NSString *) identifier {
    
    AppDelegate * objAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    if ([identifier isEqualToString:@"InfoViewController"]) {
        
        [objAppDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
  else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        @try
        {
            id objViewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
            
            if (![[objAppDelegate.objNavigationViewController topViewController] isKindOfClass:[objViewController class]])
            {
                [objAppDelegate.objNavigationViewController pushViewController:objViewController animated:YES];
            }
        
        }
        @catch (NSException *exception)
        {
            NSLog(@"No storyboard identifier found : %@", identifier);
        }
    }
}

+(void) presentViewWithStoryboardIdentifier : (NSString *) identifier
{
    AppDelegate * objAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    

   @try
    {
        id objViewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
        [objAppDelegate.objNavigationViewController presentViewController:objViewController animated:YES completion:nil];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"No storyboard identifier found : %@", identifier);
    }
}

@end
