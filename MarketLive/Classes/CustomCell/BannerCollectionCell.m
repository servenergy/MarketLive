//
//  BannerCollectionCell.m
//  MarketLive
//
//  Created by Vinod on 26/01/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "BannerCollectionCell.h"
#import "BannerCollectionDetailCell.h"

@implementation BannerCollectionCell


#pragma mark --------------   UICollectionView Datasource and Delegate methods

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
    //return CGSizeMake(screenWidth - 8, 80);
    //New height
    return CGSizeMake(screenWidth - 8, 120);
}

-(void) setTimer
{
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(aTime) userInfo:nil repeats:YES];

}

-(void) aTime
{
    if(currentIndex == 5)
    {
        currentIndex = 0;
    }
    
    [self.objBannerCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex++ inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
}

@end
