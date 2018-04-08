//
//  VendorImagesViewController.m
//  MarketLive
//
//  Created by Vinod on 26/06/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "VendorImagesViewController.h"

@interface VendorImagesViewController ()

@end

@implementation VendorImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Vendor * objVendor = [NavigationHolder sharedInstance].selectedVendor;
    
    NSString * imagePath = [DocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"VendorImage/%ld/%@", objVendor.vendor_id, self.vendorImageName]];
    
    UIImage * vendorImage = [[UIImage alloc] initWithContentsOfFile:imagePath];

    if (vendorImage)
    {
        imgVendorImage.image = vendorImage;
    }
    else
    {
        [self downloadVendorImage];
    }
}



-(void) downloadVendorImage
{
    
    Vendor * objVendor = [NavigationHolder sharedInstance].selectedVendor;
    
    NSString * imageURLPath = [NSString stringWithFormat:@"http://www.mlive.co.in/upload/%ld/%@", objVendor.vendor_id, self.vendorImageName];
    
    imageURLPath = [imageURLPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:imageURLPath];
    
    // 2
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                              if (error == nil)
                                              {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      UIImage * image = [UIImage imageWithData:data];
                                                      imgVendorImage.image = image;
                                                      [self setDownloadedImageToLocalStorage:image vendorId:objVendor.vendor_id];
                                                  });
                                              }
                                          }];
    
    // 3
    [downloadTask resume];
}

-(void) setDownloadedImageToLocalStorage : (UIImage *) image vendorId : (NSInteger) vendorId
{
    NSString * folderPath = [DocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"VendorImage/%ld", vendorId]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * imagePath = [folderPath stringByAppendingPathComponent:self.vendorImageName];
    
    NSLog(@"Image Saved : %@", imagePath);
    
    NSData *pngData = UIImagePNGRepresentation(image);
    
    [pngData writeToFile:imagePath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didVendorImageDownloaded" object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) doneClicked:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
