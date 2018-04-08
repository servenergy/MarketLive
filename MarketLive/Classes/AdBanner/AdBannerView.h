//
//  MyView.h
//  DragDrop
//
//  Created by BBIM1019 on 8/19/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBannerManager.h"

@protocol ADBannerViewDelegate <NSObject>
@required
-(void) bannerIndexDisplayChanged :(NSInteger) index;
@end

typedef enum
{
    TargetMediaPDF = 100,
    TargetMediaWeb = 200,
    TargetMediaHTML = 300,
    TargetMediaVideo = 400,
    TargetMediaAppLaunch = 500,
    
}targetMediaType;

@interface AdBannerView : UIView <UIGestureRecognizerDelegate, UIAlertViewDelegate, AdBannerManagerDelegate>
{
    float animationDuration;
    int width,yCoords,halfWidth,swipeFlag;
    int currentSponsorIndex;
    NSArray * sponsorArray;
    BOOL isSwipingFromGesture;
    UISwipeGestureRecognizer *swipeGestureLR;
    UISwipeGestureRecognizer *swipeGestureRL;
    UIPanGestureRecognizer *panRecognizer;
    
    UIImageView * leftImage;
    UIImageView * centerImage;
    UIImageView * rightImage;
    NSTimer * myTimer;
    CGPoint lastLocation;
    
    UIButton * sponsorClickBtn;
    
    BOOL isDisplayingOnSuperView;
    
    AdBannerManager * objAdBannerManager;
    
    UIPageControl * objPageControl;
}

@property (nonatomic, weak) id <ADBannerViewDelegate> delegate;

+(AdBannerView*) sharedInstance;

-(void) setFrameAccordingToOrientation;

@end
