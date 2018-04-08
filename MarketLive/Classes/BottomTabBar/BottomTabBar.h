//
//  BottomTabBar.h
//  Bimber
//
//  Created by Vinod on 28/11/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTabBar : UIView
{
    UIButton * notificationMap;
    UIButton * notificationFavorites;
    UIButton * notificationVisitors;
    UIButton * notificationRequest;
}

+(BottomTabBar*)  sharedInstance;

@end
