//
//  FavoriteManager.m
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "FavoriteManager.h"

@implementation FavoriteManager

static FavoriteManager * instance = nil;

+(FavoriteManager*) sharedInstance{
    if(!instance)
    {
        instance = [[FavoriteManager alloc] init];
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

-(BOOL) isVendorFavorite:(Vendor *)vendor languageID :(NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Favorite where %@='%ld' and  %@='%@'", tbl_favorites_vendor_id, vendor.vendor_id, tbl_favorites_language_id, languageID];
    
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

-(void) addFavoriteWithVendor:(Vendor *)vendor languageID :(NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Insert into Favorite ( %@, %@ ) VALUES ( '%ld' , '%@' )", tbl_favorites_vendor_id, tbl_favorites_language_id, vendor.vendor_id, languageID];
    
    if ([[DatabaseManager sharedInstance] insertRecord:query]) {
        NSLog(@"Favorite Added");
    }
    else {
        NSLog(@"Favorite Not Added");
    }
}

-(NSArray *) getFavoriteOfLanguage : (NSString *) languageID
{
    NSString * query = [NSString stringWithFormat:@"Select * from Favorite where %@='%@'", tbl_favorites_language_id, languageID];
    
    NSArray * result = [[DatabaseManager sharedInstance] fetchRecord:query];
    
    NSMutableArray * vendorArray = [[NSMutableArray alloc] init];
    
    if (result) {
        for (NSDictionary * dictionary in result) {
            Vendor * objVendor = [[VendorManager sharedInstance] getVendorWithID:[dictionary valueForKey:tbl_vendor_vendor_id] languageID:selectedLanguage];
            [vendorArray addObject:objVendor];
        }
    }
    return vendorArray;
}

-(void) deleteFavoriteWithVendor:(Vendor *)vendor languageID :(NSString *) languageID;
{
    NSString * query = [NSString stringWithFormat:@"Delete from Favorite where %@='%ld' and %@='%@'", tbl_favorites_vendor_id, vendor.vendor_id, tbl_favorites_language_id, languageID];
    
    if ([[DatabaseManager sharedInstance] deleteRecord:query]) {
        NSLog(@"Favorite Deleted");
    }
    else {
        NSLog(@"Favorite Not Deleted");
    }
}

@end
