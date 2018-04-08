//
//  VendorManager.h
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VendorManager : NSObject
{
    
}

+(VendorManager*) sharedInstance;

-(Vendor *) getVendorWithID :(NSString *) vendorID languageID:(NSString *) languageID;

-(NSArray *) getVendorOfCategory :(MLCategory *) mlCategory languageID:(NSString *) languageID;

-(void) updateVendor : (Vendor *) vendor;

-(void) setCategory : (Vendor *) vendor;

-(NSArray *) getAllVendors:(NSString *) languageID;

-(NSArray *) getAllVendorsOfMainCategory :(MLCategory *) mlCategory languageID:(NSString *) languageID;

-(void) deleteAllVendorImagesWithVendorId:(Vendor *) objVendor;

-(void) addVendorImage:(NSString *) objVendor imageName : (NSString *) imageName sequence : (NSInteger) sequence;

-(void) deleteAllLocalVendor;

-(NSArray *) getVendorImages:(Vendor *) vendorId;

@end
