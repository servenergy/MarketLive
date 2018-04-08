//
//  MyView.m
//  DragDrop
//
//  Created by BBIM1019 on 8/19/15.
//  Copyright (c) 2015 BBI. All rights reserved.
//

#import "AdBannerView.h"



@implementation AdBannerView

static AdBannerView * instance = nil;

+(AdBannerView*) sharedInstance
{
    if (instance==nil)
    {
        instance=[[AdBannerView alloc] init];
    }
    else
    {
        [instance startAnimation];
    }
    return instance;
}




- (instancetype)init
{
    if(__IS_IPAD)
    {
        width = screenWidth;
    }
    else
    {
        width = screenWidth - 8;
    }
    yCoords = [UIScreen mainScreen].bounds.size.height - bottomSpacing;
    
    self = [super initWithFrame:CGRectMake(0 - width, 0, width * 3, bannerViewHeight)];
    
    
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}


-(void) initialize
{
    objAdBannerManager = [AdBannerManager getInstance];
    objAdBannerManager.delegate = self;
    
    animationDuration = 0.3;
    
    swipeFlag = 0;
    
    if(__IS_IPAD)
    {
        width = screenWidth;
    }
    else
    {
        width = screenWidth - 8;
    }
    
    halfWidth = -width / 2;
    
    currentSponsorIndex = 0;
    
    [self addGestures];
    
    [self setViewFrame];
    
    [objAdBannerManager checkForUpdates];
    
    if([objAdBannerManager canShowBanner])
    {
        isDisplayingOnSuperView = YES;
        [self showView];
    }
    else
    {
        isDisplayingOnSuperView = NO;
    }
    
}



-(void) showView
{
    sponsorArray = [objAdBannerManager getSponsorList];
    
    [sponsorClickBtn addTarget:self action:@selector(sponsorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    centerImage.image = [self getImageAtIndex:currentSponsorIndex];
    
    [self setPreviousNextImage];
    
    [self setTimer];
    
    [self addSubview:leftImage];
    [self addSubview:centerImage];
    [self addSubview:rightImage];
    [self addSubview:sponsorClickBtn];
    [self bringSubviewToFront:sponsorClickBtn];
}

-(void) reloadView : (NSArray *) sponsorList
{
    sponsorArray = sponsorList;
    
    if(isDisplayingOnSuperView)
    {
        currentSponsorIndex = 0;
        
        centerImage.image = [self getImageAtIndex:currentSponsorIndex];
        
        [self setPreviousNextImage];
    }
    else
    {
        [sponsorClickBtn addTarget:self action:@selector(sponsorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        centerImage.image = [self getImageAtIndex:currentSponsorIndex];
        
        [self setPreviousNextImage];
        
        [self setTimer];
        
        [self addSubview:leftImage];
        [self addSubview:centerImage];
        [self addSubview:rightImage];
        [self addSubview:sponsorClickBtn];
        [self bringSubviewToFront:sponsorClickBtn];
        isDisplayingOnSuperView = YES;
    }
}

-(void) setFrameAccordingToOrientation
{
    if(__IS_IPAD)
    {
        width = screenWidth;
    }
    else
    {
        width = screenWidth - 8;
    }
    
    yCoords = [UIScreen mainScreen].bounds.size.height - bottomSpacing;
    
    
    leftImage.frame = CGRectMake(0,0,width,bannerViewHeight);
    centerImage.frame = CGRectMake(width,0,width,bannerViewHeight);
    rightImage.frame = CGRectMake(width * 2,0,width,bannerViewHeight);
    
    self.frame = CGRectMake(0 - width, yCoords, width * 3, bannerViewHeight);
}

-(void) addGestures
{
    swipeGestureRL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeGestureRL setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeGestureRL];
    
    swipeGestureLR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [swipeGestureLR setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeGestureLR];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self addGestureRecognizer:panRecognizer];
    
    swipeGestureRL.delegate = self;
    swipeGestureLR.delegate = self;
    panRecognizer.delegate = self;
}

-(void) setViewFrame
{
    leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,bannerViewHeight)];
    centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(width,0,width,bannerViewHeight)];
    rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(width * 2,0,width,bannerViewHeight)];
    sponsorClickBtn = [[UIButton alloc] initWithFrame:CGRectMake(width,0,width,bannerViewHeight)];
}

