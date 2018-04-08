//
//  BottomTabBar.m
//  Bimber
//
//  Created by Vinod on 28/11/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "BottomTabBar.h"

@implementation BottomTabBar

static BottomTabBar * instance = nil;

+(BottomTabBar*)  sharedInstance
{
    if(instance == nil)
    {
        CGRect frame = CGRectMake(0, screenHeight - bottomTabHeight, screenWidth, bottomTabHeight);
        instance = [[BottomTabBar alloc] initWithFrame:frame];
    }
    return instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, -2);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.3;
        
        self.backgroundColor = bottomTabBgColor;
        
        NSArray * bottomBarArray = [[NavigationHolder sharedInstance].viewControllerDictionary objectForKey:@"BottomBar"];
        
        
        int buttonWidth = screenWidth / [bottomBarArray count];
        
        for (int i = 0; i < [bottomBarArray count]; i++)
        {
            int index = (int)[[[NavigationHolder sharedInstance].viewControllerDictionary valueForKey:@"ViewControllers"] indexOfObject:[bottomBarArray objectAtIndex:i]];
            
            if(index == -1)
            {
                [Developer showDeveloperAlert:[NSString stringWithFormat:@"ViewController not found in array : \"%@\"", [bottomBarArray objectAtIndex:i]]];
            }
            else
            {
                CGRect frame = CGRectMake(i*buttonWidth, 0, buttonWidth, bottomTabHeight);
                [self addTabBarButton:[bottomBarArray objectAtIndex:i] : frame :index];
            }
        }
    }
    return self;
}

-(IBAction)tabBarButtonClicked:(UIButton *)sender
{
    NSString * storyboardID = [[[NavigationHolder sharedInstance].viewControllerDictionary objectForKey:@"ViewControllers"] objectAtIndex:sender.tag];
    if([storyboardID isEqualToString:@"BackViewController"])
    {
        AppDelegate * objAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [objAppDelegate.objNavigationViewController popViewControllerAnimated:YES];
    }
    else
    {
        [RequestManager pushViewWithStoryboardIdentifier:storyboardID];
    }
    
}


-(void) addTabBarButton :(NSString *)title : (CGRect)frame :(int) tag
{
    int imageHeight = 25;
    int imageWidth = 25;
    
    int xCoords = (frame.size.width - imageWidth) /2;
    int yCoords = (frame.size.height - imageHeight) /2;
    
    UIButton * objButton  = [[UIButton alloc] initWithFrame:frame];
    objButton.backgroundColor = [UIColor clearColor];
    objButton.tag = tag;
    [objButton addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * innerImage = [[UIImageView alloc] initWithFrame:CGRectMake(xCoords, yCoords, imageWidth, imageHeight)];
    NSString * imageName = [title stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
    [innerImage setImage:[UIImage imageNamed:imageName]];
    [objButton addSubview:innerImage];
    [objButton bringSubviewToFront:innerImage];
    [self addSubview:objButton];
}




@end
