//
//  FileDownloader.h
//  AfnetworkingDemo
//
//  Created by BBIM1019 on 11/26/15.
//  Copyright © 2015 BBI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Staring = 1,
    Running = 2,
    Paused = 3,
    Completed = 4
}DownloadingState;

@protocol FileDownloaderDelegate <NSObject>
@required
-(void) downloadingStarted;
@end

@protocol FileDownloaderProgressDelegate <NSObject>
@required

-(void) updateProgress : (long long) totalBytesRead :(long long) totalBytesExpectedToRead :(int) filesRemaining;
-(void) downloadingStarted;
-(void) downloadingPausing;
-(void) downloadingPaused;
-(void) downloadingResumed;
-(void) downloadingCanceled;
-(void) downloadingExtracting;
-(void) waitingForInternet;
-(void) downloadingComplete;
-(void) downloadItemQueueEmpty;
@end


@interface FileDownloader : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
{
    NSString * DocumentDirectory;
    long long bytesDownloaded;
    long long currSessionBytesDownloaded;
    NSURLSession *_session;
    DownloadingState state;
    Reachability * reachability;
    
    NSString * fileName;
}

+(FileDownloader*) sharedInstance;

@property (nonatomic,strong) id <FileDownloaderDelegate> delegate;
@property (nonatomic,strong) id <FileDownloaderProgressDelegate> progressDelegate;


@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData * zipResumeData;

-(void) downloadFileWithURLString : (NSString * ) downloadVersion;



@end
