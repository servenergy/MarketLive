//
//  DataChange.m
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "DataChange.h"


@implementation DataChange
@synthesize delegate;

static DataChange * instance = nil;

+(DataChange*) getInstance
{
    if (instance==nil)
    {
        instance=[[DataChange alloc] init];
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

-(void) checkForDataChange
{
    /*
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [[session dataTaskWithURL:[NSURL URLWithString:dataTrackURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error)
                {
                    if (error)
                    {
                        [delegate dataChanged:NO :nil];
                    }
                    else
                    {
                        if (data == nil) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [delegate dataChanged:NO :nil];
                            });
                        }
                        else
                        {
                            NSError * error;
                            NSArray * dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                            
                            if (dataArray) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    NSLog(@"dataArray : %@", dataArray);
                                    
                                    NSString * currentDBVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"DB_Version"];
                                    
                                    NSString * serverDBVersion = [[dataArray objectAtIndex:0] valueForKey:@"DB_Version"];
                                    
                                    NSLog(@"%@ <<>> %@", currentDBVersion, serverDBVersion);
                                    
                                    if (![currentDBVersion isEqualToString:serverDBVersion]) {
                                        
                                        [delegate dataChanged:YES :[[dataArray objectAtIndex:0] valueForKey:@"DB_Version"]];
                                    }
                                    else
                                    {
                                        [delegate dataChanged:NO :nil];
                                    }
                                    
                                });
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [delegate dataChanged:NO :nil];
                                });
                            }
                        }
                    }
                }
                else
                {
                    [delegate dataChanged:NO :nil];
                }
                
            }] resume];
     
     */
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataTrackURL]];
    
    if (data == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate dataChanged:NO :nil];
        });
    }
    else
    {
        NSError * error;
        NSArray * dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (dataArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"dataArray : %@", dataArray);
                
                NSString * currentDBVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"DB_Version"];
                
                NSString * serverDBVersion = [[dataArray objectAtIndex:0] valueForKey:@"DB_Version"];
                
                NSLog(@"%@ <<>> %@", currentDBVersion, serverDBVersion);
                
                if (![currentDBVersion isEqualToString:serverDBVersion]) {
                    
                    [delegate dataChanged:YES :[[dataArray objectAtIndex:0] valueForKey:@"DB_Version"]];
                }
                else
                {
                    [delegate dataChanged:NO :nil];
                }
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate dataChanged:NO :nil];
            });
        }
    }
}

@end
