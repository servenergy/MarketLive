//
//  NewsList.m
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "NewsList.h"

@implementation NewsList
@synthesize delegate;

static NewsList * instance = nil;

+(NewsList*) getInstance
{
    if (instance==nil)
    {
        instance=[[NewsList alloc] init];
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

-(void) downloadNewsList
{
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:[NSURL URLWithString:newsURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if (error) {
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [delegate downloadFail];
                                                  });
                                              }
                                              else
                                              {
                                                  if (data == nil) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [delegate downloadFail];
                                                      });
                                                  }
                                                  else
                                                  {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          NSError * error;
                                                          NSArray * newsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                                          
                                                          NSLog(@"newsArray : %@", newsArray);
                                                          
                                                          [data writeToFile:newsJSONFolderPathKey atomically:NO];
                                                          
                                                          [delegate downloadSuccess];
                                                      });
                                                      
                                                  }
                                              }
                                          }];
    [downloadTask resume];
}
@end
