//
//  BannerTableCell.h
//  MarketLive
//
//  Created by Vinod on 26/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerTableCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}

@property (nonatomic, strong) IBOutlet UICollectionView * objBannerCollection;

@end
