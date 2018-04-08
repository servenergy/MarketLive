//
//  Macros.h
//  Bimber
//
//  Created by Vinod on 29/11/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define debugMode @"true"

#define __IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define __IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

#define appPrimaryColor   [UIColor lightGrayColor]
#define appSecondaryColor [UIColor colorWithRed:1.0f green:50.0/255.0 blue:10/255.0 alpha:1.0]
#define appFontColor      [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0]
#define bottomTabBgColor  [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]
#define bottomTabHeight   40

#define selectedLanguage [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedLanguage"]

#define zipPath(fileName) [NSString stringWithFormat:@"http://www.mlive.co.in/UploadData/%@.zip", fileName];

#define bannerURL @"http://www.mlive.co.in/upload/SponsorList.txt"

#define dataTrackURL @"http://www.mlive.co.in/VersionFile.txt"
#define newsTrackURL @"http://www.mlive.co.in/NewsTrackFile.txt"
#define newsURL @"http://www.mlive.co.in/NewsFile.txt"

#define tbl_vendor_vendor_id @"vendor_id"
#define tbl_vendor_vendor_name @"vendor_name"
#define tbl_vendor_address @"address"
#define tbl_vendor_pincode @"pincode"
#define tbl_vendor_phone_number @"phone_number"
#define tbl_vendor_website_url @"website_url"
#define tbl_vendor_email @"email"
#define tbl_vendor_category_id @"category_id"
#define tbl_vendor_subscription_from @"subscription_from"
#define tbl_vendor_subscription_to @"subscription_to"
#define tbl_vendor_job_description @"job_description"
#define tbl_vendor_vendor_job @"vendor_job"
#define tbl_vendor_tags @"tags"
#define tbl_vendor_longitude @"longitude"
#define tbl_vendor_latitude @"latitude"
#define tbl_vendor_status @"status"
#define tbl_is_subscribed @"is_subscribed"
#define tbl_membership_type @"membership_type"

#define tbl_vendor_language_id @"language_id"

#define tbl_category_category_id @"category_id"
#define tbl_category_category_name @"category_name"
#define tbl_category_parent_category_id @"parent_category_id"
#define tbl_category_language_id @"language_id"
#define tbl_category_status @"status"

#define tbl_language_language_id @"language_id"
#define tbl_language_language_name @"language_name"

#define tbl_favorites_vendor_id @"vendor_id"
#define tbl_favorites_language_id @"language_id"

#endif /* Macros_h */
