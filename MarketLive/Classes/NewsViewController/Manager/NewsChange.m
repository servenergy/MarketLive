//
//  NewsChange.m
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "NewsChange.h"

@implementation NewsChange
@synthesize delegate;

static NewsChange * instance = nil;

+(NewsChange*) getInstance
{
    if (instance==nil)
    {
        instance=[[NewsChange alloc] init];
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

-(void) checkForNewsChange
{
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:[NSURL URLWithString:newsTrackURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if (error) {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [delegate newsChanged:NO];
                                                  });
                                              }
                                              else
                                              {
                                                  if (data == nil) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [delegate newsChanged:NO];
                                                      });
                                                  }
                                                  else
                                                  {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          [delegate newsChanged:YES];
                                                      });
                                                      
                                                  }
                                              }
                                          }];
    [downloadTask resume];
}


@end
