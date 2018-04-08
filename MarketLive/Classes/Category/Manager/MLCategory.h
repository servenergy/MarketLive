//
//  MLCategory.h
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCategory : NSObject

@property (nonatomic) NSInteger          vendor_id;
@property (nonatomic, strong) NSString * vendor_name;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * pincode;
@property (nonatomic, strong) NSString * phone_number;
@property (nonatomic, strong) NSString * email;
@property (nonatomic) NSInteger          category_id;
@property (nonatomic, strong) NSString * subscription_from;
@property (nonatomic, strong) NSString * subscription_to;
@property (nonatomic, strong) NSString * job_description;
@property (nonatomic, strong) NSString * vendor_job;
@property (nonatomic, strong) NSString * tags;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic) NSInteger          status;
@property (nonatomic) NSInteger          language_id;

-(id) initWithDictionary : (NSDictionary *) dictionary;

@end
