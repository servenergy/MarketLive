//
//  NavigationViewController.m
//  Bimber
//
//  Created by Vinod on 28/11/15.
//  Copyright © 2015 Vinod Sutar. All rights reserved.
//

#import "NavigationViewController.h"
#import "SubCategoryViewController.h"
#import "VendorsListViewController.h"
#import "VendorViewController.h"
#import "RootVendorViewController.h"
#import "VendorsSearchListViewController.h"


@interface NavigationViewController ()
{
    Reachability * hostReachability;
}

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"www.google.co.in";
    hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [hostReachability startNotifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    
    Reachability* reachability = [note object];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    
    switch (netStatus)
    {
        case ReachableViaWWAN:{
            break;
        }
        case ReachableViaWiFi:{
            break;
        }
        default:{
            break;
        }
    }
    
}


-(void) showBottomBar : (BOOL) flag
{
    if(flag)
    {
        [[BottomTabBar sharedInstance] setHidden:NO];
    }
    else
    {
        [[BottomTabBar sharedInstance] setHidden:YES];
    }
}

-(void) manageBottomBar : (UIViewController *) viewController
{
    NSString * className = NSStringFromClass([viewController class]);
    NSDictionary * dict = [[NavigationHolder sharedInstance].viewControllerDictionary valueForKey:className];
    if (dict) {
        BOOL bottomBar = [[dict valueForKeyPath:@"bottomBar.enable"] boolValue];
        [self showBottomBar:bottomBar];
    }
    else {
        
        [Developer showDeveloperAlert:[NSString stringWithFormat:@"manageBottomBar.m \n Class \"%@\" missing in Navigation.json", className ]];
    }
}

-(void) manageNavigationBar : (UIViewController *) viewController
{
    NSString * className = NSStringFromClass([viewController class]);
    NSDictionary * dict = [[NavigationHolder sharedInstance].viewControllerDictionary valueForKey:className];
    BOOL navigationBarEnable = [[dict valueForKeyPath:@"navigationBar.enable"] boolValue];
    
    
    
    
    if(navigationBarEnable)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17.0 weight:0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = [dict valueForKeyPath:@"navigationBar.title"];
        [label sizeToFit];
        
        if ([viewController isKindOfClass:[HomeViewController class]] || [viewController isKindOfClass:[SubCategoryViewController class]] || [viewController isKindOfClass:[VendorsListViewController class]] || [viewController isKindOfClass:[VendorViewController class]] || [viewController isKindOfClass:[RootVendorViewController class]] || [viewController isKindOfClass:[VendorsSearchListViewController class]])
        {
            
            UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, screenWidth, 28)];
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2 - 150, 0, 204, 28)];
            imageView.image = [UIImage imageNamed:@"NavigationImage"];
            
            [titleView addSubview:imageView];
            
            [viewController.navigationItem setTitleView:titleView];
        }
        else
        {
            viewController.navigationItem.titleView = label;
        }
        
        BOOL leftBarButtonEnable = [[dict valueForKeyPath:@"navigationBar.leftBarButton.enable"] boolValue];
        BOOL rightBarButtonEnable = [[dict valueForKeyPath:@"navigationBar.rightBarButton.enable"] boolValue];
        
        if(leftBarButtonEnable)
        {
            int index = (int)[[[NavigationHolder sharedInstance].viewControllerDictionary valueForKey:@"ViewControllers"] indexOfObject:[dict valueForKeyPath:@"navigationBar.leftBarButton.storyBoardID"]];
            
            if(index == -1)
            {
                [Developer showDeveloperAlert:[NSString stringWithFormat:@"ViewController not found in array : \"%@\"", [dict valueForKeyPath:@"navigationBar.leftBarButton.storyBoardID"]]];
            }
            else
            {
                viewController.navigationItem.leftBarButtonItem = [self getNavigationButton:[dict valueForKeyPath:@"navigationBar.leftBarButton"] :index];
            }
        }
        
        if(rightBarButtonEnable)
        {
            int index = (int)[[[NavigationHolder sharedInstance].viewControllerDictionary valueForKey:@"ViewControllers"] indexOfObject:[dict valueForKeyPath:@"navigationBar.rightBarButton.storyBoardID"]];
            
            if(index == -1)
            {
                [Developer showDeveloperAlert:[NSString stringWithFormat:@"ViewController not found in array : \"%@\"", [dict valueForKeyPath:@"navigationBar.rightBarButton.storyBoardID"]]];
            }
            else
            {
                viewController.navigationItem.rightBarButtonItem = [self getNavigationButton:[dict valueForKeyPath:@"navigationBar.rightBarButton"] :index];
            }
        }
        
        self.navigationBarHidden = NO;
    }
    else
    {
        self.navigationBarHidden = YES;
        viewController.navigationController.navigationBarHidden = YES;
    }
    /*
    if([viewController class] == [HomeViewController class])
    {
        BOOL isListViewDisplaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"HomeViewListDisplayMode"];
        
        if (isListViewDisplaying)
        {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 24)];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:[UIImage imageNamed:@"SwitchGridIcon"] forState:UIControlStateNormal];
            [button addTarget:viewController action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            button.tag = 1000;
            viewController.navigationItem.rightBarButtonItem = barButton;
        }
        else
        {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 24)];
            button.backgroundColor = [UIColor clearColor];
            [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
            [button addTarget:viewController action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            button.tag = 2000;
            viewController.navigationItem.rightBarButtonItem = barButton;
        }
    }*/
}

-(UIBarButtonItem *) getNavigationButton : (NSDictionary *) dictionary :(int) tag
{
    NSString * title = [dictionary valueForKey:@"title"];
    
    if([title isEqualToString:@""])
    {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [[dictionary valueForKeyPath:@"image.width"] integerValue], [[dictionary valueForKeyPath:@"image.height"] integerValue])];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:[dictionary valueForKeyPath:@"image.imageName"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        button.tag = tag;
        return barButton;
    }
    else
    {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:16 weight:0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[dictionary valueForKey:@"title"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        button.tag = tag;
        return barButton;
    }
    
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [self.navigationBar setTranslucent:false];
    [self.navigationBar setBarTintColor:UIColor.greenColor];
    
    [self manageBottomBar:viewController];
    [self manageNavigationBar:viewController];
    
    viewController.navigationItem.hidesBackButton=true;
    viewController.edgesForExtendedLayout=UIRectEdgeNone;
    viewController.extendedLayoutIncludesOpaqueBars=NO;
    viewController.automaticallyAdjustsScrollViewInsets=NO;
    
    [super pushViewController:viewController animated:animated];
}


-(void) navigationBarButtonClicked : (id) sender
{
    UIBarButtonItem * object = (UIBarButtonItem *)sender;
    
    NSString * storyboardID = [[[NavigationHolder sharedInstance].viewControllerDictionary objectForKey:@"ViewControllers"] objectAtIndex:object.tag];
    [RequestManager pushViewWithStoryboardIdentifier:storyboardID];
    
}

@end
