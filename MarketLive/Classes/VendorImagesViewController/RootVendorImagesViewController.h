//
//  RootVendorImagesViewController.h
//  MarketLive
//
//  Created by Vinod on 26/06/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootVendorImagesViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    __weak IBOutlet UIButton * btnDone;
    __weak IBOutlet UIPageControl * pageControl;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageData;

@end
