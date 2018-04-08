//
//  BannerTableCell.m
//  MarketLive
//
//  Created by Vinod on 26/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "BannerTableCell.h"
#import "BannerCollectionDetailCell.h"


@implementation BannerTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark --------------   UITableView Datasource and Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bannerCell";
    BannerCollectionDetailCell * collectionViewCell = (BannerCollectionDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    UIImage * image;
    
    image = [UIImage imageNamed:[NSString stringWithFormat:@"Slider%ld", indexPath.row + 1]];
    
    
    collectionViewCell.vendorImage.image = image;
    
    return collectionViewCell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenWidth - 8, 80);
}


@end
