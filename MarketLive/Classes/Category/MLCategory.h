//
//  MLCategory.h
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCategory : NSObject

@property (nonatomic) NSInteger          category_id;
@property (nonatomic, strong) NSString * category_name;
@property (nonatomic) NSInteger          parent_category_id;
@property (nonatomic) NSInteger          language_id;
@property (nonatomic) NSInteger          status;

-(id) initWithDictionary : (NSDictionary *) dictionary;

@end
