//
//  WeatherCell.h
//  MarketLive
//
//  Created by Admin on 22/03/18.
//  Copyright © 2018 Vinod Sutar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell


@property(nonatomic,weak)IBOutlet UILabel *dayLbl;
@property(nonatomic,weak)IBOutlet UILabel *minLbl;
@property(nonatomic,weak)IBOutlet UILabel *MaxLbl;


@property(nonatomic,weak)IBOutlet UIImageView *weatherImg;
@property(nonatomic,weak)IBOutlet UIImageView *bgImg;


@end
