//
//  NewsManager.m
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "NewsManager.h"

@implementation NewsManager
@synthesize delegate;

static NewsManager * instance = nil;

+(NewsManager*) getInstance
{
    if (instance==nil)
    {
        instance=[[NewsManager alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [NewsChange getInstance].delegate = self;
        [[NewsChange getInstance] checkForNewsChange];
    }
    return self;
}


-(NSArray *) getNews
{
    if([[NSFileManager defaultManager] fileExistsAtPath:newsJSONFolderPathKey])
    {
        NSString * jsonString = [[NSString alloc] initWithContentsOfFile:newsJSONFolderPathKey encoding:NSUTF8StringEncoding error:nil];
        
        NSArray * newsArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
        
        NSMutableArray * newsMutableArray = [NSMutableArray new];
        
        for (NSDictionary * dictionary in newsArray) {
            News * objNews = [[News alloc] initWithDictionary:dictionary];
            [newsMutableArray addObject:objNews];
        }
        return newsMutableArray;
    }
    else
    {
        return nil;
    }
}

-(void) addNewToList : (News *) news
{
    if([[NSFileManager defaultManager] fileExistsAtPath:newsJSONFolderPathKey])
    {
        NSString * jsonString = [[NSString alloc] initWithContentsOfFile:newsJSONFolderPathKey encoding:NSUTF8StringEncoding error:nil];
        
        NSArray * newsArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:NULL];
    }
}

-(void) checkForUpdates
{
}


-(void) newsChanged : (BOOL) changed
{
    if (changed)
    {
        NSLog(@"News Changed");
        [NewsList getInstance].delegate = self;
        [[NewsList getInstance] downloadNewsList];
    }
    else
    {
        NSLog(@"News not Changed");
    }
}

-(void) downloadSuccess
{
    NSLog(@"News downloadSuccess");
}

-(void) downloadFail
{
    NSLog(@"News downloadFail");
}





@end
