//
//  CustomHomeCollectionCell.h
//  MarketLive
//
//  Created by Vinod on 17/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHomeCollectionCell : UICollectionViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *categoryTitle;
@property (weak, nonatomic) IBOutlet UIButton *categoryImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;

@end
