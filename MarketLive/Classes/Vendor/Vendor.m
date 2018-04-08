//
//  Vendor.m
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "Vendor.h"

@implementation Vendor

-(id) initWithDictionary : (NSDictionary *) dictionary
{
    self.vendor_id = [[dictionary valueForKey:tbl_vendor_vendor_id] integerValue];
    self.vendor_name = [dictionary valueForKey:tbl_vendor_vendor_name];
    self.address = [dictionary valueForKey:tbl_vendor_address];
    self.pincode = [dictionary valueForKey:tbl_vendor_pincode];
    self.phone_number = [dictionary valueForKey:tbl_vendor_phone_number];
    self.website_url = [dictionary valueForKey:tbl_vendor_website_url];
    self.email = [dictionary valueForKey:tbl_vendor_email];
    self.category_id = [[dictionary valueForKey:tbl_vendor_category_id] integerValue];
    self.subscription_from = [dictionary valueForKey:tbl_vendor_subscription_from];
    self.subscription_to = [dictionary valueForKey:tbl_vendor_subscription_to];
    self.job_description = [dictionary valueForKey:tbl_vendor_job_description];
    self.vendor_job = [dictionary valueForKey:tbl_vendor_vendor_job];
    self.tags = [dictionary valueForKey:tbl_vendor_tags];
    self.longitude = [dictionary valueForKey:tbl_vendor_longitude];
    self.latitude = [dictionary valueForKey:tbl_vendor_latitude];
    self.status = [[dictionary valueForKey:tbl_vendor_status] integerValue];
    self.is_subscribed = [[dictionary valueForKey:tbl_is_subscribed] boolValue];
    self.membership_type = [[dictionary valueForKey:tbl_membership_type] integerValue];
    self.language_id = [[dictionary valueForKey:tbl_vendor_language_id] integerValue];
    
    return self;
}

@end
