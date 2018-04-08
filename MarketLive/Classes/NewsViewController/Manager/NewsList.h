//
//  NewsList.h
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NewsListDelegate <NSObject>
@required

-(void) downloadSuccess;
-(void) downloadFail;

@end;

@interface NewsList : NSObject

+(NewsList*) getInstance;

@property (nonatomic, weak) id <NewsListDelegate> delegate;

-(void) downloadNewsList;
@end
