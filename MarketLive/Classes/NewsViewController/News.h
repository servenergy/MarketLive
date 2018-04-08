//
//  News.h
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic) NSInteger          newsID;
@property (nonatomic, strong) NSString * newsTitle;
@property (nonatomic, strong) NSString * newsDescription;
@property (nonatomic, strong) NSString * newsDate;
@property (nonatomic) NSInteger          newsStatus;
@property (nonatomic) NSInteger          newsReadStatus;

-(id) initWithDictionary : (NSDictionary *) dictionary;

@end
