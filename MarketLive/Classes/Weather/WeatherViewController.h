//
//  WeatherViewController.h
//  MarketLive
//
//  Created by Admin on 22/03/18.
//  Copyright © 2018 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
        NSMutableArray *maxTempArray;
        NSMutableArray *minTempArray;
        NSMutableArray *dayArray;
        NSMutableArray *weatherImageArray;
        NSMutableArray *backgroundImageArray;
    
    IBOutlet UITableView * weatherTableView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainBg;

@end
