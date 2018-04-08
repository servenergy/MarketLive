//
//  ImageDownloader.h
//  MarketLive
//
//  Created by Vinod on 30/07/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate <NSObject>

-(void) didVendorImagesReceived : (NSArray *) imageArray;

@end

@interface ImageDownloader : NSObject

+(ImageDownloader*) sharedInstance;

-(void) downloadImagesOfVendorWithVendorId : (Vendor *) vendor;

@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

@end
