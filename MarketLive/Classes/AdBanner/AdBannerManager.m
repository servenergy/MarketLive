//
//  AdBannerManager.m
//  DragDrop
//
//  Created by BBIM1019 on 9/3/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "AdBannerManager.h"

@implementation AdBannerManager
@synthesize delegate;

static AdBannerManager * instance = nil;

+(AdBannerManager*) getInstance
{
    if (instance==nil)
    {
        instance=[[AdBannerManager alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}



-(BOOL) canShowBanner
{
    if([[NSFileManager defaultManager] fileExistsAtPath:sponsorListJSONPathKey])
    {
        NSString * sponsorListJSONString = [[NSString alloc] initWithContentsOfFile:sponsorListJSONPathKey encoding:NSUTF8StringEncoding error:NULL];
        
        if(sponsorListJSONString)
        {
            NSError * error;
            sponsorList = [NSJSONSerialization JSONObjectWithData:[sponsorListJSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            
            if(error == nil)
            {
                if([sponsorList count] > 0)
                {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}




-(NSArray *) getSponsorList
{
    return sponsorList;
}

-(void) checkForUpdates
{
    objAdBannerSponsorList = [AdBannerSponsorList getInstance];
    objAdBannerSponsorList.delegate = self;
    [objAdBannerSponsorList downloadSponsorList];
}

-(void) didSponsorImagesReceived : (NSArray *) sponsorArrayList;
{
    NSLog(@"Log 3 : %@", sponsorArrayList);
    
    
    NSMutableArray * tempSponsorArray = [[NSMutableArray alloc] init];
    
    for (NSString * imageName in sponsorArrayList)
    {
        //Slider1_41.png
        
        
        NSArray * hashSeperated = [imageName componentsSeparatedByString:@"_"];
        
        NSArray * dotSeperated = [[hashSeperated objectAtIndex:1] componentsSeparatedByString:@"."];
        
        NSString * vendorId = [dotSeperated objectAtIndex:0];
        
        NSMutableDictionary * objDictionary = [[NSMutableDictionary alloc] init];
        
        
        NSString * imageURLPath = [NSString stringWithFormat:@"http://www.mlive.co.in/upload/BanerImages/%@", imageName];
        
        
        [objDictionary setValue:vendorId forKey:@"banner_id"];
        [objDictionary setValue:@"20000101" forKey:@"start_date"];
        [objDictionary setValue:@"20500101" forKey:@"end_date"];
        [objDictionary setValue:@"2" forKey:@"banner_type"];
        [objDictionary setValue:@"5" forKey:@"target_media"];
        [objDictionary setValue:imageURLPath forKey:@"iphone-banner"];
        [objDictionary setValue:@"web" forKey:@"target_type"];
        [objDictionary setValue:@"5" forKey:@"duration"];
    
        [tempSponsorArray addObject:objDictionary];
    }
    
    sponsorList = tempSponsorArray;
    
    [self writeSponsorListFile];
}


-(void) getPathForContent : (NSString *) folderPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(void) writeSponsorListFile
{
    
    NSError * error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:sponsorList
                                                       options:kNilOptions
                                                         error:&error];
    
    
    if(error == nil)
    {
        [self getPathForContent:sponsorListJSONFolderPathKey];
        [jsonData writeToFile:sponsorListJSONPathKey atomically:NO];
        [self checkForSponsorImages: sponsorList];
    }
}


-(void) checkForSponsorImages:(NSArray *) sponsorArray
{
    sponsorList = sponsorArray;
    
    if(imageURLArray == nil)
        imageURLArray = [[NSMutableArray alloc] init];
    
    for (int iIndex = 0; iIndex < [sponsorList count]; iIndex++)
    {
        NSString * bannerID = [[sponsorList objectAtIndex:iIndex] objectForKey:bannerIDKey];
        
        NSString*  imagePath = bannerImagePathKey(bannerID);
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            NSString * imageURL = [[sponsorList objectAtIndex:iIndex] objectForKey:bannerImageBundlePathKey];
            
            NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
            
            [dictionary setObject:bannerID forKey:bannerIDKey];
            [dictionary setObject:imageURL forKey:bannerImageBundlePathKey];
            [imageURLArray addObject:dictionary];
        }
    }
    
    objSponsorImageDownloader = [SponsorImageDownloader getInstance];
    objSponsorImageDownloader.delegate = self;
    [objSponsorImageDownloader downloadSponsorImage];
}


-(void) setDownloadedImageToLocalStorage : (UIImage *) image imageName:(NSString *) imageName
{
    NSString * folderPath = [DocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"BannerImages"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * imagePath = [folderPath stringByAppendingPathComponent:imageName];
    
    NSLog(@"Image Saved : %@", imagePath);
    
    NSData *pngData = UIImagePNGRepresentation(image);
    
    [pngData writeToFile:imagePath atomically:YES];
}


#pragma mark ----- SponsorImageDownloader Delegate Method -----

-(NSInteger) numberOfSponsorImagesToDownload
{
    return [imageURLArray count];
}

-(NSDictionary *) getImageURLPathAtIndex: (NSInteger) index
{
    return  [imageURLArray objectAtIndex:index];
}

-(void) downloadingSponsorImage : (NSDictionary *) dictionary
{
    
}

-(void) downloadingSponsorCompleted : (NSDictionary *) dictionary
{
    
}

-(void) downloadingAllSponsorCompleted
{
    [delegate reloadView: sponsorList];
}



-(void) downloadingSponsorFailed : (NSDictionary *) dictionary
{
    
}

@end
