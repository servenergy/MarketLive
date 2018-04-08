//
//  FavoriteManager.h
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteManager : NSObject
{
    
}

+(FavoriteManager*) sharedInstance;

-(BOOL) isVendorFavorite:(Vendor *)vendor languageID :(NSString *) languageID;

-(NSArray *) getFavoriteOfLanguage : (NSString *) languageID;

-(void) addFavoriteWithVendor:(Vendor *)vendor languageID :(NSString *) languageID;

-(void) deleteFavoriteWithVendor:(Vendor *)vendor languageID :(NSString *) languageID;

@end
