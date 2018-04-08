//
//  DetailNewsViewController.m
//  MarketLive
//
//  Created by Vinod on 14/02/16.
//  Copyright © 2016 Vinod Sutar. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _newsTitle.text = [NavigationHolder sharedInstance].selectedNews.newsTitle;
    [_newsDescription setTitle:[NavigationHolder sharedInstance].selectedNews.newsDescription forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
