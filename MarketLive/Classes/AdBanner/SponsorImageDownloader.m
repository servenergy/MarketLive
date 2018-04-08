//
//  SponsorImageDownloaded.m
//  DragDrop
//
//  Created by BBIM1019 on 9/3/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "SponsorImageDownloader.h"




@implementation SponsorImageDownloader
@synthesize delegate;

static SponsorImageDownloader * instance = nil;

+(SponsorImageDownloader*) getInstance
{
    if (instance==nil)
    {
        instance=[[SponsorImageDownloader alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        imageURLArray = [[NSMutableArray alloc] init];
    }
    return self;
}




-(void) downloadSponsorImage
{
    NSInteger imageCount = [delegate numberOfSponsorImagesToDownload];
    
    for (int iIndex = 0; iIndex < imageCount; iIndex++)
    {
        [imageURLArray addObject:[delegate getImageURLPathAtIndex:iIndex]];
    }
    
    
    for (int iIndex = 0; iIndex < [imageURLArray count]; iIndex++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL * url = [NSURL URLWithString:[[imageURLArray objectAtIndex:iIndex] objectForKey:bannerImageBundlePathKey]];
            
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            NSString * bannerID = [[imageURLArray objectAtIndex:iIndex] objectForKey:bannerIDKey];
            
            NSData *pngData = UIImagePNGRepresentation(image);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString*  imageFolderPath = bannerImageFolderPathKey(bannerID);
                
                NSString*  imagePath = bannerImagePathKey(bannerID);
                
                [self getPathForContent:imageFolderPath];
                [pngData writeToFile:imagePath atomically:YES];
                [delegate downloadingSponsorCompleted:[imageURLArray objectAtIndex:iIndex]];
                
                if(iIndex == [imageURLArray count] -1)
                {
                    [delegate downloadingAllSponsorCompleted];
                }
            });
        });
    }
    
}

-(void) getPathForContent : (NSString *) folderPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}







@end
