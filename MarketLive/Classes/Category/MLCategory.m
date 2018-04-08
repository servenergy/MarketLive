//
//  MLCategory.m
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "MLCategory.h"

@implementation MLCategory

-(id) initWithDictionary : (NSDictionary *) dictionary
{
    self.category_id = [[dictionary valueForKey:tbl_category_category_id] integerValue];
    self.category_name = [dictionary valueForKey:tbl_category_category_name];
    self.parent_category_id = [[dictionary valueForKey:tbl_category_parent_category_id] integerValue];
    self.language_id = [[dictionary valueForKey:tbl_category_language_id] integerValue];
    self.status = [[dictionary valueForKey:tbl_category_status] integerValue];
    
    return self;
}

@end
