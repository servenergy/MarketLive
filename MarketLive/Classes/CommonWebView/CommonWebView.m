//
//  CommonWebView.m
//  MarketLive
//
//  Created by Vinod on 11/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "CommonWebView.h"

@interface CommonWebView ()

@end

@implementation CommonWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17.0 weight:0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NavigationHolder sharedInstance].infoTitle;
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    
    if ([[NavigationHolder sharedInstance].infoTitle isEqualToString:@"Terms and conditions"]) {
        
        NSURL *urlObj=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"termsandconditions" ofType:@"html"]] ;
        NSURLRequest *request=[NSURLRequest requestWithURL:urlObj];
        
        [objWebView loadRequest:request];
    }
    else if ([[NavigationHolder sharedInstance].infoTitle isEqualToString:@"Contact us"]) {
        
        NSURL *urlObj=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"contactus" ofType:@"html"]] ;
        NSURLRequest *request=[NSURLRequest requestWithURL:urlObj];
        
        [objWebView loadRequest:request];
    }
    else if ([[NavigationHolder sharedInstance].infoTitle isEqualToString:@"Information"]) {
        
        NSURL *urlObj=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"information" ofType:@"html"]] ;
        NSURLRequest *request=[NSURLRequest requestWithURL:urlObj];
        
        [objWebView loadRequest:request];
    }
    
    [objWebView.scrollView setBounces:NO];
    [objWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    // Do any additional setup after loading the view.
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
