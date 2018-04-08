//
//  VendorManager.m
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "VendorManager.h"

@implementation VendorManager

static VendorManager * instance = nil;

+(VendorManager*) sharedInstance{
    if(!instance)
    {
        instance = [[VendorManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(Vendor *) getVendorWithID :(NSString *) vendorID languageID:(NSString *) languageID
{
    
    NSString * query = [NSString stringWithFormat:@"Select * from Vendor where %@='%@' and %@='%@'", tbl_vendor_vendor_id, vendorID, tbl_category_language_id, languageID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    if (result) {
        if (result.count > 0) {
            return [[Vendor alloc] initWithDictionary:[result objectAtIndex:0]];
        }
    }
    return nil;
}

-(NSArray *) getVendorOfCategory :(MLCategory *) mlCategory languageID:(NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Vendor where %@='%ld' and %@='%@'", tbl_vendor_category_id, mlCategory.category_id, tbl_category_language_id, languageID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    NSMutableArray * vendorArray = [[NSMutableArray alloc] init];
    
    if (result) {
        for (NSDictionary * dictionary in result) {
            Vendor * objVendor = [[Vendor alloc] initWithDictionary:dictionary];
            [vendorArray addObject:objVendor];
        }
    }
    return vendorArray;
}



-(NSArray *) getAllVendorsOfMainCategory :(MLCategory *) mlCategory languageID:(NSString *) languageID
{
    
    NSArray * categoryArray = [[CategoryManager sharedInstance] getSubCategory:mlCategory languageID:languageID];
    
    NSMutableArray * vendorArray = [[NSMutableArray alloc] init];
    
    for (MLCategory * category in categoryArray)
    {
        NSString * query = [NSString stringWithFormat:@"Select * from Vendor where %@='%ld' and %@='%@'", tbl_vendor_category_id, category.category_id, tbl_category_language_id, languageID];
        
        NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
        
        if (result)
        {
            for (NSDictionary * dictionary in result)
            {
                Vendor * objVendor = [[Vendor alloc] initWithDictionary:dictionary];
                [vendorArray addObject:objVendor];
            }
        }

    }
    
    return vendorArray;
}


-(NSArray *) getAllVendors:(NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Vendor where %@='%@'", tbl_category_language_id, languageID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    NSMutableArray * vendorArray = [[NSMutableArray alloc] init];
    
    if (result) {
        for (NSDictionary * dictionary in result) {
            Vendor * objVendor = [[Vendor alloc] initWithDictionary:dictionary];
            [vendorArray addObject:objVendor];
        }
    }
    return vendorArray;
}

-(void) deleteAllLocalVendor
{
    NSString * query = [NSString stringWithFormat:@"delete from Vendor"];
    [[DatabaseManager sharedInstance] deleteRecord:query];
}

-(void) updateVendor : (Vendor *) vendor
{
    
    vendor.tags = [vendor.tags stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString * query = [NSString stringWithFormat:@"Insert into Vendor ( %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@ ) VALUES ( %ld, '%@', '%@', '%@', '%@', '%@', '%@', %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %ld, '%d', '%ld', %ld )",
                        tbl_vendor_vendor_id,
                        tbl_vendor_vendor_name,
                        tbl_vendor_address,
                        tbl_vendor_pincode,
                        tbl_vendor_phone_number,
                        tbl_vendor_website_url,
                        tbl_vendor_email,
                        tbl_vendor_category_id,
                        tbl_vendor_subscription_from,
                        tbl_vendor_subscription_to,
                        tbl_vendor_job_description,
                        tbl_vendor_vendor_job,
                        tbl_vendor_tags,
                        tbl_vendor_longitude,
                        tbl_vendor_latitude,
                        tbl_vendor_status,
                        tbl_is_subscribed,
                        tbl_membership_type,
                        tbl_vendor_language_id,
                        vendor.vendor_id,
                        vendor.vendor_name,
                        vendor.address,
                        vendor.pincode,
                        vendor.phone_number,
                        vendor.website_url,
                        vendor.email,
                        vendor.category_id,
                        vendor.subscription_from,
                        vendor.subscription_to,
                        vendor.job_description,
                        vendor.vendor_job,
                        vendor.tags,
                        vendor.longitude,
                        vendor.latitude,
                        vendor.status,
                        vendor.is_subscribed,
                        vendor.membership_type,
                        vendor.language_id];
    
    
    if ([[DatabaseManager sharedInstance] insertRecord:query])
    {
        NSLog(@"Vendor Added %ld, %@", vendor.vendor_id, vendor.vendor_name);
    }
    else
    {
        NSLog(@"Vendor Not Added");
    }
}

-(BOOL) isVendorExist : (Vendor *) vendor
{
    NSString * query = [NSString stringWithFormat:@"Select * from Vendor where %@='%ld'", tbl_vendor_vendor_id, vendor.vendor_id];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    if(result)
    {
        if(result.count > 0)
        {
            return YES;
        }
    }
    
    return NO;
}

-(void) setCategory : (Vendor *) vendor
{
    [NavigationHolder sharedInstance].selectedSubCategory = [[CategoryManager sharedInstance] getCategoryWithID:vendor.category_id];
}

-(void) deleteAllVendorImagesWithVendorId:(Vendor *) objVendor
{
    NSString * query = [NSString stringWithFormat:@"delete from VendorImages where %@='%ld'", tbl_vendor_vendor_id, objVendor.vendor_id];
    [[DatabaseManager sharedInstance] deleteRecord:query];
}

-(void) addVendorImage:(NSString *) vendorId imageName : (NSString *) imageName sequence : (NSInteger) sequence
{
    NSString * query = [NSString stringWithFormat:@"insert into VendorImages (vendor_id, image_name, sequence) VALUES ( %@, '%@', '%ld')", vendorId, imageName, sequence];
    
    [[DatabaseManager sharedInstance] insertRecord:query];
}

-(NSArray *) getVendorImages:(Vendor *) vendorId
{
    NSString * query = [NSString stringWithFormat:@"select * from VendorImages where vendor_id=%ld", vendorId.vendor_id];
    
    return [[DatabaseManager sharedInstance] fetchRecord:query];
}


@end
