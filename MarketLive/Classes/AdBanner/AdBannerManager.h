//
//  AdBannerManager.h
//  DragDrop
//
//  Created by BBIM1019 on 9/3/15.
//  Copyright (c) 2015 BBI. All rights reserved. Changes made to check on github
//
//  Check this changes @ 6pm IST

#import <Foundation/Foundation.h>
#import "SponsorImageDownloader.h"
#import "AdBannerSponsorList.h"


@protocol AdBannerManagerDelegate <NSObject>
@required

-(void) showView;
-(void) reloadView: (NSArray *) sponsorList;

@end;

@interface AdBannerManager : NSObject <SponsorImageDownloaderDelegate, AdBannerSponsorListDelegate, SponsorImageDownloaderDelegate>
{
    NSArray * sponsorList;
    AdBannerSponsorList * objAdBannerSponsorList;
    SponsorImageDownloader * objSponsorImageDownloader;
    NSMutableArray * imageURLArray;
}

+(AdBannerManager*) getInstance;

-(BOOL) canShowBanner;
-(NSArray *) getSponsorList;
-(void) checkForUpdates;
-(void) checkForSponsorImagesMissing;
-(NSInteger) numberOfBanner;


@property (nonatomic, weak) id <AdBannerManagerDelegate> delegate;

@end
