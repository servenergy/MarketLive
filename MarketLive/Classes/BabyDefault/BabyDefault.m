//
//  BabyDefault.m
//  MarketLive
//
//  Created by Vinod on 08/08/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "BabyDefault.h"

@interface BabyDefault ()

@end

@implementation BabyDefault

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * imageName;
    
    if(screenWidth <= 320)
    {
        if(screenHeight < 500)
        {
            imageName = @"Default.png";
        }
        else
        {
            imageName = @"Default-568h@2x.png";
        }
        
    }
    else
    {
        
        if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft)
        {
            imageName = @"Default-Landscape~ipad.png";
        }
        else if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeRight)
        {
            imageName = @"Default-Landscape~ipad.png";
            
        }
        else if([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait)
        {
            imageName = @"Default-Portrait~ipad.png";
        }
        else
        {
            imageName = @"Default-Portrait~ipad.png";
        }
    }
    
    if (imageName)
    {
        imageView.image = [UIImage imageNamed:imageName];
    }
    
    [self performSelector:@selector(dismissMe) withObject:nil afterDelay:3.0f];
}

-(void) dismissMe
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
