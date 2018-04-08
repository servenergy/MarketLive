//
//  NewsManager.h
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"
#import "NewsChange.h"
#import "NewsList.h"

@protocol NewsManagerDelegate <NSObject>
@required

-(void) reloadView: (NSArray *) sponsorList;

@end;

@interface NewsManager : NSObject <NewsChangeDelegate, NewsListDelegate>

-(NSArray *) getNews;

+(NewsManager*) getInstance;

-(void) checkForUpdates;

@property (nonatomic, weak) id <NewsManagerDelegate> delegate;

@end
