//
//  WeatherCell.m
//  MarketLive
//
//  Created by Admin on 22/03/18.
//  Copyright © 2018 Vinod Sutar. All rights reserved.
//

#import "WeatherCell.h"

@implementation WeatherCell
@synthesize MaxLbl,minLbl,dayLbl,imageView,bgImg;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