-(void)sponsorBtnClick:(id) sender
{
    [self stopAnimation];
    
    NSString * bannerTargetType = [self bannerTargetTypeAtCurrentIndex];
    
    UIAlertView * alertView;
    
    if([bannerTargetType isEqualToString:@""] ||  bannerTargetType == nil)
    {
        alertView = nil;
    }
    
    else if([bannerTargetType isEqualToString:@"web"])
    {
        NSString * vendorID = [self getBannerIDAtIndex:currentSponsorIndex];
        
        Vendor * objVendor = [[VendorManager sharedInstance] getVendorWithID:vendorID languageID:selectedLanguage];
        
        
        
        if(objVendor && objVendor.category_id > 0)
        {
            
            [NavigationHolder sharedInstance].selectedVendor = objVendor;
            
            [[VendorManager sharedInstance] setCategory:objVendor];
            
            [RequestManager pushViewWithStoryboardIdentifier:@"RootVendorViewController"];
        }
    }
    
    if(alertView)
    {
        alertView.delegate = self;
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * bannerTargetMedia = [self bannerTargetMediaAtCurrentIndex];
    
    if(buttonIndex == 1)
    {
        if(alertView.tag == TargetMediaWeb)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerTargetMedia]];
        }
        else if(alertView.tag == TargetMediaPDF)
        {
            
        }
        else if(alertView.tag == TargetMediaVideo)
        {
            
        }
        else if(alertView.tag == TargetMediaHTML)
        {
            
        }
        else if(alertView.tag == TargetMediaAppLaunch)
        {
            
        }
    }
    
    [self startAnimation];
}

-(void) setTimer
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:[self getDelayAtIndex:currentSponsorIndex] target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
}


-(void) timerMethod:(id)sender
{
    
    if ([[AdBannerManager getInstance] canShowBanner])
    {
        [self displayNextSponsorWithAnimation];
    }
}

-(void) changeLeftImageToCenter
{
    centerImage.image = leftImage.image;
    currentSponsorIndex--;
    
    if(currentSponsorIndex < 0)
        currentSponsorIndex = (int)[sponsorArray count] - 1;
    
    
    [self setPreviousNextImage];
    
}

-(void) changeRightImageToCenter
{
    centerImage.image = rightImage.image;
    currentSponsorIndex++;
    
    if(currentSponsorIndex==[sponsorArray count])
        currentSponsorIndex = 0;
    
    
    [self setPreviousNextImage];
    
}

-(void) stopAnimation
{
    [myTimer invalidate];
    myTimer = nil;
}

-(void) startAnimation
{
    if ([[AdBannerManager getInstance] canShowBanner])
    {
        if(myTimer)
        {
            [self stopAnimation];
        }
        
        [self setTimer];
    }
    else
    {
        [self stopAnimation];
    }
}

-(void) setPreviousNextImage
{
    int leftSponsorIndex;
    if(currentSponsorIndex == 0)
        leftSponsorIndex = (int)[sponsorArray count] - 1;
    else
        leftSponsorIndex = currentSponsorIndex - 1;
    
    
    int rightSponsorIndex;
    if(currentSponsorIndex == [sponsorArray count] - 1)
        rightSponsorIndex = 0;
    else
        rightSponsorIndex = currentSponsorIndex + 1;
    
    leftImage.image = [self getImageAtIndex:leftSponsorIndex];
    rightImage.image = [self getImageAtIndex:rightSponsorIndex];
}




