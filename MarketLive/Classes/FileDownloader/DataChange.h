//
//  DataChange.h
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataChangeDelegate <NSObject>
@required

-(void) dataChanged : (BOOL) changed :(NSString *) DBVersion;

@end;

@interface DataChange : NSObject

+(DataChange*) getInstance;

@property (nonatomic, weak) id <DataChangeDelegate> delegate;

-(void) checkForDataChange;


@end
