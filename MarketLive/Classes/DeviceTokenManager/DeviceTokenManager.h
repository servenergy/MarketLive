//
//  DeviceTokenManager.h
//  ESC 3.0, MB 1.7
//
//  Created by BBIM1019 on 8/11/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DeviceTokenManagerDelegate <NSObject>
@required

-(void) didDeviceTokenManagerStarted;
-(void) didDeviceTokenManagerCompletedWithResult:(int)code;
-(void) didDeviceTokenManagerFailed;

@end;

@interface DeviceTokenManager : NSObject <NSXMLParserDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <DeviceTokenManagerDelegate> delegate;

+(DeviceTokenManager*) sharedInstance;

-(void) saveTokenToServer:(NSString *)tokenID;

@end
