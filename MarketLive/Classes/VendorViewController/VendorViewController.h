//
//  VendorViewController.h
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorViewController : UIViewController
{
    
    
    __weak IBOutlet UIButton * vendorName;
    __weak IBOutlet UIButton * vendorImage;
    __weak IBOutlet UIButton * vendorAddress;
    
    __weak IBOutlet UIButton * btnCallVendor;
    __weak IBOutlet UIButton * btnLocateVendor;
    __weak IBOutlet UIButton * btnShareVendor;
    __weak IBOutlet UIButton * btnFavoriteVendor;
    __weak IBOutlet UIButton * btnWebsiteUrl;
    
    __weak IBOutlet NSLayoutConstraint * contentImageView;
    __weak IBOutlet NSLayoutConstraint * imageViewHeightConstraint;
    
}

@property (nonatomic, strong) Vendor * vendor;

@end
