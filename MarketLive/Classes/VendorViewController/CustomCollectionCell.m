//
//  CustomCollectionCell.m
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "CustomCollectionCell.h"

@implementation CustomCollectionCell


-(void) setVendor : (Vendor *) vendor
{
    objVendor = vendor;
    
    [self.vendorName setTitle:objVendor.vendor_name forState:UIControlStateNormal];
    [self.vendorAddress setTitle:objVendor.address forState:UIControlStateNormal];
    
    NSString * imageName = [NSString stringWithFormat:@"vendor_%d", (int)vendor.vendor_id];
    UIImage * image = [UIImage imageNamed:imageName];
    
    if (image) {
        self.vendorImage.image = image;
    }
    else
    {
        NSLog(@"Vendor Image Not Found");
    }
    
    if([[FavoriteManager sharedInstance] isVendorFavorite:objVendor languageID:selectedLanguage])
    {
        [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"BookmarkFill"] forState:UIControlStateNormal];
    }
    else
    {
        [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"Bookmark"] forState:UIControlStateNormal];
    }
    
}

-(IBAction) btnVendorOptionClicked:(id)sender
{
    if(sender == btnCallVendor)
    {
        
         NSString * telephoneNumber = [NSString stringWithFormat:@"tel://%@", objVendor.phone_number];
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:telephoneNumber]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneNumber]];
        }
        else
        {
            NSLog(@"Unable to open dialer");
        }
        
    }
    else if(sender == btnLocateVendor)
    {
        //latitude:@"18.647358" longitude:@"73.772037"]]
        
        NSString * urlString = @"http://maps.apple.com/?ll=18.647358,73.772037";
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        
    }
    else if(sender == btnShareVendor)
    {
        
        
        NSString *shareText = [NSString stringWithFormat:@"%@, %@, %@", objVendor.vendor_name, objVendor.address, objVendor.phone_number];
        NSURL *shareURL = [NSURL URLWithString:@"tel"];
        NSArray *itemsToShare = @[shareText, shareURL];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        
        
        AppDelegate * objAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if(__IS_IPAD)
        {
            [objAppDelegate.objNavigationViewController.splitViewController presentViewController:activityVC animated:YES completion:nil];
        }
        else
        {
            [objAppDelegate.objNavigationViewController presentViewController:activityVC animated:YES completion:nil];
        }
    }
    else if(sender == btnFavoriteVendor)
    {
        if([[FavoriteManager sharedInstance] isVendorFavorite:objVendor languageID:selectedLanguage])
        {
            [[FavoriteManager sharedInstance] deleteFavoriteWithVendor:objVendor languageID:selectedLanguage];
            [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"Bookmark"] forState:UIControlStateNormal];
        }
        else
        {
            [[FavoriteManager sharedInstance] addFavoriteWithVendor:objVendor languageID:selectedLanguage];
            [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"BookmarkFill"] forState:UIControlStateNormal];
        }
    }
    else if(sender == btnRateVendor)
    {
        
    }
}

@end
