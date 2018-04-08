//
//  CustomCollectionCell.h
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionCell : UICollectionViewCell
{
    __weak IBOutlet UIButton * btnCallVendor;
    __weak IBOutlet UIButton * btnLocateVendor;
    __weak IBOutlet UIButton * btnShareVendor;
    __weak IBOutlet UIButton * btnFavoriteVendor;
    __weak IBOutlet UIButton * btnRateVendor;
    __weak IBOutlet NSLayoutConstraint * contentImageView;
    __weak IBOutlet NSLayoutConstraint * imageViewHeightConstraint;
    
    Vendor * objVendor;
    
}

-(void) setVendor : (Vendor *) vendor;


@property (nonatomic, strong) IBOutlet UIButton * vendorName;
@property (nonatomic, strong) IBOutlet UIImageView * vendorImage;
@property (nonatomic, strong) IBOutlet UIButton * vendorAddress;

@end