- (void) panDetected:(UIPanGestureRecognizer *)uipanRecognizer
{
    CGPoint translation = [uipanRecognizer translationInView:self.superview];
    
    CGPoint viewPosition = self.center;
    viewPosition.x += translation.x;
    viewPosition.y += 0;
    
    self.center = viewPosition;
    
    [uipanRecognizer setTranslation:CGPointZero inView:self.superview];
    
    if(uipanRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self stopAnimation];
    }
    else if(uipanRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(!isSwipingFromGesture)
        {
            CGRect frame = self.frame;
            
            halfWidth = -width / 2;
            
            if(frame.origin.x > halfWidth)
            {
                [self displayPreviousSponsorWithAnimation];
            }
            else if(frame.origin.x < -width + halfWidth)
            {
                [self displayNextSponsorWithAnimation];
            }
            else
            {
                [self displayCurrentSponsorWithAnimation];
            }
        }
        else
        {
            if(swipeFlag == 1)
            {
                [self displayPreviousSponsorWithAnimation];
            }
            else if(swipeFlag == 2)
            {
                [self displayNextSponsorWithAnimation];
            }
            else
            {
                [self displayCurrentSponsorWithAnimation];
            }
        }
    }
}

- (void)swipeDetected :(UISwipeGestureRecognizer *)recognizer
{
    CGPoint dd= [panRecognizer velocityInView:self];
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(dd.x > 700)
        {
            isSwipingFromGesture = YES;
            swipeFlag = 1;
        }
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(dd.x < -700)
        {
            isSwipingFromGesture = YES;
            swipeFlag = 2;
        }
    }
}

-(void) displayCurrentSponsorWithAnimation
{
    CGRect frame = self.frame;
    frame.origin.x = -width;
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished){
        if(finished)
        {
            [self setCenterView];
        }
    }];
}

-(void) displayPreviousSponsorWithAnimation
{
    CGRect frame = self.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished){
        if(finished)
        {
            [self changeLeftImageToCenter];
            [self setCenterView];
        }
    }];
}

-(void) displayNextSponsorWithAnimation
{
    CGRect frame = self.frame;
    frame.origin.x = -width*2;
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = frame;
    } completion:^(BOOL finished){
        if(finished)
        {
            [self changeRightImageToCenter];
            [self setCenterView];
            
        }
    }];
}

-(void) setCenterView
{
    CGRect myFrame = self.frame;
    myFrame.origin.x = -width;
    self.frame = myFrame;
    [self stopAnimation];
    [self startAnimation];
    isSwipingFromGesture = NO;
    swipeFlag = 0;
    
    [_delegate bannerIndexDisplayChanged:currentSponsorIndex];
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void) dealloc{
    //[[NSNotificationCenter defaultCenter] removeObserver: self];
    //[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


#pragma mark Getter and Setter

-(UIImage *) getImageAtIndex:(int) index
{
    NSString * bannerID = [self getBannerIDAtIndex: index];
    
    NSString * imagePath = bannerImagePathKey(bannerID);
    
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    
    if(image)
    {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    else
    {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:sponsorLoadingImagePathKey]];
    }
}

-(NSString*) getBannerIDAtIndex:(int) index
{
    return [[sponsorArray objectAtIndex:index] objectForKey:bannerIDKey];
}

-(float) getDelayAtIndex:(int) index
{
    return [[[sponsorArray objectAtIndex:index] objectForKey:bannerDelayKey] floatValue];
}

-(float) getAnimatioDelayAtIndex:(int) index
{
    return [[[sponsorArray objectAtIndex:index] objectForKey:@"animationDuration"] floatValue];
}




-(NSString *) bannerTargetTypeAtCurrentIndex
{
    return [[sponsorArray objectAtIndex:currentSponsorIndex] objectForKey:bannerTargetTypeKey];
}

-(NSString *) bannerTargetMediaAtCurrentIndex
{
    return [[sponsorArray objectAtIndex:currentSponsorIndex] objectForKey:bannerTargerMediaKey];
}


@end
