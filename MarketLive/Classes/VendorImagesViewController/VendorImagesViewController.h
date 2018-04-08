//
//  VendorImagesViewController.h
//  MarketLive
//
//  Created by Vinod on 26/06/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorImagesViewController : UIViewController
{
    __weak IBOutlet UIImageView * imgVendorImage;
}

@property (nonatomic, strong) NSString * vendorImageName;

@end
