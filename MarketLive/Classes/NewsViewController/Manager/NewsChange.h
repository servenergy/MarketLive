//
//  NewsChange.h
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NewsChangeDelegate <NSObject>
@required

-(void) newsChanged : (BOOL) changed;

@end;

@interface NewsChange : NSObject

+(NewsChange*) getInstance;

@property (nonatomic, weak) id <NewsChangeDelegate> delegate;

-(void) checkForNewsChange;

@end
