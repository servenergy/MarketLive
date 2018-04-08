//
//  NavigationHolder.h
//  MarketLive
//
//  Created by Vinod on 06/12/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLCategory.h"
#import "News.h"
@interface NavigationHolder : NSObject
{
    NSDictionary * categories;
}

@property (nonatomic, strong) NSMutableDictionary * viewControllerDictionary;

@property (nonatomic, strong) MLCategory * selectedMainCategory;
@property (nonatomic, strong) MLCategory * selectedSubCategory;
@property (nonatomic, strong) NSArray * filteredVendorArray;

@property (nonatomic, strong) Vendor * selectedVendor;
@property (nonatomic, strong) News * selectedNews;

@property (nonatomic, strong) NSString * infoTitle;
@property (nonatomic, strong) NSString * infoHTML;

+(NavigationHolder*) sharedInstance;

@end
