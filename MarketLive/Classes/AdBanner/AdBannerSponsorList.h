//
//  AdBannerJSONWS.h
//  DragDrop
//
//  Created by BBIM1019 on 9/3/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import <Foundation/Foundation.h>





@protocol AdBannerSponsorListDelegate <NSObject>
@required

-(void) didSponsorImagesReceived : (NSArray *) sponsorArrayList;

@end;

@interface AdBannerSponsorList : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>


+(AdBannerSponsorList*) getInstance;

-(void) downloadSponsorList;

@property (nonatomic, weak) id <AdBannerSponsorListDelegate> delegate;

@end
