//
//  VendorViewController.m
//  MarketLive
//
//  Created by Vinod on 07/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "VendorViewController.h"
#import "CustomCollectionCell.h"
#import "ImageDownloader.h"
#import "RootVendorImagesViewController.h"
#import <MapKit/MapKit.h>



@interface VendorViewController () <ImageDownloaderDelegate>
{
    NSArray * vendorListArray;
    Vendor * currentVendor;
}

@end

@implementation VendorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [vendorName setTitle:self.vendor.vendor_name forState:UIControlStateNormal];
    [vendorAddress setTitle:self.vendor.address forState:UIControlStateNormal];
    
    
    
    if([[FavoriteManager sharedInstance] isVendorFavorite:self.vendor languageID:selectedLanguage])
    {
        [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"BookmarkFill"] forState:UIControlStateNormal];
    }
    else
    {
        [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"Bookmark"] forState:UIControlStateNormal];
    }
    
    
    [[ImageDownloader sharedInstance] setDelegate:self];
    [[ImageDownloader sharedInstance] downloadImagesOfVendorWithVendorId: self.vendor];
    
}

-(void) reloadVendorImage
{
    NSArray * imageArray = [[VendorManager sharedInstance] getVendorImages:self.vendor];
    
    
    if ([imageArray count] > 0)
    {
        NSDictionary * dictionary = [imageArray objectAtIndex:0];
        
        NSString * imagePath = [DocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"VendorImage/%ld/%@", self.vendor.vendor_id, [dictionary valueForKey:@"image_name"]]];
        
        UIImage * vendorImg = [[UIImage alloc] initWithContentsOfFile:imagePath];
        
        if (vendorImg)
        {
            [vendorImage setImage:vendorImg forState:UIControlStateNormal];
        }
        else
        {
            [self downloadVendorImage:[dictionary valueForKey:@"image_name"]];
        }
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadVendorImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didVendorImageDownloaded:)
                                                 name:@"didVendorImageDownloaded"
                                               object:nil];
}

-(void) didVendorImageDownloaded : (id) sender
{
    [self reloadVendorImage];
}


-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) downloadVendorImage : (NSString *) imageName
{
    
    Vendor * objVendor = [NavigationHolder sharedInstance].selectedVendor;
    
    NSString * imageURLPath = [NSString stringWithFormat:@"http://www.mlive.co.in/upload/%ld/%@", objVendor.vendor_id, imageName];
    
    imageURLPath = [imageURLPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:imageURLPath];
    
    NSLog(@"Downloading Image : %@", imageName);
    
    // 2
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                              if (error == nil)
                                              {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      UIImage * image = [UIImage imageWithData:data];
                                                      [self setDownloadedImageToLocalStorage:image vendorId:objVendor.vendor_id imageName:imageName];
                                                      [self reloadVendorImage];
                                                  });
                                              }
                                          }];
    
    // 3
    [downloadTask resume];
}

-(void) setDownloadedImageToLocalStorage : (UIImage *) image vendorId : (NSInteger) vendorId imageName : (NSString *) imageName
{
    NSString * folderPath = [DocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"VendorImage/%ld", vendorId]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * imagePath = [folderPath stringByAppendingPathComponent:imageName];
    
    NSLog(@"Image Saved : %@", imagePath);
    
    NSData *pngData = UIImagePNGRepresentation(image);
    
    [pngData writeToFile:imagePath atomically:YES];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didVendorImageDownloaded" object:self];
    
}

-(IBAction) btnVendorOptionClicked:(id)sender
{
    if(sender == btnCallVendor)
    {
        
        NSString * telephoneNumber = [NSString stringWithFormat:@"tel://%@", self.vendor.phone_number];
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:telephoneNumber]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneNumber]];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Unable to open dialer" message:[NSString stringWithFormat:@"Call - %@", self.vendor.phone_number] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        
    }
    else if(sender == btnLocateVendor)
    {
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate =
            CLLocationCoordinate2DMake([self.vendor.latitude floatValue], [self.vendor.longitude floatValue]);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:self.vendor.vendor_name];
            // Pass the map item to the Maps app
            [mapItem openInMapsWithLaunchOptions:nil];
        }
        
    }
    else if(sender == btnShareVendor)
    {
        
        
        NSString *shareText = [NSString stringWithFormat:@"%@, %@, %@", self.vendor.vendor_name, self.vendor.address, self.vendor.phone_number];
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
        if([[FavoriteManager sharedInstance] isVendorFavorite:self.vendor languageID:selectedLanguage])
        {
            [[FavoriteManager sharedInstance] deleteFavoriteWithVendor:self.vendor languageID:selectedLanguage];
            [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"Bookmark"] forState:UIControlStateNormal];
        }
        else
        {
            [[FavoriteManager sharedInstance] addFavoriteWithVendor:self.vendor languageID:selectedLanguage];
            [btnFavoriteVendor setBackgroundImage:[UIImage imageNamed:@"BookmarkFill"] forState:UIControlStateNormal];
        }
    }
    else if(sender == btnWebsiteUrl)
    {
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:currentVendor.website_url]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentVendor.website_url]];
        }
    }
    else if(sender == vendorImage)
    {
        
        [NavigationHolder sharedInstance].selectedVendor = self.vendor;
        
        NSArray * imageArray = [[[VendorManager sharedInstance] getVendorImages:self.vendor] valueForKey:@"image_name"];
        

        if([imageArray count] > 0)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            RootVendorImagesViewController * objViewController = [storyboard instantiateViewControllerWithIdentifier:@"RootVendorImagesViewController"];
            objViewController.pageData = imageArray;
            
            [self.navigationController presentViewController:objViewController animated:YES completion:nil];
        }
    }
}

-(void) didVendorImagesReceived : (NSArray *) imageArray
{
    NSLog(@"Image Array : %@", imageArray);
    
    [[VendorManager sharedInstance] deleteAllVendorImagesWithVendorId:self.vendor];
    
    for (NSString * imageString in imageArray)
    {
        NSArray * splitString = [imageString componentsSeparatedByString:@"_"];
        
        if([splitString count] == 3)
        {
            NSString * vendorId = [splitString objectAtIndex:1];
            NSInteger index = [imageArray indexOfObject:imageString];
            [[VendorManager sharedInstance] addVendorImage:vendorId imageName:imageString sequence:index];
        }
    }
    
    [self reloadVendorImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
