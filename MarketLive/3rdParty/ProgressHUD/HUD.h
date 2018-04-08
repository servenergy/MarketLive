//
//  HUD.h
//  Modular App
//
//  Created by BBIM1015 on 12/05/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface HUD : NSObject{
  
}
 
+(void)addHUDWithText:(NSString *)message;
+(void)updateHUDTitle:(NSString *)updateTitle;
+(void)dismissHUD;

@end
