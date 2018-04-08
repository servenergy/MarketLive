

#import <UIKit/UIKit.h>

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]


#define sponsorListJSONFolderPathKey [NSString stringWithFormat:@"%@/ADBanner", DocumentsDirectory]
#define newsJSONFolderPathKey [NSString stringWithFormat:@"%@/News.json", DocumentsDirectory]


#define sponsorListJSONPathKey [NSString stringWithFormat:@"%@/SponsorList.json", sponsorListJSONFolderPathKey]

#define sponsorLoadingImagePathKey [NSString stringWithFormat:@"%@/sponsorLoading.png", sponsorListJSONFolderPathKey]



#define bannerIDKey  @"banner_id"
#define bannerIndexKey  @"banner_index"
#define bannerNameKey  @"banner_name"
#define bannerSponsorNameKey  @"sponsor_name"
#define bannerSponsorPriceKey  @"sponsor_price"
#define bannerStartDateKey  @"start_date"
#define bannerEndDateKey  @"end_date"
#define bannerTargetMediaKey  @"target_media"
#define bannerTargetTypeKey  @"target_type"
#define bannerTargerMediaKey  @"target_media"
#define bannerImageBundlePathKey  @"iphone-banner"
#define bannerDelayKey @"duration"

#define deviceScreenWidth [[UIScreen mainScreen] bounds].size.width

#define __IS_IPHONE_MACRO (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define bannerViewHeight __IS_IPHONE_MACRO ? 120 : (deviceScreenWidth / 2.66)

//#define bannerViewHeight 120

#define bottomSpacing (bannerViewHeight + 84) // 40(bottomTabBarheight) + 44(navigationBarHeight) = 84

#define bannerImageFolderPathKey(bannerID) [NSString stringWithFormat:@"%@/ADBanner/Banner%@",DocumentsDirectory, bannerID]


#define bannerImagePathKey(bannerID) [NSString stringWithFormat:@"%@/iphone-image.png", bannerImageFolderPathKey(bannerID)]





