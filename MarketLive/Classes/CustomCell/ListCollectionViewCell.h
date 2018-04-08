//
//  ListCollectionViewCell.h
//  MarketLive
//
//  Created by Vinod on 27/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCollectionViewCell : UICollectionViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@end
