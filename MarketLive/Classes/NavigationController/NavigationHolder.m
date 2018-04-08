//
//  NavigationHolder.m
//  MarketLive
//
//  Created by Vinod on 06/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "NavigationHolder.h"

@implementation NavigationHolder
@synthesize viewControllerDictionary;

static NavigationHolder * instance = nil;

+(NavigationHolder*) sharedInstance{
    if(!instance)
    {
        instance = [[NavigationHolder alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Navigation" ofType:@"json"];
        
        NSString * jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        
        self.viewControllerDictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
    }
    return self;
}

@end
