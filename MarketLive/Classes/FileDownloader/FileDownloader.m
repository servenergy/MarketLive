//
//  FileDownloader.m
//  AfnetworkingDemo
//
//  Created by BBIM1019 on 11/26/15.
//  Copyright © 2015 BBI. All rights reserved.
//

#import "FileDownloader.h"


@implementation FileDownloader
@synthesize delegate;
@synthesize progressDelegate;
@synthesize downloadTask, zipResumeData;
static FileDownloader * instance = nil;

+(FileDownloader*) sharedInstance
{
    if (instance==nil)
    {
        instance=[[FileDownloader alloc] init];
    }
    return instance;
}

-(id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

#pragma mark --------------------------- NSURLSession Delegate Methods ---------------------------


-(void) downloadFileWithURLString : (NSString * ) downloadVersion
{
    
    NSString * zipPathURL = zipPath(downloadVersion);
    
    NSURL * url = [NSURL URLWithString:zipPathURL];
    fileName = downloadVersion;
    self.downloadTask = [self.session downloadTaskWithURL:url];
    [self.downloadTask resume];
}

- (NSURLSession *)session {
    if (!_session)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [progressDelegate downloadingResumed];
    });
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"XXXX: %lld :: %lld", totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Download Finish : %@", [location absoluteString]);
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[location path]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressDelegate downloadingExtracting];
        });
        
        if([ZipUnzipManager unZipFileToLocationWithResult:[location path] toPath:DocumentsDirectory])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //[HUD addHUDWithText:[NSString stringWithFormat:@"Please wait... %@", fileName]];
                [HUD addHUDWithText:[NSString stringWithFormat:@"Please wait..."]];
            });
            
            [NSThread sleepForTimeInterval:2.0];
            
            DocumentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            
            NSString * categoryFilePath = [NSString stringWithFormat:@"%@/category.json", DocumentDirectory];
            NSString * vendorFilePath = [NSString stringWithFormat:@"%@/vendor.json", DocumentDirectory];
            
            
            NSError * error;
            NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DocumentDirectory error:&error];
            
            NSLog(@"%@", directoryContents);
            
            if([[NSFileManager defaultManager] fileExistsAtPath:categoryFilePath])
            {
                
                [[CategoryManager sharedInstance] deleteAllCategories];
                
                NSString * jsonString = [[NSString alloc] initWithContentsOfFile:categoryFilePath encoding:NSUTF8StringEncoding error:nil];
                
                NSArray * categoryArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
                
                for (NSDictionary * dictionary in categoryArray) {
                    MLCategory * objCategory = [[MLCategory alloc] initWithDictionary:dictionary];
                    [[CategoryManager sharedInstance] updateCategory:objCategory];
                }
            }
            
            if([[NSFileManager defaultManager] fileExistsAtPath:vendorFilePath])
            {
                [[VendorManager sharedInstance] deleteAllLocalVendor];

                NSString * jsonString = [[NSString alloc] initWithContentsOfFile:vendorFilePath encoding:NSUTF8StringEncoding error:nil];
                
                NSArray * vendorArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
                
                for (NSDictionary * dictionary in vendorArray) {
                    Vendor * objVendor = [[Vendor alloc] initWithDictionary:dictionary];
                    [[VendorManager sharedInstance] updateVendor:objVendor];
                }
            }
            
            if (fileName) {
                [[NSUserDefaults standardUserDefaults] setValue:fileName forKey:@"DB_Version"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD dismissHUD];
            });
        }
    }
    else
    {
        NSLog(@"Zip not exist");
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(task.state != NSURLSessionTaskStateCompleted)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        [[FileDownloader sharedInstance].progressDelegate downloadingCanceled];
        });
    }
    else
    {
        if(error.code == -1008)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Resource Unavailable" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    }
}

@end
