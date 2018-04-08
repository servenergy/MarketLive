//
//  RootVendorViewController.h
//  MarketLive
//
//  Created by Vinod on 25/06/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootVendorViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (readonly, strong, nonatomic) NSArray *pageData;

@end
