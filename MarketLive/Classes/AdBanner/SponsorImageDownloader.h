//
//  SponsorImageDownloaded.h
//  DragDrop
//
//  Created by BBIM1019 on 9/3/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SponsorImageDownloaderDelegate <NSObject>
@required

-(NSInteger) numberOfSponsorImagesToDownload;
-(NSDictionary *) getImageURLPathAtIndex : (NSInteger) index;
-(void) downloadingSponsorImage : (NSDictionary *) dictionary;
-(void) downloadingSponsorCompleted : (NSDictionary *) dictionary;
-(void) downloadingAllSponsorCompleted;
-(void) downloadingSponsorFailed : (NSDictionary *) dictionary;

@end;


@interface SponsorImageDownloader : NSObject
{
    NSMutableArray * imageURLArray;
}

+(SponsorImageDownloader*) getInstance;

-(void) downloadSponsorImage;

@property (nonatomic, weak) id <SponsorImageDownloaderDelegate> delegate;

@end
