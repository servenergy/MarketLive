//
//  BannerCollectionCell.h
//  MarketLive
//
//  Created by Vinod on 26/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerCollectionCell : UICollectionViewCell <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSTimer *aTimer;
    int currentIndex;
}

@property (nonatomic, strong) IBOutlet UICollectionView * objBannerCollection;
-(void) setTimer;

@end
