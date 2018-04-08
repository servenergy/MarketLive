//
//  News.m
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "News.h"

@implementation News

-(id) initWithDictionary : (NSDictionary *) dictionary
{
    self.newsID = [[dictionary valueForKey:@"news_id"] integerValue];
    self.newsDate = [dictionary valueForKey:@"news_date"];
    self.newsTitle = [dictionary valueForKey:@"title"];
    self.newsDescription = [dictionary valueForKey:@"description"];
    self.newsStatus = [[dictionary valueForKey:@"status"] integerValue];
    self.newsReadStatus = [[dictionary valueForKey:@"read_status"] integerValue];
    
    return self;
}

@end
