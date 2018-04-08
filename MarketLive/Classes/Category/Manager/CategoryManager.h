//
//  CategoryManager.h
//  MarketLive
//
//  Created by Vinod on 06/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryManager : NSObject
{
    
}

+(CategoryManager*) sharedInstance;

-(NSArray *) getMainCategory :(NSString *) languageID;

-(NSArray *) getSubCategory :(MLCategory *) mlCategory languageID:(NSString *) languageID;

-(void) updateCategory : (MLCategory *) mlCategory;

-(NSString *) getCategoryName : (MLCategory *) mlCategory;

-(UIImage *) getCategoryImage : (MLCategory *) mlCategory;

-(MLCategory *) getCategoryWithID : (NSInteger) categoryID;

-(void) deleteAllCategories;

@end
